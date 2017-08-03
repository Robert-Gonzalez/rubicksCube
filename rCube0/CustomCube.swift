//
//  CustomCube.swift
//  rCube0
//
//  Created by Robert "Skipper" Gonzalez on 8/1/17.
//  Copyright © 2017 Robert "Skipper" Gonzalez. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import SceneKit



class customCube {
    
    // the representation where rotations will occur on the back end
    private var cubieCoordMap: [String : Int] = [:]
    
    // map for the cubies on the screen
    private var cubieMap: [String: cubie] = [:]
    
    // TODO: figure this thing out
    private var rotiationGroupMap: [String : rotationGroup] = [:]
    
    private let cubeNode:SCNNode = SCNNode()
    
    private var movesToExecute:[Move] = []
    
    init(cubeSideLen:CGFloat, numCubiesPerSide:Int, cubePos:SCNVector3, parentNode:SCNNode) {
        
        // side length of each individual cubie based on the desired size of the whole cube as well as the number of cubes used
        let cubieSideLen:CGFloat = cubeSideLen/CGFloat(numCubiesPerSide)
        
        // create initial node for the cube that will be attached to no geometry
        cubeNode.position = cubePos
        
        // used for cubieCoordMap
        var cubieCount:Int = 0
        
        // maximum coordinate magnitude
        let maxCoordMag = numCubiesPerSide/2

        // loop through all possible coordinates
        for coord1 in -maxCoordMag ... maxCoordMag {
            
            var coord1Sign = 1
            
            if numCubiesPerSide%2 == 0 {
                if coord1 == 0 {
                    continue
                }
                else {
                    if coord1/abs(coord1) != 1{
                        coord1Sign = -1
                    }
                }
            }
            
            for coord2 in -maxCoordMag ... maxCoordMag {
                
                var coord2Sign = 1
                
                if numCubiesPerSide%2 == 0 {
                    if coord2 == 0 {
                        continue
                    }
                    else {
                        if coord2/abs(coord2) != 1{
                            coord2Sign = -1
                        }
                    }
                }
                
                for coord3 in -maxCoordMag ... maxCoordMag {
                    
                    var coord3Sign = 1
                    
                    if numCubiesPerSide%2 == 0 {
                        if coord3 == 0 {
                            continue
                        }
                        else {
                            if coord3/abs(coord3) != 1{
                                coord3Sign = -1
                            }
                        }
                    }
                    
                    if (abs(coord1) < maxCoordMag) && (abs(coord2) < maxCoordMag) && (abs(coord3) < maxCoordMag) {
                        continue
                    }
                    
                    var unitVec = SCNVector3(0,0,0)
                    var cubiePos = SCNVector3(0,0,0)
                    
                    if numCubiesPerSide%2 != 0 {
                        unitVec = SCNVector3(Float(coord1), Float(coord2), Float(coord3))
                        cubiePos = scaleVector(vec: unitVec, scalingFactor: Float(cubieSideLen))
                    }
                    else {
                        unitVec = SCNVector3( Float(2*coord1 - coord1Sign), Float(2*coord2 - coord2Sign), Float(2*coord3 - coord3Sign))
                        cubiePos = scaleVector(vec: unitVec, scalingFactor: Float(cubieSideLen)/2)
                    }
                    
                    // create a cubie using that position
                    let cub:cubie = cubie(pos: cubiePos, sideLen:cubieSideLen, bigCubeNode: cubeNode)
                    
                    let faceThickness:CGFloat = 0.1
                    
                    // add that cubie to the rubicks cube node
                    cub.setParent(parent: cubeNode)
                    
                    // string representation of coordinates
                    let coordString = "(" + String(coord1) + "," + String(coord2) + "," + String(coord3) + ")"
                    
                    // place cubie integer representation in map of cubies
                    cubieCoordMap[coordString] = cubieCount
                    
                    // increase integer representation
                    cubieCount += 1
                    
                    let coordArray = [coord1, coord2, coord3]
                    
                    cub.addPanels(coordinates: coordArray, magToCompare: maxCoordMag, thicc: faceThickness)
                    
                    let rotCoordString1 = "(" + String(coord1) + ",0,0)"
                    let rotCoordString2 =  "(0," + String(coord2) + ",0)"
                    let rotCoordString3 = "(0,0," + String(coord3) + ")"
                    
                    let rotCoordStrings = [rotCoordString1, rotCoordString2, rotCoordString3]
                    
                    
                    for rotCoordString in rotCoordStrings {
                        
                        if rotiationGroupMap[rotCoordString] == nil {
                            
                            let axis = makeVecWithCoordString(coordAsString: rotCoordString)
                            
                            
                            let newRotGroup:rotationGroup = rotationGroup(axisVec: axis, bigCube: self)
                            
                            rotiationGroupMap[rotCoordString] = newRotGroup
                            
                            newRotGroup.setParent(parent: cubeNode)
                            
                        }
                        
                        rotiationGroupMap[rotCoordString]?.assignCubieAtCoord(cubie: cub, coordKey: coordString)
                    
                    }
                }
            }
        }
        parentNode.addChildNode(cubeNode)
    }
    
    func setRotationsToRun(moves:[Move]) {
        movesToExecute = moves
        
    }
    
    func runRotations() {
        
        if movesToExecute.count > 0 {
            
            //TODO: clean
            let groupToRotate = (rotiationGroupMap[movesToExecute[0].axisString])!
            let angleToRotate = CGFloat(movesToExecute[0].angle.rawValue)
            movesToExecute.remove(at: 0)
            
            groupToRotate.rotate(angle: angleToRotate)
        }
        else {
            print("No moves to execute.")
        }
    }

    func setParent(parent: SCNNode) {
        parent.addChildNode(cubeNode)
    }
    
    func assignCubieAtPosition(groupKey: String, coordKey: String, cubieToAdd: cubie) {
        rotiationGroupMap[groupKey]?.assignCubieAtCoord(cubie: cubieToAdd, coordKey: coordKey)
    }
    
    // function for scaling all components of a three-diensional vector
    private func scaleVector(vec:SCNVector3, scalingFactor:Float) -> SCNVector3 {
        var vecToMut = vec
        
        vecToMut.x.multiply(by: scalingFactor)
        vecToMut.y.multiply(by: scalingFactor)
        vecToMut.z.multiply(by: scalingFactor)
        
        return vecToMut
    }

}
