//
//  ExampleController_two.swift
//  PullRefreshDemo
//
//  Created by ci123 on 16/1/19.
//  Copyright © 2016年 tanhui. All rights reserved.
//

import UIKit

class ExampleController_two: UIViewController {
    let tableView : UITableView = UITableView()
    lazy var dataArr : NSMutableArray = {
        return NSMutableArray()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = self.view.bounds
        self.tableView.addBounceHeadRefresh(self, action: "loadNewData")
        self.tableView.addFootRefresh(self, action: "loadMoreData")
    }
    func loadNewData(){
        dataArr.removeAllObjects()
        for (var i = 0 ;i<5;i++){
            let str = "最新5个cell，第\(i+1)个"
            dataArr.addObject(str)
        }
        //延时模拟刷新
        DeLayTime(2.0, closure: { () -> () in
            self.tableView.reloadData()
            self.tableView.tableHeadStopRefreshing()
        })
        
    }
    func loadMoreData(){
        for (var i = 0 ;i<5;i++){
            let str = "上拉刷新5个cell，第\(i+1)个"
            dataArr.addObject(str)
        }
        //延时模拟刷新
        DeLayTime(2.0, closure: { () -> () in
            self.tableView.reloadData()
            self.tableView.tableFootStopRefreshing()
        })
        
    }
}
