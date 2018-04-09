//
//  GPWVFschooliewController.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/8/14.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWVFschooliewController: GPWSecBaseViewController,UITableViewDelegate,UITableViewDataSource {
    var showTableView:UITableView!
    var dataArr = [JSON]()
    fileprivate var page = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "钢票学院"
        
        showTableView = UITableView(frame: self.bgView.bounds, style: .grouped)
        showTableView.backgroundColor = bgColor
        showTableView.register(GPWFschoolCell.self, forCellReuseIdentifier: "GPWFschoolCell")
        showTableView.separatorStyle = .none
        showTableView.sectionFooterHeight = 0.001
        showTableView.sectionHeaderHeight = 0.0001
        showTableView.rowHeight = UITableViewAutomaticDimension
        showTableView.estimatedRowHeight = 80.0
        showTableView.setUpHeaderRefresh {
            [weak self] in
            guard let self1 = self else {return}
            self1.page = 1
            self1.getNetData()
        }
        
        showTableView.setUpFooterRefresh { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.page = strongSelf.page + 1
            strongSelf.getNetData()
        }
        
        showTableView?.delegate = self
        showTableView?.dataSource = self
        self.bgView.addSubview(showTableView)
        self.getNetData()
    }
    
    override func getNetData() {
        GPWNetwork.requetWithGet(url: Find_ticket, parameters: ["page":"\(page)"], responseJSON:  {
            [weak self] (json, msg) in
            printLog(message: json)
            guard let info = json.array else {
                return
            }
            guard let strongSelf = self else { return }
            strongSelf.showTableView.endHeaderRefreshing()
            strongSelf.showTableView.endFooterRefreshing()
            if strongSelf.page == 1 {
                strongSelf.dataArr.removeAll()
            }
            
            strongSelf.showTableView.footerRefresh.isHidden = false
            if info.count > 0 {
                strongSelf.dataArr += info
            } else {
                strongSelf.showTableView.endFooterRefreshingWithNoMoreData()
            }
            strongSelf.showTableView.reloadData()
            }, failure: { [weak self] error in
                guard let strongSelf = self else { return }
                strongSelf.showTableView.endHeaderRefreshing()
                strongSelf.showTableView.endFooterRefreshing()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GPWFschoolCell = tableView.dequeueReusableCell(withIdentifier: "GPWFschoolCell", for: indexPath) as! GPWFschoolCell
        cell.updata(dic: self.dataArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  vc = GPWWebViewController(subtitle: self.dataArr[indexPath.row]["name"].stringValue, url: self.dataArr[indexPath.row]["h5link"].stringValue)
        vc.messageFlag = "1"
        self.navigationController?.pushViewController( vc, animated: true)
    }
}
