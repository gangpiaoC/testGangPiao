//
//  GPWInvestRecordViewController.swift
//  GangPiaoWang
//   出借记录
//  Created by GC on 16/12/20.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON

class GPWBidRecordViewController: GPWSubPageBaseViewController, UITableViewDataSource, UITableViewDelegate {
    var projectID: String?
    var dataArray = [JSON]()
    var tableView: UITableView!
    var noDataImgView: UIImageView!
    var page = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestNetData()
        MobClick.beginLogPageView("\(self.classForCoder)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView("\(self.classForCoder)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 76
        tableView.sectionHeaderHeight = 0.001
        tableView.sectionFooterHeight = 0.001
        tableView.separatorStyle = .none
        self.tableView.register(GPWBidRecordCell.self, forCellReuseIdentifier: "bidCell")
        self.view.addSubview(tableView)
        
        noDataImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 76, height: 112))
        noDataImgView.centerX = view.centerX
        noDataImgView.centerY = view.centerY - 158
        noDataImgView.image = UIImage(named: "comm_noData")
        noDataImgView.isHidden = true
        view.addSubview(noDataImgView)
        
        tableView.setUpFooterRefresh { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.requestNetData()
        }
        // Do any additional setup after loading the view.
    }
    
    fileprivate func requestNetData() {
        GPWNetwork.requetWithGet(url: Financing_details_jct, parameters: ["auto_id": projectID!, "type": 3, "page": page], responseJSON: { [weak self] (json, msg) in
            guard let strongSelf = self else { return }
            let info = json.arrayValue
            if strongSelf.page == 1 && info.count == 0 {
                strongSelf.noDataImgView.isHidden = false
                return
            } else {
                 strongSelf.noDataImgView.isHidden = true
                 strongSelf.tableView.footerRefresh.isHidden = false
            }
            if info.count > 0 {
                strongSelf.page += 1
                strongSelf.dataArray += info
                strongSelf.tableView.endFooterRefreshing()
            } else {
                strongSelf.tableView.endFooterRefreshingWithNoMoreData()
            }
            strongSelf.tableView.reloadData()
            }, failure: { [weak self] error in
                guard let strongSelf = self else { return }
                strongSelf.tableView.endFooterRefreshing()
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GPWBidRecordCell = tableView.dequeueReusableCell(withIdentifier: "bidCell", for: indexPath) as! GPWBidRecordCell
        cell.setupCell(dataArray[indexPath.row])
        return cell
    }
}
