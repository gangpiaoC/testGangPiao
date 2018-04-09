//
//  GPWUserRegisterViewController.swift
//  GangPiaoWang
//  注册
//  Created by gangpiaowang on 2016/12/19.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWUserRegisterViewController: GPWSecBaseViewController,RTLabelDelegate {

    //获取验证码
    var numRtlabel:RTLabel!
    var num:Int?
    //手机号是否注册过
    var flag = false
    //短信验证码
    var duanCode:String?

    //邀请码
    fileprivate var yaoCodeTextField:UITextField!

    var bottomView:UIView!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "注册"
        self.bgView.backgroundColor = UIColor.white
        let array = [
            ["img":"user_login_phone","place":"请输入手机号"],
            ["img":"user_regiter_code","place":"请输入验证码"],
            ["img":"user_login_pw","place":"由6-16位字母+数字组成"]
        ]
        var maxheight:CGFloat = 0
        for i in 0 ..< array.count {
            
            let imgView = UIImageView(frame: CGRect(x: 16, y: maxheight + 21, width: 18, height: 21))
            imgView.image = UIImage(named: array[i]["img"]!)
            self.bgView.addSubview(imgView)
            
            let  textField = UITextField(frame: CGRect(x: imgView.maxX + 14, y: imgView.y, width: 200, height: imgView.height))
            textField.placeholder = array[i]["place"]
            textField.tag = 100 + i
            textField.font = UIFont.customFont(ofSize: 16)
            self.bgView.addSubview(textField)
            
            if i == 1 {
                textField.width = SCREEN_WIDTH / 2
                numRtlabel = RTLabel(frame: CGRect(x: SCREEN_WIDTH - 100 - 16, y: 0, width: 100, height: 0))
                numRtlabel.text = "<a href='huoquyanzheng'><font size=16 color='#f6390d'>获取验证码</font></a>"
                numRtlabel.delegate = self
                numRtlabel.textAlignment = RTTextAlignmentRight
                numRtlabel.height = numRtlabel.optimumSize.height
                numRtlabel.centerY = textField.centerY
                self.bgView.addSubview(numRtlabel)
                
                let line = UIView(frame: CGRect(x: numRtlabel.x, y: maxheight + 22, width: 1, height: 20))
                line.backgroundColor = lineColor
                self.bgView.addSubview(line)
            }

            if i != 2 {
                textField.keyboardType = .numberPad
            }else{
                textField.isSecureTextEntry = true
            }
            maxheight = textField.maxY + 10
            let line = UIView(frame: CGRect(x: imgView.x, y: maxheight, width: SCREEN_WIDTH - imgView.x * 2, height: 0.5))
            line.backgroundColor = lineColor
            self.bgView.addSubview(line)
            maxheight = line.maxY
        }
        
        maxheight += 12
        //有邀请人按钮
        let  yaoBtn = UIButton(type: .custom)
        yaoBtn.frame = CGRect(x: 0, y: maxheight, width: 32 + 70 + 32, height: 20)
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
        maxheight = yaoBtn.maxY + 28
        maxheight = yaoBtn.maxY

        yaoCodeTextField = UITextField(frame: CGRect(x: 16, y: maxheight, width: SCREEN_WIDTH - 32, height: 16 + 16 + 16))
        yaoCodeTextField.placeholder = "请输入邀请码(选填)"
        yaoCodeTextField.keyboardType = .numberPad
        yaoCodeTextField.font = UIFont.customFont(ofSize: 16)
        yaoCodeTextField.textColor = UIColor.hex("333333")
        self.bgView.addSubview(yaoCodeTextField)

        let yaoLine = UIView(frame: CGRect(x: 0, y: yaoCodeTextField.height - 0.5, width: yaoCodeTextField.width, height: 0.5))
        yaoLine.backgroundColor = lineColor
        yaoCodeTextField.addSubview(yaoLine)

        maxheight = yaoBtn.maxY + 16
        bottomView = UIView(frame: CGRect(x: 0, y: maxheight, width: SCREEN_WIDTH, height: 0))
        bottomView.backgroundColor = UIColor.white
        self.bgView.addSubview(bottomView)

        maxheight = 0
        let nextBtn = UIButton(type: .custom)
        nextBtn.frame = CGRect(x: 10, y: maxheight, width: SCREEN_WIDTH - 10 * 2, height: 64)
        nextBtn.setTitle("立即注册", for: .normal)
        nextBtn.addTarget(self, action: #selector(self.btnClick), for: .touchUpInside)
        nextBtn.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        bottomView.addSubview(nextBtn)
        maxheight = nextBtn.maxY + 18
        
        let label = RTLabel(frame: CGRect(x: 0 , y: maxheight, width: SCREEN_WIDTH, height: 12))
        label.text = "<font size=14 color='#999999'>注册即同意</font><a href='gotoxieyi'><font size=14 color='#00affe'>《钢票网用户注册协议》</font></a>"
        label.delegate = self
        label.textAlignment =  RTTextAlignmentCenter
        label.height = label.optimumSize.height
        bottomView.addSubview(label)
        maxheight = label.maxY + 20
        
        //登录
        let loginBtn = UIButton(frame: CGRect(x: 0, y:  maxheight, width:  SCREEN_WIDTH, height: 20))
        loginBtn.tag = 100
        loginBtn.addTarget(self, action: #selector(self.loginClick), for: .touchUpInside)
        bottomView.addSubview(loginBtn)
        
        let titleLabel = UILabel(frame: loginBtn.bounds)
        titleLabel.attributedText = NSAttributedString.attributedString( "已有帐号？", mainColor: UIColor.hex("666666"), mainFont: 16, second: "请登录", secondColor: redTitleColor, secondFont: 16)
        titleLabel.textAlignment = .center
        loginBtn.addSubview(titleLabel)

        maxheight = loginBtn.maxY + 50
        
        let  bottomLabel = RTLabel(frame: CGRect(x: 0, y: maxheight, width: SCREEN_WIDTH, height: 22))
        bottomLabel.text = "<font size=16 color='#f6390d'>注册送\(GPWGlobal.sharedInstance().app_exper_amount)元体验金 </font>"
        bottomLabel.textAlignment = RTTextAlignmentCenter
        bottomLabel.height = bottomLabel.optimumSize.height
        bottomView.addSubview(bottomLabel)

        maxheight = bottomLabel.maxY + 11
        
        let  bottomImgView = UIImageView(frame: CGRect(x: 0, y: bottomLabel.maxY + 20, width: 90, height: 54))
        bottomImgView.centerX = SCREEN_WIDTH / 2
        bottomImgView.image = UIImage(named: "user_zhuce_bottom")
        bottomView.addSubview(bottomImgView)
        bottomView.height = bottomLabel.maxY
    }

    @objc func yaoBtnClick(sender:UIButton) {
        yaoCodeTextField.resignFirstResponder()
        let  tempImgView = sender.viewWithTag(10000) as! UIImageView
        let tempPoint = tempImgView.center
        var tempImgName = "user_q_setpw_normal"
        var tempWidth = 8
        var tempHeight = 12
        var bottomY = sender.maxY + 16
        if sender.tag == 1000 {
            sender.tag = 1001
            tempImgName = "user_q_setpw_selected"
            tempWidth = 12
            tempHeight = 8
            bottomY = yaoCodeTextField.maxY + 27
        }else{
            sender.tag = 1000
        }

        UIView.animate(withDuration: 0.5) {
            self.bottomView.y = bottomY
            tempImgView.width = CGFloat(tempWidth)
            tempImgView.height = CGFloat(tempHeight)
            tempImgView.center = tempPoint
            tempImgView.image = UIImage(named:tempImgName)
        }
    }
    
    @objc func loginClick() {
        let vc = GPWLoginViewController()
        vc.flag = "1"
        self.navigationController?.pushViewController(vc, animated: true)
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
            numRtlabel.text = "<a href='huoquyanzheng'><font size=16 color='#f6390d'>获取验证码</font></a>"
        }else{
            numRtlabel.text = "<a href='eeee'><font size=14 color='#f6390d'>"+String(describing: num!)+"s</font><font size=14 color='#333333'>后重新发送</font></a>"
        }
    }
    
    @objc func btnClick() {
        let phoneNum = (self.bgView.viewWithTag(100) as! UITextField).text!
        let code = (self.bgView.viewWithTag(101) as! UITextField).text!
        let pw = (self.bgView.viewWithTag(102) as! UITextField).text ?? ""

        //验证密码是否符合
        let regex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if  phoneNum.count != 11 {
            self.bgView.makeToast("请输入正确手机号")
        }else if self.flag == false {
            self.bgView.makeToast("手机已注册过")
        }else{
            if predicate.evaluate(with: pw) {
                if GPWHelper.judgePhoneNum(phoneNum){
                    if code.count > 0{
                        GPWNetwork.requetWithPost(url: Register_next, parameters: ["mobile":phoneNum,"news_captcha":code], responseJSON: { [weak self]  (json, msg) in
                            guard let strongSelf = self else { return }
                            printLog(message: json)
                            strongSelf.zhuceData()
                        }) { (error) in

                        }
                    }else{
                        self.bgView.makeToast("请输入验证码")
                    }
                }else{
                    self.bgView.makeToast("请输入正确手机号")
                }
            }else{
                self.bgView.makeToast("密码为6-16个字符，由字母+数字和符号两种以上组合")
            }
        }
    }

    //注册
    func zhuceData() {
        let phoneNum = (self.bgView.viewWithTag(100) as! UITextField).text!
        let pw = (self.bgView.viewWithTag(102) as! UITextField).text!
        var dic = ["mobile":phoneNum]
        dic["password"] = pw
        let yaostr = yaoCodeTextField.text ?? ""
        if yaostr.count > 1 {
            dic["invite_code"] = yaostr
        }
        GPWNetwork.requetWithPost(url: Depose_register, parameters: dic, responseJSON:  {
            [weak self] (json, msg) in
            guard let strongSelf = self else { return }
            GPWUser.sharedInstance().analyUser(dic: json)
            strongSelf.navigationController?.pushViewController(GPWUserRegisterSViewController(), animated: true)
            }, failure: { error in
        })
    }

    func rtLabel(_ rtLabel: Any!, didSelectLinkWithURL url: String!) {
        if url == "gotoxieyi" {
            let urlstr = "https://www.gangpiaowang.com/Web/user_agreement.html"
            self.navigationController?.pushViewController(GPWWebViewController(subtitle:"",url:urlstr), animated: true)
        }else if url == "huoquyanzheng"{
              let phoneNum = (self.bgView.viewWithTag(100) as! UITextField).text!
            if  GPWHelper.judgePhoneNum(phoneNum) {
                GPWNetwork.requetWithPost(url: Num_phone, parameters: ["phone":phoneNum], responseJSON: {
                    [weak self] (json, msg) in
                    guard let strongSelf = self else { return }
                    printLog(message: json)
                      strongSelf.duanCode = json["check_captcha"].stringValue
                    if json["phmo"].intValue == 1{
                        strongSelf.bgView.makeToast(msg)
                        strongSelf.flag = false
                    }else{
                         strongSelf.flag = true
                        strongSelf.getVerificationCode()
                        strongSelf.num = 60
                        strongSelf.numRtlabel.text = "<a href='eeee'><font size=14 color='#f6390d'>"+String(describing: strongSelf.num!)+"s</font><font size=14 color='#333333'>后重新发送</font></a>"
                        strongSelf.startTime()
                    }
                    }, failure: { (error) in
                })
            }else{
                self.bgView.makeToast("请输入正确手机号")
            }
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
}
