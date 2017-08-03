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
    
    
    // TODO: consider changing name to cubienode
    // node of cube to be attatched to the parent node of a face
    private var node:SCNNode
    
    // side length of a single cubie
    private let side:CGFloat
    
    init(pos:SCNVector3, sideLen:CGFloat, bigCubeNode: SCNNode) {

        side = sideLen
        
        // use makeMaterials function to get an array of materials
        let materials = makeMaterials()
        
        // chamfer radius to give cube a curve
        let chamfer:CGFloat = 0.05
        
        // define the box geometry which is the foundation of our cubie
        let box = SCNBox(width: sideLen, height: sideLen, length: sideLen, chamferRadius: chamfer)
        
        // TODO: make this change accecible from the cubie class
        // currently this sets all the bases of the cubies to be gray
        box.firstMaterial = materials[6]
        
        node = SCNNode(geometry: box)
        node.position = pos
        
        bigCubeNode.addChildNode(node)
    }
    
    // TODO: check addPanels
    func addPanels(coordinates:[Int], magToCompare:Int, thicc:CGFloat) {
        
        for i in 0 ... (coordinates.count - 1) {
            
            
            
            if abs(coordinates[i])/magToCompare == 1 {
                
                let unitCoord:Int = coordinates[i]/magToCompare
                
                // TODO: fix the indexing
                
                var arrayRepOfPanelCoord:[Float] = [0, 0, 0]
                
                arrayRepOfPanelCoord[i] = Float(unitCoord)
                
                let panelUnitVec:SCNVector3 = makeVecWithCoordinateArray(coord: arrayRepOfPanelCoord)
                
                let stringRepOfPanelCoord = makeCoordStringWithCoordArray(coordArray: arrayRepOfPanelCoord)
                
                node.name?.append(colorNameDic[stringRepOfPanelCoord]!)
                
                
                let panelPos:SCNVector3 = scaleVector(vec: panelUnitVec, scalingFactor: Float(side)/2)
                
                
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
                
                let panelOrientation = makeVecWithCoordinateArray(coord: arrayRepOfOrientation)
                
                let pan:panel = panel(materialCode: stringRepOfPanelCoord, pos: panelPos, thickness: thicc, squareLen: side * 0.9, chamfer: 0.05, orientation: panelOrientation, parent: node)
            }
        }
    }
    
    
    
    
    
    
    
    //private class panel {
        
        init(materialCode:String, pos:SCNVector3, thickness:CGFloat, squareLen:CGFloat, chamfer:CGFloat, orientation: SCNVector3, parent: SCNNode) {
            
            let panel = SCNBox(width: squareLen, height: squareLen, length: thickness, chamferRadius: chamfer)
            panel.firstMaterial = colorDict[materialCode]
            
            let panelNode = SCNNode(geometry: panel)
            panelNode.position = pos
            panelNode.eulerAngles = orientation
            
            parent.addChildNode(panelNode)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // get the position of the cubie
    func getPos() -> SCNVector3 {
        
        return node.position
    }
    
    func getRelativePos(observerNode: SCNNode) -> SCNVector3 {
        
        return node.convertPosition(SCNVector3(0,0,0), to: observerNode)
        
    }
    
    func setParent(parent: SCNNode) {
        
        node.removeFromParentNode()
        parent.addChildNode(node)
        
    }
    
    func setPos(position: SCNVector3) {
        
        node.position = position
    }
    
    func setOrientation(orientation: SCNQuaternion) {
        
        node.orientation = orientation
    }
    
    func getOrientation() -> SCNQuaternion {
        return node.orientation
    }
}







