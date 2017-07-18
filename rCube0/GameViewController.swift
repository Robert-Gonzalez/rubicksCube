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

let sideLen:CGFloat = 5.0

func scaleVector(vec:SCNVector3) -> SCNVector3 {
    vec.x = vec.x*sideLen
    vec.y = vec.y*sideLen
    vec.z = vec.z*sideLen
    
    return vec
}

func makeMaterials() -> [SCNMaterial]{
    let colors = [UIColor.white, UIColor.green, UIColor.yellow, UIColor.blue, UIColor.red, UIColor.orange, UIColor.black, UIColor.gray]
    var materials = [SCNMaterial]()
    
    for i in colors {
        
        let material = SCNMaterial()
        material.diffuse.contents = i
        material.locksAmbientWithDiffuse = true
        
        materials.append(material)
    }
    
    return materials
}


enum cubieType {
    case trueCenter, faceCenter, corner, edge
}


enum faceType {
    case white, green, yellow, blue, red, orange
}








let colorCodes = [
    "posZ": "100000",
    "negZ": "001000",
    
    
    "posX": "010000",
    "negX": "000100",
    
    "posY": "000010",
    "negY": "000001",

]




func makeMaterialsFromEncoding(positionEncoding:String) -> [SCNMaterial] {
    
    
    let materials:[SCNMaterial] = makeMaterials()
    
    var uniqueMaterials:[SCNMaterial]
    
    for i in 0...(positionEncoding.characters.count - 1) {
        if encoding[i] == 1 {
            uniqueMaterials.append(materials[i])
        }
        else {
            uniqueMaterials.append(materials[6])
        }
    }
    
    return uniqueMaterials
}





class cubie {
    
    // node of cube to be attatched to the parent node of a face
    private var node:SCNNode
    
    init(materialCode:[Bool], pos:SCNVector3) {
        
        let chamfer:CGFloat = 1.0
        
        let box = SCNBox(width: sideLen, height: sideLen, length: sideLen, chamferRadius: chamfer)
        
        box.materials = makeMaterialsFromEncoding(encoding: materialCode)
        
        
        node = SCNNode(geometry: box)
        node.position = scaleVector(vec: pos)
    }
    
    
    func getPos() -> SCNVector3 {
    
        return node.position
    }
    
    func setPos(newPos:SCNVector3) {
        
        self.node.position = scaleVector(vec: newPos)
            
    }
    
}


class face {

    
    var center:cubie
    var edges:[cubie]
    var corners:[cubie]
    
