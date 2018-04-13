//
//  GPWFoundViewController.swift
//  GangPiaoWang
//  发现
//  Created by gangpiaowang on 2017/8/9.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWFoundViewController: GPWBaseViewController,UITableViewDelegate,UITableViewDataSource {
    fileprivate var showTableView:UITableView!
    fileprivate var dataDic:JSON?
    var page = 1
    var dataArray: [JSON] = []
    var banners: [JSON] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        page = 1
        requestNetData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化界面
        initView()
    }

    func initView() {
        self.title = "发现"

//        self.addkefuButton()
        showTableView = UITableView(frame: self.bgView.bounds, style: .plain)
        showTableView.backgroundColor = UIColor.clear
        showTableView.showsVerticalScrollIndicator = false
        showTableView?.delegate = self
        showTableView?.dataSource = self
        showTableView.separatorStyle = .none
        showTableView.register(GPWFoundTopCell.self, forCellReuseIdentifier: "GPWFoundTopCell")
        showTableView.register(GPWFoundSecCell.self, forCellReuseIdentifier: "GPWFoundSecCell")
        showTableView.register(GPWFNewsTopCell.self, forCellReuseIdentifier: "GPWFNewsTopCell")
        showTableView.register(GPWHomeNewListCell.self, forCellReuseIdentifier: "GPWHomeNewListCell")
        self.bgView.addSubview(showTableView)
        showTableView.setUpHeaderRefresh { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.page = 1
            strongSelf.requestNetData()
        }
        showTableView.setUpFooterRefresh {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.requestNetData()
        }
    }
    private func addkefuButton() {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: SCREEN_WIDTH  - 40 - 6, y: 23, width: 40, height: 40)
        button.setImage(UIImage(named: "found_top_kefu"), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(kefuClick), for: .touchUpInside)
        navigationBar.addSubview(button)
    }

    @objc private func kefuClick() {
        self.myCustem()
    }

    //帮助中心
    func  myCustem(){
        MobClick.event("found", label: "帮助中心")
        self.navigationController?.pushViewController(GPWFHelpViewController(), animated: true)
    }

    func requestNetData() {
        GPWNetwork.requetWithGet(url: Find, parameters: ["page": page], responseJSON: {
            [weak self] (json, msg) in
            printLog(message: json)
            
            guard let strongSelf = self else { return }
            strongSelf.dataDic = json
            if strongSelf.page == 1 {
                strongSelf.banners = json["banner"].arrayValue
            }
            strongSelf.showTableView.endFooterRefreshing()
            strongSelf.showTableView.endHeaderRefreshing()
            let coverage = json["coverage"].arrayValue
            if strongSelf.page == 1 {
                strongSelf.dataArray.removeAll()
                strongSelf.dataArray = coverage
                if  strongSelf.dataArray.count == 0 {
                    strongSelf.showTableView.setFooterNoMoreData()
                } else {
                    strongSelf.page += 1
                    strongSelf.showTableView.footerRefresh.isHidden = false
                }
            }else{
                if coverage.count > 0 {
                    strongSelf.page += 1
                    strongSelf.dataArray += coverage
                }else{
                    strongSelf.showTableView.endFooterRefreshingWithNoMoreData()
                }
            }
            strongSelf.showTableView.reloadData()
        }) {[weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.showTableView.endFooterRefreshing()
            strongSelf.showTableView.endHeaderRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension GPWFoundViewController{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataDic == nil {
            return 0
        }
        printLog(message: dataArray.count)
        return 3 + dataArray.count

    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return pixw(p: 138) + 12 + 10
        }else if indexPath.row == 1{
            return 93
        }else if indexPath.row == 2{
            return  56 + 10
        }else{
            return 120
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell: GPWFoundTopCell = tableView.dequeueReusableCell(withIdentifier: "GPWFoundTopCell", for: indexPath) as! GPWFoundTopCell
            cell.showInfo(array: banners, control: self)
            return cell
        }else  if indexPath.row == 1{
            let cell: GPWFoundSecCell = tableView.dequeueReusableCell(withIdentifier: "GPWFoundSecCell", for: indexPath) as! GPWFoundSecCell
            cell.superControl = self
            return cell
        }else if indexPath.row == 2{
            let cell: GPWFNewsTopCell = tableView.dequeueReusableCell(withIdentifier: "GPWFNewsTopCell", for: indexPath) as! GPWFNewsTopCell
            return cell
        }else{
            let cell: GPWHomeNewListCell = tableView.dequeueReusableCell(withIdentifier: "GPWHomeNewListCell", for: indexPath) as! GPWHomeNewListCell
            cell.updata(dic: dataArray[indexPath.row - 3])
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row <= 2 {
            return
        }
       
        let  vc = GPWWebViewController(subtitle: "报道详情", url: "\(HTML_SERVER)/Web/account_newshows.html?auto_id=\(dataArray[indexPath.row - 3]["auto_id"].intValue)")
        vc.messageFlag = "1"
        self.navigationController?.pushViewController( vc, animated: true)
    }
}

