//
//  File.swift
//  PullRefresh
//
//  Created by tanhui on 15/12/27.
//  Copyright © 2015年 tanhui. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView{

    var th_offsetX : CGFloat {
        set {
            self.contentOffset = CGPointMake(newValue, self.contentOffset.x)
        }
        get{
            return self.contentOffset.x
        }
    }
    var th_offsetY : CGFloat {
        set {
            self.contentOffset = CGPointMake(self.contentOffset.x, newValue)
        }
        get{
            return self.contentOffset.y
        }
    }
    var th_insetL : CGFloat {
        set{
            var inset = self.contentInset
            inset.left = newValue
            self.contentInset = inset
        }
        get{
            return self.contentInset.left
        }
    }
    var th_insetT : CGFloat {
        set{
            var inset = self.contentInset
            inset.top = newValue
            self.contentInset = inset
        }
        get{
            return self.contentInset.top
        }
    }
    var th_insetR : CGFloat {
        set{
            var inset = self.contentInset
            inset.right = newValue
            self.contentInset = inset
        }
        get{
            return self.contentInset.right
        }
    }
    var th_insetB : CGFloat {
        set{
            var inset = self.contentInset
            inset.bottom = newValue
            self.contentInset = inset
        }
        get{
            return self.contentInset.bottom
        }
    }
}
