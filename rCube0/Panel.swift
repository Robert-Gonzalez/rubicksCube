//
//  Panel.swift
//  rCube0
//
//  Created by Robert "Skipper" Gonzalez on 8/2/17.
//  Copyright © 2017 Robert "Skipper" Gonzalez. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import SceneKit

class panel {
    
    // TODO: add color feature
    
    let faceThickness:CGFloat = 0.1
    
    init(materialCode:String, pos:SCNVector3, squareLen:CGFloat, chamfer:CGFloat, orientation: SCNVector3, parentCubieNode: SCNNode) {
        
        let panelGeo = SCNBox(width: squareLen, height: squareLen, length: faceThickness, chamferRadius: chamfer)
        panelGeo.firstMaterial = colorDict[materialCode]
        
        let panelNode = SCNNode(geometry: panelGeo)
        panelNode.position = pos
        panelNode.eulerAngles = orientation
        
        // TODO: capitalize cubie and change node to cubieNode
        
        parentCubieNode.addChildNode(panelNode)
    }
}
