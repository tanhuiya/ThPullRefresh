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

    public func addBounceHeadRefresh(target:AnyObject?,action : Selector){
        if((self.head) != nil){
            self.head?.removeFromSuperview()
            self.head = nil
        }
        let head = ThHeadBounceRefreshView()
        self.head = head
        self.addSubview(head)
        head.refreshTarget = target
        head.refreshAction = action
    }
    public func addBounceHeadRefresh(target : AnyObject? ,closure : ()->()){
        if((self.head) != nil){
            self.head?.removeFromSuperview()
            self.head = nil
        }
        let head = ThHeadBounceRefreshView()
        self.head = head
        self.addSubview(head)
        head.refreshTarget = target
        head.refreshClosure = closure
    }

    public func addHeadRefresh(target : AnyObject?,action : Selector){
        if(self.head != nil){
            self.head?.removeFromSuperview()
            self.head = nil;
        }
        let head = ThHeadArrowRefreshView()
        self.head = head
        self.addSubview(head)
        head.refreshTarget = target
        head.refreshAction = action
    }

    public func addHeadRefresh(target : AnyObject? ,closure : ()->()){
        if(self.head != nil){
            self.head?.removeFromSuperview()
            self.head = nil;
        }
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
    //foot


    public func addFootRefresh(target : AnyObject?,action : Selector){
        if(self.foot != nil){
            self.foot?.removeFromSuperview()
            self.foot = nil;
        }
        let foot = ThFootRefreshView()
        self.foot = foot
        self.addSubview(foot)
        foot.refreshTarget = target
        foot.refreshAction = action
    }

    public func addFootRefresh(target : AnyObject? ,closure : ()->()){
        if(self.foot != nil){
            self.foot?.removeFromSuperview()
            self.foot = nil;
        }

        let foot = ThFootRefreshView()
        self.foot = foot
        self.addSubview(foot)
        foot.refreshTarget = target
        foot.refreshClosure = closure
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
}