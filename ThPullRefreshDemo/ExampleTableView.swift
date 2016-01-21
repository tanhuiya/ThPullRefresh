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
    var index = 0
//MARK:Methods
    func beginRefresh(){
        self.tableView.headBeginRefresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "tableViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.tableFooterView = UIView()
        self.tableView.addHeadRefresh(self) { () -> () in
            self.loadNewData()
        }
        self.tableView.addHeadRefresh(self, action: "loadNewData")

        self.tableView.head?.hideTimeLabel=true
//        self.tableView.addFootRefresh(self, action: "loadMoreData")
        
        self.tableView.addFootRefresh(self) { () -> () in
            self.loadMoreData()
        }
    }
    
    func loadNewData(){
        //延时模拟刷新
        self.index = 0
        DeLayTime(2.0, closure: { () -> () in
            self.dataArr.removeAllObjects()
            for (var i = 0 ;i<5;i++){
                let str = "最新5个cell，第\(self.index++)个"
                self.dataArr.addObject(str)
            }
            self.tableView.reloadData()
            self.tableView .tableHeadStopRefreshing()
        })
        
    }
    func loadMoreData(){
        //延时模拟刷新
        DeLayTime(2.0, closure: { () -> () in
            for (var i = 0 ;i<10;i++){
                let str = "上拉刷新10个cell，第\(self.index++)个"
                self.dataArr.addObject(str)
            }
            self.tableView.reloadData()
            self.tableView .tableFootStopRefreshing()
        })
        
    }
}
extension ExampleTableView{
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row%2 == 0{
            self.performSegueWithIdentifier("segue1", sender: nil)
        }else{
            self.navigationController?.pushViewController(ExampleController_two(), animated: true)
        }
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