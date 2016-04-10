//
//  DataTableViewController.swift
//  what a beautiful view
//
//  Created by 宋天瑜 on 16/2/5.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import UIKit



/// - Attributions: https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Inheritance.html
class DataTableViewController: UITableViewController {
    
    //Properties:
    //Add a Property Observer on Your Issues Array
    var issues:[[String: AnyObject]]?
        {
        willSet{
            dispatch_async(dispatch_get_main_queue())
            {
            
            self.newissues.removeAll()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-mm-dd'T'HH:mm:ssZ"
            
            for issueDetail in newValue!{
                
                if let usrdetail = issueDetail["user"] as?[String:AnyObject]
                {
                    let title = issueDetail["title"] as! String
                    let user = usrdetail["login"] as! String
                    let date = issueDetail["created_at"]as! String
                    let status = issueDetail["state"]as! String
                    self.newissues.append(Issue(title:title,user:user,date: formatter.dateFromString(date)!,status:status,detail:issueDetail)!)
                }
            }
                self.tableView.reloadData()
                self.refreshControl!.endRefreshing()
                self.removeActivityIndicator()
            }

        }
        didSet{
            //remove all the data after use
            issues?.removeAll()

        }
    }
    var newissues = [Issue]()
    var url:String?
    
    var footerDate:String?
    
    var activityIndicator:UIActivityIndicatorView!
    var FeedBackView:UIView!
    
    var formattedTimestamp: String {
        get {
            let stampformatter = NSDateFormatter()
            stampformatter.dateFormat = "'Update on' LLLL dd, YYYY 'at' HH:mm aa"
            return stampformatter.stringFromDate(NSDate())
        }
        set {
            // code to execute when setting
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //FeedBack indicator
        setActivityIndicator()
        
    }
    
    /// - Attributions: http://www.ioscreator.com/tutorials/activity-indicator-tutorial-ios8-swift
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
        
        //fade in
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
        
        //fade out
        UIView.animateWithDuration(0.6){() -> Void in
            self.FeedBackView.alpha = 0.0
            self.activityIndicator.alpha = 0.0
        }
        self.activityIndicator.stopAnimating()
        tableView.scrollEnabled = true
        
    }
    //
    // MARK: - Data Retrieval and Processing
    //
    
    /// Make a request using GitHub API v3 for issues.  This will download the
    /// issues, test that the data is valid, unserialize the JSON into an `Array`
    /// of `Dictionary`'s and then execute the completion closure.
    ///
    /// - Parameter urlString: A `String` of the URL holding the JSON
    /// - Parameter completion: A closure to run on the converted JSON
    /// - Attributions: Assignment write-up
    ///
    func loadIssues() {
        // set footer to indicate the time
        FooterSet()
        
        // activity indicator
        startActivityIndicator()
        
        //read data
        GitHubNetworkingManager.sharedInstance.grabSomeData(url!) { (response) -> Void in
            
            // Test that the `response` is not `nil` and unwrap it to the variable
            // response.  IF it is `nil` then return the function so that we do not
            // reload the table unnecessarily.
            guard let response = response else {
                //Notify Users if GitHub is Unavailable
                    let alert = UIAlertController(title: "Opps!",message:"There is something wrong with github server, try again later.", preferredStyle:UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
                    self.presentViewController(alert,animated:true,completion:nil)
                
                return
            }
            
            // Set the repsonse data to the view controller's `issues` property
                self.issues = response
            
        }   
    }
    
    /// - Attributions: http://www.adventuresofanentrepreneur.net/creating-a-mobile-appsgames-company/headers-and-footers-in-ios-tableview
    //footer setup
    func FooterSet()
    {
        let footerLabel = UILabel(frame:CGRectMake(0,0,350,20))
        let tableViewFooter = UIView(frame:CGRect(x:0,y:0,width:350,height:20))
        tableView.tableFooterView = tableViewFooter
        tableViewFooter.backgroundColor = UIColor(red:242.0/255.0,green:242.0/255.0,blue:242.0/255.0,alpha:1.0)
        footerLabel.textAlignment = .Center
        footerLabel.textColor = UIColor.lightGrayColor()
        footerLabel.text = formattedTimestamp
        tableView.tableFooterView?.addSubview(footerLabel)
        
    }
    
    func refreshTable(refreshControl: UIRefreshControl) {
        //reload and save data
        loadIssues()
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
        return newissues.count
    }
    


}
