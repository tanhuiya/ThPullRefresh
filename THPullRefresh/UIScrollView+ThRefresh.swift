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
    func headBeginRefresh(){
        self.head!.beginRefresh()
    }
    func addHeadRefresh(target : AnyObject?,action : Selector){
        let head = ThHeadArrowRefreshView()
        self.head = head
        self.addSubview(head)
        head.refreshTarget = target
        head.refreshAction = action
    }
    func addHeadRefresh(target : AnyObject? ,closure : ()->()){
        let head = ThHeadArrowRefreshView()
        self.head = head
        self.addSubview(head)
        head.refreshTarget = target
        head.refreshClosure = closure
    }
    var head : ThHeadArrowRefreshView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ThHeadRefreshName) as? ThHeadArrowRefreshView
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
    func stopHeadRefreshing(){
        self.head?.stopRefreshing()
    }
    //foot
    func addFootRefresh(target : AnyObject?,action : Selector){
        let foot = ThFootRefreshView()
        self.foot = foot
        self.addSubview(foot)
        foot.refreshTarget = target
        foot.refreshAction = action
    }
    func addFootRefresh(target : AnyObject? ,closure : ()->()){
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
    func stopFootRefreshing(){
        self.foot?.footEndRefreshing()
    }

}