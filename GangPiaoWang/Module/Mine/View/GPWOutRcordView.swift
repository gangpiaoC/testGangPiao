//
//  GPWOutRcordView.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/11/20.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWOutRcordView: LazyScrollSubView,UITableViewDelegate,UITableViewDataSource {
    var page = 1
    var dataArray:[JSON]!
    weak  var superControl:GPWOutRcordController?
    fileprivate var titLabel:UILabel!
    var showTableView:UITableView!
    var type = ""
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear

        page = 1
        dataArray = [JSON]()
        titLabel = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 32))
        titLabel.backgroundColor = UIColor.hex("fff4e1")
        titLabel.font = UIFont.customFont(ofSize: 14)
        titLabel.isHidden = true
        titLabel.textColor = UIColor.hex("f6a623")
        titLabel.text = "    已出借项目享有站岗利息补贴"
        self.addSubview(titLabel)

        showTableView = UITableView(frame: self.bounds, style: .plain)
          showTableView.y = titLabel.maxY
        showTableView.height = showTableView.height - 50 - 110
        showTableView.separatorStyle = .none
        showTableView.backgroundColor = UIColor.clear
        showTableView.setUpFooterRefresh {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.getNetData()
        }
        showTableView.setUpHeaderRefresh {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.page = 1
            strongSelf.getNetData()
        }
        showTableView.estimatedRowHeight = 0
        showTableView.estimatedSectionHeaderHeight = 0
        showTableView.estimatedSectionFooterHeight = 0
        if #available(iOS 11.0, *) {
            showTableView.contentInsetAdjustmentBehavior = .never
            showTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)//导航栏如果使用系统原生半透明的，top设置为64
            showTableView.scrollIndicatorInsets = showTableView.contentInset
        }
        showTableView.delegate = self
        showTableView.dataSource = self
        showTableView.backgroundColor = UIColor.clear
        self.addSubview(showTableView)
        self.getNetData()

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
        MobClick.event("mine", label: "平台公告-\(String(describing: dict["type"]))")
        self.page = 1
        if type == "loaned" {
            self.showTableView.y = titLabel.maxY
        }else{
            self.showTableView.y = 0
        }
        self.getNetData()
    }

    func getNetData() {
        GPWNetwork.requetWithGet(url: Invest_record, parameters: ["page":"\(page)","status":type], responseJSON:  {
            [weak self] (json,msg) in
            printLog(message: json)
             guard let strongSelf = self else { return }
            if json.isEmpty {
                printLog(message: "eeeeeeeeee")
                if strongSelf.page <= 1 {
                    strongSelf.superControl?.noDataImgView.isHidden = false
                }
                strongSelf.showTableView.endFooterRefreshing()
                strongSelf.showTableView.endHeaderRefreshing()
                strongSelf.showTableView.endFooterRefreshingWithNoMoreData()
                return
            }

            strongSelf.showTableView.endFooterRefreshing()
            strongSelf.showTableView.endHeaderRefreshing()
            if strongSelf.page == 1 {
                strongSelf.dataArray.removeAll()
                strongSelf.dataArray = json.arrayValue
                if strongSelf.dataArray.count == 0 {
                    strongSelf.showTableView.setFooterNoMoreData()
                    strongSelf.superControl?.noDataImgView.isHidden = false
                }else{
                    if strongSelf.type == "loaned" {
                        strongSelf.titLabel.isHidden = false
                    }
                    strongSelf.superControl?.noDataImgView.isHidden = true
                    strongSelf.showTableView.footerRefresh.isHidden = false
                    strongSelf.page += 1
                }
            }else{
                strongSelf.showTableView.footerRefresh.isHidden = false
                if (json.arrayObject?.count)! > 0 {
                    strongSelf.page += 1
                    strongSelf.dataArray = strongSelf.dataArray + json.arrayValue
                }else{
                    strongSelf.showTableView.endFooterRefreshingWithNoMoreData()
                }
            }
            printLog(message: strongSelf.dataArray)
            strongSelf.showTableView.reloadData()
            }, failure: { [weak self] error in
                guard let strongSelf = self else { return }
                strongSelf.showTableView.endFooterRefreshing()
                strongSelf.showTableView.endHeaderRefreshing()
        })
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataArray.count > 0 {
            return self.dataArray.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 146 + 8
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "GPWOutRcordCell") as? GPWOutRcordCell
        if cell == nil {
            cell = GPWOutRcordCell(style: .default, reuseIdentifier: "GPWOutRcordCell")
        }
        cell?.updata(dic: self.dataArray[indexPath.row ])
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = self.dataArray[indexPath.row]
        let rcorID = dic["newauto_id"].intValue
        let auto_id = dic["auto_id"].intValue
        let detailVC = GPWOutRcordDetailController()
        detailVC.rcordID =  "\(rcorID)"
        detailVC.auto_id = "\(auto_id)"
        detailVC.pTitle = dic["title"].stringValue
        self.superControl?.navigationController?.pushViewController(detailVC, animated: true)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

