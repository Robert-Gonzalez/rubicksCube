//
//  Face.swift
//  rCube0
//
//  Created by Robert "Skipper" Gonzalez on 8/1/17.
//  Copyright © 2017 Robert "Skipper" Gonzalez. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import SceneKit

enum Face: String {
    case Left = "(1,0,0)"
    case Right = "(-1,0,0)"
    case Front = "(0,0,1)"
    case Back = "(0,0,-1)"
    case Top = "(0,1,0)"
    case Bottom = "(0,-1,0)"
}
