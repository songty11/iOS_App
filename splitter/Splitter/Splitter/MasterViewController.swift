//
//  MasterViewController.swift
//  Splitter
//
//  Created by 宋天瑜 on 16/2/20.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
        {
        willSet{
            dispatch_async(dispatch_get_main_queue())
            {
                self.data.removeAll()
                let formatter = NSDateFormatter()
                formatter.dateFormat = "EEE',' dd MMM yyyy HH:mm:ss xx"
                for dataDetail in newValue
                {
                    let title = dataDetail["title"] as! String
                    let date = dataDetail["publishedDate"] as! String
                    let content = dataDetail["content"]as!String
                    let url = dataDetail["unescapedUrl"]as!String
                    self.data.append(WebData(title:title,date:formatter.dateFromString(date)!,content:content,url:url)!)
                }
                self.tableView.reloadData()
                self.refreshControl!.endRefreshing()
            }
            
        }
        didSet{

        }
    }
    let searchController = UISearchController(searchResultsController: nil)
    var searchquery:String?
    var urlquery:String?
    var data = [WebData]()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //- Attribution: https://www.natashatherobot.com/ios-8-self-sizing-table-view-cells-with-dynamic-type/
        tableView.estimatedRowHeight = 89
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        self.refreshControl?.addTarget(self, action: "refreshTable:", forControlEvents: UIControlEvents.ValueChanged)
        let searchquery = defaults.objectForKey("DefaultLaunch") as!String
        urlquery = "https://ajax.googleapis.com/ajax/services/search/news?v=1.1&rsz=large&q=" + searchquery
        
        LoadData()

        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    func LoadData() {
        // set footer to indicate the time
        
        //read data
            SharedNetworking.sharedInstance.grabSomeData(urlquery!) { (response) -> Void in
            
            // Test that the `response` is not `nil` and unwrap it to the variable
            // response.  IF it is `nil` then return the function so that we do not
            // reload the table unnecessarily.
            guard let response = response else {
                //Notify Users if network is Unavailable
                SharedNetworking.sharedInstance.noNetwork()
                return
            }
            
            // Set the repsonse data to the view controller's `issues` property
            dispatch_async(dispatch_get_main_queue())
            {
              
                if let responsedata = response["responseData"] as?[String:AnyObject]
                {
                    if let result = responsedata["results"] as?[[String:AnyObject]]
                    {
                        self.objects = result
                    }
                }
            }
            
        }
    }
    func refreshTable(refreshControl: UIRefreshControl) {
        //reload and save data
        LoadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = data[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MasterTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MasterTableViewCell
        let datacell = data[indexPath.row]
        
        
        let formatter = NSDateFormatter()
        formatter.timeStyle = .MediumStyle
        
         let datestring = formatter.stringFromDate(datacell.date)
       
        cell.TitleLabel.text =  datacell.title.html2attributedString().string
        cell.SubtitleLabel.text = (datestring + " | " + datacell.content).html2attributedString().string


        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    


}
extension MasterViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchquery = searchController.searchBar.text!
        if searchquery != ""
        {
            searchquery = searchquery!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
            urlquery = "https://ajax.googleapis.com/ajax/services/search/news?v=1.1&rsz=large&q=" + searchquery!
            defaults.setObject(searchquery, forKey: "DefaultLaunch")

            LoadData()
        }
    }
}
extension String {
    func html2attributedString() -> NSAttributedString {
        let attributedString = try! NSAttributedString(
            data: self.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        return attributedString
    }
}
