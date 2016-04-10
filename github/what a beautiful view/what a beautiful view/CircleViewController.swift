//
//  CircleViewController.swift
//  what a beautiful view
//
//  Created by 宋天瑜 on 16/1/31.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import UIKit

class CircleViewController: UIViewController {
    
    //MARK: -Properties
    @IBOutlet weak var OpenIssue: UILabel!
    @IBOutlet weak var ClosedIssue: UILabel!
    @IBOutlet weak var CircleCanvas: CircleControl!
    var activityIndicator:UIActivityIndicatorView!
    var FeedBackView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load data
        setActivityIndicator()
        loadIssues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setActivityIndicator()
    {
        FeedBackView = UIView(frame: CGRectMake(self.view.frame.width/2-50,300,100,100))
        FeedBackView.center = self.view.center
        FeedBackView.backgroundColor = UIColor.blackColor()
        FeedBackView.layer.cornerRadius = 5
        self.view.addSubview(FeedBackView)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:
            UIActivityIndicatorViewStyle.White)
        activityIndicator.hidesWhenStopped = false
        activityIndicator.center=FeedBackView.center
        self.view.addSubview(activityIndicator)
    }
    func startActivityIndicator()
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        UIView.animateWithDuration(0.6){() -> Void in
            self.FeedBackView.alpha = 0.5
            self.activityIndicator.alpha = 1.0
        }
        self.activityIndicator.startAnimating()
    }
    func removeActivityIndicator()
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        UIView.animateWithDuration(0.6){() -> Void in
            self.FeedBackView.alpha = 0.0
            self.activityIndicator.alpha = 0.0
        }
        self.activityIndicator.stopAnimating()
        
    }
    // MARK: - view data source
    func loadIssues()
    {
        startActivityIndicator()
        GitHubNetworkingManager.sharedInstance.grabSomeData("https://api.github.com/repos/uchicago-mobi/2016-Winter-Forum/issues?state=all&per_page=100") { (response) -> Void in
            // Test that the `response` is not `nil` and unwrap it to the variable
            // response.  IF it is `nil` then return the function so that we do not
            // reload the table unnecessarily.
            guard let response = response else
            {
                let alert = UIAlertController(title: "Opps!",message:"There is something wrong with github server, try again later.", preferredStyle:UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert,animated:true,completion:nil)
                return
            }
            
            // Set the repsonse data to the view controller's `issues` property
            let issues = response
            
            // Call our method that will prompt the table to reload itself with the
            // updated data
        
            var openNumber = 0.0
            var closeNumber = 0.0
            for issueDetail in issues
            {
                if let status = issueDetail["state"]as? String
                {
                    if status=="open"
                    {
                        openNumber++
                    }
                    else
                    {
                        closeNumber++
                    }
                }
            }
        
        
            //send data to circlecontrol to draw circles
            dispatch_async(dispatch_get_main_queue())
            {
                var maxRad = 0.0
                if openNumber>closeNumber
                {
                    maxRad = openNumber
                }
                else
                {
                    maxRad = closeNumber
                }
                    
                self.CircleCanvas.openRad = Double(openNumber/maxRad)
                self.CircleCanvas.closeRad = Double(closeNumber/maxRad)
                self.OpenIssue.text = "\(Int(openNumber)) Open"
                self.ClosedIssue.text = "\(Int(closeNumber)) Closed"
                self.CircleCanvas.setNeedsDisplay();
                self.removeActivityIndicator()
            }
        
        }
    }
}



