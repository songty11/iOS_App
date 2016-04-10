//
//  ActivityTableViewController.swift
//  what a beautiful view
//
//  Created by 宋天瑜 on 16/1/31.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import UIKit

class ActivityTableViewController: UITableViewController {

    
    //MARK: Properties
    var activityIndicator:UIActivityIndicatorView!
    var FeedBackView:UIView!
    var footerDate:String?
    var issues:[[String: AnyObject]]?
    {
        willSet
        {
                dispatch_async(dispatch_get_main_queue())
                {
                self.author.removeAll()
                for issueDetail in self.issues!
                {
                    
                    if let usrdetail = issueDetail["user"] as?[String:AnyObject]
                    {
                        //check if author exsist
                        var isExsist = false
                        for i in 0..<self.author.count{
                            if self.author[i].name == usrdetail["login"] as! String
                            {
                                self.author[i].numberofposts++
                                isExsist = true
                                break
                            }
                        }
                        if !isExsist
                        {
                            self.author.append(Author(name:usrdetail["login"] as! String,numberofposts:1,rank:0))
                        }
                    }
                }
                self.author.sortInPlace({$0.numberofposts > $1.numberofposts})
                for i in 0..<self.author.count{
                    self.author[i].rank = i + 1
                }
                self.tableView.reloadData()
                self.refreshControl!.endRefreshing()
                self.removeActivityIndicator()
            }
        }
        didSet
        {
            
        }
    }
    var author = [Author]()
    
    var formattedTimestamp: String {
        get {
            let stampformatter = NSDateFormatter()
            stampformatter.dateFormat = "'Update on' LLLL dd, YYYY 'at' KK:mm aa"
            return stampformatter.stringFromDate(NSDate())
        }
        set {
            // code to execute when setting
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: "refreshTable:", forControlEvents: UIControlEvents.ValueChanged)
        setActivityIndicator()
        loadIssues()
    }
    
    func setActivityIndicator()
    {
        FeedBackView = UIView(frame: CGRectMake(self.view.frame.width/2-50,230,100,100))
        FeedBackView.backgroundColor = UIColor.blackColor()
        FeedBackView.layer.cornerRadius = 5
        tableView.addSubview(FeedBackView)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:
            UIActivityIndicatorViewStyle.White)
        activityIndicator.hidesWhenStopped = false
        activityIndicator.center=FeedBackView.center
        tableView.addSubview(activityIndicator)
    }
    func startActivityIndicator()
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        UIView.animateWithDuration(0.6){() -> Void in
            self.FeedBackView.alpha = 0.5
            self.activityIndicator.alpha = 1.0
            
        }
        self.activityIndicator.startAnimating()
        
        tableView.scrollEnabled = false
        
    }
    func removeActivityIndicator()
    {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        UIView.animateWithDuration(0.6){() -> Void in
            self.FeedBackView.alpha = 0.0
            self.activityIndicator.alpha = 0.0
        }
        self.activityIndicator.stopAnimating()
        tableView.scrollEnabled = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //    while(!isinit){}
        return author.count
    }

    func refreshTable(refreshControl: UIRefreshControl) {
        loadIssues()
        
    }
    func loadIssues() {
        
        startActivityIndicator()
        FooterSet()
        
        GitHubNetworkingManager.sharedInstance.grabSomeData("https://api.github.com/repos/uchicago-mobi/2016-Winter-Forum/issues?state=all") { (response) -> Void in
            
            // Test that the `response` is not `nil` and unwrap it to the variable
            // response.  IF it is `nil` then return the function so that we do not
            // reload the table unnecessarily.
            guard let response = response else {
                let alert = UIAlertController(title: "Opps!",message:"There is something wrong with github server, try again later.", preferredStyle:UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                self.presentViewController(alert,animated:true,completion:nil)
                return
            }
            
            // Set the repsonse data to the view controller's `issues` property
            self.issues?.removeAll()
            self.issues = response
            // Call our method that will prompt the table to reload itself with the
            // updated data
            
            //reset the author data
            
        }
    }
    
    // show the content 
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "ActivityTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ActivityTableViewCell
        let authorcell = author[indexPath.row]
        
        cell.ActivityRank.text = String(authorcell.rank)
        cell.ActivityUser.text = authorcell.name
        cell.ActivityCount.text = String(authorcell.numberofposts)
        return cell
    }
    func FooterSet()
    {
        let footerLabel = UILabel(frame:CGRectMake(0,0,350,20))
        let tableViewFooter = UIView(frame:CGRect(x:0,y:0,width:350,height:20))
        tableView.tableFooterView = tableViewFooter
        footerLabel.textAlignment = .Center
        footerLabel.textColor = UIColor.lightGrayColor()
        footerLabel.text = formattedTimestamp
        tableView.tableFooterView?.addSubview(footerLabel)
        
    }

}
