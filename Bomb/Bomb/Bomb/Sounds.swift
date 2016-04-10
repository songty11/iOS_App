//
//  Sounds.swift
//  Bomb
//
//  Created by 宋天瑜 on 16/3/12.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import AVFoundation

class Sounds
{
    
    
    var Sound = [AVAudioPlayer!]()
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
        
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        
        
        var audioPlayer:AVAudioPlayer?
        
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("Players not available")
        }
        
        return audioPlayer
    }
    init()
    {
        var SoundIndex = self.setupAudioPlayerWithFile("BackGround", type: "mp3")
        self.Sound.append(SoundIndex!)
        
        SoundIndex = self.setupAudioPlayerWithFile("Lose", type: "wav")
        self.Sound.append(SoundIndex!)
        
        SoundIndex = self.setupAudioPlayerWithFile("Tap", type: "wav")
        self.Sound.append(SoundIndex!)
        
        SoundIndex = self.setupAudioPlayerWithFile("Pong", type: "mp3")
        self.Sound.append(SoundIndex!)
        
        SoundIndex = self.setupAudioPlayerWithFile("Introduction", type: "mp3")
        self.Sound.append(SoundIndex!)
        
        SoundIndex = self.setupAudioPlayerWithFile("Set", type: "wav")
        self.Sound.append(SoundIndex!)
        SoundIndex = self.setupAudioPlayerWithFile("Ding", type: "wav")
        self.Sound.append(SoundIndex!)
        
    }
    func play(i:Int)
    {
        Sound[i].play()
    }
}
