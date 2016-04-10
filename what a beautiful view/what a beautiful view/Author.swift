//
//  Author.swift
//  what a beautiful view
//
//  Created by 宋天瑜 on 16/1/31.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import UIKit

class Author{
    
    //MARK: Properties
    var name:String
    var numberofposts:Int
    var rank:Int
    
    init(name:String,numberofposts:Int,rank:Int)
    {
        self.name = name
        self.numberofposts = numberofposts
        self.rank = rank
    }
}
