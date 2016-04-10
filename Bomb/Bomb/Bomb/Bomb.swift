//
//  Bomb.swift
//  Bomb
//
//  Created by 宋天瑜 on 16/3/9.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import SpriteKit

class Bomb
{
    
    var physics:SKSpriteNode
    var lifetime:Double
    var life:Double
    var grow:Bool
    var maxSize = 1.05
    var stay:Int
    var type:Type
    
    
    init(point:CGPoint,type:Type)
    {
        self.type = type
        self.physics = SKSpriteNode(imageNamed: "Star")
        self.lifetime = 25
        
        self.stay = 0
        if type == Type.Longlast
        {
       //     self.physics = SKSpriteNode(imageNamed: "LongStar")
            self.lifetime = 50
            self.stay = 8
        }
        else if type == Type.Sudden
        {
       //     self.physics = SKSpriteNode(imageNamed: "SuddenStar")
            self.lifetime = 6
            self.maxSize = 2.4
        }
        else if type == Type.Shortlast
        {
       //     self.physics = SKSpriteNode(imageNamed: "ShortStar")
            self.lifetime = 12
        }
        else if type == Type.Explose
        {
            self.maxSize = 12
            self.lifetime = 50
        }
        
        
        self.physics.physicsBody = SKPhysicsBody(circleOfRadius: self.physics.frame.size.height)
        self.physics.setScale(0.01)
        self.physics.position = point
        self.physics.physicsBody?.affectedByGravity = false
        self.physics.physicsBody?.usesPreciseCollisionDetection = true
        self.physics.physicsBody?.categoryBitMask = 0x1<<0
        self.physics.physicsBody?.collisionBitMask = 0
        self.physics.physicsBody?.contactTestBitMask = 0x1<<1
        self.physics.zPosition = 2
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        self.physics.runAction(SKAction.repeatActionForever(action))
        
        self.life = 1
        self.grow = true
    }
    
    func updateBomb(dt: CFTimeInterval)
    {
        if grow
        {
            life++
            
            if life == lifetime
            {
                grow = false
            }
            
        }
        else if stay > 0
        {
            stay--
        }
        else
        {
            life--
            if life <= 1
            {
                physics.removeFromParent()
            }
        }
        self.physics.setScale(CGFloat(maxSize*life/lifetime))
        
    }
    
    
}