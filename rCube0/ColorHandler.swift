//
//  ColorHandler.swift
//  rCube0
//
//  Created by Robert "Skipper" Gonzalez on 8/11/17.
//  Copyright © 2017 Robert "Skipper" Gonzalez. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import SceneKit




let colorDict:[String: SCNMaterial] = [
    
    "(1,0,0)" : materialArray[1],
    "(-1,0,0)" : materialArray[3],
    "(0,1,0)" : materialArray[4],
    "(0,-1,0)" : materialArray[5],
    "(0,0,1)" : materialArray[0],
    "(0,0,-1)" : materialArray[2],
    
    
]

let colorNameDic:[String: String] = [
    
    "(1,0,0)" : "Green",
    "(-1,0,0)" : "Blue",
    "(0,1,0)" : "Red",
    "(0,-1,0)" : "Orange",
    "(0,0,1)" : "White",
    "(0,0,-1)" : "Yellow",
    
]






func makeMaterials() -> [SCNMaterial]{
    let colors = [UIColor.white, UIColor.green, UIColor.yellow, UIColor.blue, UIColor.red, UIColor.orange, UIColor.black, UIColor.gray]
    var materials = [SCNMaterial]()
    
    for i in colors {
        
        let material = SCNMaterial()
        material.diffuse.contents = i
        material.locksAmbientWithDiffuse = true
        
        materials.append(material)
        
        //print("index", colors.index(of: i), "gives color ", i)
    }
    
    return materials
}


//
//func makeMaterialFromEncoding(positionEncoding:[Int]) -> [SCNMaterial] {
//
//
//
//
//
//
//    let materials:[SCNMaterial] = makeMaterials()
//
//    var uniqueMaterials:[SCNMaterial]
//
//    for i in 0...(positionEncoding.characters.count - 1) {
//        if encoding[i] == 1 {
//            uniqueMaterials.append(materials[i])
//        }
//        else {
//            uniqueMaterials.append(materials[6])
//        }
//    }
//
//    return uniqueMaterials
//}



let materialArray = makeMaterials()



class ColorHandler { }



