//
//  ObstacleSpawner.swift
//  Stacks
//
//  Created by Angelina Olmedo on 7/2/20.
//

import Foundation
import SpriteKit

class ObstacleSpawner: SKSpriteNode {
    
    var spawnTimer: CFTimeInterval = 0
    let fixedDelta: CFTimeInterval = 1.0 / 60.0 /* 60 FPS */
    var timeSpace: CFTimeInterval?
    let scrollSpeed = 0.3
    var columnPointer = 0
    var currentScheme: [[Int]] = []
    let schemes: Schemes = Schemes()
    
    func initTimeSpace(){
        // check
        if timeSpace == nil {
            timeSpace = 0
            // get a child from self since we should have 9
            let child = self.children[0] as! SKSpriteNode
            // record the initial position to test speed
            let initialPos = self.children[0].position.x
            // move the child the at the same speed they will move towards player
            let move = SKAction.move(by: CGVector(dx: 100, dy: 0), duration: scrollSpeed)
            child.run(move)
            // user a timer that fires at 60 FPS to mesure the time it takes to get to a certain distance
            let _ = Timer.scheduledTimer(timeInterval: fixedDelta, target: self, selector: #selector(timerCheck(_:)), userInfo: ["child":child, "pos":initialPos], repeats: true)
            currentScheme = schemes.getRandomScheme()
        }
    }

    @objc func timerCheck(_ timer: Timer){
        // get the info we sent through the timer in this case a dictionary because we needed more than one data.
        let info = timer.userInfo as! [String: Any]
        // get thhe child from dict
        let child = info["child"] as! SKSpriteNode
        // get initial pos from dict
        let initialPos = info["pos"] as! CGFloat
        // check the position of child until it's more than 90% past itself
        if child.position.x <= initialPos + (child.size.width * 0.90) {
            // add time everytime the child is still not where we need it
            timeSpace! += fixedDelta
        } else {
            // we are done the child is where we need it so we stop the timer
            timer.invalidate()
            // remove all of the  animations
            child.removeAllActions()
            // reset the position
            child.position.x = initialPos
        }
    }
    
    func generate(scene: SKScene) {
        initTimeSpace()
        spawnTimer += fixedDelta
        if spawnTimer > Double(timeSpace!) {
            let copy = self.copy() as! SKSpriteNode
            var column: [SKSpriteNode] = []

            for row in 0...currentScheme.count - 1 {
                if columnPointer > currentScheme[row].count - 1{
                    columnPointer = 0
                    currentScheme = schemes.getRandomScheme()
                }
                // copy the node that represents the row we are currently working on
                let child = copy.childNode(withName: "spawnBlock-\(row)") as! SKSpriteNode
                // if spot in the scheme is == 1 then we modify it else we remove it.
                if currentScheme[row][columnPointer] == 1 {
                    // make it random color to add variety
                    child.color = UIColor.random
                    child.colorBlendFactor = 0.7
                    // convert the position from it's parent space to the scene space.
                    child.position = scene.convert(child.position, to: scene)
                    let scenePos = scene.convertPoint(fromView: copy.position)
                    // move the x to the location of its parent
                    child.position.x = scenePos.x + child.size.width
                    // edit the physicsBody properties
                    child.physicsBody?.categoryBitMask = PhysicsCategory.Obstacle
                    child.physicsBody?.collisionBitMask = PhysicsCategory.Player | PhysicsCategory.Obstacle
                    // add a copy to the column array
                    column.append(child.copy() as! SKSpriteNode)
                } else {
                    child.removeFromParent()
                }
            }
            // once we are done remove all the children that are left over if any and remove the copy itself
            copy.removeAllChildren()
            copy.removeFromParent()

            // make animations to move the child forever
            let move = SKAction.moveBy(x: -100, y: 0, duration: scrollSpeed)
            let repeater = SKAction.repeatForever(move)
            // for all the children in the column we add it to the scene and run the animation
            for copiedChild in column {
                scene.addChild(copiedChild)
                copiedChild.run(repeater)
            }
            // we then reset the column back to an emty array to get it ready for the next column
            column = []
            //reset the spawnTimer and columnPointer
            spawnTimer = 0
            columnPointer += 1
        }
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}
