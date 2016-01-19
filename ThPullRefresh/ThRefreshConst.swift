//
//  ThRefreshConst.swift
//  PullRefresh
//
//  Created by tanhui on 15/12/28.
//  Copyright © 2015年 tanhui. All rights reserved.
//

import Foundation
import UIKit

let ThHeadRefreshingCircleRadius : CGFloat = 12.0


let ThHeadRefreshTimeKey = "HeadTimeKey"
let ThHeadRefreshHeight : CGFloat = 54.0
let ThHeadRefreshContentOffset = "contentOffset";
let ThHeadRefreshAnimation = 0.4
let ThHeadRefreshCompleteDuration = 0.1
var ThHeadRefreshTextIdle = "下拉刷新"
var ThHeadRefreshTextRefreshing="正在刷新..."
var ThHeadRefreshTextPulling="松开立即刷新"
let ThRefreshShortDuration = 0.05

var ThFootRefreshHeight : CGFloat = 54.0
let ThFootRefreshTextIdle = "点击加载更多"
let ThFootRefreshTextNomore = "没有更多数据"
let ThFootRefreshTextRefreshing = "正在加载..."

let ThRefreshPanKey = "panGestureRecognizer.state"
//var ThFootRefreshTextIdle = "上拉加载更多"
//var ThFootRefreshTextRefreshing = "正在刷新"
func  DeLayTime(x:Double,closure:()->()){
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(x * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure) }