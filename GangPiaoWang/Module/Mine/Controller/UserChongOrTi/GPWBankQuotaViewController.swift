//
//  GPWBankQuotaViewController.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/8/13.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWBankQuotaViewController: GPWSecBaseViewController,UITableViewDelegate,UITableViewDataSource {
    var showTableView:UITableView!
    var dataArr = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "支持银行限额"
        
        showTableView = UITableView(frame: self.bgView.bounds, style: .plain)
        showTableView.backgroundColor = bgColor
        showTableView.register(GPWBankQCell.self, forCellReuseIdentifier: "GPWBankQCell")
        showTableView.separatorStyle = .none
        showTableView.setUpHeaderRefresh {
            [weak self] in
            guard let self1 = self else {return}
            self1.getNetData()
        }
        
        showTableView?.delegate = self
        showTableView?.dataSource = self
        self.bgView.addSubview(showTableView)
        self.getNetData()
    }
    
    override func getNetData() {
        GPWNetwork.requetWithGet(url: Bank_limit, parameters: nil, responseJSON:  {
            [weak self] (json, msg) in
            printLog(message: json)
            guard let strongSelf = self else { return }
            strongSelf.showTableView.endHeaderRefreshing()
            strongSelf.dataArr = json.array!
            strongSelf.showTableView.reloadData()
            }, failure: { [weak self] error in
                guard let strongSelf = self else { return }
                strongSelf.showTableView.endHeaderRefreshing()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell: GPWBankQCell = tableView.dequeueReusableCell(withIdentifier: "GPWBankQCell", for: indexPath) as! GPWBankQCell
        cell.updata(dic: self.dataArr[indexPath.row])
        return cell
    }
}
