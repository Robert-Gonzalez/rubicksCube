//
//  Cubie.swift
//  rCube0
//
//  Created by Robert "Skipper" Gonzalez on 8/1/17.
//  Copyright © 2017 Robert "Skipper" Gonzalez. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import SceneKit

class cubie {
    
    private let chamfer:CGFloat = 0.05
    private var cubieNode:SCNNode
    
    init(coordArray: [Int], sideLen:CGFloat, ofOddCube:Bool, maxCoordMag: Int) {
        
        // define the box geometry which is the foundation of our cubie
        let box = SCNBox(width: sideLen, height: sideLen, length: sideLen, chamferRadius: chamfer)
        
        // TODO: make this change accecible from the cubie class
        // currently this sets all the bases of the cubies to be gray
        box.firstMaterial = materialArray[6]
        
        cubieNode = SCNNode(geometry: box)
        cubieNode.position = cubiePos(coordArray: coordArray, sideLen: sideLen, ofOddCube: ofOddCube)
        
        addPanels(coordinates: coordArray, magToCompare: maxCoordMag, sideLen: sideLen, parent: cubieNode)
        
    }
    
    // MEMBER FUNCTIONS
    
    // position getter for rotation groups to identify cube location
    func getPos() -> SCNVector3 {
        
        return cubieNode.position
    }
    
    // position getter relative to parent for global position
    func getRelativePos(observerNode: SCNNode) -> SCNVector3 {
        
        return cubieNode.convertPosition(SCNVector3(0,0,0), to: observerNode)
        
    }
    
    // set the parent of the cubie
    func setParent(parent: SCNNode) {
        
        cubieNode.removeFromParentNode()
        parent.addChildNode(cubieNode)
        
    }
    
    // set position of cubie
    func setPos(position: SCNVector3) {
        
        cubieNode.position = position
    }
    
    // set rotational orientation (quaternion)
    func setOrientation(orientation: SCNQuaternion) {
        
        cubieNode.orientation = orientation
    }
    
    // get rotational orientation (quaternion)
    func getOrientation() -> SCNQuaternion {
        return cubieNode.orientation
    }
}


// PRIVATE HELPER FUNCTIONS FOR INITILIZATION


// set cubie position based on whether the n-by-n cube is of odd-n
fileprivate func cubiePos(coordArray: [Int], sideLen:CGFloat, ofOddCube:Bool) -> SCNVector3 {
    
    if ofOddCube {
        
        let unitVec = coordVec(coordArray)
        return scaleVector(vec: unitVec, scalingFactor: Float(sideLen))
        
    }
    else {
        
        let unitVec = adjustedCoordVec(coordArray)
        return scaleVector(vec: unitVec, scalingFactor: Float(sideLen)/2)
        
    }
    
}

// turn array of three coordinates into 3D vector
fileprivate func coordVec(_ coordArray: [Int]) -> SCNVector3 {
    
    let coordx = Float(coordArray[0])
    let coordy = Float(coordArray[1])
    let coordz = Float(coordArray[2])
    
    return SCNVector3(coordx, coordy, coordz)
    
}

// adjust all elements in the vector to their odd-index position (for even-n cubes)
fileprivate func adjustedCoordVec(_ coordArray: [Int]) -> SCNVector3 {
    
    let oddCoordx = adjustedCoord(Float(coordArray[0]))
    let oddCoordy = adjustedCoord(Float(coordArray[1]))
    let oddCoordz = adjustedCoord(Float(coordArray[2]))
    
    return SCNVector3(oddCoordx, oddCoordy, oddCoordz)
}

// shift coordinate to corresponding odd corrdinate (for even-n cubes)
fileprivate func adjustedCoord(_ coord: Float) -> Float {
    return 2*coord - coord/abs(coord)
}

// function for scaling all components of a three-diensional vector
fileprivate func scaleVector(vec:SCNVector3, scalingFactor:Float) -> SCNVector3 {
    var vecToMut = vec
    
    vecToMut.x.multiply(by: scalingFactor)
    vecToMut.y.multiply(by: scalingFactor)
    vecToMut.z.multiply(by: scalingFactor)
    
    return vecToMut
}

// function that adds colored panels to rubiks cube
fileprivate func addPanels(coordinates:[Int], magToCompare:Int, sideLen: CGFloat, parent: SCNNode) {
    
    for i in 0 ... (coordinates.count - 1) {
        
        // we do not care about coordinate components that aren't on the surface
        if abs(coordinates[i])/magToCompare != 1 { continue }
        
        // divide by the magnitude of the surface distance to ge the sign of the panel coordinate
        let unitCoord:Int = coordinates[i]/magToCompare
        
        var arrayRepOfPanelCoord:[Float] = [0, 0, 0]
        
        arrayRepOfPanelCoord[i] = Float(unitCoord)
        
        let panelUnitVec:SCNVector3 = makeVecWithCoordinateArray(coord: arrayRepOfPanelCoord)
        
        let stringRepOfPanelCoord = makeCoordStringWithCoordArray(coordArray: arrayRepOfPanelCoord)
        
        let panelPos:SCNVector3 = scaleVector(vec: panelUnitVec, scalingFactor: Float(sideLen)/2)
        
        // change to vector rep
        var arrayRepOfOrientation:[Float] = [0,0,0]
        
        if abs(arrayRepOfPanelCoord[0]) == 1 {
            arrayRepOfOrientation[1] = 3.14/2.0
        }
        else if abs(arrayRepOfPanelCoord[1]) == 1 {
            arrayRepOfOrientation[0] = 3.14/2.0
        }
        else {
            arrayRepOfOrientation[2] = 3.14/2.0
        }
        
        // set the panel orientation based on the panels coordinates
        let panelOrientation = makeVecWithCoordinateArray(coord: arrayRepOfOrientation)
        
        // create the panel
        let _:panel = panel(materialCode: stringRepOfPanelCoord, pos: panelPos, squareLen: sideLen * 0.9, chamfer: 0.05, orientation: panelOrientation, parentCubieNode: parent)
    }
}





