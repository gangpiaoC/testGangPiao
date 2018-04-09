//
//  GPWActiveViewController.swift
//  GangPiaoWang
//  活动列表
//  Created by gangpiaowang on 2017/5/8.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWActiveViewController: GPWSecBaseViewController,UITableViewDelegate,UITableViewDataSource {
    var showTableView:UITableView!
    var dataArr = [JSON]()
    var page = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "热门活动"
        showTableView = UITableView(frame: self.bgView.bounds, style: .plain)
        showTableView.backgroundColor = bgColor
        showTableView.separatorStyle = .none
        showTableView.setUpHeaderRefresh {
            [weak self] in
            guard let self1 = self else {return}
            self1.page = 1
            self1.getNetData()
        }
        
        showTableView.setUpFooterRefresh {
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
        GPWNetwork.requetWithGet(url: Api_active, parameters: ["page":self.page], responseJSON:  {
            [weak self] (json, msg) in
            printLog(message: json)
            guard let strongSelf = self else { return }
            strongSelf.showTableView.endFooterRefreshing()
            strongSelf.showTableView.endHeaderRefreshing()
            if strongSelf.page == 1 {
                strongSelf.dataArr = json.arrayValue
                if  strongSelf.dataArr.count == 0 {
                    strongSelf.showTableView.setFooterNoMoreData()
                } else {
                    strongSelf.page += 1
                    strongSelf.showTableView.footerRefresh.isHidden = false
                }
            }else{
                if (json.arrayObject?.count)! > 0 {
                    strongSelf.page += 1
                    strongSelf.dataArr += json.array!
                }else{
                    strongSelf.showTableView.endFooterRefreshingWithNoMoreData()
                }
            }
            strongSelf.showTableView.reloadData()
            }, failure: { [weak self] error in
                guard let strongSelf = self else { return }
                strongSelf.showTableView.endFooterRefreshing()
                strongSelf.showTableView.endHeaderRefreshing()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 16 + 68 + pixw(p: 140) + 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "GPWActiveCell") as? GPWActiveCell
        if cell == nil {
            cell = GPWActiveCell(style: .default, reuseIdentifier: "GPWActiveCell")
        }
        cell?.updata(json: self.dataArr[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = self.dataArr[indexPath.row]
        let  vc = GPWWebViewController(dic: dic)
        self.navigationController?.pushViewController( vc, animated: true)
    }
}
