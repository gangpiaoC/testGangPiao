//
//  UserSetViewController.swift
//  test
//
//  Created by gangpiaowang on 2016/12/18.
//  Copyright © 2016年 mutouwang. All rights reserved.
//

import UIKit

class UserSetViewController: GPWSecBaseViewController,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate {
        var showTableView:UITableView?
    
    var contentArray =  [
        [
            ["title":"用户名","detail":GPWUser.sharedInstance().user_name ?? ""],
            ["title":"手机号","detail":GPWUser.sharedInstance().telephone ?? ""]
        ]
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentArray.removeAll()
        contentArray.append(
            [
                ["title":"用户名","detail":GPWUser.sharedInstance().user_name ?? ""],
                ["title":"手机号","detail":GPWUser.sharedInstance().telephone ?? ""]
            ]
        )
        if GPWUser.sharedInstance().show_iden == 0{
            contentArray.append(
                [
                    ["title":"实名认证","detail":"未认证"],
                    ["title":"银行卡","detail":"未绑定"]
                ]
            )
        }else{
            contentArray.append(
                [
                    ["title":"实名认证","detail":"未认证"],
                    ["title":"银行卡","detail":"未绑定"],
                    ["title":"风险测评","detail":(GPWUser.sharedInstance().risk > 0 ? self.checkRiskType() : "")]
                ]
            )
        }
        
        contentArray.append(
            [
                ["title":"安全管理","detail":""],
                ["title":"关于","detail":""]
            ]
        )
        
        contentArray.append(
            [
                ["title":"退出","detail":""]
            ]
        )
        self.showTableView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "账户信息"
        
        showTableView = UITableView(frame: self.bgView.bounds, style: .plain)
        showTableView?.backgroundColor = bgColor
        showTableView?.delegate = self
        showTableView?.dataSource = self
        showTableView?.separatorStyle = .none
        self.bgView.addSubview(showTableView!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if GPWUser.sharedInstance().isLogin {
             return 3 + 1
        }else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return 1
        }else{
            return contentArray[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 10
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  tempView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        tempView.backgroundColor = UIColor.clear
        return tempView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 56
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 3 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "etitSetCell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "etitSetCell")
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 56))
                label.text = "退出账户"
                label.font = UIFont.customFont(ofSize: 16)
                label.textColor = redColor
                label.textAlignment = .center
                cell?.contentView.addSubview(label)
                cell?.selectionStyle = .none
            }
            return cell!
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "userSetCell") as? UserOtherCell
            if cell == nil {
                cell = UserOtherCell(style: .default, reuseIdentifier: "userSetCell")
            }
            if indexPath.section == 1 && (indexPath.row == 0 || indexPath.row == 1) {
            cell?.updata(title: contentArray[indexPath.section][indexPath.row]["title"]!, index: indexPath.row)
            }else{
             cell?.updata(title: contentArray[indexPath.section][indexPath.row]["title"]!, superc: self, detail: contentArray[indexPath.section][indexPath.row]["detail"])
                if indexPath.section == 0 && indexPath.row == 0{
                    cell?.rightImbView.isHidden = true
                }else{
                      cell?.rightImbView.isHidden = false
                }
            }
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                //用户名
               break
            case 1:
                //手机号
                MobClick.event("mine", label: "信息-手机")
                let bingController = GPWBingPhoneController()
                bingController.type = BingType.UNBING
                self.navigationController?.pushViewController(bingController, animated: true)
                break
            default:
                break
            }
        }else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                
                if GPWUser.sharedInstance().is_idcard == 0 {
                    //实名认证
                    MobClick.event("mine", label: "信息-实名")
                   self.navigationController?.pushViewController(UserReadInfoViewController(), animated: true)
                }
                break
            case 1:
                //银行卡
                if GPWUser.sharedInstance().is_valid ==  "0" {
                    MobClick.event("mine", label: "信息-实名")
                      self.navigationController?.pushViewController(UserReadInfoViewController(), animated: true)
                }else{
                    self.navigationController?.pushViewController(UserBankViewController(), animated: true)
                }
                break
            case 2:
                //风险测评
                MobClick.event("mine", label: "信息-风险")
               self.navigationController?.pushViewController(GPWRiskAssessmentViewController(), animated: true)
                break
            default:
                break
            }
        }else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                //密码管理
                MobClick.event("mine", label: "信息-密码")
                self.navigationController?.pushViewController(GPWSafeMangerController(), animated: true)
                break
            case 1:
                //关于我们
                MobClick.event("mine", label: "信息-关于")
                self.navigationController?.pushViewController(GPWAboutMeViewController(), animated: true)
                break
            default:
                break
            }
        }else if indexPath.section == 3{
            //退出
            let alertSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "退出当前账户")
            alertSheet.show(in: self.bgView)
             printLog(message: "退出")
        }
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0 {
            GPWUser.sharedInstance().outLogin()
             MobClick.event("info_logout", label: nil)
            _ = self.navigationController?.popViewController(animated: true)
            GPWNetwork.requetWithPost(url: Login_outs, parameters: nil, responseJSON: { (json,msg) in
                printLog(message: "退出成功")
            }, failure: { error in
                
            })
        }else{
            
        }
    }

    func checkRiskType() -> String {
        var  type = "保守型"
        if GPWUser.sharedInstance().risk <= 30 {
            //保守型
            type = "保守型"
        }else if GPWUser.sharedInstance().risk > 37 && GPWUser.sharedInstance().risk <= 72 {
            //稳健型
            type = "稳健型"
        }else{
            //进取型
            type = "进取型"
        }
        return type
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
