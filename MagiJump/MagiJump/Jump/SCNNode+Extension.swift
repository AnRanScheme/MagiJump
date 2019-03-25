//
//  SCNNode+Extension.swift
//  MagiJump
//
//  Created by 安然 on 2018/8/15.
//  Copyright © 2018年 anran. All rights reserved.
//

import SceneKit
import ARKit

extension SCNNode {
    
    func isNotContainedXZ(in boxNode: SCNNode) -> Bool {
        let box = boxNode.geometry as! SCNBox
        let width = Float(box.width)
        if abs(position.x - boxNode.position.x) > width / 2.0 {
            return true
        }
        if abs(position.z - boxNode.position.z) > width / 2.0 {
            return true
        }
        return false
    }
    
}

extension SCNVector3 {
    
    init (withHitTestResult result: ARHitTestResult) {
        let transform = result.worldTransform
        
        self.init(withTransform: transform)
    }
    
    init (withTransform transform: matrix_float4x4) {
        self.init()
        self.x = transform.columns.3.x
        self.y = transform.columns.3.y
        self.z = transform.columns.3.z
    }
    
    init (withNode node: SCNNode) {
        let transform = node.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let currentPosition = orientation + location
        
        self = currentPosition
    }
    
    static func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3(left.x+right.x, left.y+right.y, left.z+right.z)
    }
    
}
