//
//  GPWFMallController.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/12/28.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWFMallController: GPWSecBaseViewController,UITableViewDelegate,UITableViewDataSource {
    fileprivate var showTableView:UITableView!
    fileprivate var dataDic:JSON?

    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化界面
        initView()
    }

    func initView() {
        self.title = "钢镚商城"

        self.addkefuButton()
        showTableView = UITableView(frame: self.bgView.bounds, style: .plain)
        showTableView.backgroundColor = UIColor.clear
        showTableView.showsVerticalScrollIndicator = false
        showTableView?.delegate = self
        showTableView?.dataSource = self
        showTableView.separatorStyle = .none
        showTableView.register(MallTopCell.self, forCellReuseIdentifier: "MallTopCell")
        self.bgView.addSubview(showTableView)
        //getNetData()
        showTableView.setUpHeaderRefresh { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.getNetData()
        }
    }
    private func addkefuButton() {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: SCREEN_WIDTH  - 40 - 6, y: 23, width: 40, height: 40)
        button.setImage(UIImage(named: "mall_center_help"), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(helper), for: .touchUpInside)
        navigationBar.addSubview(button)
    }

    @objc private func helper() {
        //去往帮助中心
    }


    override func getNetData() {
        GPWNetwork.requetWithGet(url: Find, parameters: nil, responseJSON: {
            [weak self] (json, msg) in
            printLog(message: json)
            guard let strongSelf = self else { return }
            strongSelf.dataDic = json
            strongSelf.showTableView.reloadData()
            strongSelf.showTableView.endHeaderRefreshing()
        }) {[weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.showTableView.endHeaderRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension GPWFMallController{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if dataDic == nil {
//            return 0
//        }
        return 1

    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return pixw(p: 130) + 68
        }else if indexPath.row == 1{
            return 93
        }else if indexPath.row == 2 || indexPath.row == 4{
            return  54
        }else if indexPath.row == 3{
            return 201
        }else{
            return 120
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell: MallTopCell = tableView.dequeueReusableCell(withIdentifier: "MallTopCell", for: indexPath) as! MallTopCell
            cell.showInfo(money: "342456")
            return cell
        }else  if indexPath.row == 1{
            let cell: GPWFoundSecCell = tableView.dequeueReusableCell(withIdentifier: "GPWFoundSecCell", for: indexPath) as! GPWFoundSecCell
            cell.superControl = self
            return cell
        }else if indexPath.row == 2{
            let cell: GPWMallTopCell = tableView.dequeueReusableCell(withIdentifier: "GPWMallTopCell", for: indexPath) as! GPWMallTopCell
            return cell
        }else if indexPath.row == 3{
            let cell: GPWMallProsCell = tableView.dequeueReusableCell(withIdentifier: "GPWMallProsCell", for: indexPath) as! GPWMallProsCell
            return cell
        }else if indexPath.row == 4{
            let cell: GPWFNewsTopCell = tableView.dequeueReusableCell(withIdentifier: "GPWFNewsTopCell", for: indexPath) as! GPWFNewsTopCell
            return cell
        }else{
            let cell: GPWHomeNewListCell = tableView.dequeueReusableCell(withIdentifier: "GPWHomeNewListCell", for: indexPath) as! GPWHomeNewListCell
            cell.updata(dic: (self.dataDic?["coverage"][indexPath.row - 3])!)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 2{
            self.navigationController?.pushViewController(GPWFMallController(), animated: true)
        }
        return
        if indexPath.row < 3 {

        }
        if indexPath.row == 4 {
            self.navigationController?.pushViewController(GPWHomeNewListController(), animated: true)
        }else {
            let  vc = GPWWebViewController(subtitle: "报道详情", url: "\(HTML_SERVER)/Web/account_newshows.html?auto_id=\(self.dataDic?["coverage"][indexPath.row - 3]["auto_id"].intValue ?? 0)")
            vc.messageFlag = "1"
            self.navigationController?.pushViewController( vc, animated: true)
        }
    }
}


