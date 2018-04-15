//
//  GPWUserTixianViewController.swift
//  GangPiaoWang
//  提现
//  Created by gangpiaowang on 2016/12/29.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWUserTixianViewController: GPWSecBaseViewController,UITextFieldDelegate,UIScrollViewDelegate{
    var bankIcon:UIImageView!
    var tixianMoneyTextField:UITextField!
    var dic:JSON?
    fileprivate let DELEVIEWTAG = 100000
    var tixianLvLabel:UILabel!
    fileprivate var shouxu:CGFloat = 0
    var btn:UIButton!
    var bool = false
    var contentLabel:RTLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "提现"
        self.getNetData()
        
    }
    
    func initView()  {
        let scrollView = UIScrollView(frame: self.bgView.bounds)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.bgView.addSubview(scrollView)
        
        let tempBgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 135))
        tempBgView.backgroundColor = UIColor.white
        scrollView.addSubview(tempBgView)
        
        let topBlock = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        topBlock.backgroundColor = bgColor
        tempBgView.addSubview(topBlock)
        
        //可提现金额
        let temp1Label = UILabel(frame: CGRect(x: 16, y: topBlock.maxY, width: 90, height: 50))
        temp1Label.textColor = UIColor.hex("333333")
        temp1Label.text = "可提现金额"
        temp1Label.font = UIFont.customFont(ofSize: 16)
        tempBgView.addSubview(temp1Label)
        
        let temp11Label = UILabel(frame: CGRect(x: temp1Label.maxX + 5, y: temp1Label.y, width: 300, height: temp1Label.height))
        temp11Label.textColor = redColor
        temp11Label.text =  "\(self.dic?["money_cash"].string ?? "0.00")元"
        temp11Label.font = UIFont.customFont(ofSize: 16)
        tempBgView.addSubview(temp11Label)


        let  tipView =  UIView(frame: CGRect(x: 0, y: temp11Label.maxY, width: SCREEN_WIDTH, height: 54))
        tipView.backgroundColor = UIColor.hex("ffffff")
        tempBgView.addSubview(tipView)

        var payBtnMaxY = topBlock.maxY + 28

        let tiyanLabel = RTLabel(frame: CGRect(x: 16, y: 0, width: SCREEN_WIDTH -  32, height: 32))
        tiyanLabel.text = "<font size=14 color='#b7b7b7'>体验金收益</font><font size=14 color='#f6390d'>\(self.dic?["money_tyj"] ?? "0.00")元</font><font size=14 color='#b7b7b7'>\n出借满\(self.dic?["money_quota"].intValue ?? 0)元即可提现</font>"
        tiyanLabel.height = tiyanLabel.optimumSize.height
        tipView.addSubview(tiyanLabel)

        let payBtn = UIButton(type: .custom)
        payBtn.frame = CGRect(x: SCREEN_WIDTH - 16 - 100, y: payBtnMaxY, width: 100, height: 32)
        payBtn.setTitle("立即出借", for: .normal)
        payBtn.setTitleColor(redColor, for: .normal)
        payBtn.titleLabel?.font = UIFont.customFont(ofSize: 16)
        payBtn.addTarget(self, action: #selector(payClick(sender:)), for: .touchUpInside)
        payBtn.layer.cornerRadius = 16
        payBtn.centerY = payBtnMaxY
        payBtn.layer.borderColor = redColor.cgColor
        payBtn.layer.borderWidth = 1
        tempBgView.addSubview(payBtn)

        if (dic?["money_tyj"].doubleValue ?? 0) <= 0 {
            tipView.height = 0
            tipView.isHidden = true
            payBtn.isHidden = true
            payBtnMaxY = temp11Label.centerY
        }


        
        let sceBlock = UIView(frame: CGRect(x: 0, y: tipView.maxY, width: SCREEN_WIDTH, height: 10))
        sceBlock.backgroundColor = bgColor
        tempBgView.addSubview(sceBlock)
        
        
        bankIcon = UIImageView(frame: CGRect(x: 16, y: sceBlock.maxY + 21, width: 34, height: 36))
        if GPWUser.sharedInstance().is_valid == "1" {
            bankIcon.downLoadImg(imgUrl: GPWUser.sharedInstance().bank_logo!)
        }
        tempBgView.addSubview(bankIcon)
        
        //银行名称 + 银行卡号
        var bankNameStr = "未知银行"
        var bankNumStr = "尾号***"
        
        bankNameStr = "未知银行"
        if GPWUser.sharedInstance().is_valid == "1" {
            bankNameStr = GPWUser.sharedInstance().bank_name!
        }
        if GPWUser.sharedInstance().is_valid == "1" {
            let str = ((GPWUser.sharedInstance().bank_num! as NSString)).substring(with: NSRange(location: (GPWUser.sharedInstance().bank_num?.count)! - 4,length: 4))
            bankNumStr = "尾号" + str
        }
        
        let  bankLabel = RTLabel(frame: CGRect(x: bankIcon.maxX + 15, y: sceBlock.maxY + 30 , width: 300, height: 78))
        bankLabel.font = UIFont.customFont(ofSize: 16)
        bankLabel.text = "<font size=18 color='#333333'>\(bankNameStr)</font><font size=14 color='#999999'>    \(bankNumStr)</font>"
        bankLabel.height = bankLabel.optimumSize.height
        bankLabel.centerY = bankIcon.centerY
        tempBgView.addSubview(bankLabel)

        
        let threeBlock = UIView(frame: CGRect(x: 0, y: bankIcon.maxY + 21, width: SCREEN_WIDTH, height: 10))
        threeBlock.backgroundColor = bgColor
        tempBgView.addSubview(threeBlock)
        
        let temp2Label = UILabel(frame: CGRect(x: 16, y: threeBlock.maxY, width: 70, height: 56))
        temp2Label.textColor = UIColor.hex("333333")
        temp2Label.text = "提现金额"
        temp2Label.font = UIFont.customFont(ofSize: 16)
        tempBgView.addSubview(temp2Label)
        
        tixianMoneyTextField = UITextField(frame: CGRect(x: temp2Label.maxX + 10, y: temp2Label.y, width: SCREEN_WIDTH - temp1Label.maxX - 15 - 16, height: temp1Label.height))
        tixianMoneyTextField.delegate = self
        tixianMoneyTextField.keyboardType = .decimalPad
        tixianMoneyTextField.clearButtonMode = .whileEditing
        tixianMoneyTextField.addTarget(self, action: #selector(valueChanged(sender:)), for: .allEditingEvents)
        tixianMoneyTextField.placeholder = "请输入金额"
        tixianMoneyTextField.font = UIFont.customFont(ofSize: 16)
        tixianMoneyTextField.textColor = UIColor.hex("333333")
        tempBgView.addSubview(tixianMoneyTextField)
        
        let  line = UIView(frame: CGRect(x: 16, y: tixianMoneyTextField.maxY -  0.5, width: SCREEN_WIDTH - 16, height: 0.5))
        line.backgroundColor = UIColor.hex("e0e0e0")
        tempBgView.addSubview(line)
        
        let temp3Label = UILabel(frame: CGRect(x: 16, y: tixianMoneyTextField.maxY, width: 70, height: 45))
        temp3Label.textColor = UIColor.hex("333333")
        temp3Label.text = "提现费用"
        temp3Label.font = UIFont.customFont(ofSize: 16)
        scrollView.addSubview(temp3Label)
        
        tixianLvLabel = UILabel(frame: CGRect(x: temp3Label.maxX + 10, y: temp3Label.y, width: SCREEN_WIDTH - temp3Label.maxX - 15 - 16, height: temp3Label.height))
        tixianLvLabel.text = "0.00元"
        tixianLvLabel.font = UIFont.customFont(ofSize: 16)
        tixianLvLabel.textColor = redColor
        tempBgView.addSubview(tixianLvLabel)
        
        let  shouxuTipBtn = UIButton(type: .custom)
        shouxuTipBtn.frame = CGRect(x: SCREEN_WIDTH - 125 - 16, y: 0, width: 125, height: 20)
        shouxuTipBtn.centerY = tixianLvLabel.centerY
        shouxuTipBtn.setImage(UIImage(named: "user_tixian_shouxu"), for: .normal)
        shouxuTipBtn.addTarget(self, action: #selector(self.roleClick), for: .touchUpInside)
        tempBgView.addSubview(shouxuTipBtn)
         tempBgView.height = tixianLvLabel.maxY
        
        let bottomView = UIView(frame: CGRect(x: 0, y: tempBgView.maxY, width: SCREEN_WIDTH , height: 32))
        bottomView.backgroundColor = UIColor.hex("fff4dd")
        scrollView.addSubview(bottomView)
        
        let yuanView = UIView(frame: CGRect(x: 16, y: 0, width: 5, height: 5))
        yuanView.layer.masksToBounds = true
        yuanView.centerY = bottomView.height / 2
        yuanView.layer.cornerRadius = yuanView.height / 2
        yuanView.backgroundColor = UIColor.hex("f7bd5e")
        bottomView.addSubview(yuanView)
        
        let boTipLabel = UILabel(frame: CGRect(x: yuanView.maxX + 10, y: 0, width: 300, height: bottomView.height))
        boTipLabel.textColor = UIColor.hex("4a4a4a")
        boTipLabel.text = "预计下个工作日到账"
        boTipLabel.font = UIFont.customFont(ofSize: 14)
        bottomView.addSubview(boTipLabel)

        btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 16, y: bottomView.maxY + 60, width: SCREEN_WIDTH - 32, height: 48)
        btn.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        btn.setTitle("确定", for: .normal)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 18)
        btn.tag = 101
        btn.addTarget(self, action: #selector(self.btnClick(sender:)), for: .touchUpInside)
        scrollView.addSubview(btn)
        
    }


    @objc func payClick(sender:UIButton) {
        GPWHelper.selectTabBar(index: 1)
    }
    
     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let expression = "^[0-9]*((\\.)[0-9]{0,2})?$"
        let regex = try! NSRegularExpression(pattern: expression, options: NSRegularExpression.Options.allowCommentsAndWhitespace)
        let numberOfMatches = regex.numberOfMatches(in: newString, options:NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, (newString as NSString).length))
        return numberOfMatches != 0
    }
    
    @objc func btnClick(sender:UIButton)  {
        tixianMoneyTextField.resignFirstResponder()
        if sender.tag == 100 {
            printLog(message: "银行")
            self.navigationController?.pushViewController(UserBankViewController(), animated: true)
        }else{
            //账户余额
            let  yue = Double(GPWUser.sharedInstance().money ?? "0.00")  ?? 0
            
            //体验金除外的余额
            let  passTYJyue =  yue - (dic?["money_tyj"].double ?? 0)
            
            //提现金额
            let  tixian  =  Double(tixianMoneyTextField.text ?? "0.00") ?? 0
            
            let  temp = passTYJyue - tixian
            if (dic?["money_tyj"].doubleValue ?? 0) > 0 && temp < 0{
                self.bgView.makeToast("账户余额不足")
                return
            }
            if tixianMoneyTextField.text!.count > 0 {
                if bool {
                    GPWNetwork.requetWithPost(url: Api_user_withdrawals, parameters: ["amount":tixianMoneyTextField.text ?? "0"], responseJSON: {
                        [weak self] (json, msg) in
                        printLog(message: json)
                        guard let strongSelf = self else { return }
                        let vc = GPWBankWebViewController(subtitle: "", url: json.stringValue)
                        vc.moneyStr = strongSelf.tixianMoneyTextField.text ?? "0"
                        vc.shouxu = strongSelf.shouxu
                        strongSelf.navigationController?.show(vc, sender: nil)
                        }, failure: { error in
                    })
                }else{
                    UIApplication.shared.keyWindow?.makeToast("手续费大于或等于提现金额")
                }
                
            }else{
                UIApplication.shared.keyWindow?.makeToast("请输入金额")
            }
        }
    }
    
    //提现规则
    @objc func roleClick() {
        tixianMoneyTextField.resignFirstResponder()
        let wid = UIApplication.shared.keyWindow
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH , height: SCREEN_HEIGHT))
        tempView.backgroundColor = UIColor.hex("000000", alpha: 0.6)
        tempView.tag = DELEVIEWTAG
        wid?.addSubview(tempView)
        
        let roleBgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 183))
        roleBgView.image = UIImage(named: "home_getbag_role_bg")
        roleBgView.center = tempView.center
        tempView.addSubview(roleBgView)
        
        let titleImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 124, height: 35))
        titleImgView.image = UIImage(named: "user_tixian_sxtitle")
        titleImgView.centerX = roleBgView.centerX
        titleImgView.centerY = roleBgView.y + 11
        tempView.addSubview(titleImgView)
        
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.frame = CGRect(x: 0, y: roleBgView.maxY + 26, width: 40, height: 40)
        cancelBtn.setImage(UIImage(named: "home_getbag_role_cancel"), for: .normal)
        cancelBtn.centerX = roleBgView.centerX
        cancelBtn.addTarget(self, action: #selector(self.cancelClick), for: .touchUpInside)
        tempView.addSubview(cancelBtn)
        
        let  contentArray = [
            "提现每月2次免费机会,超出后,每笔提现收取2元手续费;",
            "当日提现,预计T+1个工作日到账,节假日顺延;",
            "如有任何疑问以及建议,请致电钢票网官方客服:400-900-9017。"
        ]
        
        var maxY:CGFloat = 46
        for i in 0 ..< contentArray.count {
            let numLabel = UILabel(frame: CGRect(x: 30, y: maxY + 2, width: 25, height: 15))
            numLabel.text = "\(i+1)、"
            numLabel.textColor = UIColor.hex("333333")
            numLabel.font = UIFont.customFont(ofSize: 14)
            roleBgView.addSubview(numLabel)
            
            let contentLabel = RTLabel(frame: CGRect(x: numLabel.maxX, y: maxY, width: roleBgView.width - numLabel.maxX - 30, height: 0))
            contentLabel.text = "<font size=14 color='#333333'>\(contentArray[i])</font>"
            contentLabel.height = contentLabel.optimumSize.height
            roleBgView.addSubview(contentLabel)
            maxY = maxY +  contentLabel.height + 14
        }
        
        roleBgView.height = maxY + 10
        roleBgView.centerY = SCREEN_HEIGHT / 2
        titleImgView.y = roleBgView.y - 7
        cancelBtn.y = roleBgView.maxY + 26
    }
    
    //取消
    @objc func cancelClick() {
        tixianMoneyTextField.resignFirstResponder()
        let wid = UIApplication.shared.keyWindow
        wid?.viewWithTag(DELEVIEWTAG)?.removeFromSuperview()
    }

    override func getNetData() {
        GPWNetwork.requetWithGet(url: Api_newcash_fee, parameters: nil, responseJSON: {
            [weak self] (json, msg) in
            guard let strongSelf = self else { return }
            strongSelf.dic = json
            printLog(message: json)
            strongSelf.initView()
        }) { (error) in
            
        }
    }
    
    @objc func valueChanged(sender: UITextField) {
        if self.dic == nil {
            return
        }
        printLog(message: self.dic)
        var tempStr:Double = 0.00
        let tempMoney = sender.text
        if tempMoney == nil {
            
        }else{
            
            //充值未出借提现最小金额
            let  money_deposit_fee_min = self.dic?["money_deposit_fee_min"].doubleValue ?? 2.00
            
            //充值未出借提现手续费率
            let  money_deposit_fee = self.dic?["money_deposit_fee"].doubleValue ?? 0.005
            
            //回款及福利最小提现金额
            let  money_live_fee_min = self.dic?["money_live_fee_min"].doubleValue ?? 2.00
            
            //免手续费次数（充值未出借除外）
            let  month_free_count = self.dic?["monthcount"].intValue ?? 0
            //红包金额
            let money_award = Double((self.dic?["money_award"].stringValue.replacingOccurrences(of: ",", with: ""))!) ?? 0
            //回款金额
            let money_return = Double((self.dic?["money_return"].stringValue.replacingOccurrences(of: ",", with: ""))!) ?? 0
            //充值未出借
            let money_deposit = Double((self.dic?["money_deposit"].stringValue.replacingOccurrences(of: ",", with: ""))!) ?? 0
            
            let  doubleMoney = self.notRounding(Double(sender.text!)  ?? 0, afterPoint: 2)
            let tempAll = self.notRounding(money_award + money_return + money_deposit, afterPoint: 2)

            if doubleMoney > tempAll {
                printLog(message: "eeeee====\(doubleMoney) ====== \(tempAll)")
                let index =  sender.text?.index( (sender.text?.endIndex)!, offsetBy: -1)
                sender.text = sender.text?.substring(to: index!)
                sender.text = self.dic?["money_cash"].string ?? "0.00"
                self.bgView.makeToast("提现金额不可大于账户余额")
            }
            
            let all = money_award + money_return
            
            //判断是否有免费次数
            if month_free_count <= 0 {
                tempStr = money_live_fee_min
            }else{
                tempStr = 0.00
            }
            if sender.text == "" {
                tempStr = 0.00
                bool = false
            }
            
            if doubleMoney > tempStr {
                bool = true
            }else{
                bool = false
            }
            printLog(message: "------------------")
            printLog(message: tempStr)
            tixianLvLabel.text = "\(tempStr)元"
            shouxu = CGFloat(tempStr)
        }
    }

    //MARK: /*************截取小数不四舍五入***************
    func notRounding(_ price: Double, afterPoint position: Int) -> Double {
        let roundingBehavior = NSDecimalNumberHandler(roundingMode: .down, scale: Int16(position), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let ouncesDecimal = NSDecimalNumber(value: price)
        let roundedOunces = ouncesDecimal.rounding(accordingToBehavior: roundingBehavior)
        return Double(roundedOunces)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        tixianMoneyTextField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
