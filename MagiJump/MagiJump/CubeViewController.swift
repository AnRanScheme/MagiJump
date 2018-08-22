//
//  CubeViewController.swift
//  MagiJump
//
//  Created by 安然 on 2018/8/14.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class CubeViewController: UIViewController {

    @IBOutlet weak var screenView: ARSCNView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // Run the view's session
        screenView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        screenView.session.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
    }

}

// MARK: - 自定义方法
extension CubeViewController {
    
    fileprivate func setupScene() {
        // 存放所有 3D 几何体的容器
        let scene = SCNScene()
        // 想要绘制的 3D 立方体
        let boxGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.0)
        let metarl = SCNMaterial()
        metarl.diffuse.contents = UIColor.blue
        boxGeometry.materials = [metarl]
        // 将几何体包装为 node 以便添加到 scene
        let boxNode = SCNNode(geometry: boxGeometry)
        // 把 box 放在摄像头正前方
        boxNode.position = SCNVector3Make(0, 0, -0.5)
      
        // rootNode 是一个特殊的 node，它是所有 node 的起始点
        scene.rootNode.addChildNode(boxNode)
        // 将 scene 赋给 view
        screenView.scene = scene
        // 光影效果
        screenView.autoenablesDefaultLighting = true
    }
    
}

