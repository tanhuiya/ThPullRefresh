//
//  ExampleController_one.swift
//  PullRefresh
//
//  Created by ci123 on 16/1/4.
//  Copyright © 2016年 tanhui. All rights reserved.
//

import Foundation
import UIKit

class ExampleController_one: UIViewController ,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var index = 0
    var dataArr = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .Plain, target: self, action: "dismiss")
        self.tableView .addHeadRefresh(self) { () -> () in
            for (var i = 0 ;i<5;i++){
                let str = "下拉刷新5个cell，第\(self.index+1)个"
                self.dataArr.addObject(str)
            }
            //延时模拟刷新
            DeLayTime(2.0, closure: { () -> () in
                self.tableView.reloadData()
                self.tableView .tableHeadStopRefreshing()
            })
            
        }
        self.tableView.headBeginRefresh()
    }
    func dismiss(){
        let vc = self.navigationController?.viewControllers.first as! ExampleTableView
        vc.beginRefresh()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
extension ExampleController_one{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "ExampleCellOne"
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(identifier)
        if (cell == nil) {
            cell = UITableViewCell(style: .Default, reuseIdentifier: identifier)
        }
        cell!.textLabel?.text = self.dataArr[indexPath.row] as? String
        cell?.contentView.backgroundColor=UIColor.yellowColor()
        return cell!
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
}