//
//  SpriteViewController.swift
//  MagiJump
//
//  Created by 安然 on 2018/8/23.
//  Copyright © 2018年 anran. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class SpriteViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSKView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }
    
  
    
}

// MARK: - 自定义方法
extension SpriteViewController {
    
    fileprivate func chooseDora() -> String {
        let doraNames = ["catch", "dizzy", "dream", "eat_full", "eating",
                         "find", "fly", "magic", "sing", "sit"]
        // let index = Int(arc4random_uniform(UInt32(doraNames.count)))
        // 这是Swift4.2最新用法
        let index = Int.random(in: 0..<doraNames.count)
        return doraNames[index]
    }
    
}

// MARK: - 自定义方法
extension SpriteViewController: ARSKViewDelegate {
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        let imageName = chooseDora()
        // Create and configure a node for the anchor added to the view's session.
        return SKSpriteNode(imageNamed: imageName)
    }
    
    func view(_ view: ARSKView, didAdd node: SKNode, for anchor: ARAnchor) {
        
    }
    
    
}

extension SpriteViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
}
