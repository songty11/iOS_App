//
//  ActivityTableViewCell.swift
//  what a beautiful view
//
//  Created by 宋天瑜 on 16/1/31.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var ActivityRank: UILabel!
    @IBOutlet weak var ActivityUser: UILabel!
    @IBOutlet weak var ActivityCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
