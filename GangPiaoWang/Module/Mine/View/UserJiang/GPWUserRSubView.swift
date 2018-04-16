//
//  GPWUserRSubView.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/21.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWUserRSubView: LazyScrollSubView,UITableViewDelegate,UITableViewDataSource {
    var showTableView:UITableView!
    var type:String!
    var dataArr = [JSON]()
    var page = 1

    //当为true可执行
    var flag = true
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        showTableView = UITableView(frame: self.bounds, style: .plain)
        showTableView.backgroundColor = UIColor.clear
        showTableView.separatorStyle = .none
        showTableView.height -= 40
        showTableView?.delegate = self
        showTableView?.dataSource = self
        self.addSubview(showTableView)
        showTableView.setUpHeaderRefresh {
            [weak self] in
            guard let self1 = self else {return}
            self1.page = 1
            self1.getNetData()
        }
        
        showTableView.setUpFooterRefresh {
            [weak self] in
            guard let self1 = self else {return}
            if self1.flag {
                self1.getNetData()
            }
        }
    }

    override func reloadData(withDict dict: [AnyHashable : Any]!) {
        type = dict["type"] as! String
        if self.flag {
            self.getNetData()
            MobClick.event("mine_reward", label: dict["title"] as! String)
        }
    }
    
    func getNetData() {
        flag = false
        GPWNetwork.requetWithPost(url: type, parameters: ["page":self.page], responseJSON:  {
            [weak self] (json, msg) in
            guard let strongSelf = self else { return }
            strongSelf.showTableView.endFooterRefreshing()
            strongSelf.showTableView.endHeaderRefreshing()
            if strongSelf.page == 1 {
                strongSelf.dataArr.removeAll()
                strongSelf.dataArr = json.arrayValue
                if strongSelf.dataArr.count > 0 {
                    strongSelf.showTableView.footerRefresh.isHidden = false
                    strongSelf.page += 1
                }else{
                    strongSelf.showTableView.setFooterNoMoreData()
                }
            }else{
                if (json.arrayObject?.count)! > 0 {
                    strongSelf.page += 1
                    strongSelf.dataArr = strongSelf.dataArr + json.arrayValue
                }else{
                    strongSelf.showTableView.endFooterRefreshingWithNoMoreData()
                }
            }
            if strongSelf.dataArr.count > 0 {
                (strongSelf.inCtl as! GPWSecBaseViewController).noDataImgView.isHidden = true
            }else{
                (strongSelf.inCtl as! GPWSecBaseViewController).noDataImgView.isHidden = false
            }
            printLog(message: "qqqqqq====\(strongSelf.page)wwwww====\(strongSelf.dataArr)========\(json)")
            strongSelf.showTableView.reloadData()
            strongSelf.flag = true
            }, failure: { [weak self] error in
                guard let strongSelf = self else { return }
                  printLog(message: error)
                strongSelf.showTableView.endFooterRefreshing()
                strongSelf.showTableView.endHeaderRefreshing()
                 strongSelf.flag = true
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        printLog(message: type)
         if type == nil {
            return 0
        }else{
            return self.dataArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120 + 16
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if type == Useraccounts_myred {
            var cell = tableView.dequeueReusableCell(withIdentifier: "GPWUserRBCell") as? GPWUserRBCell
            if cell == nil {
                cell = GPWUserRBCell(style: .default, reuseIdentifier: "GPWUserRBCell")
            }
            cell?.setInfo(dic: self.dataArr[indexPath.row],superC:self.inCtl)
            return cell!
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "GPWUserRCell") as? GPWUserRCell
            if cell == nil {
                cell = GPWUserRCell(style: .default, reuseIdentifier: "GPWUserRCell")
            }
            cell?.setInfo(dic: self.dataArr[indexPath.row],superC:self.inCtl)
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
