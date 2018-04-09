//
//  GPWUserRechargeViewController.swift
//  GangPiaoWang
//  充值
//  Created by gangpiaowang on 2016/12/20.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWUserRechargeViewController: GPWSecBaseViewController ,UITextFieldDelegate{
    var bankIcon:UIImageView!
    var bankLabel:RTLabel!
    var minAmount = 2.00
    var chongMoney = 0.00
    var moneyTextField:UITextField!
    
    init(money:Double = 0.00){
        super.init(nibName: nil, bundle: nil)
        self.chongMoney = money
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "充值"
        
        let  messageBtn = UIButton(type: .custom)
        messageBtn.tag = 101
        messageBtn.frame = CGRect(x: SCREEN_WIDTH - 20 - 16, y: 10, width: 15 + 16, height: self.navigationBar.height)
        messageBtn.setImage(UIImage(named: "user_tixian_yiwen"), for: .normal)
        messageBtn.addTarget(self, action: #selector(self.helpClick), for: .touchUpInside)
        self.navigationBar.addSubview(messageBtn)
        
        let topBgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 135 + 32 +  46  +  30))
        topBgView.backgroundColor = UIColor.white
        self.bgView.addSubview(topBgView)
        
        let topBlock = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        topBlock.backgroundColor = bgColor
        bgView.addSubview(topBlock)
        
        bankIcon = UIImageView(frame: CGRect(x: 16, y: topBlock.maxY + 21, width: 34, height: 36))
        if GPWUser.sharedInstance().is_valid == "1" {
            bankIcon.downLoadImg(imgUrl: GPWUser.sharedInstance().bank_logo!)
        }
        bgView.addSubview(bankIcon)
        
        //银行名称 + 银行卡号
        var bankNameStr = "未知银行"
        var bankNumStr = "尾号***"
        
        bankNameStr = "未知银行"
        if GPWUser.sharedInstance().is_valid == "1" {
             bankNameStr = GPWUser.sharedInstance().bank_name!
        }
        
        if GPWUser.sharedInstance().is_valid == "1" {
            let str = ((GPWUser.sharedInstance().bank_num! as NSString)).substring(with: NSRange(location: (GPWUser.sharedInstance().bank_num?.characters.count)! - 4,length: 4))
            bankNumStr = "尾号" + str
        }
        
        bankLabel = RTLabel(frame: CGRect(x: bankIcon.maxX + 16, y: topBlock.maxY + 28, width: 300, height: 16))
        bankLabel.font = UIFont.customFont(ofSize: 16)
        bankLabel.text = "<font size=18 color='#333333'>\(bankNameStr)</font><font size=14 color='#999999'>    \(bankNumStr)</font>"
        bankLabel.height = bankLabel.optimumSize.height
        bgView.addSubview(bankLabel)
        
        //限制说明
        let   xianzhiLabel = UILabel(frame: CGRect(x: bankLabel.x, y: bankLabel.maxY + 10, width: 260, height: 14))
        xianzhiLabel.font = UIFont.customFont(ofSize: 14)
        xianzhiLabel.text = "单笔限额\(GPWUser.sharedInstance().single_limit ?? 0)元,单日限额\(GPWUser.sharedInstance().day_limit ?? 0)元"
        xianzhiLabel.textColor = UIColor.hex("999999")
        bgView.addSubview(xianzhiLabel)

        //提示去pc端充值
        let  pcTipView = UIView(frame: CGRect(x: 0, y: xianzhiLabel.maxY + 22, width: SCREEN_WIDTH, height: 32))
        pcTipView.backgroundColor = UIColor.hex("fff4dd")
        self.bgView.addSubview(pcTipView)

        let topcImgView = UIImageView(frame: CGRect(x: 16, y: 0, width: 5, height: 5))
        topcImgView.image = UIImage(named:"home_tiyan_topc")
        topcImgView.centerY = pcTipView.height / 2
        pcTipView.addSubview(topcImgView)

        let topctitleLabel = UILabel(frame: CGRect(x: topcImgView.maxX + 7, y: 0, width: 300, height: pcTipView.height))
        topctitleLabel.text = "大额充值请前往PC端网银进行充值"
        topctitleLabel.font = UIFont.customFont(ofSize: 14)
        topctitleLabel.textColor = UIColor.hex("4a4a4a")
        pcTipView.addSubview(topctitleLabel)

        let sceBlock = UIView(frame: CGRect(x: 0, y: pcTipView.maxY, width: SCREEN_WIDTH, height: 10))
        sceBlock.backgroundColor = bgColor
        bgView.addSubview(sceBlock)
        
        //账户余额
        let temp2Label = UILabel (frame: CGRect(x: 16, y: sceBlock.maxY, width: 70, height: 46))
        temp2Label.textColor = UIColor.hex("333333")
        temp2Label.text = "可用余额"
        temp2Label.font = UIFont.customFont(ofSize: 16)
        bgView.addSubview(temp2Label)
        
        let yueLabel = UILabel(frame: CGRect(x: temp2Label.maxX + 10, y: temp2Label.y, width: SCREEN_WIDTH - temp2Label.maxX - 15 - 16, height: temp2Label.height))
        yueLabel.text = "\(GPWUser.sharedInstance().real_money ?? "0.00" )元"
        yueLabel.font = UIFont.customFont(ofSize: 16)
        yueLabel.textColor = redColor
        bgView.addSubview(yueLabel)
        
        let line = UIView(frame: CGRect(x: 16, y: temp2Label.maxY, width: SCREEN_WIDTH - 16, height: 0.5))
        line.backgroundColor = lineColor
        bgView.addSubview(line)
        
        //充值金额
        let temp1Label = UILabel(frame: CGRect(x: 16, y: line.maxY, width: 70, height: 45))
        temp1Label.textColor = UIColor.hex("333333")
        temp1Label.text = "充值金额"
        temp1Label.font = UIFont.customFont(ofSize: 16)
        bgView.addSubview(temp1Label)
        
        moneyTextField = UITextField(frame: CGRect(x: temp1Label.maxX + 10, y: temp1Label.y, width: SCREEN_WIDTH - temp1Label.maxX - 15 - 16, height: temp1Label.height))
        moneyTextField.placeholder = "2元起"
        moneyTextField.delegate = self
        moneyTextField.keyboardType = .decimalPad
        if self.chongMoney > 0 {
            moneyTextField.text = "\(self.chongMoney)"
        }
        moneyTextField.font = UIFont.customFont(ofSize: 16)
        moneyTextField.textColor = UIColor.hex("333333")
        bgView.addSubview(moneyTextField)
        topBgView.height = temp1Label.maxY
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 16, y:  temp1Label.maxY + 60, width: SCREEN_WIDTH - 16 * 2, height: 64)
        btn.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        btn.setTitle("确定", for: .normal)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 18)
        btn.tag = 101
        btn.addTarget(self, action: #selector(self.btnClick(sender:)), for: .touchUpInside)
        self.bgView.addSubview(btn)
        self.getNetData()
    }

    override func getNetData() {
        GPWNetwork.requetWithGet(url: Api_user_accounts_recharge, parameters: nil, responseJSON:  {
            [weak self] (json, msg) in
            guard let strongSelf = self else { return }
            strongSelf.minAmount = json["min_amount"].doubleValue
            strongSelf.moneyTextField.placeholder = "\(json["min_amount"])元起"
            printLog(message: json)
            }, failure: { error in

        })
    }
    
    func helpClick() {
        self.navigationController?.pushViewController(GPWFHelpViewController(), animated: true)
    }

    func btnClick(sender:UIButton)  {
        if sender.tag == 100 {
            printLog(message: "银行")
            self.navigationController?.pushViewController(UserBankViewController(), animated: true)
        }else{
            printLog(message: "确定")
            let money = moneyTextField.text ?? "0"
            if money == "" {
                self.bgView.makeToast("请输入金额")
                return
            }
            if Double(money)! < self.minAmount {
                self.bgView.makeToast("充值金额过小")
                return
            }
            GPWNetwork.requetWithPost(url: Api_user_deposit_recharge, parameters: ["amount":money], responseJSON: { [weak self] (json, msg) in
                guard let strongSelf = self else { return }
                printLog(message: json)
                GPWUser.sharedInstance().getUserInfo()
                let vc = GPWBankWebViewController(subtitle: "", url: json.stringValue)
                vc.moneyStr = money
                strongSelf.navigationController?.show(vc, sender: nil)
                }, failure: { error in
            
            })
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let expression = "^[0-9]*((\\.)[0-9]{0,2})?$"
        let regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpression.Options.allowCommentsAndWhitespace)
        let numberOfMatches = regex.numberOfMatches(in: newString, options:NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, (newString as NSString).length))
        return numberOfMatches != 0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
