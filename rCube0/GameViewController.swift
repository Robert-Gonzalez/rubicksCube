//
//  GameViewController.swift
//  rCube0
//
//  Created by Robert "Skipper" Gonzalez on 7/15/17.
//  Copyright © 2017 Robert "Skipper" Gonzalez. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
//import FirebaseDatabase



let rotateTime:TimeInterval = 0.2





func makeVecWithCoordString(coordAsString: String) -> SCNVector3 {
    
    return makeVecWithCoordinateArray(coord: (makeCorrdArrayWithCoordString(coordString: coordAsString)))
}

func makeCorrdArrayWithCoordString(coordString: String) -> [Float] {
    
    
    var coordinates:[Float] = []
    
    var currentCoord:String = ""
    
    for i in coordString.characters {
        
        if i ==  "," || i == ")" {
            
            coordinates.append(Float(currentCoord)!)
            currentCoord = ""
        }
        else if i != "(" {
            
            currentCoord.append(i)
            
        }
    }
    
    return coordinates
    
    
}

func makeVecWithCoordinateArray(coord: [Float]) -> SCNVector3 {
    
    
    
    let vec:SCNVector3 = SCNVector3(coord[0], coord[1], coord[2])
    
    return vec
    
}

func makeCoordStringWithCoordArray(coordArray: [Float]) -> String {
    
    return "(" + String(Int(coordArray[0])) +  "," + String(Int(coordArray[1])) +  "," + String(Int(coordArray[2])) +  ")"
    
}

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



let bigMaterialArray = makeMaterials()

let colorDict:[String: SCNMaterial] = [

    "(1,0,0)" : bigMaterialArray[1],
    "(-1,0,0)" : bigMaterialArray[3],
    "(0,1,0)" : bigMaterialArray[4],
    "(0,-1,0)" : bigMaterialArray[5],
    "(0,0,1)" : bigMaterialArray[0],
    "(0,0,-1)" : bigMaterialArray[2],


]

let colorNameDic:[String: String] = [
    
    "(1,0,0)" : "Green",
    "(-1,0,0)" : "Blue",
    "(0,1,0)" : "Red",
    "(0,-1,0)" : "Orange",
    "(0,0,1)" : "White",
    "(0,0,-1)" : "Yellow",
    
]


struct Move {
    var axisString:String
    var angle:Angle
}




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


class rubicksCube: customCube {
    
    init(parentNode: SCNNode) {
        let position:SCNVector3 = SCNVector3(0.0, 0.0, -20.0)
        super.init(cubeSideLen: 10, numCubiesPerSide: 3, cubePos: position, parentNode: parentNode)
    }
    
    // TODO: still remember to check about coordinates being stored as strings
    
  
    
    // TODOL find a way for this subclass to be usefull
    
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
            print([(face, turn)])
            let altPath:[(FaceType,TurnType)] = [(face, turn)] + solveCube(arrayOfCubies: turnFace(cubieArray: arrayOfCubies, face: face, turn: turn))
            
            check += 1
            
            
            
            
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







class GameViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // create scene
        let scene = SCNScene()
        
        
        // conveniece placement of rubicks cube properties
        let cubeX:Float = 0.0
        let cubeY:Float = 0.0
        let cubeZ:Float = -20.0
        //let cubieCurve:CGFloat = 0.5
        let rubicksCubeSideLen:CGFloat = 10
        let dimensionOfCube:Int = 4

        
        // set up the vector witht the cube's position
        let ourCubePos:SCNVector3 = SCNVector3Make(cubeX, cubeY, cubeZ)
        
        
        // define the rubicks cube
        let ourCube:customCube = customCube(cubeSideLen: rubicksCubeSideLen, numCubiesPerSide: dimensionOfCube, cubePos: ourCubePos, parentNode: scene.rootNode)
        
        //let ourCube:rubicksCube = rubicksCube(parentNode: scene.rootNode)
        
