//
//  GPWHomeNewListController.swift
//  GangPiaoWang
//  媒体报道
//  Created by gangpiaowang on 2017/3/21.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWHomeNewListController: GPWSecBaseViewController,UITableViewDelegate,UITableViewDataSource {
    fileprivate var page:Int?
    fileprivate var dataArray = [JSON]()
    private var showTableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "媒体报道"
        dataArray = [JSON]()
        page = 1
        showTableView = UITableView(frame: self.bgView.bounds, style: .plain)
        showTableView.backgroundColor = bgColor
        showTableView?.delegate = self
        showTableView?.dataSource = self
        showTableView.separatorStyle = .none
        self.bgView.addSubview(showTableView)
        
        showTableView.setUpHeaderRefresh { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.page = 1
            strongSelf.getNetData()
        }
        
        showTableView.setUpFooterRefresh { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.getNetData()
        }
        self.getNetData()
    }
    
    override func getNetData(){
        printLog(message: self.page)
        GPWNetwork.requetWithGet(url: Media_report, parameters: ["page":"\(self.page!)"], responseJSON:  {
            [weak self] (json, msg) in
            guard let strongSelf = self else { return }
            strongSelf.showTableView.endFooterRefreshing()
            strongSelf.showTableView.endHeaderRefreshing()
            if strongSelf.page == 1 {
                strongSelf.dataArray.removeAll()
                strongSelf.dataArray = json.arrayValue
                if  strongSelf.dataArray.count == 0 {
                    strongSelf.showTableView.setFooterNoMoreData()
                } else {
                    strongSelf.page = strongSelf.page! + 1
                    strongSelf.showTableView.footerRefresh.isHidden = false
                }
                strongSelf.showTableView.reloadData()
            }else{
                if (json.arrayObject?.count)! > 0 {
                    strongSelf.page = strongSelf.page! + 1
                    strongSelf.dataArray = strongSelf.dataArray + json.arrayValue
                    strongSelf.showTableView.reloadData()
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
}
extension GPWHomeNewListController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "GPWHomeNewListCell") as? GPWHomeNewListCell
        if cell == nil {
            cell = GPWHomeNewListCell(style: .default, reuseIdentifier: "GPWHomeNewListCell")
        }
        cell?.updata(dic: self.dataArray[indexPath.row])
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        printLog(message:  "\(HTML_SERVER)/Web/account_newshows.html?auto_id=\( self.dataArray[indexPath.row]["auto_id"])")
        let  vc = GPWWebViewController(subtitle: "报道详情", url: "\(HTML_SERVER)/Web/account_newshows.html?auto_id=\( self.dataArray[indexPath.row]["auto_id"])")
        vc.messageFlag = "1"
        self.navigationController?.pushViewController( vc, animated: true)
    }
}
