//
//  IntroScene.swift
//  Bomb
//
//  Created by 宋天瑜 on 16/3/11.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import SpriteKit
import UIKit

class IntroScene: SKScene {
    
    var Sound = Sounds()
    var BackNode = SKSpriteNode(imageNamed: "Bulb")
    let Title = SKLabelNode(fontNamed:"Chalkduster")
    let content = SKSpriteNode(imageNamed: "Content")
    
    let NormalNode = SKSpriteNode(imageNamed: "NormalFloater")
    let LongNode = SKSpriteNode(imageNamed: "LongFloater")
    let ShortNode = SKSpriteNode(imageNamed: "ShortFloater")
    let ExplosionNode = SKSpriteNode(imageNamed: "SuddenFloater")
    let NameLabel = SKLabelNode(fontNamed:"Futura")
    
    var darkenLayer: SKSpriteNode?
    
    var Line = [SKLabelNode]()
    
    var bulb_low = true
    
    override func didMoveToView(view: SKView)
    {
        let background = SKSpriteNode(imageNamed: "BackGround")
        background.position = CGPoint(x:size.width/2,y:size.height/2)
        let fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        darkenLayer = SKSpriteNode(color: fillColor, size: size)
        darkenLayer?.alpha = 0.4
        darkenLayer!.position = CGPoint(x: size.width/2, y: size.height/2)
        darkenLayer?.zPosition = 1
        addChild(darkenLayer!)
        addChild(background)
        Sound.play(4)
        Title.text = "ONE"
        Title.fontSize = 210
        Title.position = CGPoint(x:size.width/2,y:3*size.height/4)
        addChild(Title)
        Title.zPosition = 2
        
        NameLabel.text = "By Tianyu Song"
        NameLabel.fontSize = 60
        NameLabel.position = CGPoint(x:size.width/2,y:NameLabel.frame.height)
        addChild(NameLabel)
        NameLabel.zPosition = 2
        
        BackNode.setScale(0.66)
        BackNode.name = "Back"
        BackNode.position = CGPoint(x:size.width/2,y:NameLabel.position.y + NameLabel.frame.height + BackNode.frame.height/2)
        addChild(BackNode)
        BackNode.zPosition = 2
        
        let leftM = 3 * size.width / 8
        
        let lineSeparate = CGFloat(60)
        
        for _ in 1...11
        {
            Line.append(SKLabelNode(fontNamed:"Futura"))
            
        }
        Line[0].text = "This is a game for relaxing."
        Line[1].text = "Tap the marbles to start."
        Line[2].text = "Tap anywhere to set a trigger."
        Line[3].text = "You will want to trigger all floaters with one tap."
        Line[4].text = "Otherwise you lose."
        Line[5].text = "There are four kind of floaters:"
        Line[6].text = "   :Normal Floaters"
        Line[7].text = "   :Long Lasting Floaters"
        Line[8].text = "   :Short Lasting Floaters"
        Line[9].text = "   :Explosion Floaters"
        Line[10].text = "Enjoy Your Game!"
        for i in 0...10
        {
            Line[i].fontSize = 45
            if i == 0
            {
                Line[i].position = CGPoint(x:size.width/2,y:Title.position.y - Title.frame.height/2 - lineSeparate)
            }
            else if i == 5 || i == 10
            {
                Line[i].position = CGPoint(x:size.width/2,y:Line[i-1].position.y - 2 * lineSeparate)
            }
            else if i == 6
            {
                Line[i].position = CGPoint(x:Line[i].frame.width/2 + leftM,y:Line[i-1].position.y - 2 * lineSeparate)
            }
            else if i == 7 || i == 8 || i == 9
            {
                Line[i].position = CGPoint(x:Line[i].frame.width/2 + leftM,y:Line[i-1].position.y - lineSeparate)
            }
            else
            {
                Line[i].position = CGPoint(x:size.width/2,y:Line[i-1].position.y - lineSeparate)
            }
            addChild(Line[i])
            Line[i].zPosition = 2
        }
        
        let offset = CGFloat(12)
        
        NormalNode.setScale(0.75)
        NormalNode.position = CGPoint(x:Line[6].position.x - Line[6].frame.width/2 - NormalNode.size.width/2,y:Line[6].position.y + NormalNode.size.height/2 - offset)
        addChild(NormalNode)
        NormalNode.zPosition = 2
        
        LongNode.setScale(0.75)
        LongNode.position = CGPoint(x:Line[7].position.x - Line[7].frame.width/2 - LongNode.size.width/2,y:Line[7].position.y + LongNode.size.height/2 - offset)
        addChild(LongNode)
        LongNode.zPosition = 2
        ShortNode.setScale(0.75)
        ShortNode.position = CGPoint(x:Line[8].position.x - Line[8].frame.width/2 - ShortNode.size.width/2,y:Line[8].position.y + ShortNode.size.height/2 - offset)
        addChild(ShortNode)
        ShortNode.zPosition = 2
        ExplosionNode.setScale(0.75)
        ExplosionNode.position = CGPoint(x:Line[9].position.x - Line[9].frame.width/2 - ExplosionNode.size.width/2,y:Line[9].position.y + ExplosionNode.size.height/2 - offset)
        addChild(ExplosionNode)
        ExplosionNode.zPosition = 2
        
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    //    let touch = touches
      //  let location = touch.first!.locationInNode(self)
       // let node = self.nodeAtPoint(location)
        
        // If next button is touched, start transition to second scene
//        if (node.name == "Back")
//        {
            let mainScene = GameScene(size: self.size)
            let transition = SKTransition.flipHorizontalWithDuration(1.0)
            mainScene.scaleMode = SKSceneScaleMode.AspectFill
            self.scene!.view?.presentScene(mainScene, transition: transition)
     //   }
    }
    override func update(currentTime: CFTimeInterval)
    {
        if BackNode.alpha < 0.1
        {
            bulb_low = false
        }
        
        if BackNode.alpha > 0.99
        {
            bulb_low = true
        }
        
        if bulb_low
        {
            BackNode.alpha-=0.01
        }
        else
        {
            BackNode.alpha+=0.01
        }
    }
}
