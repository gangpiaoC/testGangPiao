//
//  UserAcountSafeViewController.swift
//  GangPiaoWang
//  账户安全
//  Created by gangpiaowang on 2016/12/18.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class UserAcountSafeViewController: GPWSecBaseViewController,UITableViewDelegate,UITableViewDataSource {
    let contentArray = [
        [
            "修改登录密码",
            "修改交易密码"
        ],
        [
            "修改手势密码",
            "启用Touch ID"
        ]
    ]
    
    var showTableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.title = "账户安全"
        
        showTableView = UITableView(frame: self.bgView.bounds, style: .plain)
        showTableView.backgroundColor = bgColor
        showTableView?.delegate = self
        showTableView?.dataSource = self
        self.bgView.addSubview(showTableView)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
            return 10
        }
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "userSetCell") as? UserOtherCell
        if cell == nil {
            cell = UserOtherCell(style: .default, reuseIdentifier: "userSetCell")
        }
        cell?.updata(title: contentArray[indexPath.section][indexPath.row], superc: self, detail: contentArray[indexPath.section][indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                //修改登录密码
                break
            case 1:
                //修改交易密码
                break
            default:
                break
                
            }
        }else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                //修改手势密码
                break
            case 1:
                //启用Touch ID
                break
            default:
                break
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
