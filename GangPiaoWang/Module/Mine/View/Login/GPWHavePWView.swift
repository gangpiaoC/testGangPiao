//
//  GPWHavePWView.swift
//  GangPiaoWang
//   密码登录
//  Created by gangpiaowang on 2017/3/21.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWHavePWView: UIView {
    var superController:UIViewController?
    //如何回去  1首页  其他 上一级
    var flag:String?
    //如果为0 返回  如果未1设置手势密码
    var setGestureFlag = "0"
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.comminit()
        flag = "0"
    }
    func comminit()  {
        let array = [
            ["img":"user_login_phone","place":"请输入手机号"],    ["img":"user_login_pw","place":"请输入密码"]
        ]
        
        var maxHeiht:CGFloat = 20.0
        for i in 0 ..< array.count  {
            let imgView = UIImageView(frame: CGRect(x: 16, y: maxHeiht + 21, width: 18, height: 21))
            imgView.image = UIImage(named: array[i]["img"]!)
            self.addSubview(imgView)
            
            let  textField = UITextField(frame: CGRect(x: imgView.maxX + 14, y: imgView.y, width: 200, height: imgView.height))
            textField.placeholder = array[i]["place"]
            textField.tag = 100 + i
            textField.font = UIFont.customFont(ofSize: 16)
            if (i == 1) {
                textField.isSecureTextEntry = true
                let  pwBtn = UIButton(type: .custom)
                pwBtn.frame = CGRect(x: SCREEN_WIDTH - 37 - 19, y: 0, width: 19, height: 11)
                self.addSubview(pwBtn)
                pwBtn.imageView?.contentMode = .scaleAspectFill
                pwBtn.setImage( UIImage(named: "user_login_closeeye"), for: .normal)
                pwBtn.tag = 1000
                pwBtn.addTarget(self, action: #selector(self.eyeBtnClick(sender:)), for: .touchUpInside)
                pwBtn.centerY = textField.centerY
            }else{
                textField.keyboardType = .numberPad
                let phone = UserDefaults.standard.value(forKey: USER了OGINPHONE)
                if phone != nil {
                    textField.text = phone as? String
                }
            }
            self.addSubview(textField)
            
            let line = UIView(frame: CGRect(x: imgView.x, y: textField.maxY + 8, width: SCREEN_WIDTH - imgView.x * 2, height: 0.5))
            line.backgroundColor = lineColor
            self.addSubview(line)
            maxHeiht = line.maxY
        }
        
        maxHeiht += 40
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 10, y: maxHeiht, width: SCREEN_WIDTH - 10 * 2, height: 64)
        btn.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        btn.addTarget(self, action: #selector(self.btnClick(sender:)), for: .touchUpInside)
        btn.tag = 100
        btn.titleLabel?.font = UIFont.customFont(ofSize: 16)
        btn.setTitle("登录", for: .normal)
        self.addSubview(btn)
        maxHeiht = btn.maxY + 21
        
        //注册
        let zhuceBtn = UIButton(type: .custom)
        zhuceBtn.frame = CGRect(x: btn.x, y: maxHeiht, width: 80, height: 13)
        zhuceBtn.setTitle("注册领红包", for: .normal)
        zhuceBtn.setTitleColor(redColor, for: .normal)
        zhuceBtn.addTarget(self, action: #selector(self.btnClick(sender:)), for: .touchUpInside)
        zhuceBtn.titleLabel?.font = UIFont.customFont(ofSize: 14)
        zhuceBtn.tag = 101
        self.addSubview(zhuceBtn)
        
        //忘记密码
        let forgetPwBtn = UIButton(type: .custom)
        forgetPwBtn.frame = CGRect(x: SCREEN_WIDTH - 38 - 60, y: maxHeiht, width: 60, height: 13)
        forgetPwBtn.setTitle("忘记密码", for: .normal)
        forgetPwBtn.addTarget(self, action: #selector(self.btnClick(sender:)), for: .touchUpInside)
        forgetPwBtn.titleLabel?.font = UIFont.customFont(ofSize: 14)
        forgetPwBtn.setTitleColor(redColor, for: .normal)
        forgetPwBtn.tag = 102
        self.addSubview(forgetPwBtn)
    }
    @objc func eyeBtnClick(sender:UIButton)  {
         let pw = self.viewWithTag(101) as! UITextField
        if sender.tag == 1000 {
            sender.tag = 1001
             pw.isSecureTextEntry = false
             sender.setImage( UIImage(named: "user_login_openeye"), for: .normal)
        }else{
            sender.tag = 1000
             pw.isSecureTextEntry = true
             sender.setImage( UIImage(named: "user_login_closeeye"), for: .normal)
        }
        
    }
    @objc func btnClick(sender:UIButton) {
        if sender.tag == 100 {
            printLog(message: "登录")
            let acountNum = (self.viewWithTag(100) as! UITextField).text!
            let pw = (self.viewWithTag(101) as! UITextField).text!
            if GPWHelper.judgePhoneNum(acountNum){
                if pw.count == 0 {
                    self.makeToast("请输入密码")
                    return
                }
                GPWNetwork.requetWithPost(url: Login, parameters: ["phones":acountNum,"pwd":pw], responseJSON: {[weak self] (json, msg) in
                    guard let strongSelf = self else { return }
                    GPWUser.sharedInstance().analyUser(dic: json)
                    printLog(message: json)
                    MobClick.event("__cust_event_3")
                    MobClick.event("__login", attributes:["userid":GPWUser.sharedInstance().user_name ?? "00"])
                    //获取存储的用户帐号和手势密码
                    UserDefaults.standard.set(acountNum, forKey: USER了OGINPHONE)
                    let  tempStr = UserDefaults.standard.value(forKey: USERPHONEGETURE)
                    var gesture = ""
                    if tempStr != nil {
                        let  temArray = (tempStr as! String).components(separatedBy: "@")
                        for str in temArray {
                             let  temSubArray = str.components(separatedBy: "+")
                            if temSubArray[0] == acountNum {
                                gesture = temSubArray[1]
                                GYCircleConst.saveGesture(gesture, key: gestureFinalSaveKey)
                            }
                        }
                    }
                    
                    let  pw = UserDefaults.standard.value(forKey: "firstG") as? String ?? ""
                    if pw == ""  && gesture != ""{
                        UserDefaults.standard.set("firstG", forKey: "firstG")
                        if GYCircleConst.getGestureWithKey(gestureFinalSaveKey) == nil {
                            let gestureVC = GestureViewController()
                            gestureVC.type = GestureViewControllerType.setting
                            gestureVC.flag = true
                            _ = strongSelf.superController?.navigationController?.pushViewController(gestureVC, animated: true)
                        }
                    }else{
                        if strongSelf.setGestureFlag == "1" {
                            let gestureVC = GestureViewController()
                            gestureVC.type = GestureViewControllerType.setting
                            gestureVC.flag = true
                            _ = GPWHelper.selectedNavController()?.pushViewController(gestureVC, animated: true)
                        }else{
                            if strongSelf.flag == "1" {
                                _ = strongSelf.superController?.navigationController?.popToRootViewController(animated: true)
                            }else{
                                _ = strongSelf.superController?.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                    
                    }, failure: {_ in })
            }else{
                self.makeToast("请输入正确手机号")
            }
            
        }else if sender.tag == 101 {
            printLog(message: "注册")
            superController?.navigationController?.pushViewController(GPWUserRegisterViewController(), animated: true)
        }else{
            printLog(message: "忘记密码")
            superController?.navigationController?.pushViewController(GPWUserForgetPwViewController(), animated: true)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}
