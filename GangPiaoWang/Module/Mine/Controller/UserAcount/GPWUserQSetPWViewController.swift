//
//  GPWUserQSetPWViewController.swift
//  GangPiaoWang
//  快捷登录设置密码
//  Created by gangpiaowang on 2017/3/23.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWUserQSetPWViewController: GPWSecBaseViewController {

    //0  不展示填写邀请人  1 显示
    var  setpwFlag = 1
    fileprivate var topBgView:UIView!
    fileprivate var sureBtn:UIButton!
    fileprivate var yaoCodeTextField:UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置密码"
        self.comminit()
    }
    func comminit()  {
        let array = [
            ["title":"登录密码","place":"含字母+数字和符号的6-16个字符"],
            ["title":"确认密码","place":"请确认密码"]
        ]

        topBgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0))
        topBgView.backgroundColor = UIColor.white
        self.bgView.addSubview(topBgView)
        
        let  topView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        topView.backgroundColor = bgColor
        self.bgView.addSubview(topView)
        
        var maxHeiht:CGFloat = topView.maxY
        
        for i in 0 ..< array.count  {
            let  titleLabel = UILabel(frame: CGRect(x: 16, y: maxHeiht, width: 70, height: 56))
            titleLabel.font = UIFont.customFont(ofSize: 16)
            titleLabel.textColor = UIColor.hex("333333")
            titleLabel.text = array[i]["title"]!
            self.bgView.addSubview(titleLabel)
            
            let  textField = UITextField(frame: CGRect(x: titleLabel.maxX + 5, y: titleLabel.y, width: SCREEN_WIDTH - titleLabel.maxX - 5, height: titleLabel.height))
            textField.placeholder = array[i]["place"]
            textField.tag = 100 + i
            textField.textColor = UIColor.hex("333333")
            textField.isSecureTextEntry = true
            textField.font = UIFont.customFont(ofSize: 14)
            self.bgView.addSubview(textField)
            
            let line = UIView(frame: CGRect(x: 16, y: textField.maxY - 0.5, width: SCREEN_WIDTH - 32, height: 0.5))
            line.backgroundColor = lineColor
            self.bgView.addSubview(line)
            maxHeiht = line.maxY
        }
        maxHeiht = maxHeiht + 12
        //有邀请人按钮
        if setpwFlag == 1 {
            let  yaoBtn = UIButton(type: .custom)
            yaoBtn.frame = CGRect(x: 0, y: maxHeiht, width: 32 + 70 + 32, height: 20)
            yaoBtn.setTitle("我有邀请人", for: .normal)
            yaoBtn.tag = 1000
            yaoBtn.addTarget(self, action: #selector(self.yaoBtnClick(sender:)), for: .touchUpInside)
            yaoBtn.setTitleColor(UIColor.hex("fcc30b"), for: .normal)
            yaoBtn.titleLabel?.font = UIFont.customFont(ofSize: 14)
            self.bgView.addSubview(yaoBtn)

            let yaoImgView = UIImageView(frame: CGRect(x: 16, y: 4, width: 8, height: 12))
            yaoImgView.image = UIImage(named:"user_q_setpw_normal")
            yaoImgView.centerY = yaoBtn.titleLabel?.centerY ?? 0
            yaoImgView.tag = 10000
            yaoBtn.addSubview(yaoImgView)
            maxHeiht = yaoBtn.maxY + 14

            yaoCodeTextField = UITextField(frame: CGRect(x: 16, y: maxHeiht, width: SCREEN_WIDTH - 32, height: 17))
            yaoCodeTextField.placeholder = "请输入邀请码(选填)"
            yaoCodeTextField.font = UIFont.customFont(ofSize: 16)
            yaoCodeTextField.textColor = UIColor.hex("333333")
            self.bgView.addSubview(yaoCodeTextField)
            maxHeiht = yaoCodeTextField.maxY + 18
            topBgView.height = yaoCodeTextField.y
            yaoCodeTextField.isHidden = true

            maxHeiht = yaoBtn.maxY + 40
        }else{
            topBgView.height = maxHeiht - 12
            maxHeiht = maxHeiht + 28

        }

        sureBtn = UIButton(type: .custom)
        sureBtn.frame = CGRect(x: 16, y: maxHeiht, width: SCREEN_WIDTH - 16 * 2, height: 64)
        sureBtn.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        sureBtn.addTarget(self, action: #selector(self.btnClick), for: .touchUpInside)
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.titleLabel?.font = UIFont.customFont(ofSize: 18)
        self.bgView.addSubview(sureBtn)
        maxHeiht = sureBtn.maxY + 21
    }

    @objc func yaoBtnClick(sender:UIButton) {
        yaoCodeTextField.resignFirstResponder()
        let  tempImgView = sender.viewWithTag(10000) as! UIImageView
        let tempPoint = tempImgView.center
        var tempImgName = "user_q_setpw_selected"
        var tempWidth = 12
        var tempHeight = 8
        var tempFlag = false
        var bottomY = yaoCodeTextField.maxY + 27
        if sender.tag == 1000 {
            sender.tag = 1001
        }else{
            sender.tag = 1000
            tempFlag = true
            tempImgName = "user_q_setpw_normal"
            tempWidth = 8
            tempHeight = 12
            bottomY = yaoCodeTextField.y
        }

        UIView.animate(withDuration: 0.3) {
             self.topBgView.height = bottomY
            self.yaoCodeTextField.isHidden = tempFlag
            tempImgView.width = CGFloat(tempWidth)
            tempImgView.height = CGFloat(tempHeight)
            tempImgView.center = tempPoint
            tempImgView.image = UIImage(named:tempImgName)
            self.sureBtn.y = self.topBgView.maxY + 40
        }
    }
    //网络请求
    @objc func btnClick(){
        let  temp1Str = (self.bgView.viewWithTag(100) as! UITextField).text
         let  temp2Str = (self.bgView.viewWithTag(101) as! UITextField).text

        if (temp1Str?.count)! < 6 {
            self.bgView.makeToast("密码不正确")
            return
        }

        if (temp2Str?.count)! < 6 {
            self.bgView.makeToast("密码不正确")
            return
        }

        if temp1Str != temp2Str {
            self.bgView.makeToast("两次密码不一致")
            return
        }
         var dic = ["pwd":temp1Str!,"surepwd":temp2Str!]
        if yaoCodeTextField != nil {
            dic["invite_code"] = yaoCodeTextField.text ?? ""
        }
        GPWNetwork.requetWithPost(url: User_setpwd, parameters: dic, responseJSON: {
            [weak self]  (json, msg) in
            guard let strongSelf = self else { return }
            strongSelf.bgView.makeToast(msg)
            GPWUser.sharedInstance().getUserInfo()
            if strongSelf.setpwFlag == 0 {
                strongSelf.navigationController?.popViewController(animated: true)
            }else{
                GPWGlobal.sharedInstance().gotoNiceNameFlag = true
                _ = strongSelf.navigationController?.popToRootViewController(animated: true)
            }
        }) { (error) in
        
        }
    }

    override func back(sender: GPWButton) {
        if setpwFlag == 0 {
            self.navigationController?.popViewController(animated: true)
        }else{
            GPWGlobal.sharedInstance().gotoNiceNameFlag = true
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
