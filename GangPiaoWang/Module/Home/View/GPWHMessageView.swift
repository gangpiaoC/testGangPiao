//
//  GPWHMessageView.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/11/17.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWHMessageView: LazyScrollSubView,UITableViewDelegate,UITableViewDataSource {
    var showTableView:UITableView!
    var dataArr = [JSON]()
    var page = 1
    var type = "news"
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        showTableView = UITableView(frame: self.bounds, style: .plain)
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
        self.addSubview(showTableView)
    }
    override func reloadData(withDict dict: [AnyHashable : Any]!) {
        type = dict["type"] as! String
        MobClick.event("home", label: "平台公告-\(String(describing: dict["type"]))")
        self.page = 1
        self.getNetData()
    }

    func getNetData() {
        GPWNetwork.requetWithPost(url: User_message, parameters: ["page":self.page,"type":type], responseJSON:  {
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
        return 67
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "GPWUserMessageCell") as? GPWUserMessageCell
        if cell == nil {
            cell = GPWUserMessageCell(style: .default, reuseIdentifier: "GPWUserMessageCell")
        }
        cell?.setInfo(dic: self.dataArr[indexPath.row],superC:self.inCtl,type:"news")
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = self.dataArr[indexPath.row]
        let autoid = dic["auto_id"]
        let  vc = GPWWebViewController(subtitle: "", url: "https://www.gangpiaowang.com/Web/account_newshows.html?auto_id=\(autoid)")
        vc.messageFlag = "1"
        self.inCtl.navigationController?.pushViewController( vc, animated: true)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
