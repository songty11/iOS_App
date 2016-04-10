//
//  MasterTableViewCell.swift
//  Splitter
//
//  Created by 宋天瑜 on 16/2/20.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import UIKit

class MasterTableViewCell: UITableViewCell {

  //  @IBOutlet weak var TitleLabel: UILabel!
 //   @IBOutlet weak var SubtitleLabel: UILabel!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var SubtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
