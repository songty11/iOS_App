//
//  Floater.swift
//  Bomb
//
//  Created by 宋天瑜 on 16/3/9.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import SpriteKit

enum Type
{
    case Normal
    case Longlast
    case Sudden
    case Shortlast
    case Explose
    
}
class Floater
{
    var physics:SKSpriteNode
    var velocity:CGVector
    var type:Type
    var score:Int
    
    init(point:CGPoint,Velocity:CGVector,type:Type)
    {
        self.type = type
        self.score = 50
        self.physics = SKSpriteNode(imageNamed: "NormalFloater")
        
        if type == .Longlast
        {
            self.score = 70
            self.physics = SKSpriteNode(imageNamed: "LongFloater")
        }
        else if type == .Sudden
        {
            self.score = 30
            self.physics = SKSpriteNode(imageNamed: "SuddenFloater")
        }
        else if type == .Shortlast
        {
            self.score = 100
            self.physics = SKSpriteNode(imageNamed: "ShortFloater")
        }
        self.physics.setScale(0.6)
        self.physics.position = point
        self.physics.physicsBody = SKPhysicsBody(circleOfRadius: self.physics.frame.size.height)
        
        self.physics.physicsBody?.affectedByGravity = false
        self.physics.physicsBody?.usesPreciseCollisionDetection = true
        self.physics.physicsBody?.categoryBitMask = 0x1 << 1
        self.physics.physicsBody?.collisionBitMask = 0
        self.physics.physicsBody?.contactTestBitMask = 0x1<<0// | 0x1<<0
        self.physics.zPosition = 2
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        
        self.physics.runAction(SKAction.repeatActionForever(action))
        
        self.velocity = Velocity
        
        
    }
    
    //https://www.raywenderlich.com/90520/trigonometry-games-sprite-kit-swift-tutorial-part-1
    func updateFloater(dt: CFTimeInterval)
    {
        
        // 3
        let newX = physics.position.x + velocity.dx * CGFloat(dt)
        let newY = physics.position.y + velocity.dy * CGFloat(dt)
        
        physics.position = CGPoint(x: newX, y: newY)
        physics.physicsBody?.velocity = self.velocity
    }
    
    
}