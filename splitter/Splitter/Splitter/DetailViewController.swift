//
//  DetailViewController.swift
//  Splitter
//
//  Created by 宋天瑜 on 16/2/20.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import UIKit
import Social

class DetailViewController: UIViewController,UIWebViewDelegate, DetailBookmarkDelegate,UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var Webpage: UIWebView!

    let defaults = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var FeedBackView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var LoadingLabel: UILabel!
    @IBOutlet weak var Starimage: UIImageView!
    
    var weburl:String?
        {
        didSet
        {
            if let url = weburl, webView = self.Webpage {
                
                setActivityIndicator()
                webView.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
                
            }
        }
    }
    
    var detailItem: WebData? {
        didSet {
            
            // Update the view.
            self.configureView()
        }
    }

    func setActivityIndicator()
    {
  
        FeedBackView.backgroundColor = UIColor.blackColor()
        FeedBackView.layer.cornerRadius = 5
        FeedBackView.alpha = 0.0
        activityIndicator.alpha = 0.0
        LoadingLabel.alpha = 0.0
        Webpage.addSubview(FeedBackView)
        
    }
    func startActivityIndicator()
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        //fade in
        UIView.animateWithDuration(0.6){() -> Void in
            self.FeedBackView.alpha = 0.5
            self.activityIndicator.alpha = 1.0
            self.LoadingLabel.alpha = 1.0
            
        }
        self.activityIndicator.startAnimating()
        
        Webpage.scrollView.scrollEnabled = false
        
    }
    func removeActivityIndicator()
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        //fade out
        UIView.animateWithDuration(0.6){() -> Void in
            self.FeedBackView.alpha = 0.0
            self.activityIndicator.alpha = 0.0
            self.LoadingLabel.alpha = 0.0
        }
        self.activityIndicator.stopAnimating()
        Webpage.scrollView.scrollEnabled = true
        
    }

    func setStar()
    {
        if defaults.objectForKey("favoriteurl") != nil
        {
            let dict = defaults.objectForKey("favoriteurl") as! [[String:String]]
            var isfavor = false
            for favordict in dict
            {
                if let favorurl = favordict["url"]
                {
                    if favorurl == weburl
                    {
                        isfavor = true
                    }
                }
            }
            if isfavor
            {
                Starimage.hidden = false
            }
            else
            {
                Starimage.hidden = true
            }
        }
        else
        {
            Starimage.hidden = true
        }

    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem
        {
            
            weburl = detail.url
            Webpage?.delegate = self

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      //  Starimage.alpha = 0.0
        setStar()
    
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueToBookmarks"
        {
            let bvc = segue.destinationViewController as! BookmarkViewController
            bvc.delegate = self
            bvc.modalPresentationStyle = .Popover
            bvc.popoverPresentationController!.delegate = self
        }
        
    }
    // - Attribution: Class Forum
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func bookmarkPassedURL(urlstring: String) {

        weburl = urlstring
        setStar()
    }
    
    
    func webViewDidStartLoad(Webpage : UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        startActivityIndicator()
        
    }
    
    func webViewDidFinishLoad(Webpage : UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        removeActivityIndicator()
        FeedBackView.removeFromSuperview()
       
    }
    
    
    
    @IBAction func AddtoFavorite(sender: AnyObject) {
        if(defaults.objectForKey("favoriteurl") == nil)
        {
            var dict = [[String:String]]()
            dict.append(["title": (detailItem?.title)!, "url": (detailItem?.url)!])
            defaults.setObject(dict, forKey: "favoriteurl")
        }
        else
        {
            var dict = defaults.objectForKey("favoriteurl") as! [[String:String]]
            if dict[dict.count-1]["url"] != detailItem?.url
            {
                dict.append(["title": (detailItem?.title)!, "url": (detailItem?.url)!])
                defaults.setObject(dict, forKey: "favoriteurl")
            }
        }
     //   Starimage.alpha = 1.0
        setStar()
        //Starimage.hidden = false
        
    }
    
    @IBAction func Sharetweet(sender: AnyObject) {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        vc.addURL(NSURL(string: (detailItem?.url)!))
        presentViewController(vc, animated: true, completion: nil)
        
    }

}

protocol DetailBookmarkDelegate: class {
    func bookmarkPassedURL(url: String) -> Void
}

