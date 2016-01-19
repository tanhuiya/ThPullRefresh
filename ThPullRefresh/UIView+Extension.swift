//
//  UIView+Extension.swift
//  PullRefresh
//
//  Created by tanhui on 15/12/27.
//  Copyright © 2015年 tanhui. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    var centerY : CGFloat {
        get{
            return self.center.y
        }
        set{
            self.center = CGPointMake(self.center.x, newValue)
        }
    }
    var centerX : CGFloat {
        get{
            return self.center.x
        }
        set{
            self.center = CGPointMake(newValue, self.center.y)
        }
    }
    var bottom : CGFloat {
        get {
            return self.y+self.height
        }
    }
    var right : CGFloat{
        get {
            return self.x+self.width
        }
    }
    var x : CGFloat {
        get{
            return self.frame.origin.x
        }
        set{
            self.frame = CGRectMake(newValue, self.frame.origin.y, self.frame.size.width, self.frame.size.height)
        }
    }
    
    var y : CGFloat {
        get{
            return self.frame.origin.y
        }
        set{
            self.frame = CGRectMake(self.frame.origin.x, newValue, self.frame.size.width, self.frame.size.height)
        }
    }
    
    var width : CGFloat {
        get{
            return self.frame.size.width
        }
        set{
            self.frame = CGRectMake(self.frame.origin.x,
                self.frame.origin.y, newValue, self.frame.size.height)
        }
    }
    var height : CGFloat {
        get{
            return self.frame.size.height
        }
        set{
            self.frame = CGRectMake(self.frame.origin.x,
                self.frame.origin.y, self.frame.size.width, newValue)
        }
    }
    var size : CGSize {
        get {
            return self.frame.size
        }
        set{
            self.frame = CGRectMake(self.frame.origin.x,
                self.frame.origin.y, newValue.width, newValue.height)
        }
    }
}