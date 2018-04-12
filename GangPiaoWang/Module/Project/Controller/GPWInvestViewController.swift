//
//  GPWInvestViewController.swift
//  GangPiaoWang
//  确认出借
//  Created by GC on 16/12/21.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit

class GPWInvestViewController: GPWSecBaseViewController,UIScrollViewDelegate{
    fileprivate var shareJson:JSON?
    var vipFlag = false
    //投资弹窗确认界面
    fileprivate var showSureView:UIView?
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    let cell1 = UIView(bgColor: UIColor.white)
    let cell2 = UIView(bgColor: UIColor.white)
    let cell3 = UIView(bgColor: UIColor.white)
    let cell4 = UIView(bgColor: UIColor.white)
    
    var balanceLabel: UILabel = {
        let label = UILabel(title: "", color: redTitleColor, fontSize: 16)
        label.textAlignment = .right
        return label
    }()
    lazy var joinButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("立即加入", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.customFont(ofSize: 18)
        button.setBackgroundImage(UIImage(named: "project_right_pay"), for: .normal)
        button.addTarget(self, action: #selector(join), for: .touchUpInside)
        return button
    }()
    fileprivate let textField = UITextField()
    fileprivate let incomeLabel: UILabel = UILabel(title: "0.00", color: redTitleColor, fontSize: 14, textAlign: .left)
    fileprivate let reduceLabel = UILabel(title: "暂无可用红包", color: UIColor.hex("999999"), fontSize: 12, textAlign: .center)
    
    //账户余额
    fileprivate let acountBaLabel: UILabel = UILabel(title: "可用余额：\(GPWUser.sharedInstance().real_money ?? "0.00" )", color: UIColor.hex("999999"), fontSize: 16, textAlign: .left)
    
    //项目id
    fileprivate var itemID: String!
    fileprivate var dicJson: JSON!
    
    //项目可使用红包
    fileprivate var redEnvelops = [RedEnvelop]()
    
    //项目可使用加息券
    fileprivate var rateCoupons = [RateCoupon]()
    
    fileprivate var currentRedEnvelop: RedEnvelop?
    fileprivate var currentRateCoupon: RateCoupon?
    fileprivate var currentAmount: Double = 0.0
    var couponNum = 0      //优惠券个数
    
    init(itemID: String) {
        super.init(nibName: nil, bundle: nil)
        self.itemID = itemID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let balance = GPWUser.sharedInstance().real_money ?? "0.00"
        acountBaLabel.text =  "可用余额:\(balance)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgView.backgroundColor = UIColor.white
        self.title = "确认出借"
        //键盘监听
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.getNetData()
    }
    override func getNetData() {
        GPWNetwork.requetWithGet(url: Financing_display, parameters: ["item_id": itemID!, "user_id": GPWUser.sharedInstance().user_id!], responseJSON: { [weak self] (json, msg) in
            printLog(message: json)
            guard let strongSelf = self else { return }
            strongSelf.dicJson = json
            strongSelf.shareJson = json["share"]
            strongSelf.redEnvelops = json["award"].arrayValue.map({ (json) -> RedEnvelop in
                return RedEnvelop(json)
            })
            strongSelf.rateCoupons = json["ticket"].arrayValue.map({ (json) -> RateCoupon in
                return RateCoupon(json)
            })

            strongSelf.commonInit()
            strongSelf.couponNum = json["coupon_count"].intValue
            strongSelf.resetCoupon()
            
            strongSelf.balanceLabel.text = json["balance_amount"].stringValue + "元"
            }, failure: { error in
        })
    }
    
    private func commonInit() {
        addContentView()
        addCell1()
        addCell2()
        addCell3()
        addCell4()
    }
    
    //根据优惠券个数配置UI
    func resetCoupon() {
        if couponNum > 0 {
            reduceLabel.text = "\(couponNum)张可用"
            reduceLabel.textColor = redColor
        } else {
            reduceLabel.text = "暂无可用"
            reduceLabel.textColor = UIColor.hex("999999")
        }
        currentRedEnvelop = nil
        currentRateCoupon = nil
    }
    
    private func addContentView() {
        scrollView.delegate = self
        bgView.addSubview(scrollView)
       
        self.bgView.addSubview(joinButton)
        
        scrollView.snp.makeConstraints { (maker) in
            maker.top.left.right.equalTo(bgView)
        }
        joinButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(scrollView.snp.bottom)
            maker.left.right.bottom.equalTo(bgView)
            maker.height.equalTo(44)
        }
    }
    
