//
//  RotationGroup.swift
//  rCube0
//
//  Created by Robert "Skipper" Gonzalez on 8/1/17.
//  Copyright © 2017 Robert "Skipper" Gonzalez. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import SceneKit



class rotationGroup {
    
    private let cube: customCube
    private var cubieMap: [String : cubie] = [:]
    private let groupNode = SCNNode()
    private let axis:SCNVector3
    private var angleOfRotation: CGFloat = 0 
    
    
    init(axisVec:SCNVector3, bigCube: customCube, parent: SCNNode) {
        axis = axisVec
        cube = bigCube
        parent.addChildNode(groupNode)
    }
    
    func assignCubieAtCoord(cubie: cubie, coordKey: String) {
        cubieMap[coordKey] = cubie
    }
    
    func getMap() -> [String : cubie] {
        return cubieMap
    }
    
    func rotate(angle: CGFloat) {
        
        angleOfRotation = angle
        
        for (_, cubie) in cubieMap {
            cubie.setParent(parent: groupNode)
        }
        
        let rotiation:SCNAction = SCNAction.rotate(by: angleOfRotation, around: axis, duration: rotateTime)
        
        
        groupNode.runAction(rotiation, completionHandler: resetMaps)
        
    }
    
    private func resetMaps() {
        
        // start by turning the rotation group name into an array
        var groupNameAsArray = [axis.x, axis.y, axis.z]
        
        // declare the index that's fixed
        var fixedIndex:Int = 0
        
        // find that index
        for i in 0 ... groupNameAsArray.count {
            
            if groupNameAsArray[i] != 0 {
                fixedIndex = i
                
                break
            }
        }
        
        var newCubieMap: [String : cubie] = [:]
        
        // TODO: review all private vs public class vars
        for (key, cubie) in cubieMap {

            // turn the key, the coordinates of the cubie in the group, into an array
            let keyAsArray = makeCorrdArrayWithCoordString(coordString: key)
            
            // find the coordinate array elements
            let pairToTransform = [Int(keyAsArray[(fixedIndex+1)%3]), Int(keyAsArray[(fixedIndex+2)%3])]
            
            // get the pair transformed
            let transformedPair = turnTransform(coordinates: pairToTransform, axisSign: Int(groupNameAsArray[fixedIndex]), angle: Angle(rawValue: Float(angleOfRotation))!)
            
            var transformedTriple:[Float] = [0,0,0]
            
            // place the transformed pair into the three-elem array for new coordinates
            transformedTriple[fixedIndex] = groupNameAsArray[fixedIndex]
            
            transformedTriple[(fixedIndex+1)%3] = Float(transformedPair[0])
            transformedTriple[(fixedIndex+2)%3] = Float(transformedPair[1])

            // the new coordinates of the moved cubie
            let newCoordString = makeCoordStringWithCoordArray(coordArray: transformedTriple)
            
            newCubieMap[newCoordString] = cubie

            var tripleForOtherGroup1:[Float] = [0,0,0]
            var tripleForOtherGroup2:[Float] = [0,0,0]

            tripleForOtherGroup1[(fixedIndex+1)%3] = Float(transformedPair[0])
            tripleForOtherGroup2[(fixedIndex+2)%3] = Float(transformedPair[1])
            
            let stringForG1 = makeCoordStringWithCoordArray(coordArray: tripleForOtherGroup1)
            let stringForG2 = makeCoordStringWithCoordArray(coordArray: tripleForOtherGroup2)
  
            cube.assignCubieAtPosition(groupKey: stringForG1, coordKey: newCoordString, cubieToAdd: cubie)
            cube.assignCubieAtPosition(groupKey: stringForG2, coordKey: newCoordString, cubieToAdd: cubie)
        }
        cubieMap = newCubieMap
        
        resetSpatialProperties()
        
    }
    
    private func resetSpatialProperties() {
        
        for (_, cubie) in cubieMap {
            
            let groupOrientation:SCNQuaternion = groupNode.orientation
            let newGlobalPos:SCNVector3 = cubie.getRelativePos(observerNode: groupNode.parent!)
            
            let newOrientation = combineQuaternions(q1: groupOrientation, q2: cubie.getOrientation() )
            
            cubie.setPos(position: newGlobalPos)
            cubie.setOrientation(orientation: newOrientation)
            
            let newParent =  (groupNode.parent)!
            
            cubie.setParent(parent: newParent)
        }
        
        groupNode.orientation = SCNQuaternion(0,0,0,0)
        
        cube.runRotations()
    }
    
    private func combineQuaternions(q1:SCNQuaternion, q2:SCNQuaternion) -> SCNQuaternion {
        
        var newQ:SCNQuaternion = q1
        
        newQ.w = q1.w*q2.w - q1.x*q2.x - q1.y*q2.y - q1.z*q2.z
        newQ.x = q1.w*q2.x + q1.x*q2.w + q1.y*q2.z - q1.z*q2.y
        newQ.y = q1.w*q2.y - q1.x*q2.z + q1.y*q2.w + q1.z*q2.x
        newQ.z = q1.w*q2.z + q1.x*q2.y - q1.y*q2.x + q1.z*q2.w
        
        return newQ
        
    }
}
