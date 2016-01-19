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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitleforState(ThHeadRefreshTextRefreshing, state: .Refreshing )
        self.setTitleforState(ThHeadRefreshTextIdle, state: .Idle)
        self.setTitleforState(ThHeadRefreshTextPulling, state: .Pulling)
        self.setValue(ThHeadRefreshTimeKey, forKey: "dataKey")
        self.setStates(.Idle, oldState: .None)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.arrow.center = CGPointMake(self.width*0.5-100, self.height*0.5)
        self.indicateView.center = self.arrow.center
        
        if(self.hideRefreshTextLabel && !self.hideTimeLabel){
            self.DataLabel.frame = self.bounds
        }else if(!self.hideRefreshTextLabel && self.hideTimeLabel){
            self.stateLabel.frame = self.bounds
        }else if(!self.hideRefreshTextLabel && !self.hideTimeLabel){
            self.stateLabel.frame = CGRect.init(x: 0, y: 0, width: self.width, height: self.height*0.55)
            self.DataLabel.frame = CGRect.init(x: 0, y: stateLabel.bottom, width: self.width, height: self.height-stateLabel.height)
        }
    }
    override func setStates(state: ThHeadRefreshState,oldState : ThHeadRefreshState) {
        super.setStates(state, oldState: oldState)
        if state==oldState{
            return
        }
        self.stateLabel.text = self.stateDict[state.rawValue]
        switch(state){
        case .Idle:
            self.timeDate = NSDate()
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
    func setTitleforState(title :String, state : ThHeadRefreshState){
        if title.isEmpty{
            return
        }
        self.stateDict[state.rawValue]=title
        self.stateLabel.text = self.stateDict[state.rawValue]
    }
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
    var dataKey : String = ThHeadRefreshTimeKey {
        didSet{
            self.timeDate = NSUserDefaults.standardUserDefaults().objectForKey(dataKey) as? NSDate
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

}