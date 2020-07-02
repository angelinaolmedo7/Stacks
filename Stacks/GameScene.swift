//
//  GameScene.swift
//  Stacks
//
//  Created by Angelina Olmedo on 7/1/20.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Player: UInt32 = 0b1
    static let Obstacle: UInt32 = 0b10
    static let PlayerBody: UInt32 = 0b100
    static let Barrier: UInt32 = 0b1000
}

class GameScene: SKScene {
    
    let fixedDelta: CFTimeInterval = 1.0 / 60.0 /* 60 FPS */
    let scrollSpeed: CGFloat = 200
    var scrollNode: SKNode!
    var cloudScroll: SKNode!
    var player: SKSpriteNode!
    var obstacleSpawner: SKNode!
    var playButton: CustomButtonNode!
    var frontBarrier: SKSpriteNode!
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        /* Set references to scroll nodes */
        if let scrollNode = self.childNode(withName: "scrollNode") {
            self.scrollNode = scrollNode
        } else {
            print("scrollNode could not be connected properly")
        }
        if let cloudScroll = self.childNode(withName: "cloudScroll") {
            self.cloudScroll = cloudScroll
        } else {
            print("cloudScroll could not be connected properly")
        }
        
        // referecing the barrier node from the scene
        if let frontBarrier = self.childNode(withName: "frontBarrier") as? SKSpriteNode {
          self.frontBarrier = frontBarrier
        } else {
          print("frontBarrier could not be connected properly")
        }
        
        if let playButton = self.childNode(withName: "playButton") as? CustomButtonNode {
          self.playButton = playButton
        } else {
          print("playButton was not initialized properly")
        }

        // setting the barrier physics body preferences
        frontBarrier.physicsBody?.categoryBitMask = PhysicsCategory.Barrier
        frontBarrier.physicsBody?.collisionBitMask = PhysicsCategory.None
        frontBarrier.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        /* Process world scrolling */
        scrollWorld()
    }
    
    func scrollWorld() {
        /* Scroll World */
        scrollNode.position.x -= scrollSpeed * CGFloat(fixedDelta)
        cloudScroll.position.x -= (scrollSpeed/2) * CGFloat(fixedDelta)
        
        /* Loop through scroll layer nodes */
        for ground in scrollNode.children as! [SKSpriteNode] {

            /* Get ground node position, convert node position to scene space */
            let groundPosition = scrollNode.convert(ground.position, to: self)

            /* Check if ground sprite has left the scene */
            if groundPosition.x <= -ground.size.width / 2 {

                /* Reposition ground sprite to the second starting position */
                let newPosition = CGPoint(x: (self.size.width / 2) + ground.size.width, y: groundPosition.y)

                /* Convert new node position back to scroll layer space */
                ground.position = self.convert(newPosition, to: scrollNode)
            }
        }
        
        /* Loop through cloud scroll layer nodes */
        for cloud in cloudScroll.children as! [SKSpriteNode] {

            /* Get cloud node position, convert node position to scene space */
            let cloudPosition = cloudScroll.convert(cloud.position, to: self)

            /* Check if cloud sprite has left the scene */
            if cloudPosition.x <= -cloud.size.width / 2 {

                /* Reposition cloud sprite to the second starting position */
                let newPosition = CGPoint(x: (self.size.width / 2) + cloud.size.width, y: cloudPosition.y)

                /* Convert new node position back to scroll layer space */
                cloud.position = self.convert(newPosition, to: scrollNode)
            }
        }
    }
}
