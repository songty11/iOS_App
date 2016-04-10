//
//  GameViewController.swift
//  Bomb
//
//  Created by 宋天瑜 on 16/3/8.
//  Copyright (c) 2016年 Tianyu Song. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showAlert:", name: "showAlert", object: nil)
        
        print(self.view.frame.size)
        let scene = SplashScene(size:CGSize(width:1080,height:1920))
            // Configure the view.
        
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        
    }
    
    func showAlert(object : AnyObject) {
        
        let alert = UIAlertController(title: "Congratulation",message:"New Highest Score!", preferredStyle:UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok~", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert,animated:true,completion:nil)
    }

    override func shouldAutorotate() -> Bool {
        return false
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
