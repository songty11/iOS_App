//
//  IssueTableViewController.swift
//  what a beautiful view
//
//  Created by 宋天瑜 on 16/1/30.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import UIKit

class AllIssueTableViewController: DataTableViewController{
    
    //
    // MARK: - Properties
    //
    
    /// The array of dictionaries that will hold all of our issues
    
    
    //
    // MARK: - Lifecycle
    //
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: "refreshTable:", forControlEvents: UIControlEvents.ValueChanged)
        // Make a request for all data from GitHub
        url = "https://api.github.com/repos/uchicago-mobi/2016-Winter-Forum/issues?state=all"
        self.loadIssues()
    }
    
    //
    // MARK: - Data Retrieval and Processing
    //

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    //MARK: Load date
   
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "AllIssueTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! AllIssueTableViewCell
        let issue = newissues[indexPath.row]
        
        
        cell.AllIssueLabel.text = issue.title
        cell.AllIssueUserLabel.text = issue.user
        let index = issue.date.description.startIndex.advancedBy(20)
        cell.AllIssueDateLabel.text = issue.date.description.substringToIndex(index)
        let photoopen = UIImage(named: "Checked")!
        let photoclose = UIImage(named: "Uncheck")!

        if issue.status == "open"
        {
            cell.IssueImage.image = photoopen
        }
        else
        {
            cell.IssueImage.image = photoclose
        }
        
        return cell
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowDetail" {
            let IssueDetailView = segue.destinationViewController as! IssueDetailViewController
            if let selectedIssueCell = sender as? AllIssueTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedIssueCell)!
                let selectedIssue = newissues[indexPath.row]
                IssueDetailView.selectedissue = selectedIssue
            }
        }
    }
    
}
