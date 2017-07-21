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


func scaleVector(vec:SCNVector3, scalingFactor:Float) -> SCNVector3 {
    var vecToMut = vec
    
    vecToMut.x.multiply(by: scalingFactor)
    vecToMut.y.multiply(by: scalingFactor)
    vecToMut.z.multiply(by: scalingFactor)
    
    return vecToMut
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









//consider forming single class with cubie
class panel {
    
    var panelNode:SCNNode
    
    
    init(material:SCNMaterial, pos:SCNVector3, thickness:CGFloat, squareLen:CGFloat, chamfer:CGFloat) {
        
        
        let panel = SCNBox(width: squareLen, height: squareLen, length: thickness, chamferRadius: chamfer)
        
        panel.firstMaterial = material
        
        panelNode = SCNNode(geometry: panel)
        panelNode.position = pos
            //scaleVector(vec: pos, scalingFactor: Float(squareLen))
    }
    
    
}







class cubie {
    
    // node of cube to be attatched to the parent node of a face
    var node:SCNNode
    
    
    
    
    init(pos:SCNVector3, sideLen:CGFloat) {
        
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
    }
    
    
    
    // TODO: find out if these functions are needed
    func getPos() -> SCNVector3 {
        
        return node.position
    }
    
//    func setPos(newPos:SCNVector3) {
//        
//        self.node.position = scaleVector(vec: newPos, scalingFactor: sideLen)
//        
//    }
    
}







class rotationGroup {
    
    private var cubieMap: [String : cubie] = [:]
    
    private let groupNode = SCNNode()
    
    private let axis:SCNVector3
    
    init(vec:SCNVector3) {
        axis = vec
    }
    
    func getCubie(cubieCode:String) -> cubie {
        return cubieMap[cubieCode]!
    }
    
    func setCubie(cubieCode:String, newCubie:cubie) {
        cubieMap[cubieCode] = newCubie
    }
    
    
    func getNode() -> SCNNode {
        return groupNode
    }
    
    
    func rotate() {
        // TODO: implement rotation function that will add all member cubies to the rotation group's node and then rotate the node
        
        
        for (key, cubie) in cubieMap {
            groupNode.addChildNode(cubie.node)
            
        }
        
        groupNode.runAction(SCNAction.rotate(by: 3.14/2.0, around: axis, duration: 3))
        
        
        
    }


}


// TODO: find a good place for this definition
let sides:[String] = ["front", "back", "left", "right", "top", "bottom"]


class rubicksCube {
    
    // the representation where rotations will occur on the back end
    var cubieCoordMap: [String : Int] = [:]
    
    // map for the cubies on the screen
    var cubieMap: [String: cubie] = [:]
    
    // TODO: figure this thing out
    var rotiationGroupMap: [String : rotationGroup] = [:]
    
    let cubeNode:SCNNode = SCNNode()
    
    init(cubeSideLen:CGFloat, numCubiesPerSide:Int, cubePos:SCNVector3) {
        
        // side length of each individual cubie based on the desired size of the whole cube as well as the number of cubes used
        let cubieSideLen:CGFloat = cubeSideLen/CGFloat(numCubiesPerSide)
        
        // create initial node for the cube that will be attached to no geometry
        
        cubeNode.position = cubePos
        
        // create nodes for each of the rotation groups
        // TODO: actually use these nodes
        
        
        for side in sides {
            
            var rotAxis:SCNVector3
            
            if side == "front" || side == "back" {
                rotAxis = SCNVector3(0,0,1)
            }
            
            else if side == "left" || side == "right" {
                rotAxis = SCNVector3(1,0,0)
            }
            
            else {
                rotAxis = SCNVector3(0,1,0)
            }
            
            
            
            let rotGroup:rotationGroup = rotationGroup(vec: rotAxis)
            rotiationGroupMap[side] = rotGroup
            cubeNode.addChildNode(rotGroup.getNode())
        }
        
        
        
        
        
        
        
        
        
        
        // used for cubieCoordMap
        var cubieCount:Int = 0
        
        // maximum coordinate magnitude
        let maxCoordMag = numCubiesPerSide/2
        
        // loop through all possible coordinates
        // TODO: make sure this works for even numbers of numCubiesPerSide
        for coord1 in -maxCoordMag ... maxCoordMag {
            for coord2 in -maxCoordMag ... maxCoordMag {
                for coord3 in -maxCoordMag ... maxCoordMag {
                    
                    
                    
                    
                    
                    
                    
                    
                    // set the position of each cubie based on the coordinates
                    
                    let unitVec = SCNVector3(Float(coord1), Float(coord2), Float(coord3))
                    let cubiePos = scaleVector(vec: unitVec, scalingFactor: Float(cubieSideLen))
                    
                    
                    
                    // create a cubie using that position
                    // TODO: change variable names because it's easy to mix up cubieSideLen and cubeSideLen
                    let cub:cubie = cubie(pos: cubiePos, sideLen:cubieSideLen)
                    
                    
                    
                    // TODO: move where materials are established
                    let faceMaterials = makeMaterials()
                    
                    
                    let faceThickness:CGFloat = 0.1
                    
                    
                    //                    var panelCoordArray:[Int] = [Int]()
                    //                    let coordArray = [coord1,coord2,coord3]
                    //
                    //                    for i in 0...2 {
                    //                        panelCoordArray.append(coordArray[i]/maxCoordMag)
                    //                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    if abs(coord1)/maxCoordMag == 1 {
                        
                        
                        
                        
                        let unitCoord:Int = coord1/maxCoordMag
                        
                        // NOTE THIS IS SUBJECT TO CHANGE
                        let faceMaterial = faceMaterials[-unitCoord + 2]
                        
                        let panelUnitVec1:SCNVector3 = SCNVector3(Float(unitCoord), 0, 0)
                        let panelPos1:SCNVector3 = scaleVector(vec: panelUnitVec1, scalingFactor: Float(cubieSideLen)/2)
                        let pan1:panel = panel(material: faceMaterial, pos: panelPos1, thickness: faceThickness, squareLen: cubieSideLen * 0.9, chamfer: 0.05)
                        
                        pan1.panelNode.eulerAngles = SCNVector3(0,3.14/2,0)
                        
                        cub.node.addChildNode(pan1.panelNode)
                    }
                    
                    
                    
                    
                    
                    if abs(coord2)/maxCoordMag == 1 {
                        
                        let unitCoord:Int = coord2/maxCoordMag
                        
                        // NOTE THIS IS SUBJECT TO CHANGE
                        let faceMaterial = faceMaterials[Int(-(Float(unitCoord)/2.0) + 4.5)]
                        
                        let panelUnitVec2:SCNVector3 = SCNVector3(0, Float(unitCoord), 0)
                        let panelPos2:SCNVector3 = scaleVector(vec: panelUnitVec2, scalingFactor: Float(cubieSideLen)/2)
                        let pan2:panel = panel(material: faceMaterial, pos: panelPos2, thickness: faceThickness, squareLen: cubieSideLen * 0.9, chamfer: 0.05)
                        
                        pan2.panelNode.eulerAngles = SCNVector3(3.14/2,0,0)
                        
                        cub.node.addChildNode(pan2.panelNode)
                    }
                    
                    
                    
                    
                    if abs(coord3)/maxCoordMag == 1 {
                        
                        let unitCoord:Int = coord3/maxCoordMag
                        
                        // NOTE THIS IS SUBJECT TO CHANGE
                        let faceMaterial = faceMaterials[-(unitCoord - 1)]
                        
                        let panelUnitVec3:SCNVector3 = SCNVector3(0, 0, Float(unitCoord))
                        let panelPos3:SCNVector3 = scaleVector(vec: panelUnitVec3, scalingFactor: Float(cubieSideLen)/2)
                        let pan3:panel = panel(material: faceMaterial, pos: panelPos3, thickness: faceThickness, squareLen: cubieSideLen * 0.9, chamfer: 0.05)
                        cub.node.addChildNode(pan3.panelNode)

                    }
                    
                    

                    
//                    let panelUnitVec1:SCNVector3 = SCNVector3(Float(panelCoordArray[0]), 0, 0)
//                    let panelPos1:SCNVector3 = scaleVector(vec: panelUnitVec1, scalingFactor: Float(cubieSideLen))
                    
//                    let panelUnitVec2:SCNVector3 = SCNVector3(0, Float(panelCoordArray[1]), 0)
//                    let panelPos2:SCNVector3 = scaleVector(vec: panelUnitVec2, scalingFactor: Float(cubieSideLen))
                    
//                    let panelUnitVec3:SCNVector3 = SCNVector3(0, 0, Float(panelCoordArray[2]))
//                    let panelPos3:SCNVector3 = scaleVector(vec: panelUnitVec3, scalingFactor: Float(cubieSideLen))
                    
                    
                    
                    
                    
                    
                    
                    

                    
                    // add that cubie to the rubicks cube node
                    cubeNode.addChildNode(cub.node)
                    
                    // string representation of coordinates
                    let coordString = String(coord1) + "," + String(coord2) + "," + String(coord3)
                    
                    // place cubie integer representation in map of cubies
                    cubieCoordMap[coordString] = cubieCount
                    
                    // increase integer representation
                    cubieCount += 1
                    
                    // place scene kit cubie in map of cubies
                    cubieMap[coordString] = cub
                    
                    
                    
                    
                    
                    
                    
                    if coord1/maxCoordMag == 1 {
                        
                        let rotCoordString = String(-coord3) + "," + String(coord2)
                        rotiationGroupMap["left"]?.setCubie(cubieCode: rotCoordString, newCubie: cub)
                    }
                    if coord1/maxCoordMag == -1 {
                        
                        let rotCoordString = String(coord3) + "," + String(coord2)
                        rotiationGroupMap["right"]?.setCubie(cubieCode: rotCoordString, newCubie: cub)
                    }
                    if coord2/maxCoordMag == 1 {
                        
                        let rotCoordString = String(coord1) + "," + String(-coord3)
                        rotiationGroupMap["top"]?.setCubie(cubieCode: rotCoordString, newCubie: cub)
                    }
                    if coord2/maxCoordMag == -1 {
                        
                        let rotCoordString = String(coord1) + "," + String(coord3)
                        rotiationGroupMap["bottom"]?.setCubie(cubieCode: rotCoordString, newCubie: cub)
                    }
                    if coord3/maxCoordMag == 1 {
                        
                        let rotCoordString = String(coord1) + "," + String(coord2)
                        rotiationGroupMap["front"]?.setCubie(cubieCode: rotCoordString, newCubie: cub)
                    }
                    if coord3/maxCoordMag == -1 {
                        
                        let rotCoordString = String(coord1) + "," + String(-coord2)
                        rotiationGroupMap["back"]?.setCubie(cubieCode: rotCoordString, newCubie: cub)
                    }
                    
                }
            }
        }
        
        
        
    }
    
    func rotate(side:String) {
        
        rotiationGroupMap[side].rotate()
        
        
    }
    
    func rotateFront() {
        
        
        
        
        
        
        
        rotiationGroupMap["front"].rotate()
        
        
    }
    
    func rotateBack() {
        
        rotiationGroupMap["back"].rotate()
    }
    
    func rotateLeft() {
        
        
        rotiationGroupMap["left"].rotate()
    }
    
    func rotateRight() {
        
        rotiationGroupMap["right"].rotate()
    }
    
    func rotateTop() {
        
        rotiationGroupMap["top"].rotate()
    }
    
    func rotateBottom() {
        
        rotiationGroupMap["bottom"].rotate()
        
    }
    
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
        let dimensionOfCube:Int = 3

        
        // set up the vector witht the cube's position
        let ourCubePos:SCNVector3 = SCNVector3Make(cubeX, cubeY, cubeZ)
        // define the rubicks cube
        let ourCube:rubicksCube = rubicksCube(cubeSideLen: rubicksCubeSideLen, numCubiesPerSide: dimensionOfCube, cubePos: ourCubePos)
        
        
        ourCube.rotiationGroupMap["left"]?.rotate()
        
        //ourCube.rotiationGroupMap["back"]?.rotate()
        
        // extra node (MAY DELETE)
        let itemNode = SCNNode()
        

        // add cube node to item node
        itemNode.addChildNode(ourCube.cubeNode)
        
       
        
        
        

        
        
        // add item node to root node
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
