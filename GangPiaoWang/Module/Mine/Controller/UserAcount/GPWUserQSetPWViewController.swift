//
//  GPWUserQSetPWViewController.swift
//  GangPiaoWang
//  快捷登录设置密码
//  Created by gangpiaowang on 2017/3/23.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWUserQSetPWViewController: GPWSecBaseViewController {
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView(bgColor: UIColor.hex("f2f2f2"))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入手机号"
        textField.font = UIFont.customFont(ofSize: 16)
        textField.keyboardType = .numberPad
        textField.isEnabled = false
        return textField
    }()
    let authTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入手机验证码"
        textField.font = UIFont.customFont(ofSize: 16)
        textField.keyboardType = .numberPad
        return textField
    }()
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "含字母+数字的6-16个字符"
        textField.font = UIFont.customFont(ofSize: 16)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let authRTBgView = UIView(bgColor: UIColor.clear)
    lazy var authRTLabel: RTLabel = {
        let label = RTLabel(frame: CGRect(x: 0, y: 9, width: 100, height: 0))
        label.text = "<a href='huoquyanzheng'><font size=16 color='#fa713d'>获取验证码</font></a>"
        label.delegate = self
        label.textAlignment = RTTextAlignmentRight
        label.height = label.optimumSize.height
        return label
    }()
    
    lazy var completeButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        button.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        button.setTitle("完成", for: .normal)
        button.titleLabel?.font = UIFont.customFont(ofSize: 18)
        return button
    }()

    var num:Int = 60
    var authCode: String = ""
    var timer:Timer?
    let phoneNum: String
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
    
    init(phone: String) {
        phoneNum = phone
        phoneTextField.text = phone
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置登录密码"
        commonInit()
    }
    func commonInit()  {
        let topView = UIView(bgColor: UIColor.hex("f2f2f2"))
        let topLabel = UILabel(title: "此账号还未设置登录密码，请设置登录密码", color: UIColor.hex("b7b7b7"), fontSize: 14, textAlign: .center, numberOfLines: 0)
        topView.addSubview(topLabel)
        scrollView.addSubview(topView)
        
        let middleView = UIView(bgColor: UIColor.white)
        let phoneTipLabel: UILabel = {
            let label = UILabel()
            label.textColor = titleColor
            label.font = UIFont.systemFont(ofSize: 16)
            label.text = "手机号"
            return label
        }()
        let authTipLabel: UILabel = {
            let label = UILabel()
            label.textColor = titleColor
            label.font = UIFont.systemFont(ofSize: 16)
            label.text = "验证码"
            return label
        }()
        let passwordTipLabel: UILabel = {
            let label = UILabel()
            label.textColor = titleColor
            label.font = UIFont.systemFont(ofSize: 16)
            label.text = "登录密码"
            return label
        }()
        
        let phoneLineView = UIView(bgColor: lineColor)
        let authLineView = UIView(bgColor: lineColor)
        let authVLineView = UIView(bgColor: lineColor)
        
        middleView.addSubview(phoneTipLabel)
        middleView.addSubview(authTipLabel)
        middleView.addSubview(passwordTipLabel)
        middleView.addSubview(phoneTextField)
        middleView.addSubview(authTextField)
        middleView.addSubview(passwordTextField)
        middleView.addSubview(phoneLineView)
        middleView.addSubview(authLineView)
        middleView.addSubview(authVLineView)
        middleView.addSubview(authRTBgView)
        authRTBgView.addSubview(authRTLabel)
        scrollView.addSubview(middleView)
        
        scrollView.addSubview(completeButton)
        
        bgView.addSubview(scrollView)
        scrollView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(bgView)
        }
        
        topView.snp.makeConstraints { (maker) in
            maker.top.left.right.equalTo(scrollView)
            maker.width.equalTo(bgView)
        }

        topLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(topView).inset(16)
            maker.top.bottom.equalTo(topView).inset(18)
        }
        
        middleView.snp.makeConstraints { (maker) in
            maker.top.equalTo(topView.snp.bottom)
            maker.left.right.equalTo(scrollView)
        }
        
        phoneTipLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(middleView).offset(20)
            maker.left.equalTo(middleView).offset(20)
            maker.width.equalTo(66)
        }
        
        phoneTextField.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(phoneTipLabel)
            maker.left.equalTo(phoneTipLabel.snp.right).offset(14)
            maker.right.equalTo(middleView).offset(-16)
            maker.height.equalTo(phoneTipLabel)
        }
        
        phoneLineView.snp.makeConstraints { (maker) in
            maker.top.equalTo(phoneTipLabel.snp.bottom).offset(20)
            maker.left.equalTo(middleView).offset(16)
            maker.right.equalTo(middleView)
            maker.height.equalTo(1)
        }
       
        authTipLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(phoneLineView.snp.bottom).offset(20)
            maker.left.equalTo(phoneTipLabel)
            maker.width.equalTo(phoneTipLabel)
        }

        authTextField.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(authTipLabel)
            maker.left.height.equalTo(phoneTextField)
        }
        
        authVLineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(authTextField.snp.right).offset(10)
            maker.centerY.equalTo(authTipLabel)
            maker.width.equalTo(1)
            maker.height.equalTo(20)
        }
        
        authRTBgView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(authTipLabel)
            maker.left.equalTo(authVLineView.snp.right).offset(10)
            maker.right.equalTo(middleView).offset(-16)
            maker.height.equalTo(40)
            maker.width.equalTo(100)
        }

        authLineView.snp.makeConstraints { (maker) in
            maker.top.equalTo(authTipLabel.snp.bottom).offset(20)
            maker.left.right.height.equalTo(phoneLineView)
        }

        passwordTipLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(authLineView.snp.bottom).offset(20)
            maker.left.width.equalTo(phoneTipLabel)
        }

        passwordTextField.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(passwordTipLabel)
            maker.left.right.height.equalTo(phoneTextField)
            maker.bottom.equalTo(middleView).offset(-20)
        }
        
        completeButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(middleView.snp.bottom).offset(45)
            maker.left.right.equalTo(scrollView).inset(16)
            maker.bottom.equalTo(scrollView).offset(-34)
        }
    }
    
    //网络请求
    @objc func btnClick(){
        guard let authNum = authTextField.text, !authNum.isEmpty else {
            self.bgView.makeToast("请获取验证码")
            return
        }
        guard let password = passwordTextField.text, password.count >= 6 else {
            self.bgView.makeToast("密码不正确")
            return
        }

         let dic = [
            "mobile": phoneNum,
            "newpwd": password,
            "news_captcha": authNum
        ]
        
        GPWNetwork.requetWithPost(url: Setup, parameters: dic, responseJSON: {
            [weak self]  (json, msg) in
            guard let strongSelf = self else { return }
            strongSelf.bgView.makeToast(msg)
            GPWUser.sharedInstance().analyUser(dic: json)
            let viewControllers = self?.navigationController?.viewControllers ?? []
            var sourceControllers = viewControllers
            for i in 0..<viewControllers.count {
                let vc = viewControllers[i]
                if vc.isKind(of: GPWLoginViewController.self) {

                    sourceControllers.removeSubrange(i..<viewControllers.count - 1)
                    self?.navigationController?.viewControllers = sourceControllers
                    break
                }
            }
            _ = strongSelf.navigationController?.popViewController(animated: true)
        }) { (error) in

        }
    }

    override func back(sender: GPWButton) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension GPWUserQSetPWViewController: RTLabelDelegate {
    func startTime() {
    let timer = Timer(timeInterval: 1.0,
                      target: self,
                      selector: #selector(updateTimer(timer:)),
                      userInfo: nil,
                      repeats: true)
    self.timer = timer
        // 将定时器添加到运行循环
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    @objc func updateTimer(timer:Timer) {
        num  = num - 1
        if (num == 0) {
            timer.invalidate()
            CFRunLoopStop(CFRunLoopGetCurrent())
            authRTLabel.text = "<a href='huoquyanzheng'><font size=13 color='#fa713d'>获取验证码</font></a>"
        }else{
            authRTLabel.text = "<a href='eeee'><font size=13 color='#fa713d'>"+String(describing: num)+"s</font><font size=11 color='#333333'>后重新发送</font></a>"
        }
    }
    func rtLabel(_ rtLabel: Any!, didSelectLinkWithURL url: String!) {
        if url == "huoquyanzheng"{
            let phoneNum = phoneTextField.text ?? ""
            if  GPWHelper.judgePhoneNum(phoneNum) {
                GPWNetwork.requetWithGet(url: Quick_captcha, parameters: nil, responseJSON: {
                    [weak self] (json, msg) in
                    guard let strongSelf = self else { return }
                    printLog(message: json)
                    strongSelf.authCode = json.stringValue
                    strongSelf.getVerificationCode(phone: phoneNum)
                    strongSelf.num = 60
                    strongSelf.authRTLabel.text = "<a href='eeee'><font size=13 color='#fa713d'>"+String(describing: strongSelf.num)+"s</font><font size=13 color='#333333'>后重新发送</font></a>"
                    strongSelf.startTime()
                }) { (error) in
                    
                }
            }else{
                self.bgView.makeToast("请输入正确手机号")
            }
        }
    }
    //获取验证码
    func getVerificationCode(phone:String)  {
        printLog(message: self.authCode)
        GPWNetwork.requetWithPost(url: Get_news_captcha_app, parameters: ["mobile":phone,"check_captcha":self.authCode], responseJSON: { [weak self]  (json, msg) in
            guard let strongSelf = self else { return }
            strongSelf.bgView.makeToast(msg)
        }) { (error) in
            
        }
    }
}
