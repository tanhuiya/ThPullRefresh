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
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitleforState(ThHeadRefreshTextRefreshing, state: .Refreshing )
        self.setTitleforState(ThHeadRefreshTextIdle, state: .Idle)
        self.setTitleforState(ThHeadRefreshTextPulling, state: .Pulling)
        self.setValue(ThHeadRefreshTimeKey, forKey: "dataKey")
        self.setStates(.Idle, oldState: .None)
    }
    
    //private method
    func setStates (newState:ThHeadRefreshState , oldState:ThHeadRefreshState){
        if newState==oldState{
            return
        }
        self.stateLabel.text = self.stateDict[state.rawValue]
        switch(newState){
            
        case .Idle:
            if(oldState == .Refreshing){
                UIView.animateWithDuration(ThHeadRefreshAnimation, animations: {
                    self.scrollView?.th_insetT -= self.height

                    }, completion: nil)
                self.timeDate = NSDate()
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
    func setTitleforState(title :String, state : ThHeadRefreshState){
        if title.isEmpty{
            return
        }
        self.stateDict[state.rawValue]=title
        self.stateLabel.text = self.stateDict[state.rawValue]
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
        if(self.hideRefreshTextLabel && !self.hideTimeLabel){
            self.DataLabel.frame = self.bounds
        }else if(!self.hideRefreshTextLabel && self.hideTimeLabel){
            self.stateLabel.frame = self.bounds
        }else if(!self.hideRefreshTextLabel && !self.hideTimeLabel){
            self.stateLabel.frame = CGRect.init(x: 0, y: 0, width: self.width, height: self.height*0.55)
            self.DataLabel.frame = CGRect.init(x: 0, y: stateLabel.bottom, width: self.width, height: self.height-stateLabel.height)
        }
    }
    lazy var stateDict : Dictionary<Int,String> = {
        let staDic = Dictionary<Int , String>()
        return staDic
    }()
    lazy var DataLabel : UILabel = {
        let data = UILabel ()
        self.addSubview(data)
        data.textAlignment = .Center
        data.font = UIFont.systemFontOfSize(13)
        data.textColor = UIColor(red: 45/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1.0)
        return data
    }()
    lazy var stateLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(15)
        label.textAlignment = .Center
        label.textColor = UIColor(red: 45/255.0, green: 45/255.0, blue: 45/255.0, alpha: 1.0)
        self.addSubview(label)
        return label
    }()
    
    var timeDate : NSDate? {
        didSet{
            if (timeDate == nil){
                self.DataLabel.text = "最后更新：无记录"
                return
            }
            NSUserDefaults.standardUserDefaults().setObject(timeDate, forKey: ThHeadRefreshTimeKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            let calendar = NSCalendar.currentCalendar()
            let unitFlags : NSCalendarUnit = [.Year,.Month,.Day,.Hour,.Minute]
            //创建当前和需要计算的components
            let cmp = calendar.components(unitFlags, fromDate: timeDate!)
            let cmpNow = calendar.components(unitFlags, fromDate: NSDate())
            
            let format = NSDateFormatter()
            if cmp.day==cmp.day{
                format.dateFormat = "今天 HH:mm"
            }else if cmp.year==cmpNow.year{
                format.dateFormat = "MM-dd HH:mm"
            }else {
                format.dateFormat = "yyyy-MM-dd HH:mm"
            }
            let string = format.stringFromDate(timeDate!)
            self.DataLabel.text = string
        }
    }
    
    var state : ThHeadRefreshState = .Idle
        {
        didSet {
            self.setStates(state, oldState: oldValue)
        }
    }
    
    var dataKey : String = ThHeadRefreshTimeKey {
        didSet{
            self.timeDate = NSUserDefaults.standardUserDefaults().objectForKey(dataKey) as? NSDate
        }
    }
    var oringalheight : CGFloat?
    var hideTimeLabel : Bool = false
    var hideRefreshTextLabel : Bool = false
}