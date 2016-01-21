//
//  UIScrollView+ThRefresh.swift
//  PullRefresh
//
//  Created by tanhui on 15/12/29.
//  Copyright © 2015年 tanhui. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView{
    private struct AssociatedKeys {
        static var ThHeadRefreshName = "ThHeadRefreshName"
        static var ThFootRefreshName = "ThFootRefreshName"

    }
    public func headBeginRefresh(){
        self.head!.beginRefresh()
    }
    /*
    *bgColor 背景颜色
    *loadingColor 加载的颜色
    */
    public func addBounceHeadRefresh(target:AnyObject?,bgColor:UIColor,loadingColor:UIColor,action : Selector){
        self.removeHead()
        let head = ThHeadBounceRefreshView()
        head.bgColor = bgColor
        head.loadingColor = loadingColor
        self.head = head
        self.addSubview(head)
        head.refreshTarget = target
        head.refreshAction = action
    }
    public func addBounceHeadRefresh(target : AnyObject? ,bgColor:UIColor,loadingColor:UIColor,closure : ()->()){
        self.removeHead()
        let head = ThHeadBounceRefreshView()
        head.bgColor = bgColor
        head.loadingColor = loadingColor
        self.head = head
        self.addSubview(head)
        head.refreshTarget = target
        head.refreshClosure = closure
    }

    public func addHeadRefresh(target : AnyObject?,action : Selector){
        self.removeHead()
        let head = ThHeadArrowRefreshView()
        self.head = head
        self.addSubview(head)
        head.refreshTarget = target
        head.refreshAction = action
    }

    public func addHeadRefresh(target : AnyObject? ,closure : ()->()){
        self.removeHead()
        let head = ThHeadArrowRefreshView()
        self.head = head
        self.addSubview(head)
        head.refreshTarget = target
        head.refreshClosure = closure
    }
    var head : ThHeadRefreshView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ThHeadRefreshName) as? ThHeadRefreshView
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.ThHeadRefreshName,
                    newValue ,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    public func tableHeadStopRefreshing(){
        self.head?.stopRefreshing()
    }
    
    //MARK: foot

    public func addFootRefresh(target : AnyObject?,action : Selector){
        self.removeFoot()
        let foot = ThFootRefreshView()
        self.foot = foot
        self.addSubview(foot)
        foot.refreshTarget = target
        foot.refreshAction = action
    }

    public func addFootRefresh(target : AnyObject? ,closure : ()->()){
        self.removeFoot()
        let foot = ThFootRefreshView()
        self.addSubview(foot)
        foot.refreshTarget = target
        foot.refreshClosure = closure
        self.foot = foot
    }
    var foot : ThFootRefreshView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ThFootRefreshName) as? ThFootRefreshView
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.ThFootRefreshName,
                    newValue ,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    public func tableFootStopRefreshing(){
        self.foot?.footEndRefreshing()
    }
    public func tableFootShowNomore(){
        if(self.istableFootRefreshing()){
            self.tableFootStopRefreshing()
        }
        self.foot?.state = .Nomore
    }
    public func istableFootRefreshing()->Bool{
        return self.foot?.state == .Refreshing
    }
    
    func removeFoot(){
        self.foot = nil;
        self.foot?.removeFromSuperview()
    }
    func removeHead(){
        self.head?.removeFromSuperview()
        self.head = nil;
    }
}