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


struct Move {
    var axisString:String
    var angle:Angle
}


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





class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create scene
        let scene = SCNScene()
        
        // define the rubicks cube
        // let dimensionOfCube:Int = 3
        // let ourCube:customCube = customCube(numCubiesPerSide: dimensionOfCube, parentNode: scene.rootNode)
        
//        let ourCube:rubicksCube = rubicksCube(parentNode: scene.rootNode)
//        
//        
//        let when = DispatchTime.now() + 5 // change 2 to desired number of seconds
//        DispatchQueue.main.asyncAfter(deadline: when) {
//            // Your code with delay
//            //ourCube.setRotationsToRun(moves: moveArray)
//            //ourCube.runRotations()
//        }
        
        
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
            
            
            // TODO: use other dict type?
            
            
            
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
        
        print(solveCube(arrayOfCubies: cubeArrayToSolve))
        
        
        

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 35)
        
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
