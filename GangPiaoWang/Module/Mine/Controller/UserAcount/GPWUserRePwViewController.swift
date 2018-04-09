//
//  GPWUserRePwViewController.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/19.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWUserRePwViewController: GPWSecBaseViewController {

    var phone:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "重置密码"
        self.bgView.backgroundColor = UIColor.white
        let imgView = UIImageView(frame: CGRect(x: 0, y: 23, width: 65, height: 66))
        imgView.image = UIImage(named: "user_forget_repw")
        imgView.centerX = SCREEN_WIDTH / 2
        self.bgView.addSubview(imgView)
        
        let temp1Label = UILabel(frame: CGRect(x: 0, y: imgView.maxY + 10, width: SCREEN_WIDTH, height: 19))
        temp1Label.text = "重置密码"
        temp1Label.centerX = imgView.centerX
        temp1Label.textAlignment = .center
        temp1Label.font = UIFont.customFont(ofSize: 18)
        temp1Label.textColor = UIColor.hex("666666")
        self.bgView.addSubview(temp1Label)
        
        let array = ["6-16个字符，由字母+数字和符号两种以上组合","确认密码"]
        var maxheight = temp1Label.maxY + 50 - 17
        for i in 0 ..< array.count {
            let textField = UITextField(frame: CGRect(x: 16, y: maxheight, width: SCREEN_WIDTH - 32, height: 17 * 2 + 12))
            textField.placeholder = array[i]
            textField.font = UIFont.customFont(ofSize: 16)
            textField.textColor = UIColor.hex("333333")
            textField.tag = 100 + i
            textField.isSecureTextEntry = true
            self.bgView.addSubview(textField)
            maxheight = textField.maxY
            
            let line = UIView(frame: CGRect(x: textField.x, y: maxheight, width: textField.width, height: 0.5))
            line.backgroundColor = lineColor
            self.bgView.addSubview(line)
            maxheight = line.maxY
        }
        
        maxheight += 32
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 10, y:  maxheight, width: SCREEN_WIDTH - 20 * 2, height: 64)
        btn.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        btn.setTitle("确定", for: .normal)
        btn.addTarget(self, action: #selector(self.btnClick), for: .touchUpInside)
        self.bgView.addSubview(btn)
    }
    
    func btnClick() {
        let newpw = (self.bgView.viewWithTag(100) as! UITextField).text 
        if newpw?.characters.count == 0 {
            self.bgView.makeToast("请输入新密码")
            return
        }else if  GPWHelper.judgePw(pw: newpw!){
        }else{
            self.bgView.makeToast("密码为6-16个字符，由字母+数字和符号两种以上组合")
            return
        }
        let surepw = (self.bgView.viewWithTag(101) as! UITextField).text
        if surepw?.characters.count == 0 {
            self.bgView.makeToast("请确认密码")
            return
        }else if  newpw == surepw{
        }else{
            self.bgView.makeToast("两次密码不统一")
            return
        }
        GPWNetwork.requetWithPost(url: Forget, parameters: ["phone":self.phone!,"newpwd":newpw ?? "","surepwd":surepw ?? ""], responseJSON:  { [weak self] (json, msg) in
            guard let strongSelf = self else { return }
            strongSelf.bgView.makeToast(msg)
            GPWUser.sharedInstance().outLogin()
            _ = strongSelf.navigationController?.popToRootViewController(animated: true)
            }, failure: { error in
                printLog(message: error)
        })
    }

}
