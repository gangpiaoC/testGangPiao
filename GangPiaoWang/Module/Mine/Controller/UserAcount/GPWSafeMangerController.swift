//
//  GPWSafeMangerController.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/3/3.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWSafeMangerController: GPWSecBaseViewController ,UITableViewDelegate,UITableViewDataSource {
    var showTableView:UITableView?
    var titleArray = [["设置登录密码","修改支付密码"],["手势密码"]]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let password = GYCircleConst.getGestureWithKey(gestureFinalSaveKey) ?? ""
        if password.characters.count >= 4 {
            self.titleArray = [["修改登录密码","修改支付密码"],["手势密码","修改手势密码"]]
            if GPWUser.sharedInstance().set_pwd == 1 {
                 self.titleArray = [["设置登录密码","修改支付密码"],["手势密码","修改手势密码"]]
            }
        }else{
             self.titleArray = [["修改登录密码","修改支付密码"],["手势密码"]]
            if GPWUser.sharedInstance().set_pwd == 0 {
                self.titleArray = [["设置登录密码","修改支付密码"],["手势密码"]]
            }
        }
        showTableView?.reloadData()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "安全管理"
        showTableView = UITableView(frame: self.bgView.bounds , style: .plain)
        showTableView?.delegate = self
        showTableView?.dataSource = self
        showTableView?.backgroundColor = UIColor.clear
        self.showTableView?.register(UserOtherCell.self, forCellReuseIdentifier: "UserOtherCell")
        self.showTableView?.register(UserOtherCell.self, forCellReuseIdentifier: "safeCell")

        showTableView?.separatorStyle = .none
        self.bgView.addSubview(showTableView!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return titleArray[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 10
        }
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 || indexPath.row == 1 {
            let  cell = tableView.dequeueReusableCell(withIdentifier: "UserOtherCell") as? UserOtherCell
            cell?.updata(imgName: nil, title: titleArray[indexPath.section][indexPath.row], superc: self, detail: nil)
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "safeCell") as? UserOtherCell
            cell?.swicth.addTarget(self, action: #selector(switchDidChange(sender:)), for:.valueChanged)
            let password = GYCircleConst.getGestureWithKey(gestureFinalSaveKey) ?? ""
            var flag:Bool = false
            if password.characters.count >= 4 {
                flag = true
            }
            cell?.changSwitchValue(title: titleArray[indexPath.section][indexPath.row], bool: flag, superc: self)
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                //修改登录密码
                printLog(message: "修改登录密码")
                if self.titleArray[indexPath.section][indexPath.row] == "设置登录密码" {
                     MobClick.event("mine", label: "信息-密码-设置")
                }else{
                     MobClick.event("mine", label: "信息-密码-登录")
                }
               
                if GPWUser.sharedInstance().set_pwd == 0 {
                    let con = GPWUserQSetPWViewController()
                    con.setpwFlag = 0
                    self.navigationController?.pushViewController(con, animated: true)
                }else{
                    self.navigationController?.pushViewController(GPWUserChangepwViewController(), animated: true)
                }
                break
            case 1:
                //修改交易密码
                printLog(message: "修改交易密码")
                MobClick.event("mine", label: "信息-实名-交易")
                if GPWUser.sharedInstance().is_idcard == 1 {
                    GPWNetwork.requetWithGet(url: Api_user_trade_succes, parameters: nil, responseJSON: {[weak self] (json,msg) in
                        guard let strongSelf = self else { return }
                        let vc = GPWBankWebViewController(subtitle: "", url: json.stringValue)
                        strongSelf.navigationController?.show(vc, sender: nil)
                        
                        }, failure: { (error) in
                            
                    })
                }else{
                    self.bgView.makeToast("未实名认证")
                }
                break
            default:
                break
            }
        }else{
            switch indexPath.row {
            case 0:
                break
            case 1:
                let gesture = GestureViewController()
                gesture.type = GestureViewControllerType.change
                _ = GPWHelper.selectedNavController()?.pushViewController(gesture, animated: true)
                break
            default :
                break
            }
        }
    }
    func switchDidChange(sender:UISwitch){
        if sender.isOn {
            let gesture = GestureViewController()
            gesture.type = GestureViewControllerType.setting
            _ = GPWHelper.selectedNavController()?.pushViewController(gesture, animated: true)
        }else{
            let gesture = GestureViewController()
            gesture.type = GestureViewControllerType.close
            _ = GPWHelper.selectedNavController()?.pushViewController(gesture, animated: true)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
