//
//  GPWUserSetLoginPwViewController.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/19.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWUserSetLoginPwViewController: GPWSecBaseViewController {

    var pwtextField:UITextField!
    var acountPhone:String?
    var yaotextField:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置登录密码"
        self.bgView.backgroundColor = UIColor.white
        
        pwtextField = UITextField(frame: CGRect(x: 16, y: 0, width: SCREEN_WIDTH - 16 * 2, height: 56))
        pwtextField.placeholder = "含字母+数字和符号的6-16个字符"
        pwtextField.textColor = UIColor.hex("333333")
        pwtextField.font = UIFont.customFont(ofSize: 16)
        pwtextField.isSecureTextEntry = true
        self.bgView.addSubview(pwtextField)
        
        let line1 = UIView(frame: CGRect(x: pwtextField.x, y: pwtextField.maxY , width: pwtextField.width, height: 0.5))
        line1.backgroundColor = lineColor
        self.bgView.addSubview(line1)
        
        let yaoLabel = UILabel(frame: CGRect(x: line1.x, y: line1.y + 15, width: 200, height: 18))
        yaoLabel.text = "我有推荐人"
        yaoLabel.font = UIFont.customFont(ofSize: 12)
        yaoLabel.textColor = UIColor.hex("fcc30b")
        self.bgView.addSubview(yaoLabel)
        
        yaotextField = UITextField(frame: CGRect(x: 16, y: yaoLabel.maxY + 10, width: SCREEN_WIDTH - 16 * 2, height: 15))
        yaotextField.placeholder = "推荐人邀请码（选填）"
        yaotextField.textColor = UIColor.hex("333333")
        yaotextField.font = UIFont.customFont(ofSize: 14)
        self.bgView.addSubview(yaotextField)
        
        let line2 = UIView(frame: CGRect(x: pwtextField.x, y: yaotextField.maxY + 13, width: pwtextField.width, height: 0.5))
        line2.backgroundColor = lineColor
        self.bgView.addSubview(line2)
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 16, y: line2.maxY + 40, width: SCREEN_WIDTH - 16 * 2, height: 44)
        btn.setTitle("完成", for: .normal)
        btn.addTarget(self, action: #selector(self.btnClick), for: .touchUpInside)
        btn.setBackgroundImage(UIImage(named: "project_right_pay"), for: .normal)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 18)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 5.0
        self.bgView.addSubview(btn)
    }
    
    override func getNetData() {
        
        let regex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        var dic = ["mobile":acountPhone!]
        if pwtextField.text?.count == 0 {
            bgView.makeToast("请输入密码")
            return
        }
        if predicate.evaluate(with: pwtextField.text) {
         dic["password"] = pwtextField.text!
            if yaotextField.text!.characters.count >= 1 {
                dic["invite_code"] = yaotextField.text!
            }
            GPWNetwork.requetWithPost(url: Depose_register, parameters: dic, responseJSON:  {
                [weak self] (json, msg) in
                guard let strongSelf = self else { return }
                GPWUser.sharedInstance().analyUser(dic: json)
                strongSelf.navigationController?.pushViewController(GPWUserRegisterSViewController(), animated: true)
                }, failure: { error in
                    
            })
        }else{
            self.bgView.makeToast("密码为6-16个字符，由字母+数字和符号两种以上组合")
        }
    }
    @objc func  btnClick() {
        self.getNetData()
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
