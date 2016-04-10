//
//  ViewController.swift
//  Fun And Games
//
//  Created by Tianyu Song on 16/2/13.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {

    //MARK: Properties
    //Grid views
    @IBOutlet weak var NewBigO: UIImageView!
    @IBOutlet weak var NewBigX: UIImageView!
    @IBOutlet weak var board_1: UIView!
    @IBOutlet weak var board_2: UIView!
    @IBOutlet weak var board_3: UIView!
    @IBOutlet weak var board_4: UIView!
    @IBOutlet weak var board_5: UIView!
    @IBOutlet weak var board_6: UIView!
    @IBOutlet weak var board_7: UIView!
    @IBOutlet weak var board_8: UIView!
    @IBOutlet weak var board_9: UIView!
    
    //Instruction
    @IBOutlet weak var InstructionView: UIView!
    @IBOutlet weak var InstructionContent: UILabel!
    @IBOutlet weak var VersionLabel: UILabel!
    
    
    //center of chessborad
    var chessBoardCenter = [CGPoint]()
    
    //status of chessboard (0,1,2)
    var chessBoard = [[Int]]()
    
    //image in each box
    var chessImage = [UIImageView]()
    
    //which player is in charge, true for X, false for O
    var isX = true
    
    //count steps, for TIE judgement
    var stepcnt = 0
    
    var WinningType = 0
    
    //check whether game is over
    var GameOver = false
    
    //the origin position of X and O
    var Ocenter:CGPoint!
    var Xcenter:CGPoint!
    
    //Sound file
    var Sound = [AVAudioPlayer?]()
    
    
    //MARK: Init progress
    // - Attribution: http://www.raywenderlich.com/114298/learn-to-code-ios-apps-with-swift-tutorial-5-making-it-beautiful
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
    func soundInit()
    {
        var SoundIndex = self.setupAudioPlayerWithFile("Drag", type: "mp3")
        self.Sound.append(SoundIndex)
        SoundIndex = self.setupAudioPlayerWithFile("Buzzer", type: "mp3")
        self.Sound.append(SoundIndex)
        SoundIndex = self.setupAudioPlayerWithFile("Place", type: "mp3")
        self.Sound.append(SoundIndex)
        SoundIndex = self.setupAudioPlayerWithFile("Celebrate", type: "mp3")
        self.Sound.append(SoundIndex)
    }
    
    //Add pan getsture
    func addGestureToView(view:UIView)
    {
        let panGesture  = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        view.addGestureRecognizer(panGesture)
    }
    
    //Put the gird view into an array
    func initChessBoard()
    {
        var point = CGPoint(x:board_1.center.x,y:board_1.center.y)
        chessBoardCenter.append(point)
        point = CGPoint(x:board_2.center.x,y:board_2.center.y)
        chessBoardCenter.append(point)
        point = CGPoint(x:board_3.center.x,y:board_3.center.y)
        chessBoardCenter.append(point)
        point = CGPoint(x:board_4.center.x,y:board_4.center.y)
        chessBoardCenter.append(point)
        point = CGPoint(x:board_5.center.x,y:board_5.center.y)
        chessBoardCenter.append(point)
        point = CGPoint(x:board_6.center.x,y:board_6.center.y)
        chessBoardCenter.append(point)
        point = CGPoint(x:board_7.center.x,y:board_7.center.y)
        chessBoardCenter.append(point)
        point = CGPoint(x:board_8.center.x,y:board_8.center.y)
        chessBoardCenter.append(point)
        point = CGPoint(x:board_9.center.x,y:board_9.center.y)
        chessBoardCenter.append(point)
    }
    //Clean the game board, called at the begin of each round
    func cleanBoard()
    {
        chessBoard = [[0,0,0],[0,0,0],[0,0,0]]
        stepcnt = 0
        isX = true
        NewBigO.userInteractionEnabled = false
        NewBigO.alpha = 0.5
        NewBigX.userInteractionEnabled = true
        NewBigX.alpha = 1.0
        GameOver  = false
        for img in chessImage{
            img.removeFromSuperview()
        }
        chessImage.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initChessBoard()    //chessboard inition
        
        soundInit()     //sound file inition
        
        cleanBoard()    //clean chessboard
        
        InstructionContent.text = "Tic-Tac-Toe is a game for two players, X and O, who take turns marking the spaces in a 3×3 grid. The player who succeeds in placing three of their marks in a horizontal, vertical, or diagonal row wins the game. You will start with X. To play with, simply drag an 'X' or 'O' from bottom and place it into grid. The player in turn will notified with an animation. You will not put two items in the same square. Any player win the game will be notified with a music. Enjoy your game!"
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            self.VersionLabel.text = "Version: \(version)"
        }
        
        addGestureToView(NewBigO)
        addGestureToView(NewBigX)
        
        //save the origin place
        Ocenter = NewBigO.center
        Xcenter = NewBigX.center
        
     }

    
    //MARK: Inner Logic
    
    //One Step
    func setAstep(view:UIView)
    {
        var P:CGPoint
        //if isX is true, what we are dragging is an X, else is O
        if isX
        {
            P = NewBigX.center
        }
        else
        {
            P = NewBigO.center
        }
        
        //Find the closet box index
        let index = countClosetPos(P)
        
        //If it is not empty
        if chessBoard[index/3][index%3] != 0
        {
            
            //Play buzzer sound
            Sound[1]?.play()
            
            //animation back
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
                if self.isX
                {
                    self.NewBigX.center = self.Xcenter
                }
                else
                {
                    self.NewBigO.center = self.Ocenter
                }
                }, completion: nil)
            return
        }
        
        //successfully placed
        //Set the center point of new item
        let centerPoint = chessBoardCenter[index]
        
        //play sound
        Sound[2]?.play()
        
        if(!isX)
        {
            //is O, put a new image on there
            NewBigO.center = Ocenter
            let newO = UIImage(named:"O")
            let newOImageView = UIImageView(image:newO)
            newOImageView.frame = CGRectMake(0,0,111,111)
            newOImageView.center = centerPoint
            newOImageView.userInteractionEnabled = false
            
            chessImage.append(newOImageView)
            view.insertSubview(chessImage[chessImage.count-1], belowSubview: InstructionView)
            chessBoard[index/3][index%3] = 2
            
            //step plus 1
            stepcnt++
            
            //Next player
            UserExchange()
            
            //check whether game is over
            if isOver(index)
            {
                //player 2 wins
                cheer(2)
            }
            else if stepcnt == 9
            {
                //tie
                cheer(3)
            }
            
            
        }
        else
        {
            // is X
            NewBigX.center = Xcenter
            let newX = UIImage(named:"X")
            let newXImageView = UIImageView(image:newX)
            newXImageView.frame = CGRectMake(0,0,111,111)
            newXImageView.center = centerPoint
            newXImageView.userInteractionEnabled = false
            
            chessImage.append(newXImageView)
            view.insertSubview(chessImage[chessImage.count-1], belowSubview: InstructionView)
            chessBoard[index/3][index%3] = 1
            stepcnt++
            UserExchange()
            if isOver(index)
            {
                cheer(1)
            }
            else if stepcnt == 9
            {
                cheer(3)
            }
            
            
        }
        
    }
    
    //Find the closet box
    func countClosetPos(P:CGPoint)->Int{
        
        var closetdis = 2147483646  //set to max
        var closetindex = 0

        for var i=0; i < chessBoardCenter.count; i++ {
            let dis = Int((chessBoardCenter[i].x - P.x)*(chessBoardCenter[i].x - P.x) + (chessBoardCenter[i].y - P.y)*(chessBoardCenter[i].y - P.y))
            if dis < closetdis  //find a smaller one
            {
                closetdis = dis
                closetindex = i
            }
        }
        return closetindex
    }
    
    //"getting bigger" animation
    func BlingBling(Type:Bool)
    {
        if(!Type)
        {
            //is O
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
                self.NewBigO.transform = CGAffineTransformMakeScale(2, 2)
                }, completion: nil)
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
                self.NewBigO.transform = CGAffineTransformMakeScale(1, 1)
                }, completion: nil)
        }
        else
        {
            //is X
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
                self.NewBigX.transform = CGAffineTransformMakeScale(2, 2)
                }, completion: nil)
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
                self.NewBigX.transform = CGAffineTransformMakeScale(1, 1)
                }, completion: nil)
        }
        
    }
    
    //Set next player
    func UserExchange()
    {
        isX = !isX
        
        //check if game is over, if not, play animation
        if !GameOver
        {
            BlingBling(isX)
        }
        if(isX)
        {
            NewBigO.userInteractionEnabled = false
            NewBigO.alpha = 0.5
            NewBigX.userInteractionEnabled = true
            NewBigX.alpha = 1.0
        }
        else
        {
            NewBigX.userInteractionEnabled = false
            NewBigX.alpha = 0.5
            NewBigO.userInteractionEnabled = true
            NewBigO.alpha = 1.0
        }
    }

    //Draw a line accoring to the type of win
    func CreatLine()->WinLineUIView
    {
        var rect = CGRect(x:0,y:0,width: 0,height: 0)
        var viewLine = WinLineUIView(frame:rect)
        if WinningType == 1
        {
            rect = CGRect(x:0,y:0,width:300,height:20)
            viewLine = WinLineUIView(frame: rect)
            viewLine.center = chessBoardCenter[1]
        }
        else if WinningType == 2
        {
            rect = CGRect(x:0,y:0,width:300,height:20)
            viewLine = WinLineUIView(frame: rect)
            viewLine.center = chessBoardCenter[4]

        }
        else if WinningType == 3
        {
            rect = CGRect(x:0,y:0,width:300,height:20)
            viewLine = WinLineUIView(frame: rect)
            viewLine.center = chessBoardCenter[7]
        }
        else if WinningType == 4
        {
            rect = CGRect(x:0,y:0,width:20,height:300)
            viewLine = WinLineUIView(frame: rect)
            viewLine.center = chessBoardCenter[3]
        }
        else if WinningType == 5
        {
            rect = CGRect(x:0,y:0,width:20,height:300)
            viewLine = WinLineUIView(frame: rect)
            viewLine.center = chessBoardCenter[4]
        }
        else if WinningType == 6
        {
            rect = CGRect(x:0,y:0,width:20,height:300)
            viewLine = WinLineUIView(frame: rect)
            viewLine.center = chessBoardCenter[5]
        }
        else if WinningType == 7
        {
            rect = CGRect(x:0,y:0 ,width:420,height:20)
            viewLine = WinLineUIView(frame: rect)
            viewLine.center = chessBoardCenter[4]
            let xform = CGAffineTransformMakeRotation(CGFloat(M_PI/4.0));
            viewLine.transform = xform
        }
        else if WinningType == 8
        {
            rect = CGRect(x:0,y:0 ,width:420,height:20)
            viewLine = WinLineUIView(frame: rect)
            viewLine.center = chessBoardCenter[4]
            let xform = CGAffineTransformMakeRotation(CGFloat(3*M_PI/4.0));
            viewLine.transform = xform
        }
        return viewLine
    }
    
    //Check if game is over
    func isOver(index:Int)->Bool{
        let x = index / 3
        let y = index % 3
        
        //if the winning type is "---"
        if chessBoard[x][0]*chessBoard[x][1]*chessBoard[x][2] != 0 && chessBoard[x][0]==chessBoard[x][1] && chessBoard[x][1] == chessBoard[x][2]
        {
            WinningType = x + 1
            GameOver = true
            return true
        }
            
        //if the winning type is " | "
        else if chessBoard[0][y]*chessBoard[1][y]*chessBoard[2][y] != 0 && chessBoard[0][y]==chessBoard[1][y] && chessBoard[1][y] == chessBoard[2][y]
        {

            WinningType = y + 4
            GameOver = true
            return true
        }
            
        //if the winning type is "\"
        else if chessBoard[0][0]*chessBoard[1][1]*chessBoard[2][2] != 0 && chessBoard[0][0]==chessBoard[1][1] && chessBoard[1][1] == chessBoard[2][2]
        {
            WinningType = 7
            GameOver = true
            return true
        }
        // if the winning type is "/"
        else if chessBoard[0][2]*chessBoard[1][1]*chessBoard[2][0] != 0 && chessBoard[0][2]==chessBoard[1][1] && chessBoard[1][1] == chessBoard[2][0]
        {
            
            WinningType = 8
            GameOver = true
            return true
        }
        else
        {
            return false
        }
    }
    
    //what to do if game is over
    func cheer(winner:Int)
    {
        var Winmessage:String
        if winner == 1  //player 1 wins
        {
            // celebrate sound
            Sound[3]?.play()
            Winmessage = "X Wins!"
        }
        else if winner == 2 //player 2 wins
        {
            // celebrate sound
            Sound[3]?.play()
            Winmessage = "O Wins!"
        }
        else    //Tie, will not play music
        {
            Winmessage = "Tie!"
        }
        
        let viewLine = CreatLine()
        
        //Not Tie, draw a line
        if winner != 3
        {
            self.view.addSubview(viewLine)
        }
        
        let alert = UIAlertController(title: "Game Over",message:Winmessage, preferredStyle:UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.Default, handler: {
            action in
            //animation - fly out
            UIView.animateWithDuration(0.7, delay: 0.0, options: .CurveEaseOut, animations: {
                    for XO in self.chessImage
                    {
                        XO.center.x = 1000
                    }
                    viewLine.center.x = 1000
                }, completion: {finish in
                    //and then clean the chessboard
                    self.cleanBoard()
                    viewLine.removeFromSuperview()
                   
            })
            }))
        self.presentViewController(alert,animated:true,completion:nil)
        
    }
    
    
    //Mark: Action
    @IBAction func handlePanGesture(sender: UIPanGestureRecognizer)
    {
        if sender.state == UIGestureRecognizerState.Began   //drag start
        {
            //Play drag sound
            Sound[0]?.play()
        }
        //set to new place
        let translation = sender.translationInView(self.view)
        if let view = sender.view{
            view.center = CGPoint(x:view.center.x + translation.x,y:view.center.y+translation.y)
        }
        sender.setTranslation(CGPointZero, inView: self.view)
        
        if sender.state == UIGestureRecognizerState.Ended   //drag end
        {
            setAstep(view)
        }
    }
    
    //show instruction view
    @IBAction func ShowInstruction(sender: UIButton) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
            self.InstructionView.center.y = 333
            }, completion: nil)
        
    }
    
    //Hide instruction view
    @IBAction func HideInstruction(sender: UIButton) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
            self.InstructionView.center.y = 1000
            }, completion: {finish in
            self.InstructionView.center.y = -334
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

