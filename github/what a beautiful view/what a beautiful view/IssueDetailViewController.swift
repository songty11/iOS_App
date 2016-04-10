//
//  IssueDetailViewController.swift
//  what a beautiful view
//
//  Created by 宋天瑜 on 16/1/30.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import UIKit
import SafariServices

class IssueDetailViewController: UIViewController,SFSafariViewControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var DetailTitle: UILabel!
    @IBOutlet weak var DetailAuthor: UILabel!
    @IBOutlet weak var DetailDate: UILabel!
    @IBOutlet weak var DetailStatus: UILabel!
    @IBOutlet weak var AuthorTitle: UILabel!
    @IBOutlet weak var DateTitle: UILabel!
    @IBOutlet weak var StatusTitle: UILabel!
    let defaults = NSUserDefaults.standardUserDefaults()

    var selectedissue:Issue?

    override func viewDidLoad() {
        super.viewDidLoad()
        LoadData()
    
        }

    func LoadData()
    {
        if let issues = selectedissue
        {
                DetailTitle.text = issues.title
                DetailAuthor.text = issues.user
                DetailStatus.text = issues.status
                let index = issues.date.description.startIndex.advancedBy(20)
                DetailDate.text = issues.date.description.substringToIndex(index)
        }
        
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController)
    {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Action
    
    /// - Attributions: http://code.tutsplus.com/tutorials/ios-9-getting-started-with-sfsafariviewcontroller--cms-24260
    //Open url
    @IBAction func OpenSafari(sender: UIBarButtonItem) {
        let svc = SFSafariViewController(URL: NSURL(string:selectedissue?.detail["html_url"]as!String)!, entersReaderIfAvailable: true)
        svc.delegate = self
        self.presentViewController(svc, animated: true, completion: nil)
    }

    @IBAction func NightModeSwitch(sender: UISwitch) {
        if sender.on{
            defaults.setBool(true, forKey: "NightMode")
            self.view.backgroundColor = UIColor(red:30.0/255.0,green:32.0/255.0,blue:40.0/255.0,alpha:1.0)
            DetailTitle.textColor = UIColor(red:218.0/255.0,green:218.0/255.0,blue:218.0/255.0,alpha:1.0)
            DetailAuthor.textColor = UIColor(red:218.0/255.0,green:218.0/255.0,blue:218.0/255.0,alpha:1.0)
            DetailStatus.textColor = UIColor(red:218.0/255.0,green:218.0/255.0,blue:218.0/255.0,alpha:1.0)
            DetailDate.textColor = UIColor(red:218.0/255.0,green:218.0/255.0,blue:218.0/255.0,alpha:1.0)
            AuthorTitle.textColor = UIColor(red:218.0/255.0,green:218.0/255.0,blue:218.0/255.0,alpha:1.0)
            DateTitle.textColor = UIColor(red:218.0/255.0,green:218.0/255.0,blue:218.0/255.0,alpha:1.0)
            StatusTitle.textColor = UIColor(red:218.0/255.0,green:218.0/255.0,blue:218.0/255.0,alpha:1.0)
            
            
        }
        else
        {
            defaults.setBool(false, forKey: "NightMode")
            self.view.backgroundColor = UIColor.whiteColor()
            DetailTitle.textColor = UIColor.blackColor()
            DetailAuthor.textColor = UIColor.blackColor()
            DetailStatus.textColor = UIColor.blackColor()
            DetailDate.textColor = UIColor.blackColor()
            AuthorTitle.textColor = UIColor.blackColor()
            DateTitle.textColor = UIColor.blackColor()
            StatusTitle.textColor = UIColor.blackColor()
            
        }
    }
 

}
