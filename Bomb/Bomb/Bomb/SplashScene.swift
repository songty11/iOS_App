//
//  SplashScene.swift
//  Bomb
//
//  Created by 宋天瑜 on 16/3/12.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import SpriteKit

class SplashScene: SKScene {
    
    var Sound = Sounds()
    let Title = SKLabelNode(fontNamed:"Futura")
    let Name = SKLabelNode(fontNamed:"Futura")
    var progressBall = [SKSpriteNode]()
    var timer = 0
    
    
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "BackGround")
        background.position = CGPoint(x:size.width/2,y:size.height/2)
        addChild(background)
         self.physicsWorld.gravity.dy = self.physicsWorld.gravity.dy*3
        Title.text = "One"
        Title.fontSize = 210
        Title.position = CGPoint(x:size.width/2,y:2*size.height/3)
        Title.zPosition = 1
        addChild(Title)
        Name.text = "By Tianyu Song"
        Name.fontSize = 75
        Name.position = CGPoint(x:size.width/2,y:Title.position.y - Title.frame.height/2 - 2 * Name.frame.height)
        addChild(Name)
        Name.zPosition = 1
        
        let node = SKSpriteNode(imageNamed: "MainBall")
        node.setScale(0.6)
        node.position = CGPoint(x:size.width/10,y:size.height/4)
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        node.runAction(SKAction.repeatActionForever(action))
        addChild(node)
        progressBall.append(node)
        node.zPosition = 1
    }
    func clearSplash()
    {
        for node in progressBall
        {
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.frame.height)
            node.physicsBody?.affectedByGravity = true
        }
        
        progressBall.removeAll()
        
        Title.physicsBody = SKPhysicsBody(rectangleOfSize: Title.frame.size)
        Title.physicsBody?.affectedByGravity = true
        Name.physicsBody = SKPhysicsBody(rectangleOfSize: Name.frame.size)
        Name.physicsBody?.affectedByGravity = true
    }
    override func update(currentTime: CFTimeInterval)
    {
        
        if timer < 99999999
        {
            timer++
        }
        if timer == 41
        {
            clearSplash()
        }
        else if timer % 5 == 0 && timer < 41
        {
            let i = CGFloat(timer/5)
            let node = SKSpriteNode(imageNamed: "MainBall")
            node.setScale(0.6)
            node.position = CGPoint(x:(i + 1) * size.width/10,y:size.height/4)
            addChild(node)
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            node.runAction(SKAction.repeatActionForever(action))
            progressBall.append(node)
            node.zPosition = 1
        }
        if Title.position.y < 0
        {
            let newScene = GameScene(size: self.size)
            newScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(newScene)
        }
    }

}
