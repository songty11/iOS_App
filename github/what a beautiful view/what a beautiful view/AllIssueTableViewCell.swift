//
//  AllIssueTableViewCell.swift
//  what a beautiful view
//
//  Created by 宋天瑜 on 16/1/30.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import UIKit

class AllIssueTableViewCell: UITableViewCell {
   
        //MARK: Properties
    @IBOutlet weak var IssueImage: UIImageView!
    @IBOutlet weak var AllIssueLabel: UILabel!
    @IBOutlet weak var AllIssueUserLabel: UILabel!
    @IBOutlet weak var AllIssueDateLabel: UILabel!
    let defaults = NSUserDefaults.standardUserDefaults()
    override func awakeFromNib() {
        super.awakeFromNib()
    
    //    Night()
        // Initialization code
    }
    func Night()
    {
        if defaults.boolForKey("NightMode")
        {
            self.backgroundColor = UIColor(red:30.0/255.0,green:32.0/255.0,blue:40.0/255.0,alpha:1.0)
        }
        else
        {
            self.backgroundColor = UIColor.whiteColor()
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
