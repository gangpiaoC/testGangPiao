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
    fileprivate var inviterTextField:UITextField!
    let yaoImgView = UIImageView(frame: CGRect(x: 16, y: 4, width: 8, height: 12))

    var bottomView:UIView!
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView(bgColor: UIColor.white)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        return scrollView
    }()
    let inviterBgView = UIView(bgColor: UIColor.white)
    let acceptButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "user_register_acceptUnSelected"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "user_register_acceptSelected"), for: .selected)
        button.isSelected = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "快速注册"
        self.bgView.backgroundColor = UIColor.white
        bgView.addSubview(scrollView)
        
        var maxheight:CGFloat = 0
        
        let  topImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: pixw(p: 98)))
        topImgView.image = UIImage(named: "user_zhuce_bottom")
        scrollView.addSubview(topImgView)
        
        let array = [
            ["tip":"手机号","place":"请输入手机号"],
            ["tip":"验证码","place":"请输入手机验证码"],
            ["tip":"登录密码","place":"含字母+数字的6-16个字符"]
        ]
        maxheight = topImgView.maxY
        for i in 0 ..< array.count {
            
            let tipLabel = UILabel(frame: CGRect(x: 16, y: maxheight + 21, width: 66, height: 21))
            tipLabel.textColor = titleColor
            tipLabel.font = UIFont.systemFont(ofSize: 16)
            tipLabel.text = array[i]["tip"]
            scrollView.addSubview(tipLabel)
            
            let  textField = UITextField(frame: CGRect(x: tipLabel.maxX + 14, y: tipLabel.y, width: 200, height: tipLabel.height))
            textField.placeholder = array[i]["place"]
            textField.tag = 100 + i
            textField.font = UIFont.customFont(ofSize: 16)
            scrollView.addSubview(textField)
            
            if i == 1 {
                textField.width = SCREEN_WIDTH / 2
                numRtlabel = RTLabel(frame: CGRect(x: SCREEN_WIDTH - 100 - 16, y: 0, width: 100, height: 0))
                numRtlabel.text = "<a href='huoquyanzheng'><font size=16 color='#fa713d'>获取验证码</font></a>"
                numRtlabel.delegate = self
                numRtlabel.textAlignment = RTTextAlignmentRight
                numRtlabel.height = numRtlabel.optimumSize.height
                numRtlabel.centerY = textField.centerY
                scrollView.addSubview(numRtlabel)
                
                let line = UIView(frame: CGRect(x: numRtlabel.x, y: maxheight + 22, width: 1, height: 20))
                line.backgroundColor = lineColor
                scrollView.addSubview(line)
            }

            if i != 2 {
                textField.keyboardType = .numberPad
            }else{
                textField.isSecureTextEntry = true
            }
            maxheight = textField.maxY + 20
            let line = UIView(frame: CGRect(x: tipLabel.x, y: maxheight, width: SCREEN_WIDTH - tipLabel.x * 2, height: 1))
            line.backgroundColor = lineColor
            scrollView.addSubview(line)
            maxheight = line.maxY
        }
        
        inviterBgView.frame = CGRect(x: 0, y: maxheight, width: SCREEN_WIDTH, height: 0)
        scrollView.addSubview(inviterBgView)
        
        let yaoCodeLabel = UILabel(frame: CGRect(x: 16, y: 21, width: 66, height: 21))
        yaoCodeLabel.textColor = titleColor
        yaoCodeLabel.font = UIFont.systemFont(ofSize: 16)
        yaoCodeLabel.text = "邀请人"
        inviterBgView.addSubview(yaoCodeLabel)
        
        inviterTextField = UITextField(frame: CGRect(x: yaoCodeLabel.maxX + 14, y: yaoCodeLabel.y, width: 200, height: yaoCodeLabel.height))
        inviterTextField.placeholder = "请输入邀请人手机号(选填)"
        inviterTextField.keyboardType = .numberPad
        inviterTextField.font = UIFont.customFont(ofSize: 16)
        inviterTextField.textColor = UIColor.hex("333333")
        inviterBgView.addSubview(inviterTextField)
        
        let yaoLine = UIView(frame: CGRect(x: yaoCodeLabel.x, y: 56 - 1, width: SCREEN_WIDTH - yaoCodeLabel.x * 2, height: 1))
        yaoLine.backgroundColor = lineColor
        inviterBgView.addSubview(yaoLine)
        
        maxheight = inviterBgView.maxY
        
        bottomView = UIView(frame: CGRect(x: 0, y: maxheight, width: SCREEN_WIDTH, height: 0))
        bottomView.backgroundColor = UIColor.white
        scrollView.addSubview(bottomView)
        //有邀请人按钮
        let  yaoBtn = UIButton(type: .custom)
        yaoBtn.frame = CGRect(x: 0, y: 12, width: 32 + 70 + 32, height: 20)
        yaoBtn.setTitle("我有邀请人", for: .normal)
        yaoBtn.addTarget(self, action: #selector(yaoBtnClick(sender:)), for: .touchUpInside)
        yaoBtn.setTitleColor(UIColor.hex("f5a623"), for: .normal)
        yaoBtn.titleLabel?.font = UIFont.customFont(ofSize: 14)
        bottomView.addSubview(yaoBtn)

        yaoImgView.image = UIImage(named:"user_q_setpw_normal")
        yaoImgView.centerY = yaoBtn.titleLabel?.centerY ?? 0
        yaoBtn.addSubview(yaoImgView)
        
        maxheight = yaoBtn.maxY + 34
        let registerButton = UIButton(type: .custom)
        registerButton.frame = CGRect(x: 16, y: maxheight, width: SCREEN_WIDTH - 16 * 2, height: 48)
        registerButton.setTitle("完成注册", for: .normal)
        registerButton.addTarget(self, action: #selector(self.btnClick), for: .touchUpInside)
        registerButton.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        bottomView.addSubview(registerButton)
        maxheight = registerButton.maxY + 8
        
        acceptButton.frame = CGRect(x: 8, y: maxheight, width: 30, height: 30)
        acceptButton.addTarget(self, action: #selector(acceptButtonAction(_:)), for: .touchUpInside)
        bottomView.addSubview(acceptButton)
        
        let protocalLabel = RTLabel(frame: CGRect(x: acceptButton.maxX  , y: maxheight, width: SCREEN_WIDTH, height: 14))
        protocalLabel.text = "<font size=14 color='#999999'>同意</font><a href='gotoxieyi'><font size=14 color='#4585f5'>《钢票网用户注册协议》</font></a>"
        protocalLabel.delegate = self
        protocalLabel.textAlignment =  RTTextAlignmentLeft
        protocalLabel.height = protocalLabel.optimumSize.height
        bottomView.addSubview(protocalLabel)
        protocalLabel.centerY = acceptButton.centerY
        bottomView.height = protocalLabel.maxY
        maxheight += protocalLabel.maxY + 16
        
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT < 568 + 216 ? 568 + 216 : SCREEN_HEIGHT)
    }

    @objc func acceptButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @objc func yaoBtnClick(sender:UIButton) {
        inviterTextField.resignFirstResponder()
        sender.isSelected = !sender.isSelected
        var transform = CGAffineTransform.identity
        if sender.isSelected {  //
            transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 0.5))
            inviterBgView.height = 56
        } else {
            inviterBgView.height = 0
        }
        let bottomY = inviterBgView.maxY
        
        UIView.animate(withDuration: 0.25) {
            self.yaoImgView.transform = transform
            self.bottomView.y = bottomY
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
            numRtlabel.text = "<a href='huoquyanzheng'><font size=16 color='#fa713d'>获取验证码</font></a>"
        }else{
            numRtlabel.text = "<a href='eeee'><font size=14 color='#fa713d'>"+String(describing: num!)+"s</font><font size=14 color='#333333'>后重新发送</font></a>"
        }
    }
    
    @objc func btnClick() {
        let phoneNum = (self.bgView.viewWithTag(100) as! UITextField).text!
        let code = (self.bgView.viewWithTag(101) as! UITextField).text!
        let pw = (self.bgView.viewWithTag(102) as! UITextField).text ?? ""
        
        if !acceptButton.isSelected {
            self.bgView.makeToast("请先同意《钢票网用户注册协议》")
            return
        }
        
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
        let yaostr = inviterTextField.text ?? ""
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
                        strongSelf.numRtlabel.text = "<a href='eeee'><font size=14 color='#fa713d'>"+String(describing: strongSelf.num!)+"s</font><font size=14 color='#333333'>后重新发送</font></a>"
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
