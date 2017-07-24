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




let rotateTime:TimeInterval = 1

// function for scaling all components of a three-diensional vector
func scaleVector(vec:SCNVector3, scalingFactor:Float) -> SCNVector3 {
    var vecToMut = vec
    
    vecToMut.x.multiply(by: scalingFactor)
    vecToMut.y.multiply(by: scalingFactor)
    vecToMut.z.multiply(by: scalingFactor)
    
    return vecToMut
}



func addVecs(vec1:SCNVector3, vec2:SCNVector3) -> SCNVector3 {
    
    var newVec:SCNVector3 = vec1
    
    newVec.x = vec1.x + vec2.x
    newVec.y = vec1.y + vec2.y
    newVec.z = vec1.z + vec2.z
    
    return newVec
    
}

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


//consider forming single class with cubie
class panel {
    
    var panelNode:SCNNode
    
    
    init(materialCode:String, pos:SCNVector3, thickness:CGFloat, squareLen:CGFloat, chamfer:CGFloat) {
        
        
        let panel = SCNBox(width: squareLen, height: squareLen, length: thickness, chamferRadius: chamfer)
        
        
        
        panel.firstMaterial = colorDict[materialCode]
        
        panelNode = SCNNode(geometry: panel)
        panelNode.position = pos
            //scaleVector(vec: pos, scalingFactor: Float(squareLen))
    }
    
    
}







class cubie {
    
    // node of cube to be attatched to the parent node of a face
    var node:SCNNode
    
    // side length of a single cubie
    private let side:CGFloat
    
    
    init(pos:SCNVector3, sideLen:CGFloat) {
        
        
        side = sideLen
        
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
    
    
    
    // get the position of the cubie
    func getPos() -> SCNVector3 {
        
        return node.position
    }
    
    
    
    func addPanels(theCoordString:String, magToCompare:Int, thicc:CGFloat) {

        
        
        var coordinates:[Int] = []
        
        var currentCoord:String = ""
        
        for i in theCoordString.characters {
            
            if i ==  "," || i == ")" {
                coordinates.append(Int(currentCoord)!)
                currentCoord = ""
            }
            else if i != "(" {
                
                currentCoord.append(i)
                
            }
        }
        
        

        
        for i in 0 ... (coordinates.count - 1) {
            
            
            
            if abs(coordinates[i])/magToCompare == 1 {
                
                
                
                
                let unitCoord:Int = coordinates[i]/magToCompare
                
                // TODO: fix the indexing
                
                
                
                var arrayRepOfPanelCoord:[Float] = [0, 0, 0]
                
                arrayRepOfPanelCoord[i] = Float(unitCoord)
                
                
                

                let panelUnitVec:SCNVector3 = makeVecWithCoordinateArray(coord: arrayRepOfPanelCoord)

                
                let stringRepOfPanelCoord = makeCoordStringWithCoordArray(coordArray: arrayRepOfPanelCoord)
                
                
                let panelPos:SCNVector3 = scaleVector(vec: panelUnitVec, scalingFactor: Float(side)/2)
                let pan:panel = panel(materialCode: stringRepOfPanelCoord, pos: panelPos, thickness: thicc, squareLen: side * 0.9, chamfer: 0.05)
                
                
                
                var arrayRepOfOrientation:[Float] = [0,0,0]
                
                if abs(arrayRepOfPanelCoord[0]) == 1 {
                    arrayRepOfOrientation[1] = 3.14/2.0
                }
                else if abs(arrayRepOfPanelCoord[1]) == 1 {
                    arrayRepOfOrientation[0] = 3.14/2.0
                }
                else {
                    arrayRepOfOrientation[2] = 3.14/2.0
                }
                
                
                

                pan.panelNode.eulerAngles = makeVecWithCoordinateArray(coord: arrayRepOfOrientation)

                
                
                
                node.addChildNode(pan.panelNode)
            }
        
        
        
            
        }
        
        
    }
    
}







class rotationGroup {
    
    var cubieMap: [String : cubie] = [:]
    
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
            //print("group ", axis, " has member with key ", key, " and position ", cubie.getPos())
            
