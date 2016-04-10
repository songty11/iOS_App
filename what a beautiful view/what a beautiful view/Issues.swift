//
//  Issues.swift
//  what a beautiful view
//
//  Created by 宋天瑜 on 16/1/30.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import UIKit

class Issue{
    
    //MARK: Properties
    var title:String
    var user: String
    var date: NSDate
    var status: String
    var detail:[String:AnyObject]
    
    init?(title:String,user:String,date:NSDate,status:String,detail:[String:AnyObject])
    {
        self.title = title
        self.user = user
        self.date = date
        self.status = status
        self.detail = detail
        

    }
}