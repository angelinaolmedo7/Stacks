//
//  Player.swift
//  Stacks
//
//  Created by Angelina Olmedo on 7/2/20.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    var canStack: Bool = true
    let maxStack: Int = 8
    var bodyNodes: [SKSpriteNode] = []
    var initialPos: CGPoint!
    
    func setup(){
        // set the texture to the head from our assets file
        self.texture = SKTexture(imageNamed: "birdhead")
        // give the player a physicsBody
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.isDynamic = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.physicsBody?.collisionBitMask = PhysicsCategory.Obstacle | PhysicsCategory.PlayerBody
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle
        self.initialPos = self.position
    }
    
    func stack(scene: SKScene){
        // check if we are able to stack again
        if canStack && bodyNodes.count <= maxStack{
            // while this is happening we cant stack again
            canStack = false
            // make a new spriteNode with the egg texture
            let body = SKSpriteNode(color: .cyan, size: CGSize(width: 100, height: 100))
            body.texture = SKTexture(imageNamed: "egg")
            // give it a physicsBody
            body.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100))
            body.physicsBody?.allowsRotation = false
            body.physicsBody?.isDynamic = true
            body.physicsBody?.affectedByGravity = true
            body.physicsBody?.categoryBitMask = PhysicsCategory.PlayerBody
            body.physicsBody?.contactTestBitMask = PhysicsCategory.Obstacle
            body.physicsBody?.collisionBitMask =  PhysicsCategory.Obstacle | PhysicsCategory.PlayerBody
            // make animation for player
            let jump = SKAction.moveTo(y: self.position.y + self.size.height + 10, duration: 0.1)

            let addChild = SKAction.run {
                // conver the space from the player space to the scene space
                body.position = scene.convert(CGPoint(x: self.position.x , y: self.position.y - (self.size.height + 5)), to: scene)
                // add the body to our bodyNodes array
                self.bodyNodes.append(body)
                // add the body to the scene
                scene.addChild(body)
            }
            // a small wait to give a unique feel
            let smallWait = SKAction.wait(forDuration: 0.03)
            // enableStack
            let enableStack = SKAction.run {
                self.canStack = true
            }
            // animation sequence
            let sequence = SKAction.sequence([jump, addChild, smallWait, enableStack])
            self.run(sequence)
        }
    }
}
