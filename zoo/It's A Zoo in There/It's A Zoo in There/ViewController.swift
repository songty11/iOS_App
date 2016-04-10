//
//  ViewController.swift
//  It's A Zoo in There
//
//  Created by 宋天瑜 on 16/1/16.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import UIKit
import AVFoundation


//Array extension - shuffle
extension CollectionType {
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    mutating func shuffleInPlace() {
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var Label: UILabel!
    var animalArr = [Animal]()
    
    var Sound = [AVAudioPlayer?]()
    
    
    //MARK: Sound system from:http://www.raywenderlich.com/114298/learn-to-code-ios-apps-with-swift-tutorial-5-making-it-beautiful
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
     
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        

        var audioPlayer:AVAudioPlayer?
        
    
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("Player not available")
        }
        
        return audioPlayer
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animalArr.append(Animal(name:"Dragon", species:"Legend", age:2000,
            image: UIImage(named: "dragon.jpg")!,soundPath:"dragonSound"))
        animalArr.append(Animal(name:"Cat", species:"Lazy", age:3,
            image: UIImage(named: "Cat.jpg")!,soundPath:"catSound"))
        animalArr.append(Animal(name:"Squirrel", species:"Cute", age:2,
            image: UIImage(named: "Squirrel.jpg")!,soundPath:"squirrelSound"))
        
        animalArr = animalArr.shuffle()
        
        for i in 0...2
        {
            if let Soundindex = self.setupAudioPlayerWithFile(animalArr[i].soundPath!, type:"mp3") { self.Sound.append(Soundindex)}
       
        }
        
        //MARK: Set Scroll view
        ScrollView.contentSize = CGSizeMake(1125.0,500.0)
        ScrollView.frame.size = CGSizeMake(375.0,500.0)
        ScrollView.pagingEnabled = true
        ScrollView.delegate = self
        
        //MARK: Add Button
        for i in 0...2{
            let button:UIButton = UIButton(type:.System)
            button.backgroundColor = UIColor.whiteColor()
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.setTitle(animalArr[i].name, forState:UIControlState.Normal)
            button.frame=CGRectMake(CGFloat(110+375*i), 360, 150, 30)
            button.tag = i
            button.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
            
            
            ScrollView.addSubview(button)
        }
        
        //MARK: Add image view
        for i in 0...2{
            var imageView = UIImageView()
            imageView = UIImageView(frame:CGRectMake(CGFloat(375*i),100,375,250));
            imageView.image = animalArr[i].image
            ScrollView.addSubview(imageView)
        }
        
        self.view.addSubview(ScrollView)
        
        //MARK: Set initial value of label
        Label.text = animalArr[0].name
        self.view.addSubview(Label)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func buttonTapped(sender:UIButton!)
    {
        for i in  0...2{
            Sound[i]?.stop()}
        let btsendtag:UIButton = sender
        let alert = UIAlertController(title: animalArr[btsendtag.tag].name,message:"This \(animalArr[btsendtag.tag].name) is \(animalArr[btsendtag.tag].age) years old", preferredStyle:UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert,animated:true,completion:nil)
        Sound[btsendtag.tag]?.play()
        animalArr[btsendtag.tag].dumpAnimalObject()
    }
    
    func crollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        Label.text = "\(animalArr[pageIndex].name)"
    }
    
    
    //MARK: fade in fade out
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let pageIndex = scrollView.contentOffset.x / scrollView.frame.size.width
        
        if (pageIndex >= 0 && pageIndex <= 0.5) {
            Label.text = "\(animalArr[0].name)"
            Label.alpha = 1-2*pageIndex
        } else if (pageIndex > 0.5 && pageIndex <= 1) {
            Label.text = "\(animalArr[1].name)"
            Label.alpha = -1 + 2*pageIndex
        } else if (pageIndex > 1 && pageIndex <= 1.5) {
            Label.text = "\(animalArr[1].name)"
            Label.alpha = 3-2*pageIndex
            
        } else if (pageIndex > 1.5 && pageIndex <= 2) {
            Label.text = "\(animalArr[2].name)"
            Label.alpha = -3 + 2*pageIndex
            
        } else if (pageIndex > 2 && pageIndex <= 2.5) {
            Label.text = "\(animalArr[2].name)"
            Label.alpha = 5-2*pageIndex
            
        } else{
            Label.text = "\(animalArr[2].name)"
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

