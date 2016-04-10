//
//  Difficulty.swift
//  Bomb
//
//  Created by 宋天瑜 on 16/3/10.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import SpriteKit
class Difficulty
{
    var x:Int
    let probabilityStep = 1.0/80.0
    var probability = 1.0/70.0
    init(level:Int)
    {
        self.x = level
    }
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func levelUp()
    {
        x++
        probability += probabilityStep
        
    }
    
    func getNumberofFloater()->Int
    {
       let number = 33 + Int(17 * cos(Double(Double(x) * M_PI/15.0)))
        
        let offset = Int(random(min:-3,max:3))
        
        print("level: \(x)")
        print("Number: \(number)")
        
        if x > 15
        {
            return 16 + offset
        }
        return number + offset
    }
    
    func getType()->Type
    {
        let typeNumber = random(min:0,max:CGFloat(1.0/probability))
        
        if(typeNumber > 1.0)
        {
            return Type.Normal
        }
        else
        {
            let specialNumber = random(min:0,max:5)
            if specialNumber <= 3
            {
                return Type.Shortlast
            }
            else if specialNumber <= 4
            {
                return Type.Longlast
            }
            else
            {
                return Type.Sudden
            }
        }
    }
    
    func getSpeed()->CGFloat
    {
        var minspeed = CGFloat(42 + 8 * cos(Double(Double(x) * M_PI/15.0)))
        var maxspeed = CGFloat(95 + 15 * cos(Double(Double(x) * M_PI/15.0)))
        
        if x > 15
        {
            minspeed = 20
            maxspeed = 80
        }
        
        var speed = random(min:minspeed,max:maxspeed)
        let minus = random(min:0,max:100)
        
        if minus > 50
        {
            speed = -speed
        }
        return 3 * speed
    }
    
    
}