# ThPullRefresh
* swift 快速集成下拉刷新，上拉加载更多功能.<br />
如何使用：<br />
Cocoapods 导入：pod 'ThPullRefresh'，<br />
		在项目中 import 'ThPullRefresh'<br />
手动导入：将'ThPullRefresh' 文件夹中的所有文件拽入项目中<br />

##用法如下：<br />
* 添加下拉刷新<br />
        self.tableView.addHeadRefresh(self, action: "loadNewData")<br />
            self.tableView.addHeadRefresh(self) { () -> () in<br />
            self.loadNewData()<br />
        }<br />
* 添加下拉动画刷新<br />
    self.tableView.addBounceHeadRefresh(self,bgColor:UIColor.orangeColor(),loadingColor:UIColor.blueColor(), action: "loadNewData")<br />

* 停止headRefresh<br />
        self.tableView .tableHeadStopRefreshing()<br />
        <br />
* 添加上拉加载更多<br />
        self.tableView.addFootRefresh(self, action: "loadMoreData")<br />
        self.tableView.addFootRefresh(self) { () -> () in<br />
            //todo<br />
        }<br />
* 停止footRefresh<br />
        self.tableView .tableFootStopRefreshing()<br />
