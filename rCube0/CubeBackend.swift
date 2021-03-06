//
//  CubeBackend.swift
//  rCube0
//
//  Created by Robert "Skipper" Gonzalez on 8/11/17.
//  Copyright © 2017 Robert "Skipper" Gonzalez. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import SceneKit




func turnTransform(coordinates: [Int], axisSign:Int, angle:Angle) -> [Int] {
    
    
    
    if angle == Angle.quarterTurnAngle {
        
        return [axisSign * coordinates[1], axisSign * -coordinates[0]]
        
    }
        
        
    else if angle == Angle.inverseQuarterTurnAngle {
        
        
        return [ -axisSign * coordinates[1], -axisSign * -coordinates[0]]
        
    }
        
    else {
        
        return [ -coordinates[0], -coordinates[1]]
        
    }
    
    
    
}




let cubieDict:[String:Int] = [
    
    // corners
    "whiteBlueOrange":      0,
    "whiteBlueRed":         1,
    "whiteGreenRed":        2,
    "whiteGreenOrange":     3,
    "yellowGreenOrange":    4,
    "yellowGreenRed":       5,
    "yellowBlueRed":        6,
    "yellowBlueOrange":     7,
    
    
    
    // edges
    "whiteOrange":          8,
    "whiteBlue":            9,
    "whiteRed":             10,
    "whiteGreen":           11,
    "yellowOrange":         12,
    "yellowGreen":          13,
    "yellowRed":            14,
    "yellowBlue":           15,
    "greenRed":             16,
    "greenOrange":          17,
    "blueRed":              18,
    "blueOrange":           19
]


let faceEdgesIndeciesDict:[String:[Int]] = [
    
    "Left" :    [cubieDict["whiteGreen"]!, cubieDict["whiteRed"]!, cubieDict["yellowGreen"]!, cubieDict["greenOrange"]!],
    
    
    "Right":    [cubieDict["yellowBlue"]!, cubieDict["blueRed"]!, cubieDict["whiteBlue"]!, cubieDict["blueOrange"]!],
    
    
    "Front":    [cubieDict["whiteBlue"]!, cubieDict["whiteRed"]!, cubieDict["whiteGreen"]!, cubieDict["whiteOrange"]!],
    
    
    "Back":     [cubieDict["yellowGreen"]!, cubieDict["yellowRed"]!, cubieDict["yellowBlue"]!, cubieDict["yellowOrange"]!],
    
    
    "Top":      [cubieDict["blueRed"]!, cubieDict["yellowRed"]!, cubieDict["greenRed"]!, cubieDict["whiteRed"]!],
    
    
    "Bottom":   [cubieDict["blueOrange"]!, cubieDict["whiteOrange"]!, cubieDict["greenOrange"]!, cubieDict["yellowOrange"]!],
]




let faceCornersIndeciesDict:[String:[Int]] = [
    
    "Left" :    [cubieDict["whiteGreenOrange"]!, cubieDict["whiteGreenRed"]!, cubieDict["yellowGreenRed"]!, cubieDict["yellowGreenOrange"]!],
    
    
    "Right":    [cubieDict["whiteBlueOrange"]!, cubieDict["yellowBlueOrange"]!, cubieDict["yellowBlueRed"]!, cubieDict["whiteBlueRed"]!],
    
    
    "Front":    [cubieDict["whiteBlueOrange"]!, cubieDict["whiteBlueRed"]!, cubieDict["whiteGreenRed"]!, cubieDict["whiteGreenOrange"]!],
    
    
    "Back":     [cubieDict["yellowGreenOrange"]!, cubieDict["yellowGreenRed"]!, cubieDict["yellowBlueRed"]!, cubieDict["yellowBlueOrange"]!],
    
    
    "Top":      [cubieDict["whiteBlueRed"]!, cubieDict["yellowBlueRed"]!, cubieDict["yellowGreenRed"]!, cubieDict["whiteGreenRed"]!],
    
    
    "Bottom":   [cubieDict["yellowGreenOrange"]!, cubieDict["yellowBlueOrange"]!, cubieDict["whiteBlueOrange"]!, cubieDict["whiteGreenOrange"]!],
    
]







func makeConfigStringRep(arrayRep:[Int]) -> String {
    
    var stringRep = "("
    
    
    for i in 0 ... arrayRep.count-1 {
        
        stringRep.append(String(arrayRep[i]))
        
        
        if i != arrayRep.count-1 {
            stringRep.append(",")
        }
        else {
            stringRep.append(")")
        }
        
    }
    
    return stringRep
    
}



class cublet {
    
    private var cubieArray:[Int]
    
    private let solvedCubieString = "(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19)"
    
    
    