            cubie.node.removeFromParentNode()
            groupNode.addChildNode(cubie.node)
            
        }
        
        
        
        
        groupNode.runAction(SCNAction.rotate(by: -3.14/2.0, around: axis, duration: rotateTime))
        
        
        
        
        //        let when = DispatchTime.now() + 4 // change 2 to desired number of seconds
        //
        //
        //        DispatchQueue.main.asyncAfter(deadline: when) {
        //            // Your code with delay
        //            ourCube.rotateTop()
        //            
        //        }
        
        
        //Thread.sleep(forTimeInterval: 40)
        

        
        let when = DispatchTime.now() + rotateTime  + 1 // change 2 to desired number of seconds
        
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            self.reset()
            
        }
        
        
    }
    
    
    
    func reset() {
        
        
        var angles:SCNVector3 = groupNode.eulerAngles
        if abs(axis.y) == 1 {
            

            angles.y = -angles.y

        }
        
        
        print("group node euler angles: ", groupNode.eulerAngles)
        print("y-adjusted euler angles: ", angles)
        
        for (key, cubie) in cubieMap {

            
            
            print("key: ", key)
            
            for n in cubie.node.childNodes {
                print(n.geometry?.firstMaterial?.diffuse.contents)
            }
            
            
            print("position of cubie: ", cubie.getPos())
            
            

            
            let newGlobalPos:SCNVector3 = cubie.node.convertPosition(SCNVector3(0,0,0), to: groupNode.parent)
            print("global position of cubie: ", newGlobalPos)

            
            cubie.node.removeFromParentNode()
            

            // TODO: reimplement the setPos member function of the cubie class
            
            print("global position of cubie: ", newGlobalPos)
            
            cubie.node.position = newGlobalPos
            
            
            print("global position of cubie: ", cubie.getPos())
            
            
            //cubie.node
            
            //print("current pivot: ", cubie.node.pivot)
            
            //cubie.node.pivot = SCNMatrix4Rotate(cubie.node.pivot, 3.14/2.0, axis.x, axis.y, axis.z)
            
            
            
                
            
            //print("new pivot: ", cubie.node.pivot)
            cubie.node.eulerAngles = addVecs(vec1: cubie.node.eulerAngles  , vec2: angles)
            

            
            
            cubie.node.removeFromParentNode()
            
            groupNode.parent?.addChildNode(cubie.node)

            
            
            
            
        }
        
        groupNode.eulerAngles = SCNVector3(0,0,0)
        
        
    }


}


class customCube {
    
    // the representation where rotations will occur on the back end
    var cubieCoordMap: [String : Int] = [:]
    
    // map for the cubies on the screen
    var cubieMap: [String: cubie] = [:]
    
    // TODO: figure this thing out
    var rotiationGroupMap: [String : rotationGroup] = [:]
    
    let cubeNode:SCNNode = SCNNode()
    
    
    
    var max:Int
    
