//
//  GameScene.swift
//  Bomb
//
//  Created by 宋天瑜 on 16/3/8.
//  Copyright (c) 2016年 Tianyu Song. All rights reserved.
//

import SpriteKit
import CoreMotion
class GameScene: SKScene {
    
    var Sound = Sounds()
    let defaults = NSUserDefaults.standardUserDefaults()
    var welcomeBall = SKSpriteNode(imageNamed: "MainBall")
    let Arrow = SKSpriteNode(imageNamed: "Arrow")
    let Label = SKLabelNode(fontNamed:"Futura")
    let NewPlayer = SKLabelNode(fontNamed:"Futura")
    
    var introNode = SKSpriteNode(imageNamed: "Bulb")
    var LightNode = SKSpriteNode(imageNamed: "Light")
    var wiggle = SKAction()
    var explose = [SKSpriteNode]()
    var velocity = CGVector(dx: 0,dy: 0)

    var timer = 0
    
    var startGame = false
    var isExplo = false
    var isfirstlaunch = false
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func randomImage(fmin:Int)->SKSpriteNode
    {
        var Ball = SKSpriteNode(imageNamed: "LongFloater")
        let number = Int(random(min:CGFloat(fmin),max:28))
        if number < 25
        {
            Ball = SKSpriteNode(imageNamed: "\(number)")
        }
        else if number == 25
        {
            Ball = SKSpriteNode(imageNamed: "LongFloater")
        }
        else if number == 26
        {
            Ball = SKSpriteNode(imageNamed: "NormalFloater")
        }
        else if number == 27
        {
            Ball = SKSpriteNode(imageNamed: "ShortFloater")
        }
        return Ball
    }
    
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "BackGround")
        background.position = CGPoint(x:size.width/2,y:size.height/2)
        
        addChild(background)
        self.physicsWorld.gravity.dy = self.physicsWorld.gravity.dy*2
        Label.text = ""
        Label.fontSize = 180
        Label.zPosition = 1
        Arrow.setScale(0.75)
        Arrow.alpha = 0.8
        Arrow.zPosition = 1
        
        let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
        welcomeBall.runAction(SKAction.repeatActionForever(action))
        welcomeBall.zPosition = 1
        self.addChild(Arrow)
        Label.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        self.addChild(Label)
        welcomeBall.setScale(1.8)
        
        velocity.dy = -CGFloat(10) * sqrt(2*(-physicsWorld.gravity.dy)*(size.height/2 + welcomeBall.size.height))
        print(velocity)
        welcomeBall.position = CGPoint(x:size.width/2,y:size.height/2)
        welcomeBall.physicsBody = SKPhysicsBody(circleOfRadius: welcomeBall.size.height)
        welcomeBall.physicsBody?.affectedByGravity = true
        welcomeBall.physicsBody?.collisionBitMask = 0
        welcomeBall.name = "Start"
        self.addChild(welcomeBall)

        LightNode.setScale(1.2)
        LightNode.position = CGPoint(x:size.width/2,y:2*size.height/3)
        LightNode.alpha = 0
        LightNode.zPosition = 1
        addChild(LightNode)
        
        
        introNode.setScale(1.05)
        introNode.name = "introBar"
        introNode.physicsBody = SKPhysicsBody(circleOfRadius: introNode.frame.width)
        introNode.position = CGPoint(x:size.width/2,y:2*size.height/3)
        introNode.physicsBody!.affectedByGravity = false
        introNode.zPosition = 1
        let rotR = SKAction.rotateByAngle(0.15, duration: 0.1)
        let rotL = SKAction.rotateByAngle(-0.15, duration: 0.1)
        let cycle = SKAction.sequence([rotR, rotL, rotL, rotR])
        wiggle = SKAction.repeatAction(cycle, count: 2)
        introNode.runAction(wiggle, withKey: "wiggle")
        
        addChild(introNode)
        
        
        NewPlayer.text = "Need help? Try to tap the bulb."
        NewPlayer.fontSize = 60
        NewPlayer.position = CGPoint(x:size.width/2,y:introNode.position.y+introNode.size.height/2 + NewPlayer.frame.size.height/2 + 5)
        NewPlayer.zPosition = 1
        if(defaults.objectForKey("Initial Launch") != nil)
        {
            print ("Not First Launch: ✌️")
            isfirstlaunch = false
        }
        else
        {
            defaults.setObject(NSDate(), forKey: "Initial Launch")
            print ("First Launch: 👆")
            addChild(NewPlayer)
            isfirstlaunch = true
        }
    }
    func explosion(P:CGPoint)
    {
        for i in 1...24
        {
            let node = SKSpriteNode(imageNamed: "\(i)")
            node.setScale(0.6)
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.height)
            node.physicsBody?.affectedByGravity = false
            node.physicsBody?.collisionBitMask = 0
            node.position = P
            let speedX = 2700.0 * sin(Double(i)*M_PI/12.0)
            let speedY = 2700.0 * cos(Double(i)*M_PI/12.0)
            node.physicsBody?.velocity = CGVector(dx: speedX, dy: speedY)
            node.zPosition = 1
            self.addChild(node)
            explose.append(node)
        }
    
      Label.text = "Ready"
        welcomeBall.removeFromParent()
        Arrow.removeFromParent()

     //   self.addChild(Label)
        
        
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches 
        let location = touch.first!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        // If next button is touched, start transition to second scene
        if (node.name == "Start")
        {
            explosion(location)
            isExplo = true
            Sound.play(6)

        }
        if node.name == "introBar"
        {
            NewPlayer.alpha = 0.0
            node.setScale(1.2)
            LightNode.alpha = 0.7
            Sound.play(2)
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches
        let location = touch.first!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        if node.name == "introBar"
        {
            node.setScale(1.05)
            let introScene = IntroScene(size: self.size)
            let transition = SKTransition.flipHorizontalWithDuration(1.0)
            introScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(introScene, transition: transition)
        }
    }
    
    override func update(currentTime: CFTimeInterval)
    {
        
        if timer < 99999999
        {
            timer++
        }
        if !isExplo
        {
            if welcomeBall.position.y <= welcomeBall.size.height/2
            {
                welcomeBall.position.y = welcomeBall.size.height
                welcomeBall.physicsBody?.velocity.dy = -velocity.dy
                Sound.play(3)
              //  Sound.rplay()
            }
            if abs((welcomeBall.physicsBody?.velocity.dy)!) < 70
            {
                introNode.runAction(wiggle, withKey: "wiggle")
            }
            Arrow.position = CGPoint(x: welcomeBall.position.x + 1.5 * welcomeBall.size.width,y: welcomeBall.position.y + 2 * welcomeBall.size.height)
            
            introNode.alpha = (1 - 1.5 * welcomeBall.position.y/(size.height - 15))
            
            if NewPlayer.alpha >= 0
            {
                NewPlayer.alpha-=0.001
            }
            else
            {
                NewPlayer.removeFromParent()
            }
        
        }
        else if !startGame
        {
            var index = 0
            for node in explose
            {
                if node.position.y < 0 || node.position.y > self.size.height || node.position.x < 0 || node.position.x > self.size.width
                {
                    explose.removeAtIndex(index)
                    index--
                }
                
                index++
            }
            if explose.count == 0
            {
                startGame = true
            }
        }
        else
        {
            introNode.physicsBody?.affectedByGravity = true
            let secondScene = PlayboardScene(size: self.size)
            let transition = SKTransition.flipHorizontalWithDuration(1.0)
            secondScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(secondScene, transition: transition)
        }
        
        
        
        if timer == 450
        {
            if !isfirstlaunch
            {
                addChild(NewPlayer)
            }
        }
    }
}
