//
//  ModelViewController.swift
//  MagiJump
//
//  Created by 安然 on 2018/8/15.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ModelViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        addHandler()
    }
    
    @IBAction func resetButtonAction(_ sender: UIButton) {
        reset()
    }
    
    var planeAnchor: ARPlaneAnchor?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.session.run(configuration)
        sceneView.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ModelViewController {
    
    func addHandler() {
        if planeAnchor != nil {
            addPortal(with: planeAnchor!.transform)
        }
    }
    
    func reset() {
        // 清除节点之前先停止AR会话，否则会crash
        // pause ar session before remove node, or will be crash
        sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        planeAnchor = nil
        addButton.isEnabled = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        // 使用重置配置启动AR会话，场景将会被重置
        // Run AR session with reset options, then session will be reset
        sceneView.session.run(configuration,
                               options: [.resetTracking,
                                         .removeExistingAnchors])
    }
    
    func addPortal(withHitTestResult result: ARHitTestResult) {
        addPortal(with: result.worldTransform)
    }
    
    func addPortal(with transform: matrix_float4x4) {
        guard let portalScene = SCNScene(named: "SceneKit Asset.scnassets/tjgc.scn") else {return}
        let portalNode = portalScene.rootNode.childNode(withName: "tjgc", recursively: false)!
        let newVector3 = SCNVector3.init(withTransform: transform)
        portalNode.position = SCNVector3.init(newVector3.x, newVector3.y, newVector3.z-1)
        sceneView.scene.rootNode.addChildNode(portalNode)
        
        self.addPlane(nodeName: "roof", portalNode: portalNode, imageName: "top")
        self.addPlane(nodeName: "floor", portalNode: portalNode, imageName: "bottom")
        self.addWalls(nodeName: "backWall", portalNode: portalNode, imageName: "back")
        self.addWalls(nodeName: "sideWallA", portalNode: portalNode, imageName: "sideA")
        self.addWalls(nodeName: "sideWallB", portalNode: portalNode, imageName: "sideB")
        self.addWalls(nodeName: "sideDoorA", portalNode: portalNode, imageName: "sideDoorA")
        self.addWalls(nodeName: "sideDoorB", portalNode: portalNode, imageName: "sideDoorB")
        self.addWalls(nodeName: "doorHeader", portalNode: portalNode, imageName: "top")
        self.addNode(nodeName: "tower", portalNode: portalNode, imageName: "")
    }
    
    fileprivate func addPlane(nodeName: String, portalNode: SCNNode, imageName: String) {
        let child = portalNode.childNode(withName: nodeName, recursively: true)
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "SceneKit Asset.scnassets/\(imageName).png")
        child?.renderingOrder = 200
    }
    
    fileprivate func addWalls(nodeName: String, portalNode: SCNNode, imageName: String) {
        let child = portalNode.childNode(withName: nodeName, recursively: true)
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "SceneKit Asset.scnassets/\(imageName).png")
        child?.renderingOrder = 200
        if let mask = child?.childNode(withName: "mask", recursively: false) {
            // 设置渲染顺序，渲染顺序小的优先渲染，从而通过让优先渲染的节点透明使后面渲染的节点也透明
            // set the redering order, nodes with greater rendering orders are rendered last. We can let NodeA to be transparent and rendered first, so that the node rendered after NodeA will also be transparent.
            mask.renderingOrder = 150
            mask.geometry?.firstMaterial?.transparency = 0.00001
        }
    }
    
    fileprivate func addNode(nodeName: String, portalNode: SCNNode, imageName: String) {
        let child = portalNode.childNode(withName: nodeName, recursively: true)
        child?.renderingOrder = 200
    }
    
}

extension ModelViewController: ARSCNViewDelegate {
    
    // ARSCNView当检测到平面时会向其放置锚点，同时调用didAdd:anchor:代理方法
    // ARSCNView will add anchor when plane detected, the call didAdd:anchor: delegate function
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 如果检测到的是水平面，那么就是我们需要的，所以在此判断是否为水平面
        // Judge the plane if it is horizontal plane
        guard anchor is ARPlaneAnchor else {return}
        
        planeAnchor = anchor as? ARPlaneAnchor
        
        // 启用放置按钮, 显示可放置标签
        // Enable Add Button, and make remind label visiable.
        DispatchQueue.main.async {
            self.addButton.isEnabled = true
            self.detailLabel.isHidden = false
            self.detailLabel.text = "检测到平面，请点击放置按钮"
            // "Plane Detected, Press Add button to add."
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            UIView.animate(withDuration: 1, animations: {
                self.detailLabel.isHidden = true
            })
        }
    }
    
}
