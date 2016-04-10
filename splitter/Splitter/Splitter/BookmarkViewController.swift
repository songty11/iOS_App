//
//  BookmarkViewController.swift
//  Splitter
//
//  Created by 宋天瑜 on 16/2/21.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import UIKit

class BookmarkViewController: UITableViewController {

    let defaults = NSUserDefaults.standardUserDefaults()
    weak var delegate: DetailViewController?
    var data = [[String:String]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableViewAutomaticDimension

       if(defaults.objectForKey("favoriteurl") != nil)
       {
            data = defaults.objectForKey("favoriteurl") as![[String:String]]
            tableView.reloadData()
        }
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
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "BookmarkTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! BookmarkTableViewCell
        let datacell = data[indexPath.row]
        
        cell.BookmarktitleLabel.text =  datacell["title"]!.html2attributedString().string
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selecteddata = data[indexPath.row]
        let url = selecteddata["url"]
        delegate?.bookmarkPassedURL(url!)
        self.dismissViewControllerAnimated(true){() -> Void in
        }
        
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            data.removeAtIndex(indexPath.row)
            defaults.setObject(data, forKey: "favoriteurl")
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }



}
