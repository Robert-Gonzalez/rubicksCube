//
//  Panel.swift
//  rCube0
//
//  Created by Robert "Skipper" Gonzalez on 8/1/17.
//  Copyright © 2017 Robert "Skipper" Gonzalez. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import SceneKit


//consider forming single class with cubie
private class panel {
    
    init(materialCode:String, pos:SCNVector3, thickness:CGFloat, squareLen:CGFloat, chamfer:CGFloat, orientation: SCNVector3, parent: SCNNode) {
        
        let panel = SCNBox(width: squareLen, height: squareLen, length: thickness, chamferRadius: chamfer)
        panel.firstMaterial = colorDict[materialCode]
        
        let panelNode = SCNNode(geometry: panel)
        panelNode.position = pos
        panelNode.eulerAngles = orientation
        
        parent.addChildNode(panelNode)
    }
}