    init(faceColor:color, position: SCNVector3) {
        
        center = cubie(materialCode: <#T##[Bool]#>, pos: position)
        
        
        let coordinateOptions:[Float] =
        
        
        let coord = [
            "no z" : [[]
            "no y" :
            "no x" :
        
        
        ]
        
        
        
        
        if center.getPos().z != 0 {
            for coordinate in coordinateOptions {
                
                
                
                let edgePosX:SCNVector3 = SCNVector3(x:coordinate[0], y:coordinate[1], z:sideLen)

                let edgeX:cubie = cubie(materials: [SCNMaterial], pos: edgePos)
                edges.append(edge)
                
                
                
                
                
                let edgePosY = SCNVector3(x:0, y:j, z:sideLen)

                let edgeY:cubie = cubie(materials: [SCNMaterial], pos: edgePos)
                edges.append(edge)
            }
        }
        
        
        
        
        
        
        
        
        
    }
    
}








class GameViewController: UIViewController {
    
    
    
    
    
    
    func makeCenterBoxes(materials:[SCNMaterial]) -> [SCNBox] {
        
        var centerBoxes = [SCNBox]()
        
        let sideLen:CGFloat = 5.0
        let chamfer:CGFloat = 1.0
        
        for i in 0...5 {
            var templateCenter = [SCNMaterial](repeating: materials[6], count:6)
            templateCenter[i] = materials[i]
            let centerBox = SCNBox(width: sideLen, height: sideLen, length: sideLen, chamferRadius: chamfer)
            centerBoxes.append(centerBox)
        }
        
        return centerBoxes
        
    }
    
    func makeCenterNodes(centerBoxes:[SCNBox]) -> [SCNNode] {
        
        var centerNodes = [SCNNode]()
        
        let sideLen:CGFloat = 5.0
        let centerDist:Float = Float(sideLen)
        
        for i in centerBoxes[0...5]{
            let centerNode = SCNNode(geometry: i)
            centerNode.position = SCNVector3(x: 0, y: 0, z: 0 + centerDist)
        
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        // create a new scene
//        let scene = SCNScene(/*named: "art.scnassets/ship.scn"*/)//!
//        
//
//        
//        let whiteMaterial = SCNMaterial()
//        whiteMaterial.diffuse.contents = UIColor.white
//        whiteMaterial.locksAmbientWithDiffuse   = true
//        
//        
//        let greenMaterial = SCNMaterial()
//        greenMaterial.diffuse.contents = UIColor.green
//        greenMaterial.locksAmbientWithDiffuse = true
//        
//        
//        let yellowMaterial = SCNMaterial()
//        yellowMaterial.diffuse.contents = UIColor.yellow
//        yellowMaterial.locksAmbientWithDiffuse = true
//        
//        let blueMaterial  = SCNMaterial()
//        blueMaterial.diffuse.contents = UIColor.blue
//        blueMaterial.locksAmbientWithDiffuse = true
//        
//        let redMaterial = SCNMaterial()
//        redMaterial.diffuse.contents = UIColor.red
//        redMaterial.locksAmbientWithDiffuse = true
//        
//        let orangeMaterial = SCNMaterial()
//        orangeMaterial.diffuse.contents = UIColor.orange
//        orangeMaterial.locksAmbientWithDiffuse = true
//        
//        
//        
//        
//        
//        
//        
//        let blackMaterial = SCNMaterial()
//        blackMaterial.diffuse.contents = UIColor.black
//        blackMaterial.locksAmbientWithDiffuse   = true
//        
//        let darkGreyMaterial = SCNMaterial()
//        darkGreyMaterial.diffuse.contents = UIColor.darkGray
//        darkGreyMaterial.locksAmbientWithDiffuse   = true
//        
//        
//        
//        let sideLen:CGFloat = 5.0
//        let chamfer:CGFloat = 1.0
//
//        let trueCenter = SCNBox(width: sideLen, height: sideLen, length: sideLen, chamferRadius: chamfer)
//        let whiteCenter = SCNBox(width: sideLen, height: sideLen, length: sideLen, chamferRadius: 1.0)
//        let greenCenter = SCNBox(width: sideLen, height: sideLen, length: sideLen, chamferRadius: chamfer)
//        let yellowCenter = SCNBox(width: sideLen, height: sideLen, length: sideLen, chamferRadius: chamfer)
//        let blueCenter = SCNBox(width: sideLen, height: sideLen, length: sideLen, chamferRadius: chamfer)
//        let redCenter = SCNBox(width: sideLen, height: sideLen, length: sideLen, chamferRadius: chamfer)
//        let orangeCenter = SCNBox(width: sideLen, height: sideLen, length: sideLen, chamferRadius: chamfer)
        
        
        
//        trueCenter.firstMaterial = darkGreyMaterial
//        whiteCenter.materials = [whiteMaterial, blackMaterial, blackMaterial, blackMaterial, blackMaterial, blackMaterial]
//        greenCenter.materials = [blackMaterial, greenMaterial, blackMaterial, blackMaterial, blackMaterial, blackMaterial]
//        yellowCenter.materials = [blackMaterial, blackMaterial, yellowMaterial, blackMaterial, blackMaterial, blackMaterial]
//        blueCenter.materials = [blackMaterial, blackMaterial, blackMaterial, blueMaterial, blackMaterial, blackMaterial]
//        redCenter.materials = [blackMaterial, blackMaterial, blackMaterial, blackMaterial, redMaterial, blackMaterial]
//        orangeCenter.materials = [blackMaterial, blackMaterial, blackMaterial, blackMaterial, blackMaterial, orangeMaterial]
        
        
        //boxGeometry.materials = [whiteMaterial, greenMaterial, yellowMaterial, blueMaterial, redMaterial, orangeMaterial]
        
        
        
        let boxNode = SCNNode(geometry: trueCenter)
        
        
        boxNode.position = SCNVector3(x:0, y:0, z:-20)
        
        let trueCenterNode = SCNNode(geometry: trueCenter)
        
        
//        
//        let whiteCenterNode = SCNNode(geometry: whiteCenter)
//        let greenCenterNode = SCNNode(geometry: greenCenter)
//        let yellowCenterNode = SCNNode(geometry: yellowCenter)
//        let blueCenterNode = SCNNode(geometry: blueCenter)
//        let redCenterNode = SCNNode(geometry: redCenter)
//        let orangeCenterNode = SCNNode(geometry: orangeCenter)
        


        
        let centerX:Float = 0.0
        let centerY:Float = 0.0
        let centerZ:Float = -20.0
        
//        let centerDist:Float = Float(sideLen)
        
        trueCenterNode.position = SCNVector3(x: centerX, y: centerY, z: centerZ)
//        whiteCenterNode.position = SCNVector3(x: 0, y: 0, z: 0 + centerDist)
//        greenCenterNode.position = SCNVector3(x: 0 + centerDist, y: 0, z: 0)
//        yellowCenterNode.position = SCNVector3(x: 0, y: 0, z: 0 - centerDist)
//        blueCenterNode.position = SCNVector3(x: 0 - centerDist, y: 0, z: 0)
//        redCenterNode.position = SCNVector3(x: 0, y: 0 + centerDist, z: 0)
//        orangeCenterNode.position = SCNVector3(x: 0, y: 0 - centerDist, z: 0)
        
        
        
        
        let itemNode = SCNNode()
        
        
        //        boxNode.addChildNode(xNode)
        //        boxNode.addChildNode(xPointNode)
        //        boxNode.addChildNode(yNode)
        //        boxNode.addChildNode(yPointNode)
        //        boxNode.addChildNode(zNode)
        //        boxNode.addChildNode(zPointNode)
        
        trueCenterNode.addChildNode(whiteCenterNode)
        itemNode.addChildNode(greenCenterNode)
        trueCenterNode.addChildNode(yellowCenterNode)
        trueCenterNode.addChildNode(blueCenterNode)
        trueCenterNode.addChildNode(redCenterNode)
        trueCenterNode.addChildNode(orangeCenterNode)
        
        itemNode.addChildNode(trueCenterNode)
        
        
        scene.rootNode.addChildNode(itemNode)
        
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
        
        // retrieve the ship node
        //        let ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        
        // animate the 3d object
        //        ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 0.5, z: 0, duration: 1)))
        
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
            
            
            
            //material.diffuse.contents = newMaterial.diffuse.contents
            
            
            
            
//            ref?.child("Faces").child("face" + String(result.geometryIndex)).setValue(newIndex)
            //SCNAction.rotate(by: 3.14/2.0, around: result.node!.eulerAngles, duration: 1)
            
            
            
            
            
            
            
            
            
            
            
            
            //result.node!.runAction(SCNAction.rotateBy(x: 0, y: 3.14/2.0, z: 0, duration: 1))
            
            
            result.node!.pivot = SCNMatrix4Rotate(result.node!.pivot, 10, 10, 10, 10)
//            result.node!.runAction(SCNAction.rotateBy(x: 0, y: 3.14/2.0, z: 0, duration: 1))
            
            
            //result.node!.runAction(SCNAction)
            
            
            //result.node!.runAction(SCNAction.rotateBy(x: 3.14/2.0, y: 0, z: 0, duration: 1))
            
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
