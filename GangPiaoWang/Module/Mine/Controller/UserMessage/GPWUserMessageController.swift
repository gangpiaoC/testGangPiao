//
//  GPWUserMessageController.swift
//  GangPiaoWang
//  消息中心
//  Created by gangpiaowang on 2016/12/22.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWUserMessageController: GPWSecBaseViewController,UITableViewDelegate,UITableViewDataSource {
    var showTableView:UITableView!
    var dataArr = [JSON]()
    var page = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息中心"
        
        //消息已读
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: SCREEN_WIDTH - 90 - 16, y: 33, width: 90, height: 21)
        btn.setTitle("全部标为已读", for: .normal)
        btn.setTitleColor(UIColor.hex("666666"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(self.btnClick), for: .touchUpInside)
        self.navigationBar.addSubview(btn)
        
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
    
    func btnClick()  {
        //消息全读
        GPWNetwork.requetWithPost(url: Update_messages, parameters: ["auto_id":"all"], responseJSON:  {
            [weak self] (json, msg) in
            printLog(message: json)
            guard let strongSelf = self else { return }
            strongSelf.page = 1
            strongSelf.getNetData()
        }, failure: { error in
            
        })
    }
    
    override func getNetData() {
        GPWNetwork.requetWithPost(url: User_message, parameters: ["page":self.page,"type":"message"], responseJSON:  {
            [weak self] (json, msg) in
            printLog(message: json)
            guard let strongSelf = self else { return }
            strongSelf.showTableView.endFooterRefreshing()
            strongSelf.showTableView.endHeaderRefreshing()
            if strongSelf.page == 1 {
                strongSelf.dataArr = json.array!
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
        cell?.setInfo(dic: self.dataArr[indexPath.row],superC:self,type:"message")
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var dic = self.dataArr[indexPath.row]
        dic["is_read"] = "1"
        self.dataArr[indexPath.row] = dic
        self.showTableView.reloadData()
        self.navigationController?.pushViewController(GPWUserMDetailViewController(dic:self.dataArr[indexPath.row]), animated: true)
    }
}
