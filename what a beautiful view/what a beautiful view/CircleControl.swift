//
//  CircleControl.swift
//  what a beautiful view
//
//  Created by 宋天瑜 on 16/1/31.
//  Copyright © 2016年 Tianyu Song. All rights reserved.
//

import UIKit

class CircleControl: UIView {
    
    
    //MARK: Properties:
    var openRad = 0.0
    var closeRad = 0.0
    
    
    
    /// - Attributions: https://gist.github.com/tabinks/f40f0c13dde6ac104709#file-gistfile1-swift
    override func drawRect(rect: CGRect) {
        
        //the red circle
        
        if openRad > closeRad
        {
            let context1 = UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(context1, 5.0);
            UIColor.redColor().set()
            CGContextAddArc(context1, (frame.size.width)/2, frame.size.height/2, (frame.size.width)/2-10, 0.0, CGFloat(M_PI * 2), 1)
            CGContextStrokePath(context1);
            
            let context2 = UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(context2, 5.0);
            UIColor.greenColor().set()
            CGContextAddArc(context2, (frame.size.width)/2, frame.size.height/2, (frame.size.width)/2-30, 0.0, CGFloat(M_PI * 2), 1)
            CGContextStrokePath(context2);
            
        }
        else
        {
            let context1 = UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(context1, 5.0);
            UIColor.greenColor().set()
            CGContextAddArc(context1, (frame.size.width)/2, frame.size.height/2, (frame.size.width)/2-10, 0.0, CGFloat(M_PI * 2), 1)
            CGContextStrokePath(context1);
            
            let context2 = UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(context2, 5.0);
            UIColor.redColor().set()
            CGContextAddArc(context2, (frame.size.width)/2, frame.size.height/2, (frame.size.width)/2-30, 0.0, CGFloat(M_PI * 2), 1)
            CGContextStrokePath(context2);
        }
        
        
    }
}
