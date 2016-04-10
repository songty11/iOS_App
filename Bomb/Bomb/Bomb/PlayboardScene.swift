//
//  WelcomeScene.swift
//  Bomb
//
//  Created by 宋天瑜 on 16/3/11.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import SpriteKit
import CoreMotion
import AVFoundation

class PlayboardScene: SKScene,SKPhysicsContactDelegate {
    
    let bombCategory: UInt32 = 0x1 << 0
    let floaterCategory: UInt32 = 0x1 << 1
    let CountdownLabel = SKLabelNode(fontNamed:"Futura")
    let ScoreLabel = SKLabelNode(fontNamed:"Futura")
    let LevelLabel = SKLabelNode(fontNamed:"Futura")
    var Sound = Sounds()
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var darkenLayer: SKSpriteNode?
    
    let DarkenOpacity: CGFloat = 0.8
    var gameOverElapsed: CFTimeInterval = 0
    
    var lastUpdateTime: CFTimeInterval = 0
    
    var floaters = [Floater]()
    var bombs = [Bomb]()
    var difficultyAdjustment = Difficulty(level: 0)
    var _setBomb = false
    var _needCountdown = true
    var _needNewlevel = false
    var _win = false
    var _lose = false
    var _waitforResult = false
    
    var _timer = 0
    var _level = 0
    var _score = 0
    
