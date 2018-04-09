//
//  GPWUserMoneyToSubView.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/21.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWUserMoneyToSubView: LazyScrollSubView,UITableViewDelegate,UITableViewDataSource {
    
    var showTableView:UITableView!
    var type:String!
    var dataArr = [JSON]()
    var page = 1
    override init(frame: CGRect) {
        super.init(frame: frame)
        showTableView = UITableView(frame: self.bounds, style: .plain)
        showTableView.backgroundColor = UIColor.clear
        showTableView.separatorStyle = .none
        showTableView.height -= 40
        showTableView.setUpHeaderRefresh {
            [weak self] in
            guard let self1 = self else {return}
            self1.page = 1
            self1.getNetData()
        }
        
        showTableView.setUpFooterRefresh {
            [weak self] in
            guard let self1 = self else {return}
            self1.page += 1
            self1.getNetData()
        }
        showTableView?.delegate = self
        showTableView?.dataSource = self
        self.addSubview(showTableView)
    }
    
    override func reloadData(withDict dict: [AnyHashable : Any]!) {
        type = dict["type"] as! String
        MobClick.event("home", label: "平台公告-\(String(describing: dict["type"]))")
        self.page = 1
        self.getNetData()
    }
    
    func getNetData() {
        GPWNetwork.requetWithPost(url: Money_record, parameters: ["type":self.type,"page":"\(self.page)"], responseJSON:  {  [weak self] (json, msg) in
            guard let strongSelf = self else { return }
            strongSelf.showTableView.endFooterRefreshing()
            strongSelf.showTableView.endHeaderRefreshing()
            if strongSelf.page == 1 {
                strongSelf.dataArr = json.arrayValue
                if  strongSelf.dataArr.count == 0 {
                    strongSelf.showTableView.setFooterNoMoreData()
                }else{
                    strongSelf.showTableView.footerRefresh.isHidden = false
                }
            }else{
                if (json.arrayObject?.count)! > 0 {
                    strongSelf.dataArr = strongSelf.dataArr + json.arrayValue
                }else{
                    strongSelf.showTableView.endFooterRefreshingWithNoMoreData()
                }
            }
             strongSelf.showNoDataImg()
            strongSelf.showTableView.reloadData()
            }, failure: { [weak self] error in
                guard let strongSelf = self else { return }
                strongSelf.showTableView.endFooterRefreshing()
                strongSelf.showTableView.endHeaderRefreshing()
                strongSelf.showNoDataImg()
        })
    }
    
    func showNoDataImg(){
        if  self.dataArr.count == 0 {
            (self.inCtl as! GPWSecBaseViewController).noDataImgView.isHidden = false
            self.showTableView.setFooterNoMoreData()
        }else{
            (self.inCtl as! GPWSecBaseViewController).noDataImgView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == nil {
            return 0
        }
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "GPWMoneyToCell") as? GPWMoneyToCell
        if cell == nil {
            cell = GPWMoneyToCell(style: .default, reuseIdentifier: "GPWMoneyToCell")
        }
         cell?.setInfo(dic: self.dataArr[indexPath.row],superC:self.inCtl)
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
