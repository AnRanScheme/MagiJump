//
//  DropPlane.swift
//  MagiJump
//
//  Created by 安然 on 2018/8/15.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class DropPlane: SCNNode {
    
    var anchor: ARPlaneAnchor
    var planeGeometry: SCNBox
    
    init(withAnchor anchor: ARPlaneAnchor, isHidden hidden: Bool) {
        self.anchor = anchor
        let width = anchor.extent.x
        let length = anchor.extent.z
        
        // 使用 SCNBox 替代 SCNPlane 以便场景中的几何体与平面交互。
        
        // 为了让物理引擎正常工作，需要给平面一些高度以便场景中的几何体与其交互
        let planeHeight = 0.01
        
        self.planeGeometry = SCNBox(width: CGFloat(width),
                               height: CGFloat(planeHeight),
                               length: CGFloat(length),
                               chamferRadius: 0)
        /// 要在实例化之前设置属性
        super.init()
        
        
        // 相比把网格视觉化为灰色平面，我更喜欢用科幻风的颜色来渲染
        let material = SCNMaterial()
        let img = UIImage(named: "tron_grid.png")
        material.diffuse.contents = img
        
        // 由于正在使用立方体，但却只需要渲染表面的网格，所以让其他几条边都透明
        let transparentMaterial = SCNMaterial()
        transparentMaterial.diffuse.contents = UIColor(white: 1, alpha: 0)
        
        if hidden {
            planeGeometry.materials = [transparentMaterial,
                                       transparentMaterial,
                                       transparentMaterial,
                                       transparentMaterial,
                                       transparentMaterial,
                                       transparentMaterial]
        } else {
            planeGeometry.materials = [transparentMaterial,
                                       transparentMaterial,
                                       transparentMaterial,
                                       transparentMaterial,
                                       material,
                                       transparentMaterial]
        }
        
        let planeNode = SCNNode(geometry: planeGeometry)
        
        // 由于平面有一些高度，将其向下移动到实际的表面
        planeNode.position = SCNVector3Make(0, Float(-planeHeight / 2.0), 0)
        
        // SceneKit 里的平面默认是垂直的，所以需要旋转90度来匹配 ARKit 中的平面
        planeNode.transform = SCNMatrix4MakeRotation(Float(-.pi / 2.0), 1.0, 0.0, 0.0)
        
        // 给平面物理实体，以便场景中的物体与其交互
        planeNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: planeGeometry, options: nil))
        
        setTextureScale()
        addChildNode(planeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DropPlane {
    
    func update(anchor: ARPlaneAnchor) {
        // 随着用户移动，平面 plane 的 范围 extend 和 位置 location 可能会更新。
        // 需要更新 3D 几何体来匹配 plane 的新参数。
        planeGeometry.width = CGFloat(anchor.extent.x);
        planeGeometry.height = CGFloat(anchor.extent.z);
        
        // plane 刚创建时中心点 center 为 0,0,0，node transform 包含了变换参数。
        // plane 更新后变换没变但 center 更新了，所以需要更新 3D 几何体的位置
        position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        
        let node = childNodes.first
        // physicsBody = nil
        node?.physicsBody = SCNPhysicsBody(type: .kinematic, shape: SCNPhysicsShape(geometry: planeGeometry, options: nil))
        setTextureScale()
    }
    
    func setTextureScale() {
        let width = planeGeometry.width
        let height = planeGeometry.height
        
        // 平面的宽度/高度 width/height 更新时，我希望 tron grid material 覆盖整个平面，不断重复纹理。
        // 但如果网格小于 1 个单位，我不希望纹理挤在一起，所以这种情况下通过缩放更新纹理坐标并裁剪纹理
        let material = planeGeometry.materials.first
        material?.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(width), Float(height), 1)
        material?.diffuse.wrapS = .repeat
        material?.diffuse.wrapT = .repeat
    }
    
    func hide() {
        let transparentMaterial = SCNMaterial()
        transparentMaterial.diffuse.contents = UIColor(white: 1, alpha: 0)
        planeGeometry.materials = [transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial, transparentMaterial]
    }
    
}
