//
//  GPWQuirstView.swift
//  GangPiaoWang
//  快捷登录
//  Created by gangpiaowang on 2017/3/21.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
class GPWQuirstView: UIView,RTLabelDelegate {
    var superController:UIViewController?
    //如何回去  1首页  其他 上一级
    var flag:String?
    //如果为0 返回  如果未1设置手势密码
    var setGestureFlag = "0"
    //获取验证码
    private var numRtlabel:RTLabel!
    private var num:Int?
    private var duanCode:String?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.comminit()
        flag = "0"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func comminit()  {
        let array = [
            ["img":"user_login_phone","place":"请输入手机号"],    ["img":"user_login_code","place":"请输入手机验证码"]
        ]
        
        var maxHeiht:CGFloat = 20.0
        for i in 0 ..< array.count  {
            let imgView = UIImageView(frame: CGRect(x: 16, y: maxHeiht + 21, width: 18, height: 21))
            imgView.image = UIImage(named: array[i]["img"]!)
            self.addSubview(imgView)
            
            let  textField = UITextField(frame: CGRect(x: imgView.maxX + 14, y: imgView.y, width: 160, height: imgView.height))
            textField.placeholder = array[i]["place"]
            textField.tag = 1000 + i
            textField.font = UIFont.customFont(ofSize: 16)
             textField.keyboardType = .numberPad
            if (i == 1) {
                //验证码按钮
                numRtlabel = RTLabel(frame: CGRect(x: SCREEN_WIDTH - 80 - 16, y: textField.y, width: 70 + 16, height: textField.height))
                numRtlabel.backgroundColor = UIColor.white
                numRtlabel.text = "<a href='huoquyanzheng'><font size=13 color='#f6390d'>获取验证码</font></a>"
                numRtlabel.delegate = self
                numRtlabel.textAlignment = RTTextAlignmentCenter
                numRtlabel.height = numRtlabel.optimumSize.height
                numRtlabel.centerY = textField.centerY
                self.addSubview(numRtlabel)

                let  shuLine = UIView(frame: CGRect(x: numRtlabel.x - 18, y: 0, width: 0.5, height: 20))
                shuLine.backgroundColor = lineColor
                shuLine.centerY = textField.centerY
                self.addSubview(shuLine)
            }else{
                let phone = UserDefaults.standard.value(forKey: USER了OGINPHONE)
                if phone != nil {
                    textField.text = phone as? String
                }
            }
            self.addSubview(textField)
            let line = UIView(frame: CGRect(x: imgView.x, y: textField.maxY + 8, width: SCREEN_WIDTH - imgView.x * 2 , height: 0.5))
            line.backgroundColor = lineColor
            self.addSubview(line)
            maxHeiht = line.maxY
        }
        
        maxHeiht += 40
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 10, y: maxHeiht, width: SCREEN_WIDTH - 10 * 2, height: 64)
        btn.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 16)
        btn.addTarget(self, action: #selector(self.btnClick(sender:)), for: .touchUpInside)
        btn.tag = 100
        btn.setTitle("登录", for: .normal)
        self.addSubview(btn)
        maxHeiht = btn.maxY + 21
    }
    
    @objc func btnClick(sender:UIButton) {
        if sender.tag == 100 {
            printLog(message: "登录")
            let acountNum = (self.viewWithTag(1000) as! UITextField).text!
            let codeStr = (self.viewWithTag(1001) as! UITextField).text!
            if GPWHelper.judgePhoneNum(acountNum){
                if codeStr.characters.count == 0 {
                    self.makeToast("请输入验证码")
                    return
                }else{
                  //登录
                    GPWNetwork.requetWithPost(url: Quick_login, parameters: ["mobile":acountNum,"captcha":codeStr], responseJSON: {[weak self] (json, msg) in
                        guard let strongSelf = self else { return }
                        GPWUser.sharedInstance().getUserInfo()
                        GPWUser.sharedInstance().analyUser(dic: json)
                         UserDefaults.standard.set(acountNum, forKey: USER了OGINPHONE)
                        MobClick.event("__cust_event_3")
                        MobClick.event("__login", attributes:["userid":GPWUser.sharedInstance().user_name ?? "00"])
                        if json["userinfo"]["zhu"].intValue == 1 {
                            strongSelf.superController?.navigationController?.pushViewController(GPWUserQSetPWViewController(), animated: true)
                        }else{
                            //获取存储的用户帐号和手势密码
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
                    }, failure: { (error) in
                        
                    })
                }
            }else{
                 self.makeToast("手机号有误")
            }
        }else if sender.tag == 101 {
            printLog(message: "注册")
        }
    }
    
    func startTime() {
        let timer:Timer = Timer(timeInterval: 1.0,
                                target: self,
                                selector: #selector(self.updateTimer(timer:)),
                                userInfo: nil,
                                repeats: true)
        
        // 将定时器添加到运行循环
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    @objc func updateTimer(timer:Timer) {
        num  = num! - 1
        if (num == 0) {
            timer.invalidate()
            CFRunLoopStop(CFRunLoopGetCurrent())
            numRtlabel.text = "<a href='huoquyanzheng'><font size=13 color='#f6390d'>获取验证码</font></a>"
        }else{
            numRtlabel.text = "<a href='eeee'><font size=13 color='#f6390d'>"+String(describing: num!)+"s</font><font size=11 color='#333333'>后重新发送</font></a>"
        }
    }
    func rtLabel(_ rtLabel: Any!, didSelectLinkWithURL url: String!) {
        if url == "huoquyanzheng"{
            let phoneNum = (self.viewWithTag(1000) as! UITextField).text!
            if  GPWHelper.judgePhoneNum(phoneNum) {
                GPWNetwork.requetWithGet(url: Quick_captcha, parameters: nil, responseJSON: {
                    [weak self] (json, msg) in
                    guard let strongSelf = self else { return }
                    printLog(message: json)
                    strongSelf.duanCode = json.string
                    strongSelf.getVerificationCode(phone: phoneNum)
                    strongSelf.num = 60
                    strongSelf.numRtlabel.text = "<a href='eeee'><font size=13 color='#f6390d'>"+String(describing: strongSelf.num!)+"s</font><font size=13 color='#333333'>后重新发送</font></a>"
                    strongSelf.startTime()
                }) { (error) in
                    
                }
            }else{
                self.makeToast("请输入正确手机号")
            }
        }else if url == "zhuce" {
            self.superController?.navigationController?.pushViewController(GPWUserRegisterViewController(), animated: true)
        }
    }
    //获取验证码
    func getVerificationCode(phone:String)  {
        printLog(message: self.duanCode)
        let phoneNum = (self.viewWithTag(1000) as! UITextField).text!
        GPWNetwork.requetWithPost(url: Get_news_captcha_app, parameters: ["mobile":phoneNum,"check_captcha":self.duanCode ?? "0"], responseJSON: { [weak self]  (json, msg) in
            guard let strongSelf = self else { return }
            strongSelf.makeToast(msg)
        }) { (error) in
            
        }
    }
}
