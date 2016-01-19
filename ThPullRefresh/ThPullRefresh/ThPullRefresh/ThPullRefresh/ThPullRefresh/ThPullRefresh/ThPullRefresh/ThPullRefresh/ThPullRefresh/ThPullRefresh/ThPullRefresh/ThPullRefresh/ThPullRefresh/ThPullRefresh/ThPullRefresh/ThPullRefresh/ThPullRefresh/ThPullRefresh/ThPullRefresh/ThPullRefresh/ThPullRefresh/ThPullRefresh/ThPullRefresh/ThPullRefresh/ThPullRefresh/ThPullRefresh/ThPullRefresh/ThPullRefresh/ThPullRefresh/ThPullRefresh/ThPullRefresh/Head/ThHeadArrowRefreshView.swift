//
//  ThHeadArrowRefresh.swift
//  PullRefresh
//
//  Created by tanhui on 16/1/1.
//  Copyright © 2016年 tanhui. All rights reserved.
//

import Foundation
import UIKit

class ThHeadArrowRefreshView : ThHeadRefreshView {
    
    lazy var arrow : UIImageView = {
        let path = "ThRefresh.bundle" as NSString
        let whole = path.stringByAppendingPathComponent("arrow.png")
        let arrow = UIImageView(image: UIImage(named: whole))
        arrow.contentMode = .ScaleAspectFit
        self.addSubview(arrow)
        return arrow
    }()
    lazy var indicateView : UIActivityIndicatorView = {
        let indicateView = UIActivityIndicatorView(activityIndicatorStyle: .White )
        self.addSubview(indicateView)
        return indicateView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.arrow.center = CGPointMake(self.width*0.5-100, self.height*0.5)
        self.indicateView.center = self.arrow.center
    }
    override func setStates(state: ThHeadRefreshState,oldState : ThHeadRefreshState) {
        super.setStates(state, oldState: oldState)
        if state==oldState{
            return
        }
        switch(state){
            
        case .Idle:
                self.arrow.hidden=false
                self.indicateView.hidden = true
                self.arrow.transform=CGAffineTransformIdentity
            break
        case .Pulling:
                self.arrow.hidden=false
                self.indicateView.hidden = true
                self.arrow.transform = CGAffineTransformMakeRotation( CGFloat(-M_PI) )
            break
        case .Refreshing:
                self.arrow.hidden=true
                self.indicateView.hidden = false
                self.indicateView.startAnimating()
            break
        default:
            break
        }

    }
}