    init(cubeSideLen:CGFloat, numCubiesPerSide:Int, cubePos:SCNVector3) {
        
        // side length of each individual cubie based on the desired size of the whole cube as well as the number of cubes used
        let cubieSideLen:CGFloat = cubeSideLen/CGFloat(numCubiesPerSide)
        
        // create initial node for the cube that will be attached to no geometry
        
        cubeNode.position = cubePos

        
        // used for cubieCoordMap
        var cubieCount:Int = 0
        
        // maximum coordinate magnitude
        let maxCoordMag = numCubiesPerSide/2
        
        
        // FIX
        max = maxCoordMag
        
        // loop through all possible coordinates
        // TODO: make sure this works for even numbers of numCubiesPerSide
        for coord1 in -maxCoordMag ... maxCoordMag {
            for coord2 in -maxCoordMag ... maxCoordMag {
                for coord3 in -maxCoordMag ... maxCoordMag {
                    
                    // TODO: figure out how to make odd cubes
                    //if (numCubiesPerSide % 2) == 0 &&
                    
                    if (abs(coord1) < maxCoordMag) && (abs(coord2) < maxCoordMag) && (abs(coord3) < maxCoordMag) {
                        continue
                    }
                    
                    // set the position of each cubie based on the coordinates
                    
                    let unitVec = SCNVector3(Float(coord1), Float(coord2), Float(coord3))
                    let cubiePos = scaleVector(vec: unitVec, scalingFactor: Float(cubieSideLen))
                    
                    
                    
                    // create a cubie using that position
                    // TODO: change variable names because it's easy to mix up cubieSideLen and cubeSideLen
                    let cub:cubie = cubie(pos: cubiePos, sideLen:cubieSideLen)
                    
                    
                    
                    // TODO: move where materials are established
                    let faceMaterials = makeMaterials()
                    
                    
                    let faceThickness:CGFloat = 0.1
                    
                
                    
                    // add that cubie to the rubicks cube node
                    cubeNode.addChildNode(cub.node)
                    
                    // string representation of coordinates
                    let coordString = "(" + String(coord1) + "," + String(coord2) + "," + String(coord3) + ")"
                    
                    // place cubie integer representation in map of cubies
                    cubieCoordMap[coordString] = cubieCount
                    
                    // increase integer representation
                    cubieCount += 1
                    
                    // place scene kit cubie in map of cubies
                    cubieMap[coordString] = cub
                    
                    
                    
                    cub.addPanels(theCoordString: coordString, magToCompare: maxCoordMag, thicc: faceThickness)
                    
                    
                    
                    
                    
                    let rotCoordString1 = "(" + String(coord1) + ",0,0)"
                    let rotCoordString2 =  "(0," + String(coord2) + ",0)"
                    let rotCoordString3 = "(0,0," + String(coord3) + ")"
                    
                    let rotCoordStrings = [rotCoordString1, rotCoordString2, rotCoordString3]
                    
                    
                    for rotCoordString in rotCoordStrings {
                        
                        
                        if rotiationGroupMap[rotCoordString] == nil {
                            
                            
                            

                            let axis = makeVecWithCoordString(coordAsString: rotCoordString)
                            
                            
                            let newRotGroup:rotationGroup = rotationGroup(vec: axis)
                            
                            rotiationGroupMap[rotCoordString] = newRotGroup
                            
                            cubeNode.addChildNode(newRotGroup.getNode())
                            
                            
                            
                        }
                        
                        rotiationGroupMap[rotCoordString]?.setCubie(cubieCode: coordString, newCubie: cub)
                        
                    }
                    
                    
                    
                    
                    
                    
                }
            }
        }
        
        
        
    }
    
    
    func rotate(groupName:String) {
        
        
        
        
        // rotate the rotation group
        self.rotiationGroupMap[groupName]?.rotate()
        
        
        // the following steps are taken to reset which cubies are in which rotation groups
        
        // start by turning the rotation group name into an array
        var groupNameAsArray = makeCorrdArrayWithCoordString(coordString: groupName)
        
        
        // declare the index that's fixed
        var fixedIndex:Int = 0
        
        
        
        // find that index
        for i in 0 ... groupNameAsArray.count {
            
            if groupNameAsArray[i] != 0 {
                fixedIndex = i
                
                break
                
                
            }
            
        }
        
        
        //print("fixed index: ", fixedIndex)
        
        //print("group name: ", groupName)
        
        
//        
//        let pairToTransform = [Int(groupNameAsArray[(fixedIndex+1)%3]), Int(groupNameAsArray[(fixedIndex+2)%3])]
//        
//        
//        
//        // TODO: look at type casting to see if it could be reduced
//        let transformedPair = turnTransform(coordinates: pairToTransform, axisSign: Int(groupNameAsArray[fixedIndex]))
//        
//        
//        
//        
//        //
        
        
        var newCubieMap: [String : cubie] = [:]
        
        
        
        // TODO: review all private vs public class vars
        for (key, cubie) in (rotiationGroupMap[groupName]?.cubieMap)! {
            
            
            //print("key: ", key)
            //print("real position: ", cubie.getPos())
            
            // turn the key, the coordinates of the cubie in the group, into an array
            let keyAsArray = makeCorrdArrayWithCoordString(coordString: key)
            
            // TODO: obsevre all conversions of coords from string to arrays and find out which way to have them to minimize transformations
            
            // find the coordinate array elements
            let pairToTransform = [Int(keyAsArray[(fixedIndex+1)%3]), Int(keyAsArray[(fixedIndex+2)%3])]
            
            // get the pair transformed
            let transformedPair = turnTransform(coordinates: pairToTransform, axisSign: Int(groupNameAsArray[fixedIndex]))
            
            
            var transformedTriple:[Float] = [0,0,0]
            
            // place the transformed pair into the three-elem array for new coordinates
            transformedTriple[fixedIndex] = groupNameAsArray[fixedIndex]
            
            
            transformedTriple[(fixedIndex+1)%3] = Float(transformedPair[0])
            transformedTriple[(fixedIndex+2)%3] = Float(transformedPair[1])
            
            
            
            //print("transformed key: ", transformedTriple)
            
            // the new coordinates of the moved cubie
            let newCoordString = makeCoordStringWithCoordArray(coordArray: transformedTriple)
            
            //print("transformed key as string: ", newCoordString)
            
            
            
            
            newCubieMap[newCoordString] = cubie
            
            
            
            var tripleForOtherGroup1:[Float] = [0,0,0]
            
            
            tripleForOtherGroup1[(fixedIndex+1)%3] = Float(transformedPair[0])
            
            let stringForG1 = makeCoordStringWithCoordArray(coordArray: tripleForOtherGroup1)
            
            var tripleForOtherGroup2:[Float] = [0,0,0]
            
            
            tripleForOtherGroup2[(fixedIndex+2)%3] = Float(transformedPair[1])
            
            let stringForG2 = makeCoordStringWithCoordArray(coordArray: tripleForOtherGroup2)
            
            
            rotiationGroupMap[stringForG1]?.cubieMap[newCoordString] = cubie
            rotiationGroupMap[stringForG2]?.cubieMap[newCoordString] = cubie
            
            
            
            //print("String for g1 ", stringForG1)
            //print("String for g2 ", stringForG2)
        }
        
        
        
        cubieMap = newCubieMap
        
        
        
        
        
        
    }
    

    
}





