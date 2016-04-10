//
//  WebData.swift
//  Splitter
//
//  Created by 宋天瑜 on 16/2/21.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import UIKit

class WebData {
    var title : String
    var date : NSDate
    var content : String
    var url : String
    
    init?(title:String,date : NSDate ,content:String, url:String)
    {
        self.url = url
        self.title = title
        self.date = date
        self.content = content
    }
}
