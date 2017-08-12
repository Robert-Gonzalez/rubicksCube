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

// TODO: find way to know if a rubiks cube configuration is real

class customCube {
    
    private var cubieMap: [String: cubie] = [:]
    private var rotiationGroupMap: [String : rotationGroup] = [:]
    private let cubeNode:SCNNode = SCNNode()
    private var movesToExecute:[Move] = []
    let rubicksCubeSideLen:CGFloat = 10
    
    init(numCubiesPerSide:Int, parentNode:SCNNode) {
        
        // side length of each individual cubie based on the desired size of the whole cube as well as the number of cubes used
        let cubieSideLen:CGFloat = rubicksCubeSideLen/CGFloat(numCubiesPerSide)
        
        // maximum coordinate magnitude
        let maxCoordMag = numCubiesPerSide/2

        // loop through all possible coordinates
        for coord1 in -maxCoordMag ... maxCoordMag {
            for coord2 in -maxCoordMag ... maxCoordMag {
                for coord3 in -maxCoordMag ... maxCoordMag {
                    
                    // if the coordinate is not on the surface of the cube space, set up next cube
                    if (abs(coord1) < maxCoordMag) && (abs(coord2) < maxCoordMag) && (abs(coord3) < maxCoordMag) {continue}
                    
                    // create coordinate array, initialize cubie, and add it to the big cube as a child node
                    let coordArray = [coord1, coord2, coord3]
                    let isDimensionOdd: Bool = (numCubiesPerSide%2 != 0)
                    
                    let cub:cubie = cubie(coordArray: coordArray, sideLen:cubieSideLen, ofOddCube: isDimensionOdd, maxCoordMag: maxCoordMag)
                    cub.setParent(parent: cubeNode)
                    
                    // create string keys for the three rotation groups, and place into array
                    let rotGroupAxisArrays:[[Int]] = makeRotGroupAxisArrays(coords: coordArray)
                    
                    // create key for the coordinates of the cubie for each rotation group's map
                    let coordString = "(" + String(coord1) + "," + String(coord2) + "," + String(coord3) + ")"
                    
                    for axisArray in rotGroupAxisArrays {
                        
                        let axisString:String = "(" + String(axisArray[0]) + "," + String(axisArray[1]) + "," + String(axisArray[2]) + ")"
                        
                        // if the rotation group does not exist, create it
                        if rotiationGroupMap[axisString] == nil {
                            
                            // make axis of rotation for group, then create new group
                            let axis = SCNVector3(axisArray[0], axisArray[1], axisArray[2])
                            let newRotGroup:rotationGroup = rotationGroup(axisVec: axis, bigCube: self, parent: cubeNode)
                            
                            // add group to the big cube's node and the big cube's map of rotation groups
                            rotiationGroupMap[axisString] = newRotGroup
                            
                        }
                        
                        // add the cubie to the rotation group
                        rotiationGroupMap[axisString]?.assignCubieAtCoord(cubie: cub, coordKey: coordString)
                    }
                }
            }
        }
        // add big cube to parent node (probably a root node)
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
    
    private func makeRotGroupAxisArrays(coords:[Int]) -> [[Int]] {
        
        
                let rotAxis1 = [coords[0],0,0]
                let rotAxis2 = [0,coords[1],0]
                let rotAxis3 = [0,0,coords[2]]
        
                return [rotAxis1, rotAxis2, rotAxis3]
        
    }
}
