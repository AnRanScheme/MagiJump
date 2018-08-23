//
//  Scene.swift
//  WhereIsDora
//
//  Created by Mars on 19/06/2017.
//  Copyright © 2017 Mars. All rights reserved.
//

import SpriteKit
import GameplayKit
import ARKit

class Scene: SKScene {
    
    let remainingDoraNode = SKLabelNode()
    var doraGeneTimer: Timer?
    
    var doraCreated = 0
    var doraRemains = 0 {
        didSet {
            remainingDoraNode.text = "\(doraRemains)个Dora离开了你的房间"
        }
    }
    
    override func didMove(to view: SKView) {
        // Setup your scene here
        
        // 1. Set the node
        remainingDoraNode.fontSize = 25
        remainingDoraNode.fontName = "BradleyHandITCTT-Bold"
        remainingDoraNode.color = .red
        remainingDoraNode.position = CGPoint(x: 0, y: 100)
        
        // 2. Add the node into the scene
        addChild(remainingDoraNode)
        
        // 3. Set the initial value
        doraRemains = 0
        
        // 4. Create a timer to generate Dora
        doraGeneTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in
            self.generateDora()
        }
    }
    
    func generateDora() {
        if doraCreated == 20 {
            doraGeneTimer?.invalidate()
            doraGeneTimer = nil
            
            return
        }
        
        doraCreated += 1
        doraRemains += 1
        
        guard let sceneView = self.view as? ARSKView else {
            return
        }
        
        let randNumber = GKRandomSource.sharedRandom()
        
        let xRotation = simd_float4x4(
            SCNMatrix4MakeRotation(Float.pi * 2 * randNumber.nextUniform(), 1, 0, 0))
        
        let yRotation = simd_float4x4(
            SCNMatrix4MakeRotation(Float.pi * 2 * randNumber.nextUniform(), 0, 1, 0))
        
        let rotation = simd_mul(xRotation, yRotation)
        
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1.5
        
        let transform = simd_mul(rotation, translation)
        
        let anchor = ARAnchor(transform: transform)
        sceneView.session.add(anchor: anchor)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: self)
        let hittedDora = nodes(at: location)
        
        if let dora = hittedDora.first {
            if dora is SKLabelNode { return }
            // 1. Fadeout Doraemon
            let scaleOut = SKAction.scale(by: 2, duration: 0.2)
            let fadeOut = SKAction.fadeOut(withDuration: 0.2)
            let group = SKAction.group([scaleOut, fadeOut])
            let sequence = SKAction.sequence([group, SKAction.removeFromParent()])
            
            dora.run(sequence)
            
            // 2. Decrement Doraemon counter
            doraRemains -= 1
        }
        
        if doraRemains == 0 && doraCreated == 20 {
            remainingDoraNode.removeFromParent()
            
            let gameOver = SKSpriteNode(imageNamed: "game_over")
            addChild(gameOver)
        }
        
        
    }
    
    func gameOver() {
        remainingDoraNode.removeFromParent()
        
        let gameOver = SKSpriteNode(imageNamed: "game_over")
        addChild(gameOver)
    }
}
