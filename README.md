# ThPullRefresh
swift 快速集成下拉刷新，上拉加载更多功能.
如何使用：
Cocoapods 导入：pod 'ThPullRefresh'，
		在项目中 import 'ThPullRefresh'
手动导入：将'ThPullRefresh' 文件夹中的所有文件拽入项目中

用法如下：
//添加下拉刷新
        self.tableView.addHeadRefresh(self, action: "loadNewData")
        self.tableView.addHeadRefresh(self) { () -> () in
            self.loadNewData()
        }
//停止headRefresh
        self.tableView.tableHeadStopRefreshing()
        
//添加上拉加载更多
        self.tableView.addFootRefresh(self, action: "loadMore")
        self.tableView.addFootRefresh(self) { () -> () in
            self.loadMore()
        }
//停止footRefresh
        self.tableView.tableFootStopRefreshing()