        let moveArray:[Move] = [
            
            Move(axisString: Face.Left.rawValue, angle: Angle.quarterTurnAngle),
            Move(axisString: Face.Left.rawValue, angle: Angle.quarterTurnAngle),
            Move(axisString: Face.Left.rawValue, angle: Angle.quarterTurnAngle),
            Move(axisString: Face.Left.rawValue, angle: Angle.quarterTurnAngle),
            
            
            Move(axisString: Face.Right.rawValue, angle: Angle.quarterTurnAngle),
            Move(axisString: Face.Right.rawValue, angle: Angle.quarterTurnAngle),
            Move(axisString: Face.Right.rawValue, angle: Angle.quarterTurnAngle),
            Move(axisString: Face.Right.rawValue, angle: Angle.quarterTurnAngle),
            
            
            Move(axisString: Face.Front.rawValue, angle: Angle.quarterTurnAngle),
            Move(axisString: Face.Front.rawValue, angle: Angle.quarterTurnAngle),
            Move(axisString: Face.Front.rawValue, angle: Angle.quarterTurnAngle),
            Move(axisString: Face.Front.rawValue, angle: Angle.quarterTurnAngle),
            
            
            Move(axisString: "(0,0,-1)", angle: Angle.quarterTurnAngle),
            Move(axisString: "(0,0,-1)", angle: Angle.quarterTurnAngle),
            Move(axisString: "(0,0,-1)", angle: Angle.quarterTurnAngle),
            Move(axisString: "(0,0,-1)", angle: Angle.quarterTurnAngle),
            
            Move(axisString: "(0,1,0)", angle: Angle.quarterTurnAngle),
            Move(axisString: "(0,1,0)", angle: Angle.quarterTurnAngle),
            Move(axisString: "(0,1,0)", angle: Angle.quarterTurnAngle),
            Move(axisString: "(0,1,0)", angle: Angle.quarterTurnAngle),
            
            
            Move(axisString: "(0,-1,0)", angle: Angle.quarterTurnAngle),
            Move(axisString: "(0,-1,0)", angle: Angle.quarterTurnAngle),
            Move(axisString: "(0,-1,0)", angle: Angle.quarterTurnAngle),
            Move(axisString: "(0,-1,0)", angle: Angle.quarterTurnAngle),
            
            
            Move(axisString: "(1,0,0)", angle: Angle.quarterTurnAngle),
            Move(axisString: "(0,1,0)", angle: Angle.quarterTurnAngle),
            Move(axisString: "(0,0,1)", angle: Angle.quarterTurnAngle),
            Move(axisString: "(0,-1,0)", angle: Angle.quarterTurnAngle),
            Move(axisString: "(-1,0,0)", angle: Angle.quarterTurnAngle),
            Move(axisString: "(0,0,-1)", angle: Angle.quarterTurnAngle),
            
            Move(axisString: "(1,0,0)", angle: Angle.quarterTurnAngle),
            Move(axisString: "(0,1,0)", angle: Angle.quarterTurnAngle),
            Move(axisString: "(0,0,1)", angle: Angle.quarterTurnAngle),
            Move(axisString: "(0,-1,0)", angle: Angle.quarterTurnAngle),
            Move(axisString: "(-1,0,0)", angle: Angle.quarterTurnAngle),
            Move(axisString: "(0,0,-1)", angle: Angle.quarterTurnAngle),
            
            
            Move(axisString: "(0,0,-1)", angle: Angle.inverseQuarterTurnAngle),
            Move(axisString: "(-1,0,0)", angle: Angle.inverseQuarterTurnAngle),
            Move(axisString: "(0,-1,0)", angle: Angle.inverseQuarterTurnAngle),
            Move(axisString: "(0,0,1)", angle: Angle.inverseQuarterTurnAngle),
            Move(axisString: "(0,1,0)", angle: Angle.inverseQuarterTurnAngle),
            Move(axisString: "(1,0,0)", angle: Angle.inverseQuarterTurnAngle),
            
            Move(axisString: "(0,0,-1)", angle: Angle.inverseQuarterTurnAngle),
            Move(axisString: "(-1,0,0)", angle: Angle.inverseQuarterTurnAngle),
            Move(axisString: "(0,-1,0)", angle: Angle.inverseQuarterTurnAngle),
            Move(axisString: "(0,0,1)", angle: Angle.inverseQuarterTurnAngle),
            Move(axisString: "(0,1,0)", angle: Angle.inverseQuarterTurnAngle),
            Move(axisString: "(1,0,0)", angle: Angle.inverseQuarterTurnAngle)
            
        ]
        
        
        
        
        let when = DispatchTime.now() + 5 // change 2 to desired number of seconds
        
        
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            ourCube.setRotationsToRun(moves: moveArray)
            ourCube.runRotations()
        }
        
        
