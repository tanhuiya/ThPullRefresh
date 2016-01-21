//
//  ThFootRefreshView.swift
//  PullRefresh
//
//  Created by tanhui on 16/1/2.
//  Copyright © 2016年 tanhui. All rights reserved.
//

import Foundation
import UIKit

enum  ThFootRefreshState : Int {
    case None = 0
    case Idle = 1
    case Refreshing = 2
    case Nomore = 3
}

class ThFootRefreshView : ThRefreshBasicView {
    lazy var stateDict : Dictionary<Int,String> = {
        let staDic = Dictionary<Int , String>()
        return staDic
    }()
    lazy var refreshingLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(15)
        label.textAlignment = .Center
        label.textColor = UIColor(red: 45/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1.0)
        self.addSubview(label)
        return label
    }()
    lazy var noMoreLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(15)
        label.textAlignment = .Center
        label.textColor = UIColor(red: 45/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1.0)
        self.addSubview(label)
        return label
    }()
    lazy var idleBtn : UIButton = {
       let btn = UIButton()
        self.addSubview(btn)
        btn.titleLabel!.font = UIFont.systemFontOfSize(15)
        btn.setTitleColor(UIColor(red: 45/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1.0), forState: .Normal )
        btn.addTarget(self, action: "startRefreshing", forControlEvents: .TouchUpInside)
        return btn
    }()
    lazy var indicateView : UIActivityIndicatorView = {
        let indicateView = UIActivityIndicatorView(activityIndicatorStyle: .White )
        self.refreshingLabel.addSubview(indicateView)
            indicateView.startAnimating()
        return indicateView
    }()
    var state : ThFootRefreshState = .Idle {
        didSet{
            self.setStates(state, oldState: oldValue)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitleforState(ThFootRefreshTextIdle, state: .Idle)
        self.setTitleforState(ThFootRefreshTextRefreshing , state: .Refreshing)
        self.setTitleforState(ThFootRefreshTextNomore , state: .Nomore )
        self.setStates(state, oldState: .None)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.idleBtn.frame = self.bounds
        self.refreshingLabel.frame = self.bounds
        self.noMoreLabel.frame = self.bounds
        self.indicateView.center = CGPoint(x: self.center.x-100,y: self.center.y)
    }
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if newSuperview != nil{
            newSuperview!.addObserver(self, forKeyPath: ThRefreshPanKey, options: .New , context: nil)
            newSuperview!.addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
            self.height = ThFootRefreshHeight
            self.scrollView?.th_insetB += self.height
            self.adjustFrameOfContentSize()
        }
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if self.state == .Idle{
            if keyPath == ThRefreshPanKey{
                //不超过一个屏幕
                if ((self.scrollView?.contentSize.height)!+(self.scrollView?.th_insetT)! <= self.scrollView?.height){
                    if(self.scrollView?.th_offsetY > 0-(self.scrollView?.th_insetT)!){
                        self.startRefreshing()
                    }
                }else if((self.scrollView?.contentOffset.y)!+(self.scrollView?.height)!>(self.scrollView?.contentSize.height)!+(self.scrollView?.th_insetB)!){
                    //超过一个屏幕
                    self.startRefreshing()
                }
                
            }else if keyPath == ThHeadRefreshContentOffset{
                self.adjustStateWithContentOffset()
            }
        }
        self.adjustFrameOfContentSize()
    }
    
    
    func setTitleforState(title :String, state : ThFootRefreshState){
        if title.isEmpty{
            return
        }
        switch (title){
            case ThFootRefreshTextIdle :
                self.idleBtn .setTitle(title, forState: .Normal)
                break
            case ThFootRefreshTextRefreshing :
                self.refreshingLabel.text = title
                break
            case ThFootRefreshTextNomore :
                self.noMoreLabel.text = title
                break
            default :
                break
        }
    }
    private func adjustFrameOfContentSize(){
        self.y = (self.scrollView?.contentSize.height)!
    }
    private func adjustStateWithContentOffset(){
        if self.height<=0{
            return
        }
        if (self.scrollView?.contentSize.height)!+(self.scrollView?.th_insetT)! > self.scrollView?.height{
            //超过一个屏幕
            if((self.scrollView?.contentOffset.y)!+(self.scrollView?.height)!>(self.scrollView?.contentSize.height)!+(self.scrollView?.th_insetB)!){
                self.startRefreshing()
            }

        }
    }
    private func setStates (newState:ThFootRefreshState , oldState:ThFootRefreshState){
        if newState==oldState{
            return
        }
        switch newState {
        case .Idle :
            self.noMoreLabel.hidden = true
            self.refreshingLabel.hidden = true
            self.idleBtn.hidden = true
            UIView.animateWithDuration(ThRefreshShortDuration, animations: { () -> Void in
                self.idleBtn.hidden = false
            })
            break
        case .Nomore :
            self.noMoreLabel.hidden = true
            self.refreshingLabel.hidden = true
            self.idleBtn.hidden = true
            UIView.animateWithDuration(ThRefreshShortDuration, animations: { () -> Void in
                self.noMoreLabel.hidden = false
            })
            break
        case .Refreshing :
            self.noMoreLabel.hidden = true
            self.refreshingLabel.hidden = true
            self.idleBtn.hidden = true
            if oldState == .Idle{
                UIView.animateWithDuration(ThRefreshShortDuration, animations: { () -> Void in
                    self.refreshingLabel.hidden = false
                })
                if self.refreshClosure != nil{
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
    func startRefreshing(){
        self.state = .Refreshing
    }
    func footEndRefreshing(){
        self.state = .Idle
    }
    deinit{
        self.superview?.removeObserver(self, forKeyPath: "contentOffset" ,context: nil)
        self.superview?.removeObserver(self, forKeyPath: ThRefreshPanKey ,context: nil)
    }
}