    //https://www.raywenderlich.com/119815/sprite-kit-swift-2-tutorial-for-beginners
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addfloater()
    {
        let floatersize = SKSpriteNode(imageNamed: "NormalFloater")
        
        let Y = random(min: floatersize.size.height/2, max: size.height - floatersize.size.height/2)
        let X = random(min: floatersize.size.width/2, max: size.width - floatersize.size.width/2)
        
        
        let floater = Floater(point: CGPoint(x:X,y:Y),Velocity: CGVector(dx:difficultyAdjustment.getSpeed(),dy:difficultyAdjustment.getSpeed()),type: difficultyAdjustment.getType())
        self.addChild(floater.physics)
        floaters.append(floater)
        
    }
    func setLabel()
    {
        CountdownLabel.fontSize = 180
        CountdownLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        CountdownLabel.zPosition = 1
        LevelLabel.fontSize = 60
        ScoreLabel.fontSize = 60
        LevelLabel.text = "Level : 00"
        ScoreLabel.text = "Score : 0"
        LevelLabel.horizontalAlignmentMode = .Left
        ScoreLabel.horizontalAlignmentMode = .Left
        LevelLabel.position = CGPoint(x:CGRectGetWidth(self.frame) - LevelLabel.frame.width,y:CGRectGetHeight(self.frame)-LevelLabel.frame.height)
        ScoreLabel.position = CGPoint(x:10,y:CGRectGetHeight(self.frame)-ScoreLabel.frame.height)
        LevelLabel.zPosition = 5
        ScoreLabel.zPosition = 5
        
        
        
        self.addChild(LevelLabel)
        self.addChild(ScoreLabel)
    }
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "BackGround")
        background.position = CGPoint(x:size.width/2,y:size.height/2)
        addChild(background)

        /* Setup your scene here */
        Sound.play(0)
        setLabel()
        startNewLevel()
        
        self.physicsWorld.contactDelegate = self
        
    }
    
    func countDown()
    {
        if _timer >= 0 && _timer < 30
        {
            CountdownLabel.text = "Level \(_level)"
        }
        else if _timer >= 30 && _timer < 70
        {
            CountdownLabel.text = "3"
        }
        else if _timer >= 70 && _timer < 110
        {
            CountdownLabel.text = "2"
        }
        else if _timer >= 110 && _timer < 150
        {
            CountdownLabel.text = "1"
        }
        else if _timer >= 150 && _timer < 190
        {
            CountdownLabel.text = "Begin!"
        }
        else
        {
            CountdownLabel.removeFromParent()
            CountdownLabel.text = "3"
            _needCountdown = false
            _needNewlevel = true
        }
    }
    
    func startNewLevel()
    {
        difficultyAdjustment.levelUp()
        
        _setBomb = false
        _needCountdown = true
        _needNewlevel = false
        _waitforResult = false
        _win = false
        _lose = false
        _level++
        
        _timer = 0
        bombs.removeAll()
        floaters.removeAll()
        self.addChild(CountdownLabel)
        LevelLabel.text = "Level: \(_level)"
        ScoreLabel.text = "Score: \(_score)"
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            if _setBomb
            {
                let location = touch.locationInNode(self)
                
                let bomb = Bomb(point: location,type: Type.Normal)
                
                let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
                
                bomb.physics.runAction(SKAction.repeatActionForever(action))
                
                self.addChild(bomb.physics)
                bombs.append(bomb)
                
                // tap once!
                Sound.play(5)
                  _setBomb = false
                _waitforResult = true
            }
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        
     if _lose
     {
        let scene = GameScene(size: size)
        let reveal = SKTransition.flipHorizontalWithDuration(1)
        view?.presentScene(scene, transition: reveal)
        return
    }
}
    
    func edgeReached(floater:Floater)
    {
        let newX = floater.physics.position.x
        let newY = floater.physics.position.y
        
        var collidedWithVerticalBorder = false
        var collidedWithHorizontalBorder = false
        
        
        if newX < floater.physics.frame.size.width/2 {
            floater.physics.position.x = floater.physics.frame.size.width/2
            collidedWithHorizontalBorder = true
        } else if newX > self.frame.size.width - floater.physics.frame.size.width/2{
            
            floater.physics.position.x = self.frame.size.width - floater.physics.frame.size.width/2
            collidedWithHorizontalBorder = true
        }
        
        if newY < floater.physics.frame.size.height/2 {
            floater.physics.position.y = floater.physics.frame.size.height/2
            collidedWithVerticalBorder = true
        } else if newY > self.frame.size.height - floater.physics.frame.size.height/2 - LevelLabel.frame.height{
            floater.physics.position.y = self.frame.size.height - floater.physics.frame.size.height/2 - LevelLabel.frame.height
            collidedWithVerticalBorder = true
        }
        
        
        if collidedWithHorizontalBorder
        {
            floater.velocity.dx = -floater.velocity.dx
            floater.velocity.dy = floater.velocity.dy
        }
        if collidedWithVerticalBorder
        {
            floater.velocity.dx = floater.velocity.dx
            floater.velocity.dy = -floater.velocity.dy
        }
        
    }
    func explosion(floater:Floater)
    {
        
        let bomb = Bomb(point: floater.physics.position,type: floater.type)
        self.addChild(bomb.physics)
        bombs.append(bomb)
        
    }
    
    func checkCollision(floater:Floater,bomb:Bomb)->Bool{
        var hasCollision = false
        
        let deltaX = floater.physics.position.x - bomb.physics.position.x
        let deltaY = floater.physics.position.y - bomb.physics.position.y
        
        let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
        if distance <= floater.physics.frame.size.height + bomb.physics.size.height {
            hasCollision = true
        }
        return hasCollision
    }
    
    func GameStart()
    {
        _setBomb = true
        for _ in 1...difficultyAdjustment.getNumberofFloater()
        {
            addfloater()
        }
        _needNewlevel = false
    }
    
    
    
    func motionUpdate(currentTime: CFTimeInterval)
    {
        var index = 0
        for floater in floaters
        {
            let deltaTime = max(1.0/30, currentTime - lastUpdateTime)
            lastUpdateTime = currentTime
            floater.updateFloater(deltaTime)
            edgeReached(floater)
            var collision = false
            for bomb in bombs
            {
                
                collision = checkCollision(floater,bomb: bomb)
                if collision
                {
                    break
                }
                
            }
            if collision
            {
                explosion(floater)
                _score+=floater.score
                floater.physics.removeFromParent()
                floaters.removeAtIndex(index)
                index--
                
                
            }
            index++
        }
        
        index = 0
        for bomb in bombs
        {
            
            let deltaTime = max(1.0/30, currentTime - lastUpdateTime)
            lastUpdateTime = currentTime
            bomb.updateBomb(deltaTime)
            
            if bomb.life <= 1
            {
                bomb.physics.removeFromParent()
                bombs.removeAtIndex(index)
                index--
                
            }
            index++
            
        }
        if _waitforResult && floaters.count==0 && bombs.count == 0 && !_lose
        {
            _win = true
            startNewLevel()
        }
        ScoreLabel.text = "Score: \(_score)"
        
    }
    func checkGameOver(currentTime: CFTimeInterval)
    {
        let deltaTime = max(1.0/30, currentTime - lastUpdateTime)
        lastUpdateTime = currentTime
        if _waitforResult && floaters.count != 0 && bombs.count == 0 && !_lose
        {
            _lose = true
            gameOverElapsed = 0
            
            let fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            darkenLayer = SKSpriteNode(color: fillColor, size: size)
            darkenLayer?.alpha = 0
            darkenLayer!.position = CGPoint(x: size.width/2, y: size.height/2)
            darkenLayer?.zPosition = 1
            
            addChild(darkenLayer!)
            
            var Highest = defaults.integerForKey("HighestScore")
            
            
            let gameOverLabel = SKLabelNode(fontNamed: "Futura")
            gameOverLabel.text = "Game Over"
            gameOverLabel.fontSize = 120
            gameOverLabel.zPosition = 3
            gameOverLabel.position = CGPoint(x: size.width/2 + 0.5, y: size.height/2 + 50)
            
            let Congratulation = SKLabelNode(fontNamed: "Futura")
            Congratulation.text = "New Record!"
            Congratulation.color = UIColor(red:253.0/255.0,green:252.0/255.0,blue:127.0/255.0,alpha:1.0)
            Congratulation.fontSize = 90
            Congratulation.zPosition = 3
            Congratulation.position = CGPoint(x: size.width/2 + 0.5, y: gameOverLabel.position.y - gameOverLabel.frame.height - 5)
            if Highest < _score
            {
                addChild(Congratulation)
                defaults.setInteger(_score, forKey: "HighestScore")
                Highest = _score
                Sound.play(1)
                NSNotificationCenter.defaultCenter().postNotificationName("showAlert", object: nil)
                
            
            }

            let gameOverScore = SKLabelNode(fontNamed: "Futura")
            gameOverScore.text = "Your Score: \(_score)"
            gameOverScore.fontSize = 60
            gameOverScore.zPosition = 3
            gameOverScore.position = CGPoint(x: size.width/2 + 0.5, y: Congratulation.position.y - Congratulation.frame.height - 5)
            
            let HighestScore = SKLabelNode(fontNamed: "Futura")
            HighestScore.text = "Highest Score: \(Highest)"
            HighestScore.fontSize = 60
            HighestScore.zPosition = 3
            HighestScore.position = CGPoint(x: size.width/2 + 0.5, y: gameOverScore.position.y - gameOverScore.frame.height - 5)
            
            let gameOverTipsLabel = SKLabelNode(fontNamed: "Futura")
            gameOverTipsLabel.text = "Tap anywhere to restart"
            gameOverTipsLabel.fontSize = 60
            gameOverTipsLabel.zPosition = 3
            gameOverTipsLabel.position = CGPoint(x: size.width/2 + 0.5, y: 10 + gameOverTipsLabel.frame.height)
            addChild(gameOverLabel)
            addChild(gameOverTipsLabel)
            addChild(gameOverScore)
            addChild(HighestScore)
            
            
            
        }
        else if _waitforResult && floaters.count != 0 && bombs.count == 0 && _lose
        {
            darkenLayer?.alpha = min(DarkenOpacity, darkenLayer!.alpha + CGFloat(deltaTime))
        }
        
    }
    override func update(currentTime: CFTimeInterval)
    {
        //1 count down
        if _needCountdown
        {
            countDown()
        }
            
            //2 new level setting
        else if _needNewlevel
        {
            GameStart()
        }
            
            //3 running game
        else
        {
            motionUpdate(currentTime)
        }

        checkGameOver(currentTime)
        
        
        if _timer < 99999999
        {
            _timer++
        }
        /* Called before each frame is rendered */
    }
    
    
    
   }