    private func addCell1() {
        let  topView = UIView()
        topView.backgroundColor = bgColor
        let staticBalanceLabel = UILabel(title: "可投金额 ", color: UIColor.hex("333333"), fontSize: 16)
       
        scrollView.addSubview(cell1)
        cell1.addSubview(topView)
        cell1.addSubview(staticBalanceLabel)
        cell1.addSubview(balanceLabel)
        
        cell1.snp.makeConstraints { (maker) in
            maker.top.left.equalTo(scrollView)
            maker.width.equalTo(bgView)
            maker.height.equalTo(10 + 56)
        }
        
        topView.snp.makeConstraints { (make) in
            make.top.left.equalTo(cell1)
            make.width.equalTo(cell1)
            make.height.equalTo(10)
        }
        
        staticBalanceLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(topView.snp.bottom)
            maker.left.equalTo(cell1).offset(16)
            maker.bottom.equalTo(cell1)
        }
        
        balanceLabel.snp.makeConstraints { (maker) in
            maker.top.bottom.equalTo(staticBalanceLabel)
            maker.left.equalTo(staticBalanceLabel.snp.right).offset(16)
            maker.right.equalTo(cell1).offset(-16)
        }
    }
    
    private func addCell2() {
        let block = UIView(bgColor: bgColor)
        scrollView.addSubview(block)
        block.snp.makeConstraints { (maker) in
            maker.top.equalTo(cell1.snp.bottom)
            maker.left.right.equalTo(cell1)
            maker.height.equalTo(10)
        }
        scrollView.addSubview(cell2)

        cell2.snp.makeConstraints { (maker) in
            maker.left.equalTo(scrollView)
            maker.width.equalTo(SCREEN_WIDTH)
            maker.top.equalTo(block.snp.bottom)
            maker.height.equalTo(235)
        }
        
        let staticAmountLabel = UILabel(title: "出借金额(元)", color: titleColor, fontSize: 16)
        let staticIncomeLabel = UILabel(title: "预计收益", color: UIColor.hex("999999"), fontSize: 14)
        staticIncomeLabel.backgroundColor = UIColor.clear
        let bgImgView = UIImageView(image: UIImage(named: "project_sure_secbg"))
        let line = UIImageView(image: UIImage(named:"project_sure_secline"))
        staticIncomeLabel.textAlignment = .right
        textField.clearButtonMode = .whileEditing
        textField.placeholder = "\(dicJson["begin_amount"])元起投"
        textField.font = UIFont.customFont(ofSize: 26)
        textField.textColor = redTitleColor
        textField.keyboardType = .numberPad
        textField.textAlignment  = .center
        textField.delegate = self
        textField.addTarget(self, action: #selector(valueChanged(sender:)), for: .allEditingEvents)
        
        cell2.addSubview(staticAmountLabel)
        cell2.addSubview(acountBaLabel)
        cell2.addSubview(textField)
        cell2.addSubview(staticIncomeLabel)
        staticIncomeLabel.backgroundColor = UIColor.clear
        cell2.addSubview(incomeLabel)
        incomeLabel.backgroundColor = UIColor.clear
        cell2.addSubview(bgImgView)
        cell2.addSubview(line)

        //说明文字
        let  tempDetailLabel = UILabel(title: "利息 = 出借金额 * 借款期限 * 利率 / 365", color: UIColor.hex("999999"), fontSize: 14)
        cell2.addSubview(tempDetailLabel)
        
        staticAmountLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(cell2).offset(20)
            maker.width.equalTo(scrollView)
            maker.left.equalTo(cell2).offset(16)
        }
        acountBaLabel.snp.makeConstraints { (make) in
            make.top.equalTo(staticAmountLabel.snp.bottom).offset(12)
            make.left.equalTo(staticAmountLabel)
        }
        
        textField.snp.makeConstraints { (maker) in
            maker.top.equalTo(acountBaLabel.snp.bottom).offset(29)
            maker.left.equalTo(cell2).offset(16)
            maker.right.equalTo(cell2).offset(-16)
        }
        
        line.snp.makeConstraints { (maker) in
            maker.top.equalTo(textField.snp.bottom).offset(13)
            maker.centerX.equalTo(textField)
        }
        
        staticIncomeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(line.snp.bottom).offset(27)
            maker.left.equalTo(cell2)
            maker.width.equalTo(SCREEN_WIDTH / 2)
        }
        
        incomeLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(staticIncomeLabel)
            maker.left.equalTo(staticIncomeLabel.snp.right).offset(5)
            maker.width.equalTo(cell2).offset(-16)
        }
        
        bgImgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(line.snp.bottom).offset(15)
            maker.width.equalTo(150)
            maker.height.equalTo(34)
            maker.centerX.equalTo(cell2).offset(cell2.width / 2)
        }

        tempDetailLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(bgImgView.snp.bottom).offset(15)
            maker.width.equalTo(300)
            maker.left.equalTo(16)
        }
    }
    
    private func addCell3() {
        let line2 = UIView(bgColor: bgColor)
        let arrowView = UIImageView(image: UIImage(named: "user_rightImg"))
        scrollView.addSubview(line2)
        
        line2.snp.makeConstraints { (maker) in
            maker.top.equalTo(cell2.snp.bottom)
            maker.left.right.equalTo(cell2)
            maker.height.equalTo(10)
        }
        
        scrollView.addSubview(cell3)
        cell3.addSubview(arrowView)
        cell3.snp.makeConstraints { (maker) in
            maker.top.equalTo(line2.snp.bottom)
            maker.width.equalTo(scrollView)
            maker.height.equalTo(56)
        }
        
        arrowView.snp.makeConstraints { (maker) in
            maker.right.equalTo(cell3).offset(-16)
            maker.width.equalTo(9)
            maker.height.equalTo(18)
            maker.centerY.equalTo(cell3)
        }
        
        
        let staticTitleLabel = UILabel(title: "优惠券", color: titleColor, fontSize: 16)
        
        cell3.addSubview(staticTitleLabel)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(redBagTap(_:)))
        cell3.addGestureRecognizer(tapGesture)
        cell3.addSubview(reduceLabel)
        
        staticTitleLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(cell3)
            maker.left.equalTo(cell3).offset(16)
        }
        
        reduceLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(arrowView.snp.left).offset(-16)
            maker.centerY.equalTo(cell3)
        }
    }
    
    private func addCell4() {
        let line4 = UIView(bgColor: bgColor)
        scrollView.addSubview(line4)
        line4.snp.makeConstraints { (maker) in
            maker.top.equalTo(cell3.snp.bottom)
            maker.width.equalTo(cell3)
            maker.height.equalTo(10)
        }
        
        scrollView.addSubview(cell4)
        cell4.snp.makeConstraints { (maker) in
            maker.top.equalTo(line4.snp.bottom)
            maker.left.width.equalTo(scrollView)
        }
        
        let  bottomTitleLabel = RTLabel()
        bottomTitleLabel.text = "<a href='fuwuxieyi'><font size=12 color='#666666'>阅读并同意</font><font size=12 color='#2e7cd6'>《服务协议书》</font></a><font size=12 color='#666666'>、</font><a href='wangluojiedai'><font size=12 color='#2e7cd6'>《网络借贷风险和禁止性行为提示书》</font></a><font size=12 color='#666666'>和</font><a href='zijinhefa'><font size=12 color='#2e7cd6'>《资金合法来源承诺书》</font></a><font size=12 color='#666666'>\n市场有风险,出借需谨慎</font>"
        bottomTitleLabel.delegate = self
        cell4.addSubview(bottomTitleLabel)
        bottomTitleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(cell4).offset(11)
            maker.left.equalTo(cell4).offset(16)
            maker.right.equalTo(cell4).offset(-16)
            maker.height.equalTo(100)
            maker.bottom.equalTo(cell4).offset(-20)
        }
        printLog(message: scrollView.contentSize.height)
    }
    
    //确认前的提示框
    func beforeSureView() {
        let wid = UIApplication.shared.keyWindow
        showSureView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        showSureView?.backgroundColor = UIColor.hex("000000", alpha: 0.6)
        wid?.addSubview(showSureView!)
        
        let  showView = UIView(frame: CGRect(x: 0, y: 0, width: 306, height: 228))
        showView.backgroundColor = UIColor.white
        showView.layer.masksToBounds = true
        showView.layer.cornerRadius = 4
        showView.center = CGPoint(x: (showSureView?.width)! / 2, y: (showSureView?.height)! / 2 - 20)
        showSureView?.addSubview(showView)
        
        let topLabel = UILabel(frame: CGRect(x: 0, y: 42, width: showView.width, height: 18))
        topLabel.text = "您即将加入\(self.dicJson["title"])"
        topLabel.textAlignment = .center
        topLabel.textColor = UIColor.hex("666666")
        topLabel.font = UIFont.customFont(ofSize: 18)
        showView.addSubview(topLabel)
        
        let showInfo = [
                            ["imgcolor":"666666","content1":"加入金额：","content2":"\(textField.text ?? "0")"],
                            ["imgcolor":"f73c0d","content1":"预计收益：","content2":"\(incomeLabel.text ?? "0")"]
        ]
        
        var maxY = topLabel.maxY + 20 + 10
        for i in 0 ..< showInfo.count {
            let dian = UIView(frame: CGRect(x: 51, y: maxY , width: 6, height: 6))
            dian.layer.masksToBounds = true
            dian.layer.cornerRadius = 3
            dian.backgroundColor = UIColor.hex("f5a623")
            showView.addSubview(dian)
            
            let  contentLabel = RTLabel(frame: CGRect(x: dian.maxX + 5, y: 0, width: showView.width - dian.maxX - 5, height: 40))
            contentLabel.text = "<font size=16 color='#999999'>\(showInfo[i]["content1"]!)</font><font size=18 color='#\(showInfo[i]["imgcolor"]!)'>￥</font><font size=22 color='#\(showInfo[i]["imgcolor"]!)'>\(showInfo[i]["content2"]!)</font>"
            contentLabel.height = contentLabel.optimumSize.height
            contentLabel.centerY = dian.centerY - 2
            showView.addSubview(contentLabel)
            maxY = contentLabel.maxY + 15
        }
        
        let  cancelBtn = UIButton(type: .custom)
        cancelBtn.frame = CGRect(x: 19, y: topLabel.maxY + 98, width: 130, height: 56)
        cancelBtn.setImage(UIImage(named: "project_sure_show_cancel"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(self.cancelClick), for: .touchUpInside)
        showView.addSubview(cancelBtn)
        
        let sureBtn = UIButton(type: .custom)
        sureBtn.frame = CGRect(x: cancelBtn.maxX + 16, y:  cancelBtn.y, width: 130, height: 56)
        sureBtn.setImage(UIImage(named: "project_sure_show_sure"), for: .normal)
        sureBtn.addTarget(self, action: #selector(self.showBtnClick(sender:)), for: .touchUpInside)
        showView.addSubview(sureBtn)
        
    }
    
    @objc func cancelClick() {
        showSureView?.removeFromSuperview()
    }
    
    @objc func showBtnClick(sender:UIButton) {
        showSureView?.removeFromSuperview()
        MobClick.event("project", label: "详情-出借-立即加入")
        GPWNetwork.requetWithPost(url: Confirm_invest, parameters: ["item_id": itemID, "rate": dicJson["rate_loaner"].doubleValue, "amount": textField.text ?? "0", "award_id": currentRedEnvelop?.auto_id ?? "", "ticket_id": currentRateCoupon?.auto_id ?? ""], responseJSON:  { [weak self] (json, msg) in
            guard let strongSelf = self else { return }
            printLog(message: json)
            let vc = GPWBankWebViewController(url:  json.stringValue, sureJson: strongSelf.shareJson!)
            vc.moneyStr = strongSelf.textField.text
//            vc.vipFlag = strongSelf.vipFlag
            //标剩余金额
            let balance_amount =  Int(strongSelf.dicJson["balance_amount"].stringValue.replacingOccurrences(of: ",", with: "")) ?? 0
            //投资金额
            let  tempAmount  = Int(strongSelf.textField.text ?? "0")
            if balance_amount == tempAmount {
                vc.market_regamount = balance_amount
            }
            vc.proName = strongSelf.dicJson["title"].stringValue
            vc.shouyi = strongSelf.incomeLabel.text
            strongSelf.navigationController?.show(vc, sender: nil)
            }, failure: { [weak self] error in
                guard let strongSelf = self else { return }
               strongSelf.navigationController?.pushViewController(GPWFailController(type: FailType.CHUJIETYPE, tip: GPWGlobal.sharedInstance().msg), animated: true)
        })
    }
    
    //键盘的出现
    @objc func keyBoardWillShow(_ notification: Notification){
        //获取userInfo
        let kbInfo = notification.userInfo
        //获取键盘的size
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //键盘的y偏移量
        let changeY = kbRect.origin.y - SCREEN_HEIGHT
        //键盘弹出的时间
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        //界面偏移动画
        UIView.animate(withDuration: duration) {
            self.joinButton.y =  self.bgView.height -  44 + changeY
            printLog(message: self.bgView.height)
            printLog(message: self.joinButton.y)
        }
    }
    
    //键盘的隐藏
    @objc func keyBoardWillHide(_ notification: Notification){
        let kbInfo = notification.userInfo
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration) {
            self.joinButton.y =  self.bgView.height - 44
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension GPWInvestViewController:RTLabelDelegate {
    func rtLabel(_ rtLabel: Any!, didSelectLinkWithURL url: String!) {
        printLog(message:url)
        var  strUrl:String = ""
        if url == "fuwuxieyi" {
            strUrl = dicJson["url"].stringValue
        }else  if url == "wangluojiedai" {
            strUrl = dicJson["url_fx"].stringValue
        }else if url == "zijinhefa" {
            strUrl = dicJson["url_hf"].stringValue
        }
        //协议书
        let vc = GPWWebViewController(subtitle: "", url:  strUrl)
        navigationController?.show(vc, sender: nil)
    }
    
    //MARK: /*************Helper方法***************
    fileprivate func resetText() {
        incomeLabel.text = "0.00"
        currentAmount = 0.0
        if currentRateCoupon == nil {
            if couponNum > 0 {
                reduceLabel.text = "\(couponNum)张可用"
                reduceLabel.textColor = redColor
            } else {
                reduceLabel.text = "暂无可用"
                reduceLabel.textColor = UIColor.hex("999999")
            }
        }
        currentRedEnvelop = nil
    }
    
  
    
    //MARK: /*************红包与加息券选择处理***************
    fileprivate func userManualSelectRateCoupon() {
        //年化收益率
        var rate_loaner = dicJson["rate_loaner"].doubleValue
       
        if dicJson["is_index"].intValue == 1 {
            if GPWUser.sharedInstance().staue == 0 {
                rate_loaner = rate_loaner +  dicJson["rate_new"].doubleValue
            }
        }
        
        //红包金额
        var redEnvelopAmount = 0.0
        //标的天数
        let deadline = dicJson["deadline"].doubleValue
        
        if let redCoupon = currentRedEnvelop {
             redEnvelopAmount = Double(redCoupon.amount)
            reduceLabel.text = "\(redCoupon.amount)元"
            reduceLabel.textColor = redTitleColor
            cell3.isUserInteractionEnabled = true
        } else if let rateCoupon = currentRateCoupon {
            reduceLabel.text = "加息\(rateCoupon.rate)%"
            reduceLabel.textColor = redTitleColor
            rate_loaner += (rateCoupon.rate as NSString).doubleValue
            cell3.isUserInteractionEnabled = true
        } else {
            resetCoupon()
        }
        
        let income =  currentAmount / 365.0 * deadline * rate_loaner / 100.0 + redEnvelopAmount
        incomeLabel.text =  GPWHelper.notRounding(income, afterPoint: 2)
    }
}

extension GPWInvestViewController {
    //MARK: /*************红包选择***************
    @objc fileprivate func redBagTap(_ tapGesture: UITapGestureRecognizer) {
        textField.resignFirstResponder()

        let vc = GPWAvailableRateCouponViewController(redEnvelops: redEnvelops, rateCoupons: rateCoupons, currentRedEnvelop: currentRedEnvelop, currentRateCoupon: currentRateCoupon, currentAmount: currentAmount, deadLine: dicJson["deadline"].intValue)
        vc.handleCoupon =  { [weak self] (redEnvelop, rateCoupon) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.currentRedEnvelop = redEnvelop
            strongSelf.currentRateCoupon = rateCoupon
            strongSelf.userManualSelectRateCoupon()
        }
        self.navigationController?.show(vc, sender: nil)
    }

    
    //MARK: /*************确认投资***************
    @objc fileprivate func join() {
        textField.resignFirstResponder()
        //起投金额
        let begin_amount = dicJson["begin_amount"].intValue
        //新手标限投金额
        let begin_amount_sx = dicJson["begin_amount_sx"].intValue
        //标剩余金额
        let balance_amount =  Int(dicJson["balance_amount"].stringValue.replacingOccurrences(of: ",", with: "")) ?? 0
        
        guard let text = textField.text, text != "" else {
            self.view.makeToast("请输入有效金额")
            return
        }
        if !GPWHelper.judgeDecimalNum(text) {
            self.view.makeToast("请输入有效金额")
            return
        }
        guard let amount = Int(text),  amount > 0 else {
            self.view.makeToast("请输入有效金额")
            return
        }

        if  begin_amount > 0 {
            if amount  < begin_amount {
                 self.view.makeToast("金额小于起投金额")
                return
            }
            if amount % 100 != 0 {
                 self.view.makeToast("输入100的整数倍")
                 return
            }
        }
        
        if GPWUser.sharedInstance().isLogin && GPWUser.sharedInstance().staue == 1 {
        }else{
            if amount > begin_amount_sx && begin_amount_sx != 0 {
                self.view.makeToast("限投\(begin_amount_sx)元")
                textField.text = "\(amount)"
                return
            }
        }
       
        //超过剩余金额
        if amount > balance_amount {
            self.bgView.makeToast("出借金额超过剩余金额")
            textField.text = "\(Int(amount))"
            return
        }
        
        guard let money = Double((GPWUser.sharedInstance().real_money ?? "0.00").replacingOccurrences(of: ",", with: "")) else {
            self.bgView.makeToast("账户异常")
            return
        }
        if Double(amount) > money {
            let minus = Double(amount) - money
            let alertC = UIAlertController(title: "账户余额不足，请充值\(minus)元", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                
            })
            let okAction = UIAlertAction(title: "充值", style: .default, handler: { (alert) in
                let vc = GPWUserRechargeViewController(money: minus)
                self.navigationController?.show(vc, sender: nil)
            })
            alertC.addAction(cancelAction)
            alertC.addAction(okAction)
            self.navigationController?.present(alertC, animated: true, completion: nil)
        } else {
            self.beforeSureView()
        }
    }
    
}

extension GPWInvestViewController: UITextFieldDelegate {

    
    //MARK: /*************UITextFieldDelegate***************
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        resetText()
        return true
    }
    
    @objc func valueChanged(sender: UITextField) {
        guard let money = sender.text, money != "" else {
            resetText()
            return
        }
        
        let balance_amount =  Double(dicJson["balance_amount"].stringValue.replacingOccurrences(of: ",", with: "")) ?? 0
        //投的钱大于余额则置为余额
        if Double(money)! >  balance_amount {
            sender.text = "\(dicJson["balance_amount"].stringValue.replacingOccurrences(of: ",", with: ""))"
            self.valueChanged(sender: sender)
            return
        }

        //如果复制粘贴进来为小数 默认去除小数点后面部分
        if "\(Int(Double(sender.text ?? "0")!))" != "\(String(describing: Double(money)))" {
            textField.text =  "\(Int(Double(money)!))"
        }

        if let mon = Double(money) {
            currentAmount = mon
            //年化收益率
            var rate_loaner = dicJson["rate_loaner"].doubleValue
            
            //新手标
            if dicJson["is_index"].intValue == 1 {
                //没投过
                if GPWUser.sharedInstance().staue == 0 {
                    rate_loaner = rate_loaner +  dicJson["rate_new"].doubleValue
                }
            }
            //红包金额
            let redEnvelopAmount = 0.0
            //标的天数
            let deadline = dicJson["deadline"].doubleValue
            
            if let rateCoupon = currentRateCoupon {
                rate_loaner += Double(rateCoupon.rate) ?? 0.00 / 100
            } else {
                resetCoupon()
            }
            let text =  mon / 365.0 * deadline * rate_loaner / 100.0 + redEnvelopAmount
            incomeLabel.text = GPWHelper.notRounding(text, afterPoint: 2)
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        textField.resignFirstResponder()
    }
}

