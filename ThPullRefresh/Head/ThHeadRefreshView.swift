//
//  ThHeadRefresh.swift
//  PullRefresh
//
//  Created by tanhui on 15/12/28.
//  Copyright © 2015年 tanhui. All rights reserved.
//

import Foundation
import UIKit

enum ThHeadRefreshState:Int{
    case None=0
    case Idle=1
    case Pulling=2
    case Refreshing=3
    case WillRefresh=4
}

class ThHeadRefreshView: ThRefreshBasicView {
    //public
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func beginRefresh(){
        if(self.window != nil){
            self.state = .Refreshing
        }else{
            self.state = .WillRefresh
            self.setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if(self.state == .WillRefresh){
            self.state = .Refreshing
        }
    }
    
    
    //private method
    func setStates (newState:ThHeadRefreshState , oldState:ThHeadRefreshState){
        if newState==oldState{
            return
        }
        switch(newState){
            
        case .Idle:
            if(oldState == .Refreshing){
                UIView.animateWithDuration(ThHeadRefreshAnimation, animations: {
                    self.scrollView?.th_insetT -= self.height
                    
                    }, completion: nil)
            }
            break
        case .Pulling:
            break
        case .Refreshing:
            if(oldState == .Pulling || oldState == .WillRefresh){
                UIView.animateWithDuration(ThHeadRefreshAnimation, animations: {
                    self.scrollView?.th_insetT=(self.scrollView?.th_insetT)!+self.oringalheight!
                    
                    }, completion: nil)
                if((self.refreshClosure) != nil){
                    self.refreshClosure!()
                }else{
                    self.refreshTarget?.performSelector(self.refreshAction!)
                }
            }
            break
        default:
            break
        }

    }
    
    func adjustStateWithContentOffset(){
//        print(self.scrollView?.contentOffset.y)

        let offset = self.scrollView?.th_offsetY
        let headExistOffset = 0-(self.scrollView?.contentInset.top)!
        let refreshPoint = headExistOffset - self.height
        if(self.scrollView?.dragging == true){
            
            if(self.state == .Idle && offset<refreshPoint){
                self.state = .Pulling
            }else if (self.state == .Pulling && offset>=refreshPoint){
                self.state = .Idle
            }
        }else if (self.state == .Pulling){
            self.state = .Refreshing

        }
        
    }
    
    func stopRefreshing(){
            UIView.animateWithDuration(ThHeadRefreshCompleteDuration) { () -> Void in
                self.state = .Idle
        }
    }
    //override
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if (keyPath==ThHeadRefreshContentOffset){
            self.adjustStateWithContentOffset()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if(newSuperview != nil){
            self.height = ThHeadRefreshHeight
            self.oringalheight = self.height
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.y = -self.height
        
    }
        
    
    
    var state : ThHeadRefreshState = .Idle
        {
        didSet {
            self.setStates(state, oldState: oldValue)
        }
    }
    
    
    var oringalheight : CGFloat?
    var hideTimeLabel : Bool = false
    var hideRefreshTextLabel : Bool = false
}