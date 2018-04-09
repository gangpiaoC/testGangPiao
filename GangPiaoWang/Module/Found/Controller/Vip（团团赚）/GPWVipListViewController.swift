//
//  GPWVipListViewController.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/9/1.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWVipListViewController: GPWSecBaseViewController, GPWTableViewDelegate {
    fileprivate var tableView: GPWTableView!
    fileprivate var page = 1
    fileprivate var dataArray = [JSON]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "团团赚项目"
        commonInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        page = 1
        getNetData()
    }
    
    private func commonInit() {
        self.tableView = GPWTableView(frame: self.bgView.bounds, delegate: self)
        self.tableView.register(GPWFVListCell.self, forCellReuseIdentifier: "GPWFVListCell")
        self.tableView.register(GPWListTopCell.self, forCellReuseIdentifier: "GPWListTopCell")
        self.bgView.addSubview(self.tableView)
        
        tableView.setUpHeaderRefresh { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.page = 1
            strongSelf.getNetData()
        }
        
        tableView.setUpFooterRefresh { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.getNetData()
        }
    }
    
    override func getNetData() {
        GPWNetwork.requetWithGet(url: TTZ_list, parameters: ["page": page], responseJSON:  {
            [weak self] (json, msg) in
            guard let strongSelf = self else { return }
            guard let info = json["info"].array else {
                return
            }
            
            if strongSelf.page == 1 {
                strongSelf.dataArray.removeAll()
            }
            
            strongSelf.tableView.footerRefresh.isHidden = false
            if info.count > 0 {
                strongSelf.page += 1
                strongSelf.dataArray += info
                strongSelf.tableView.endFooterRefreshing()
            } else {
                strongSelf.tableView.endFooterRefreshingWithNoMoreData()
            }
            
            strongSelf.tableView.endHeaderRefreshing()
            strongSelf.tableView.reloadData()
            }, failure: { [weak self] error in
                guard let strongSelf = self else { return }
                strongSelf.tableView.endHeaderRefreshing()
                strongSelf.tableView.endFooterRefreshing()
        })
    }
}


extension GPWVipListViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: GPWFVListCell = tableView.dequeueReusableCell(withIdentifier: "GPWFVListCell", for: indexPath) as! GPWFVListCell
        cell.setupCell(dict: dataArray[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let projectID = self.dataArray[indexPath.row]["auto_id"]
        let vc = GPWVipPDetailViewController(projectID: "\(String(describing: projectID))")
        vc.title =  self.dataArray[indexPath.row]["title"].stringValue
        self.navigationController?.show(vc, sender: nil)
    }
}
