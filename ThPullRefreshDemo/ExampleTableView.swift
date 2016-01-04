//
//  ExampleTableView.swift
//  PullRefresh
//
//  Created by tanhui on 15/12/28.
//  Copyright © 2015年 tanhui. All rights reserved.
//

import Foundation
import UIKit



class ExampleTableView: UITableViewController {
    lazy var dataArr : NSMutableArray = {
       return NSMutableArray()
    }()
    
    //public 
    func beginRefresh(){
        self.tableView.headBeginRefresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.backgroundColor=UIColor.redColor()
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "tableViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.tableFooterView = UIView()
        self.tableView.addHeadRefresh(self) { () -> () in
            self.loadNewData()
        }
        self.tableView.head?.hideTimeLabel=true
//        self.tableView.addHeadRefresh(self, action: "loadNewData")
        self.tableView.addFootRefresh(self, action: "loadMoreData")
    }
    
    func loadNewData(){
        
        for (var i = 0 ;i<5;i++){
            let str = "下拉刷新5个cell，第\(i+1)个"
            dataArr.addObject(str)
        }
        //延时模拟刷新
        DeLayTime(2.0, closure: { () -> () in
            self.tableView.reloadData()
            self.tableView .stopHeadRefreshing()
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
            self.tableView .stopFootRefreshing()
        })
        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("segue1", sender: nil)
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView .dequeueReusableCellWithIdentifier("tableViewCell", forIndexPath: indexPath)
        cell.textLabel?.text=self.dataArr[indexPath.row] as? String
        return cell
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
}