func turnTransform(coordinates: [Int], axisSign:Int) -> [Int] {
    
    
    return [axisSign * coordinates[1], axisSign * -coordinates[0]]
}


class rubicksCube: customCube {
    
    init() {
        let position:SCNVector3 = SCNVector3(0.0, 0.0, -20.0)
        super.init(cubeSideLen: 10, numCubiesPerSide: 3, cubePos: position)
    }
    
    // TODO: consider moving where the rotation function is defined
    func rotateFront() {
        self.rotate(groupName: "(0,0,1)")
    }
    
    func rotateBack() {
        self.rotate(groupName: "(0,0,-1)")
    }
    
    func rotateLeft() {
        self.rotate(groupName: "(-1,0,0)")
    }
    
    func rotateRight() {
        self.rotate(groupName: "(1,0,0)")
    }
    
    func rotateTop() {
        self.rotate(groupName: "(0,1,0)")
    }
    
    func rotateBottom() {
        self.rotate(groupName: "(0,-1,0)")
    }
    
    
    
    
    
    
    
}
    

func executeMoves(moves:[()->()]) {
    
    var waitingTime:TimeInterval = 0
    
    for i in 0 ... (moves.count-1) {
        
        let when = DispatchTime.now() + waitingTime // change 2 to desired number of seconds
        
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            moves[i]()
            
        }
        
        waitingTime += rotateTime + 2
        
    }
}



class GameViewController: UIViewController {
    
    
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // create scene
        let scene = SCNScene()
        
        
//        // conveniece placement of rubicks cube properties
//        let cubeX:Float = 0.0
//        let cubeY:Float = 0.0
//        let cubeZ:Float = -20.0
//        //let cubieCurve:CGFloat = 0.5
//        let rubicksCubeSideLen:CGFloat = 10
//        let dimensionOfCube:Int = 10
//
//        
//        // set up the vector witht the cube's position
//        let ourCubePos:SCNVector3 = SCNVector3Make(cubeX, cubeY, cubeZ)
//        
//        
//        // define the rubicks cube
//        let ourCube:customCube = customCube(cubeSideLen: rubicksCubeSideLen, numCubiesPerSide: dimensionOfCube, cubePos: ourCubePos)
        
        
        
        
        let ourCube:rubicksCube = rubicksCube()
        

        

        
        
        
        
        
        
        //ourCube.rotateRight()
        //ourCube.rotateTop()
        
        //ourCube.rotateBottom()
        
        let arrayOfMoves:[()->()] = [ourCube.rotateRight, ourCube.rotateRight]//, ourCube.rotateRight] //, ourCube.rotateRight, ourCube.rotateBack]
        
        
        
        let when = DispatchTime.now() + 5 // change 2 to desired number of seconds
        
        
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            executeMoves(moves: arrayOfMoves)
            
        }



        
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
