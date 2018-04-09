//
//  GPWXXPLViewController.swift
//  GangPiaoWang
// 信息披露
//  Created by gangpiaowang on 2018/3/13.
//  Copyright © 2018年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWXXPLViewController: GPWSecBaseViewController,UITableViewDelegate,UITableViewDataSource {
    fileprivate var showTableView:UITableView!
    var type:String?
    fileprivate var  jsonArray:[JSON]?
    fileprivate let titleArray = [
        "组织信息",
         "备案信息",
          "审核信息",
           "平台信息",
            "运营数据",
             "重大事项信息",
              "法律政策信息",
              "咨询、投诉、举报信息",
               "法定代表人声明"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == "falv" {
            self.title = "法律政策信息"
        }else{
            self.title = "信息披露"
        }
        showTableView = UITableView(frame: self.bgView.bounds, style: .plain)
        showTableView.backgroundColor = bgColor
        showTableView?.delegate = self
        showTableView?.dataSource = self
        showTableView.separatorStyle = .none
        self.bgView.addSubview(showTableView)
        if type == "falv" {
            self.getNetData()
        }
    }
    override func getNetData() {
        GPWNetwork.requetWithGet(url:Statute, parameters: nil, responseJSON: {  [weak self] (json, msg) in
            printLog(message: json)
            guard let strongSelf = self else { return }
            strongSelf.jsonArray = json.array
            strongSelf.showTableView.reloadData()
        }) { [weak self] error in

        }
    }
}
extension GPWXXPLViewController{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: "UserOtherCell") as? UserOtherCell
        if cell == nil {
            cell = UserOtherCell(style: .default, reuseIdentifier: "UserOtherCell")
        }
        if type == "falv" {
            cell?.updata(title: jsonArray?[indexPath.row]["title"].stringValue ?? "")
        }else{
            cell?.updata(title: titleArray[indexPath.row])
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == "falv" {
            let tempJson = jsonArray![indexPath.row]
            print(tempJson["link"].stringValue)

            let  control = DownHTongController()
            control.urlStr = ((tempJson["link"].stringValue) as NSString) as String!
            print(tempJson["link"].stringValue)
            control.navTitle = ((tempJson["title"].stringValue) as NSString) as String!
            control.navigationItem.hidesBackButton = true
            self.navigationController?.pushViewController(control, animated: false)

        }else{

            var type = "zzxx"
            switch (indexPath.row) {
            case 0 :
                //组织信息
                type = "zzxx"
                break
            case 1 :
                //备案信息
                type = "baxx"
                break
            case 2 :
                //审核信息
                type = "shxx"
                break
            case 3 :
                //平台信息
                type = "ptxx"
                break
            case 4 :
                //运营数据
                type = "yysj"
                break
            case 5 :
                //重大事项信息
                type = "zdsxxx-box"
                break
            case 6 :
                //法律政策信息
                let  controller  = GPWXXPLViewController()
                controller.type = "falv"
                self.navigationController?.pushViewController(controller, animated: true)
                break
            case 7 :
                //咨询、投诉、举报信息
                type = "ztjxx"
                break
            case 8 :
                //法定代表人声明
                type = "frdb"
                break
            default:
                break
            }
            var url = "\(HTML_SERVER)/Web/user_xxpl?likey=\(type)"
            if indexPath.row == 8 {
                url = "\(HTML_SERVER)/resource/gpw_flxx/fddbrsm.jpg"
            }

            print(url)
            let webController = GPWWebViewController(subtitle: titleArray[indexPath.row], url: url)
            webController.messageFlag = "1"
            self.navigationController?.pushViewController(webController, animated: true)

        }
    }
}
