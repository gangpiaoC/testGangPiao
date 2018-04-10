//
//  GPWProjectViewController.swift
//  GangPiaoWang
//
//  Created by GC on 16/11/25.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON

class GPWProjectTypeController: GPWBaseViewController, GPWTableViewDelegate {
    fileprivate var tableView: GPWTableView!
    fileprivate var page = 1
    fileprivate var dataArray = [JSON]()
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        page = 1
        requestNetData()
    }
    
    private func commonInit() {
        self.tableView = GPWTableView(frame: self.bgView.bounds, delegate: self)
        self.tableView.register(GPWProjectCell.self, forCellReuseIdentifier: "cell")
        self.bgView.addSubview(self.tableView)
        
        tableView.setUpHeaderRefresh { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.page = 1
            strongSelf.requestNetData()
        }
        
        tableView.setUpFooterRefresh { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.requestNetData()
        }
    }
    
    private func requestNetData() {
        GPWNetwork.requetWithGet(url: Financing_list, parameters: ["page": page], responseJSON:  {
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

            strongSelf.tableView.reloadData()
            strongSelf.tableView.endHeaderRefreshing()
            }, failure: { [weak self] error in
                guard let strongSelf = self else { return }
                strongSelf.tableView.endHeaderRefreshing()
                strongSelf.tableView.endFooterRefreshing()
        })
    }
}
extension GPWProjectTypeController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GPWProjectCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GPWProjectCell
        cell.setupCell(dict: dataArray[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        printLog(message: "cell-->>index: \(indexPath.row)")
        let projectID = dataArray[indexPath.row]["auto_id"]
        printLog(message: projectID)
        let vc = GPWProjectDetailViewController(projectID: "\(projectID)")
        vc.title = dataArray[indexPath.row]["title"].string
        self.navigationController?.show(vc, sender: nil)
    }
}
