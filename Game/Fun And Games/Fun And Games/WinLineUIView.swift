//
//  WinLineUIView.swift
//  Fun And Games
//
//  Created by Tianyu Song on 16/2/14.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import UIKit

class WinLineUIView: UIView {
    
    // - Attribution: http://www.hangge.com/blog/cache/detail_938.html
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func drawRect(rect: CGRect) {
        UIColor(red:55.0/255.0,green:172.0/255.0,blue:203.0/255.0,alpha:1.0).setFill()
        let pathRect = CGRectInset(self.bounds, 1, 1)
        let path = UIBezierPath(roundedRect: pathRect, cornerRadius: 10)
        path.fill()

    }


}
