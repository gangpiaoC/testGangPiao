//
//  GPWUserForgetPwViewController.swift
//  GangPiaoWang
// 忘记密码
//  Created by gangpiaowang on 2016/12/19.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWUserForgetPwViewController: GPWSecBaseViewController,RTLabelDelegate {

    //获取验证码
    var numRtlabel:RTLabel!
    var num:Int?
    //下一步
    var nextBtn:UIButton!
    //手机号是否注册过
    var flag = false
    //短信验证码
    var duanCode:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "找回密码"
        self.bgView.backgroundColor = UIColor.white
        let imgView = UIImageView(frame: CGRect(x: 0, y: 23, width: 70, height: 66))
        imgView.image = UIImage(named: "user_forget_top")
        imgView.centerX = SCREEN_WIDTH / 2
        self.bgView.addSubview(imgView)
        
        let temp1Label = UILabel(frame: CGRect(x: 0, y: imgView.maxY + 10, width: SCREEN_WIDTH, height: 25))
        temp1Label.text = "找回密码"
        temp1Label.centerX = imgView.centerX
        temp1Label.textAlignment = .center
        temp1Label.font = UIFont.customFont(ofSize: 18)
        temp1Label.textColor = UIColor.hex("666666")
        self.bgView.addSubview(temp1Label)
        
        let array = ["请输入手机号","请输入验证码"]
        var maxheight = temp1Label.maxY + 50 - 17
        for i in 0 ..< array.count {
            let textField = UITextField(frame: CGRect(x: 16, y: maxheight, width: SCREEN_WIDTH - 32, height: 17 * 2 + 12))
            textField.placeholder = array[i]
            textField.font = UIFont.customFont(ofSize: 16)
            textField.keyboardType = .numberPad
            textField.textColor = UIColor.hex("333333")
            textField.tag = 100 + i
            self.bgView.addSubview(textField)
            
            if i == 1 {
                textField.width = SCREEN_WIDTH / 2
                numRtlabel = RTLabel(frame: CGRect(x: SCREEN_WIDTH - 100 - 16, y: 0, width: 100, height: 0))
                numRtlabel.text = "<a href='huoxuyanzheng'><font size=11 color='#00affe'>获取验证码</font></a>"
                numRtlabel.delegate = self
                numRtlabel.textAlignment = RTTextAlignmentRight
                numRtlabel.height = numRtlabel.optimumSize.height
                numRtlabel.centerY = textField.centerY
                self.bgView.addSubview(numRtlabel)
            }

            maxheight = textField.maxY
            let line = UIView(frame: CGRect(x: textField.x, y: maxheight, width: SCREEN_WIDTH - 32, height: 0.5))
            line.backgroundColor = lineColor
            self.bgView.addSubview(line)
            maxheight = line.maxY
        }
        
        maxheight += 32
        nextBtn = UIButton(type: .custom)
        nextBtn.frame = CGRect(x: 10, y: maxheight, width: SCREEN_WIDTH - 10 * 2, height: 64)
        nextBtn.setTitle("下一步", for: .normal)
        nextBtn.addTarget(self, action: #selector(self.btnClick), for: .touchUpInside)
        nextBtn.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        self.bgView.addSubview(nextBtn)
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
            numRtlabel.text = "<a href='huoxuyanzheng'><font size=11 color='#00affe'>获取验证码</font></a>"
        }else{
            numRtlabel.text = "<a href='eeee'><font size=11 color='#f6390d'>"+String(describing: num!)+"s</font><font size=11 color='#333333'>后重新发送</font></a>"
        }
    }

    func rtLabel(_ rtLabel: Any!, didSelectLinkWithURL url: String!) {
        if url == "gotoxieyi" {
            let urlstr = "https://www.gangpiaowang.com/Web/user_agreement.html"
            self.navigationController?.pushViewController(GPWWebViewController(subtitle:"",url:urlstr), animated: true)
        }else if url == "huoxuyanzheng"{
            let phoneNum = (self.bgView.viewWithTag(100) as! UITextField).text!
            if  GPWHelper.judgePhoneNum(phoneNum) {
                GPWNetwork.requetWithPost(url: Num_phone, parameters: ["phone":phoneNum], responseJSON: {
                    [weak self] (json, msg) in
                    guard let strongSelf = self else { return }
                    printLog(message: json)
                     strongSelf.duanCode = json["check_captcha"].stringValue
                    if json["phmo"].intValue == 0 {
                        strongSelf.flag = false
                        strongSelf.bgView.makeToast(msg)
                    }else{
                         strongSelf.flag = true
                        strongSelf.getVerificationCode()
                        strongSelf.num = 60
                        strongSelf.numRtlabel.text = "<a href='eeee'><font size=11 color='#f6390d'>"+String(describing: strongSelf.num!)+"s</font><font size=11 color='#333333'>后重新发送</font></a>"
                        strongSelf.startTime()
                    }
                    }, failure: { (error) in
                })
            }else{
                self.bgView.makeToast("请输入正确手机号")
            }
        }
    }
    @objc func btnClick() {
        let phone = (self.bgView.viewWithTag(100) as! UITextField).text ?? ""

        if GPWHelper.judgePhoneNum(phone){
            if  self.flag == false{
                bgView.makeToast("手机未注册")
            }else if GPWHelper.judgePhoneNum(phone) {
                let code = (self.bgView.viewWithTag(101) as! UITextField).text ?? ""
                if code.characters.count == 0 {
                    bgView.makeToast("请输入验证码")
                    return
                }
                GPWNetwork.requetWithPost(url: Forget_next, parameters: ["mobile":phone,"news_captcha":code], responseJSON: { [weak self]  (json, msg) in
                    guard let strongSelf = self else { return }
                    let setLoginpwControl = GPWUserRePwViewController()
                    setLoginpwControl.phone = phone
                    strongSelf.navigationController?.pushViewController(setLoginpwControl, animated: true)
                }) { (error) in

                }
            }else{
                bgView.makeToast( "请输入正确手机号")
            }
        }else{
             bgView.makeToast("请输入正确手机号")
        }
    }
    //获取验证码
    func getVerificationCode()  {
        let phoneNum = (self.bgView.viewWithTag(100) as! UITextField).text!
        GPWNetwork.requetWithPost(url: Get_news_captcha_app, parameters: ["mobile":phoneNum,"check_captcha":self.duanCode ?? "0"], responseJSON: { [weak self]  (json, msg) in
            guard let strongSelf = self else { return }
            strongSelf.bgView.makeToast(msg)
        }) { (error) in
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