    init(arrayOfCubieNums:[Int]) {
        
        cubieArray = arrayOfCubieNums
    }
    
    
    
    
    
}

let solvedCubieString = "(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19)"



enum FaceType:String {
    
    case Left = "Left"
    case Right = "Right"
    case Front = "Front"
    case Back = "Back"
    case Top = "Top"
    case Bottom = "Bottom"
    
}

enum TurnType : Int {
    
    case quarterTurn = 1
    case halfTurn = 2
    case inverseTurn = -1
    
}





var tableOfCheckedConfigurationsPaths:[String:[(FaceType,TurnType)]] = [:]

var tableOfCheckedConfigurationsStrings:[String:String] = [:]






var check = 0


func solveCube(arrayOfCubies:[Int]) -> [(FaceType,TurnType)] {
    
    
    
    
    let configString = makeConfigStringRep(arrayRep: arrayOfCubies)
    
    
    print(configString)
    
    
    if tableOfCheckedConfigurationsStrings[configString] != nil {
        
        print("TRUE")
        return []
        
        //tableOfCheckedConfigurationsPaths[configString]!
    }
    
    
    if configString == solvedCubieString {
        
        print("Done!")
        return []
        
        
    }
    
    
    tableOfCheckedConfigurationsStrings[configString] = configString
    
    //print(tableOfCheckedConfigurationsStrings)
    
    
    
    let turnArray = [TurnType.quarterTurn, TurnType.halfTurn, TurnType.inverseTurn]
    
    
    let faceArray = [FaceType.Left, FaceType.Right, FaceType.Front, FaceType.Back, FaceType.Top, FaceType.Bottom]
    
    
    var altPaths:[[(FaceType,TurnType)]] = []
    
    
    for turn in turnArray {
        for face in faceArray{
            print("check: ", check)
            print(face)
            print(turn)
            check += 1
            
            print([(face, turn)])
            
            let altPath:[(FaceType,TurnType)] = [(face, turn)] + solveCube(arrayOfCubies: turnFace(cubieArray: arrayOfCubies, face: face, turn: turn))
            
            
            
            
            
            
            altPaths.append(altPath)
            
        }
        
        
        
    }
    
    var min = Int.max
    var minIndex:Int = 0
    
    for i in 0 ... altPaths.count {
        
        
        let path = altPaths[i]
        
        if (path.count < min) {
            min = path.count
            
            minIndex = i
            
        }
    }
    
    tableOfCheckedConfigurationsPaths[configString] = altPaths[minIndex]
    
    return altPaths[minIndex]
    
    
}



func turnFace(cubieArray:[Int], face: FaceType, turn: TurnType) -> [Int] {
    
    let turnedCorners = turnFaceForCubieType(cubieArray: cubieArray, cubieTypeDict: faceCornersIndeciesDict, face: face, turn: turn)
    
    let turnedEdgesAndCorners = turnFaceForCubieType(cubieArray: turnedCorners, cubieTypeDict: faceEdgesIndeciesDict, face: face, turn: turn)
    
    return turnedEdgesAndCorners
    
}

func turnFaceForCubieType(cubieArray:[Int], cubieTypeDict:[String:[Int]], face: FaceType, turn: TurnType) -> [Int] {
    
    
    var newArray = cubieArray
    
    let indexDict:[Int] = cubieTypeDict[face.rawValue]!
    
    let numIndecies:Int = indexDict.count
    
    
    if turn == TurnType.quarterTurn {
        
        var temp1:Int
        
        var temp2:Int = newArray[indexDict[0]]
        
        for index in 0 ... (indexDict.count - 1) {
            
            
            temp1 = newArray[indexDict[(index + 1)%numIndecies]]
            
            newArray[indexDict[(index + 1)%numIndecies]] = temp2
            
            temp2 = temp1
        }
        
    }
        
        
        
        
        
    else if turn == TurnType.halfTurn {
        
        for index in 0 ... ((indexDict.count - 1)/2) {
            
            
            let temp = newArray[indexDict[(index + 2)%numIndecies]]
            
            
            newArray[indexDict[(index + 2)%numIndecies]] = cubieArray[indexDict[0]]
            
            
            newArray[indexDict[0]] = temp
            
            
        }
        
    }
        
        
    else {
        
        
        var temp1:Int
        
        var temp2:Int = newArray[indexDict[indexDict.count-1]]
        
        for index in (indexDict.count - 1) ... 0 {
            
            
            temp1 = newArray[indexDict[(index - 1)%numIndecies]]
            
            newArray[indexDict[(index - 1)%numIndecies]] = temp2
            
            temp2 = temp1
        }
        
        
    }
    
    
    return newArray
    
}


