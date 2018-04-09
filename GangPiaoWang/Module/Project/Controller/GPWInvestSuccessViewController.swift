//
//  GPWInvestSuccessViewController.swift
//  GangPiaoWang
//
//  Created by GC on 17/1/5.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
class GPWInvestSuccessViewController: GPWSecBaseViewController {
    
    //出借本金
    fileprivate var money: String = "0"
    
    //出借收益
    fileprivate var shouyi: String = "0"
    
    //分享信息
    fileprivate var shareJson:JSON?
    
    //出借成功 分享红包
    var sureSucessID:String = ""
    
    //出借项目名称
    fileprivate var projectName:String = ""
    
    //是否为满标  如果>0  则为满标 奖励金额
    fileprivate var prizeNum:Int = 0
    
    //是否为团团赚vip
    var  vipFlag:Bool = false
    
    
    init(money: String,shareJson:JSON,shouyi:String,proName:String,prizeNum:Int) {
        super.init(nibName: nil, bundle: nil)
        self.money = money
        self.shareJson = shareJson
        self.shouyi = shouyi
        self.projectName = proName
        self.prizeNum = prizeNum
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "出借成功"
        GPWGlobal.sharedInstance().vipSucessFlag = true
        self.leftButton.isHidden = true
        setupViews()
        self.getNetData()
    }
    override func getNetData() {
        if vipFlag && GPWUser.sharedInstance().identity == 1{
            GPWNetwork.requetWithGet(url:Invest_success_share, parameters: ["invest_id":self.sureSucessID], responseJSON: { [weak self] (json, msg) in
                printLog(message: json)
                guard let strongSelf = self else { return }
                strongSelf.shareJson = json
                strongSelf.showVipShareView()
                }, failure: { (error) in

            })
        }else{
            if Int(self.money)! >= self.shareJson?["share_money"].intValue ?? 0 && vipFlag == false {
                showShareBag()
            }
        }
    }
    //领头人投资成功以后展示
    func showVipShareView() {
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        bgView.backgroundColor = UIColor.hex("000000", alpha: 0.75)
        bgView.tag = 10001
        let wid = UIApplication.shared.keyWindow
        wid?.addSubview(bgView)
        
        let  bgImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 354))
        bgImgView.image = UIImage(named: "f_vip_sucess_web")
        bgImgView.isUserInteractionEnabled = true
        bgImgView.centerX = SCREEN_WIDTH / 2
        bgImgView.centerY = SCREEN_HEIGHT / 2
        bgView.addSubview(bgImgView)
        
        let topLabel = UILabel(frame: CGRect(x: 0, y: 175, width: bgImgView.width, height: 15))
        topLabel.font = UIFont.customFont(ofSize: 14)
        topLabel.text = "您的邀请口令为"
        topLabel.textColor = UIColor.hex("f0f0fd")
        topLabel.textAlignment = .center
        bgImgView.addSubview(topLabel)
        
        let codeBgImgView = UIImageView(frame: CGRect(x: 0, y: topLabel.maxY + 10, width: 154, height: 31))
        codeBgImgView.image = UIImage(named: "f_vip_sucess_line")
        codeBgImgView.centerX = bgImgView.width / 2
        bgImgView.addSubview(codeBgImgView)
        
        let codeLabel = UILabel(frame: codeBgImgView.bounds)
        codeLabel.font = UIFont.customFont(ofSize: 18)
        codeLabel.text = "\(self.shareJson?["kouling"].intValue ?? 0)"
        codeLabel.textColor = UIColor.hex("f2f3ff")
        codeLabel.textAlignment = .center
        codeBgImgView.addSubview(codeLabel)
        
        let bottomLabel = UILabel(frame: CGRect(x: 0, y: codeBgImgView.maxY + 20, width: bgImgView.width, height: 19))
        bottomLabel.font = UIFont.customFont(ofSize: 18)
        bottomLabel.text = "赶快邀请朋友加入吧"
        bottomLabel.textColor = UIColor.hex("fbcb67")
        bottomLabel.textAlignment = .center
        bgImgView.addSubview(bottomLabel)
        
        let shareBtn = UIButton(type: .custom)
        shareBtn.frame = CGRect(x: 0, y: bottomLabel.maxY + 14, width: 252, height: 44)
        shareBtn.setImage(UIImage(named: "f_vip_sucess_btn"), for: .normal)
        shareBtn.centerX = bgImgView.width / 2
        shareBtn.addTarget(self, action: #selector(shareViewShow), for: .touchUpInside)
        shareBtn.tag = 1000
        bgImgView.addSubview(shareBtn)
        
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.frame = CGRect(x: 0, y: bgImgView.maxY + 28, width: 40, height: 40)
        cancelBtn.setImage(UIImage(named: "f_vip_detail_cancel"), for: .normal)
        cancelBtn.tag = 1001
        cancelBtn.addTarget(self, action: #selector(self.cancelClick), for: .touchUpInside)
        cancelBtn.centerX = bgImgView.centerX
        bgView.addSubview(cancelBtn)
    }
    
    //分享视图
    @objc func shareViewShow() {
        cancelClick()
        if let json = shareJson {
            MobClick.event("biao", label: "分享")
            let title = json["share_title"].stringValue
            let subtitle = json["share_content"].stringValue
            let imgUrl = json["share_picture"].stringValue
            let toUrl = json["share_link"].stringValue
            GPWShare.shared.show(title: title, subtitle: subtitle, imgUrl: imgUrl, toUrl: toUrl)
        }
    }
    
    //初始化
    private func setupViews() {
        let  tempBgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0))
        tempBgView.backgroundColor = UIColor.white
        bgView.addSubview(tempBgView)
        
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        topView.backgroundColor = bgColor
        tempBgView.addSubview(topView)
        
        
        let imgView = UIImageView(frame: CGRect(x: 0, y: topView.maxY + 45, width: 69, height: 70))
        imgView.image = UIImage(named: "project_investSucess")
        imgView.centerX = SCREEN_WIDTH / 2
        tempBgView.addSubview(imgView)
        
        let tipLabel = UILabel(frame: CGRect(x: 0, y: imgView.maxY + 39, width: SCREEN_WIDTH, height: 19))
        tipLabel.font = UIFont.customFont(ofSize: 18)
        tipLabel.textAlignment = .center
        tipLabel.text = "成功出借\(self.projectName)"
        tipLabel.textColor = subTitleColor
        tempBgView.addSubview(tipLabel)
        var  maxY = tipLabel.maxY + 26
        
        //满标奖励展示
        if self.prizeNum > 0 {
            let  prizeLabel = RTLabel(frame: CGRect(x: 0, y: maxY, width: SCREEN_WIDTH, height: 0))
            prizeLabel.textAlignment = RTTextAlignmentCenter
            prizeLabel.text = "<font size=16 color='#888888'>恭喜您获得满标奖励的</font><font size=16 color='#f6390c'>\(self.prizeNum)元</font><font  size=16 color='#888888'>红包</font>"
            prizeLabel.height = prizeLabel.optimumSize.height
            tempBgView.addSubview(prizeLabel)
            maxY = prizeLabel.maxY + 10
            
            let goBtn = UIButton(type: .custom)
            goBtn.frame = CGRect(x: 0, y: maxY, width: SCREEN_WIDTH, height: 17)
            goBtn.setTitle("请到我的账户查看", for: .normal)
            goBtn.titleLabel?.font = UIFont.customFont(ofSize: 16)
            goBtn.setTitleColor(UIColor.hex("888888"), for: .normal)
            tempBgView.addSubview(goBtn)
            maxY = goBtn.maxY
        }
       
        maxY = maxY + 30
        let bottomView = UIView(frame: CGRect(x: 0, y: maxY, width: SCREEN_WIDTH, height: 10))
        bottomView.backgroundColor = bgColor
        tempBgView.addSubview(bottomView)

        
        let conArray = [
            ["title":"出借本金","money":"\(self.money)元"],
            ["title":"预计收益","money":"\(self.shouyi)元"]
        ]

        
        for i in 0 ..< conArray.count {
            let titleLabel = UILabel(frame: CGRect(x: 16, y: maxY, width: 200, height: 56))
            titleLabel.text = conArray[i]["title"]
            titleLabel.font = UIFont.customFont(ofSize: 16)
            titleLabel.textColor = UIColor.hex("333333")
            tempBgView.addSubview(titleLabel)
            
            let moneyLabel = UILabel(frame: CGRect(x: SCREEN_WIDTH - 16 - 200, y: 0, width: 200, height: 56))
            moneyLabel.text = conArray[i]["money"]
            moneyLabel.font = UIFont.customFont(ofSize: 16)
            moneyLabel.textColor = UIColor.hex("666666")
            moneyLabel.textAlignment = .right
            moneyLabel.centerY = titleLabel.centerY
            tempBgView.addSubview(moneyLabel)
            if i == 1 {
                moneyLabel.textColor = redTitleColor
            }
            
            maxY = moneyLabel.maxY
            let line = UIView(frame: CGRect(x: 16, y: maxY, width: SCREEN_WIDTH - 16, height: 0.5))
            line.backgroundColor = bgColor
            tempBgView.addSubview(line)
            maxY = line.maxY
        }
        tempBgView.height = maxY
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 16, y: tempBgView.maxY + 30, width: SCREEN_WIDTH - 16 * 2, height: 64)
        btn.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        btn.setTitle("完成", for: .normal)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 18)
        btn.addTarget(self, action: #selector(self.btnClick), for: .touchUpInside)
        self.bgView.addSubview(btn)
    }
    
    //去我的奖励
    func goClick()  {
        //self.navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
    }
    
    @objc func btnClick() {
        if let viewControllers = self.navigationController?.viewControllers {
            for vc in viewControllers {
                if vc.isKind(of: GPWProjectDetailViewController.self) {
                    _ = self.navigationController?.popToViewController(vc, animated: true)
                    return
                }else if vc.isKind(of: GPWVipPDetailViewController.self) {
                    _ = self.navigationController?.popToViewController(vc, animated: true)
                    return
                }
            }
        }
       GPWHelper.selectTabBar(index: PROJECTBARTAG)
    }
    
    private func showShareBag(){
        let wid = UIApplication.shared.keyWindow
        
        let  tempBgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        tempBgView.backgroundColor = UIColor.hex("000000", alpha: 0.6)
        tempBgView.tag = 10001
        wid?.addSubview(tempBgView)
        
        //跳转
        let sureBtn = UIButton(type: .custom)
        sureBtn.addTarget(self, action: #selector(self.sureShare), for: .touchUpInside)
        tempBgView.addSubview(sureBtn)
        
        sureBtn.snp.makeConstraints { (maker) in
            maker.center.equalTo(tempBgView)
            maker.width.equalTo(322)
            maker.height.equalTo(325)
        }
        
        
        let imgView = UIImageView()
        sureBtn.addSubview(imgView)
        
        imgView.snp.makeConstraints { (maker) in
            maker.top.left.bottom.right.equalTo(sureBtn)
        }
        
        imgView.image = UIImage(named: "project_share_redbag")
        
        //取消
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setImage(UIImage(named: "ad_cancel"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(self.cancelClick), for: .touchUpInside)
        tempBgView.addSubview(cancelBtn)
        
        cancelBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(sureBtn)
            maker.top.equalTo(sureBtn.snp.bottom).offset(30)
        }
    }
    
    //分享红包
    @objc private func sureShare(){
        printLog(message: self.sureSucessID)
        if self.sureSucessID != "" {
            GPWNetwork.requetWithPost(url: Api_sendaward, parameters: ["invest_id":self.sureSucessID], responseJSON: {
                (json, msg) in
                printLog(message: json)
            }, failure: { (error) in
                printLog(message: error.localizedDescription)
            })
        }
        
        printLog(message: "\(String(describing: self.shareJson?["share_url"].stringValue ?? ""))\( self.sureSucessID)")
        GPWShare.shared.show(title: self.shareJson?["share_title"].stringValue ?? "", subtitle: self.shareJson?["share_content"].stringValue ?? "", imgUrl: self.shareJson?["share_photo"].stringValue ?? "", toUrl:  "\(String(describing: self.shareJson?["share_url"].stringValue ?? ""))\( self.sureSucessID)")
        cancelClick()
    }
    
    //取消分享
    @objc private func cancelClick() {
        UIApplication.shared.keyWindow?.viewWithTag(10001)?.removeFromSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (navigationController as! GPWNavigationController).canDrag = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
