//
//  IssueTableViewController.swift
//  what a beautiful view
//
//  Created by 宋天瑜 on 16/1/30.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import UIKit

class IssueTableViewController: DataTableViewController{

    //
    // MARK: - Properties
    //
    
    /// The array of dictionaries that will hold all of our issues
    
    //
    // MARK: - Lifecycle
    //
    
    /// - Attributions: https://www.andrewcbancroft.com/2015/03/17/basics-of-pull-to-refresh-for-swift-developers/
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: "refreshTable:", forControlEvents: UIControlEvents.ValueChanged)
        // Make a request for all open data from GitHub
        url = "https://api.github.com/repos/uchicago-mobi/2016-Winter-Forum/issues?state=open"
        self.loadIssues()
        
        
    }
//    
//    var formattedTimestamp:String{
//        get{
//            formatter.dataForma
//        }
//        set
//        {
//            
//        }
//    }
    
    //
    // MARK: - Table View Refresh
    //
    
    /// Reload the table with newly downloaded data.  This should be called when
    /// the table is first shown onscreen and when the user conducts a
    /// pull-to-refresh operation.
    ///
    /// - Note: You should be telling you table to reload here
    /// - Attributions: Lecture slides and assignment write-up
    ///
    

    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Load date
    
    // MARK: - Table view data source
    
    
    ///-Attribution: Start Developing iOS Apps (Swift)
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "IssueTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! IssueTableViewCell
        let issue = newissues[indexPath.row]
        
        
        
        cell.TitleLabel.text = issue.title
        cell.UserLabel.text = issue.user
        let index = issue.date.description.startIndex.advancedBy(20)
        cell.DateLabel.text = issue.date.description.substringToIndex(index)
        

        return cell
    }
    
    // MARK: - Navigation
    ///-Attribution: Start Developing iOS Apps (Swift)
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowDetail" {
            let IssueDetailView = segue.destinationViewController as! IssueDetailViewController
            if let selectedIssueCell = sender as? IssueTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedIssueCell)!
                let selectedIssue = newissues[indexPath.row]
                IssueDetailView.selectedissue = selectedIssue
            }
        }
    }
    override func viewWillAppear(animated: Bool) {
        loadIssues()
    }
}