//        
//        
//        let cubeArrayToSolve:[Int] = [
//            
//            
//            // TODO: use real dict?
//            
//            
//            
//            //corners
//            
//            cubieDict["whiteBlueOrange"]!, // white bottom left
//            cubieDict["whiteBlueRed"]!, // white top left
//            cubieDict["whiteGreenRed"]!, // white top right
//            cubieDict["whiteGreenOrange"]!, // white bottom right
//            cubieDict["yellowGreenOrange"]!, // yellow bottom left
//            cubieDict["yellowGreenRed"]!, // yellow top left
//            cubieDict["yellowBlueRed"]!, // yellow top right
//            cubieDict["yellowBlueOrange"]!, // yellow bottom right
//            
//            
//            //edges
//                                
//                                
//            cubieDict["whiteOrange"]!, // white bottom
//            cubieDict["whiteBlue"]!, // white left
//            cubieDict["whiteRed"]!, // white top
//            cubieDict["whiteGreen"]!, // white right
//            cubieDict["yellowOrange"]!, // yellow bottom
//            cubieDict["yellowGreen"]!, // yellow left
//            cubieDict["yellowRed"]!, // yellow top
//            cubieDict["yellowBlue"]!, // yellow right
//            cubieDict["greenRed"]!, // green top
//            cubieDict["greenOrange"]!, // green bottom
//            cubieDict["blueRed"]!, // blue top
//            cubieDict["blueOrange"]! // blue bottom
//            
//            
//
//        
//        ]
        
        
        
        
        let cubeArrayToSolve:[Int] = [
            
            
            // TODO: use real dict?
            
            
            
            //corners
            
            cubieDict["whiteBlueOrange"]!, // white bottom left
            cubieDict["whiteBlueRed"]!, // white top left
            cubieDict["whiteGreenOrange"]!, // white top right
            cubieDict["yellowGreenOrange"]!, // white bottom right
            cubieDict["yellowBlueOrange"]!, // yellow bottom left
            cubieDict["yellowGreenRed"]!, // yellow top left
            cubieDict["whiteGreenRed"]!, // yellow top right
            cubieDict["yellowBlueRed"]!, // yellow bottom right
            
            
            //edges
            
            
            cubieDict["whiteOrange"]!, // white bottom
            cubieDict["whiteBlue"]!, // white left
            cubieDict["whiteRed"]!, // white top
            cubieDict["greenOrange"]!, // white right
            cubieDict["yellowBlue"]!, // yellow bottom
            cubieDict["greenOrange"]!, // yellow left
            cubieDict["greenRed"]!, // yellow top
            cubieDict["yellowRed"]!, // yellow right
            cubieDict["whiteGreen"]!, // green top
            cubieDict["yellowGreen"]!, // green bottom
            cubieDict["blueRed"]!, // blue top
            cubieDict["blueOrange"]! // blue bottom
            
            
            
            
        ]
        
        //print(solveCube(arrayOfCubies: cubeArrayToSolve))
        
        
        

        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.white
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.purple
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
    }
    
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject = hitResults[0]
            
            let colors: [UIColor] = [UIColor.green, UIColor.red, UIColor.blue, UIColor.yellow, UIColor.purple, UIColor.white]
            
            // get its material
            let material = result.node!.geometry!.materials[result.geometryIndex]
            
            var newIndex:Int = Int(arc4random_uniform(6))
            
            let newMaterial = SCNMaterial()
            newMaterial.diffuse.contents = colors[newIndex]
            newMaterial.locksAmbientWithDiffuse = true
            
            while newMaterial.diffuse.contents as! UIColor == material.diffuse.contents as! UIColor {
                newIndex = Int(arc4random_uniform(6))
                newMaterial.diffuse.contents = colors[newIndex]
            }
            
            // rotate it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0
            
            
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0
                
                
//                result.node!.runAction(SCNAction.rotateBy(x: 3.14/2.0, y: 0, z: 0, duration: 1))
                
                SCNTransaction.commit()
            }

            
            
            result.node!.runAction(SCNAction.rotateBy(x: 0, y: 3.14/2.0, z: 0, duration: 1))
            
            SCNTransaction.commit()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
}
