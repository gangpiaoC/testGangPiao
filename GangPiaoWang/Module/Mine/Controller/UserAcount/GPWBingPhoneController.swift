//
//  GPWBingPhoneController.swift
//  GangPiaoWang
//     解绑和绑定手机号
//  Created by gangpiaowang on 2017/3/3.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
public enum BingType{
    /// 解绑
    case UNBING
    /// 绑定
    case BINGED
}
class GPWBingPhoneController: GPWSecBaseViewController,RTLabelDelegate {
    //电话输入框tag
    private let PHONEFIELDTAG = 100
    //验证码输入框tag
    private let  CODEFIELDTAG = 101
    var type:BingType?
    var phoneNum:String?
    fileprivate var num:Int?
    fileprivate var duanCode:String?
    //获取验证码
    private var numRtlabel:RTLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景白色
        let  topBgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 46 * 2))
        topBgView.backgroundColor = UIColor.white
        self.bgView.addSubview(topBgView)
        
        let  block = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        block.backgroundColor = bgColor
        topBgView.addSubview(block)
        
        //手机号
        let phoneField = UITextField(frame: CGRect(x: 16, y: block.maxY, width: SCREEN_WIDTH - 20, height: 56))
        phoneField.font = UIFont.customFont(ofSize: 16)
        phoneField.textColor = UIColor.hex("333333")
        phoneField.placeholder = "新手机号"
        phoneField.tag = PHONEFIELDTAG
        if type == BingType.UNBING {
            phoneField.isUserInteractionEnabled = false
            phoneField.text = GPWUser.sharedInstance().telephone
        }
        phoneField.keyboardType = .numberPad
        self.bgView.addSubview(phoneField)
        
        //线
        let  line = UIView(frame: CGRect(x: phoneField.x, y: phoneField.maxY - 0.5, width: SCREEN_WIDTH - phoneField.x, height: 0.5))
        line.backgroundColor = UIColor.hex("e0e0e0")
        self.bgView.addSubview(line)
    
        //验证码
        let codeField = UITextField(frame: CGRect(x: 16, y: line.maxY, width: SCREEN_WIDTH * 2 / 3 - 10, height: phoneField.height))
        codeField.placeholder = "手机验证码"
        codeField.tag = CODEFIELDTAG
        codeField.keyboardType = .numberPad
        codeField.font = UIFont.customFont(ofSize: 16)
        codeField.backgroundColor = UIColor.white
        codeField.textColor = UIColor.hex("333333")
        self.bgView.addSubview(codeField)
        topBgView.height =  codeField.maxY
        
        //验证码按钮
        numRtlabel = RTLabel(frame: CGRect(x: SCREEN_WIDTH - 70 - 16, y: codeField.y, width: 70 + 16, height: codeField.height))
        numRtlabel.backgroundColor = UIColor.white
        numRtlabel.text = "<a href='huoquyanzheng'><font size=14 color='#f6390d'>获取验证码</font></a>"
        numRtlabel.delegate = self
        numRtlabel.textAlignment = RTTextAlignmentCenter
        numRtlabel.height = numRtlabel.optimumSize.height
        numRtlabel.centerY = codeField.centerY
       self.bgView.addSubview(numRtlabel)
        
        let shuLine = UIView(frame: CGRect(x: numRtlabel.x - 16, y: 0, width: 0.5, height: 20))
        shuLine.centerY = numRtlabel.centerY
        shuLine.backgroundColor = UIColor.hex("e0e0e0")
        self.bgView.addSubview(shuLine)
        
        let btn = UIButton(frame: CGRect(x: 16, y: topBgView.maxY + 60, width: SCREEN_WIDTH - 16 * 2, height: 64))
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 3
        btn.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action:#selector(btnClick) , for: .touchUpInside)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 18)
        self.bgView.addSubview(btn)
        
        if type == BingType.BINGED {
            self.title = "绑定手机号"
            btn.setTitle("确认绑定", for: .normal)
            phoneField.placeholder = "新手机号"
        }else{
            self.title = "解绑手机号"
            btn.setTitle("确认解绑", for: .normal)
        }

    }
    @objc func btnClick()  {
        let phoneStr = (self.bgView.viewWithTag(PHONEFIELDTAG) as! UITextField).text ?? ""
        let codeStr = (self.bgView.viewWithTag(CODEFIELDTAG) as! UITextField).text ?? ""
        if codeStr.characters.count < 4 {
            self.bgView.makeToast("请输入正确验证码")
            return
        }
        if  GPWHelper.judgePhoneNum(phoneStr)  {
            if type == BingType.BINGED{
                GPWNetwork.requetWithPost(url: Api_bind_phone, parameters: ["mobile":phoneStr,"news_captcha":codeStr], responseJSON: {  [weak self] (json, msg) in
                    guard let strongSelf = self else { return }
                    GPWUser.sharedInstance().getUserInfo()
                    let  alertViewContoll = UIAlertController(title: "", message: "手机号更改成功", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "确定", style: .default, handler: { (alert) in
                        strongSelf.navigationController?.popToRootViewController(animated: true)
                    })
                    alertViewContoll.addAction(okAction)
                    strongSelf.navigationController?.present(alertViewContoll, animated: true, completion: nil)

                    }, failure: { (error) in
                        
                })
            }else{
                GPWNetwork.requetWithPost(url: Api_unbundphone, parameters: ["mobile":phoneStr,"captcha":codeStr], responseJSON: {  [weak self] (json, msg) in
                    printLog(message: json)
                    guard let strongSelf = self else { return }
                    let bingController = GPWBingPhoneController()
                    bingController.type = BingType.BINGED
                    bingController.phoneNum = phoneStr
                    strongSelf.navigationController?.pushViewController(bingController, animated: true)
                }, failure: { (error) in
                    
                })
            }
        }else{
            self.bgView.makeToast("请输入正确手机号")
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
            numRtlabel.text = "<a href='huoquyanzheng'><font size=11 color='#00affe'>获取验证码</font></a>"
        }else{
            numRtlabel.text = "<a href='eeee'><font size=11 color='#f6390d'>"+String(describing: num!)+"s</font><font size=11 color='#333333'>后重新发送</font></a>"
        }
    }
    func rtLabel(_ rtLabel: Any!, didSelectLinkWithURL url: String!) {
        if url == "huoquyanzheng"{
            let phoneNum = (self.bgView.viewWithTag(PHONEFIELDTAG) as! UITextField).text!
            if  GPWHelper.judgePhoneNum(phoneNum) {
                GPWNetwork.requetWithPost(url: Num_phone, parameters: ["phone":phoneNum], responseJSON: {
                    [weak self] (json, msg) in
                    guard let strongSelf = self else { return }
                    printLog(message: json)
                    strongSelf.duanCode = json["check_captcha"].stringValue
                    if strongSelf.type == BingType.UNBING {
                        if json["phmo"].intValue == 1{
                            strongSelf.getVerificationCode()
                            strongSelf.num = 60
                            strongSelf.numRtlabel.text = "<a href='eeee'><font size=11 color='#f6390d'>"+String(describing: strongSelf.num!)+"s</font><font size=11 color='#333333'>后重新发送</font></a>"
                            strongSelf.startTime()
                        }else{
                            strongSelf.bgView.makeToast(msg)
                        }
                    }else{
                        if json["phmo"].intValue == 0{
                            strongSelf.getVerificationCode()
                            strongSelf.num = 60
                            strongSelf.numRtlabel.text = "<a href='eeee'><font size=11 color='#f6390d'>"+String(describing: strongSelf.num!)+"s</font><font size=11 color='#333333'>后重新发送</font></a>"
                            strongSelf.startTime()
                        }else{
                            strongSelf.bgView.makeToast(msg)
                        }
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
        let phoneNum = (self.bgView.viewWithTag(PHONEFIELDTAG) as! UITextField).text!
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
