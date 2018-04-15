//
//  UserController.swift
//  test
//  用户中心
//  Created by gangpiaowang on 2016/12/16.
//  Copyright © 2016年 mutouwang. All rights reserved.
//

import UIKit

class UserController: GPWBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var showTableView:UITableView!

    fileprivate var  messageImgView:UIImageView!
    
    //设置
    var setBtn:UIButton!
    
    //展示客服电话
    var flag = false

    //未登录背景
    var noLoginView:UIView!
    
    let imgArray = ["user_jilu","user_liushui","user_jiangli","user_yaoqing","user_fankui"]
    let titleArray = ["出借记录","资金流水","我的奖励","我的邀请","意见反馈"]
    override func viewWillAppear(_ animated: Bool) { 
        super.viewWillAppear(animated)
        self.getMessageNum()
       self.navigationController?.navigationBar.barStyle = .black
        if GPWUser.sharedInstance().isLogin {
            if noLoginView != nil {
                noLoginView.isHidden = true
            }
           self.showTableView.reloadData()
        }else{
            noLoginView.isHidden = false
        }

        //开通存管
        if GPWGlobal.sharedInstance().gotoNiceNameFlag && GPWUser.sharedInstance().isLogin && GPWUser.sharedInstance().is_idcard == 0 {
            GPWGlobal.sharedInstance().gotoNiceNameFlag = false
            self.showQuireInfo()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barStyle = .default
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isBarHidden = true
        self.bgView.height = SCREEN_HEIGHT - 44
        showTableView = UITableView(frame: self.bgView.bounds, style: .plain)
        showTableView.backgroundColor = UIColor.clear
        showTableView.addTwitterCover(with: UIImage(named: "user_center_topbg"))
        showTableView?.delegate = self
        showTableView.showsVerticalScrollIndicator = false
        showTableView?.dataSource = self
        showTableView.separatorStyle = .none
        self.bgView.addSubview(showTableView)

        if #available(iOS 11.0, *) {
           showTableView.estimatedRowHeight = 0
            showTableView.estimatedSectionHeaderHeight = 0
            showTableView.estimatedSectionFooterHeight = 0
            showTableView.contentInsetAdjustmentBehavior = .never
            showTableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0)//导航栏如果使用系统原生半透明的，top设置为64
            showTableView.scrollIndicatorInsets = showTableView.contentInset
        }
        self.addMessageBtn()
         self.noLogin()
    }

    //快捷注册后如果没有实名就会提示
    func showQuireInfo() {
         let tempStr =  UserDefaults().string(forKey: "firstTiyanFlag")
        if tempStr == GPWUser.sharedInstance().telephone {
            return
        }

        if tempStr != nil {
            let tempArray = tempStr?.components(separatedBy: "$")
            for temp in tempArray ?? ["00","00"] {
                if temp == GPWUser.sharedInstance().telephone {
                    return
                }
            }
        }
        if tempStr != nil {
            UserDefaults().setValue(( tempStr ?? "0" ) + "$"  + ( GPWUser.sharedInstance().telephone ?? "0" ), forKey: "firstTiyanFlag")
        }else{
                UserDefaults().setValue(GPWUser.sharedInstance().telephone, forKey: "firstTiyanFlag")
        }

        let wid = UIApplication.shared.keyWindow
        let  bgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        bgView.backgroundColor = UIColor.hex("000000", alpha: 0.6)
        bgView.tag = 10001
        wid?.addSubview(bgView)

        let  quireView = UIView(frame: CGRect(x: 0, y: 0, width: 332, height: 228))
        quireView.layer.masksToBounds = true
        quireView.layer.cornerRadius = 5
        quireView.backgroundColor = UIColor.white
        quireView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT / 2)
        bgView.addSubview(quireView)

        let  quireImgView = UIImageView(frame: CGRect(x: 0, y: 30, width: 100, height: 60))
        quireImgView.image = UIImage(named:"user_regiter_show_top")
        quireImgView.centerX = quireView.width / 2
        quireView.addSubview(quireImgView)

        let quireLabel = RTLabel(frame: CGRect(x: 0, y: quireImgView.maxY + 16, width: quireView.width, height: 20))

        var tempTiyan:String = "\(GPWUser.sharedInstance().userTiyanMoney)"
        if tempTiyan.count < 10 {
            tempTiyan = GPWGlobal.sharedInstance().app_exper_amount
        }
        quireLabel.text = "<font size=18 color='#f6390d'>\(tempTiyan)元体验金</font><font size=18 color='#666666'>已塞入您的账户</font>"
        quireLabel.textAlignment = RTTextAlignmentCenter
        quireLabel.height = quireLabel.optimumSize.height
        quireView.addSubview(quireLabel)

        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: quireView.height - 29 - 58, width: 290, height: 58)
        btn.setImage(UIImage(named:"user_regiter_show_kt"), for: .normal)
        btn.tag = 1000
        btn.centerX = quireImgView.centerX
        btn.addTarget(self, action: #selector(self.quireClick(sender:)), for: .touchUpInside)
        quireView.addSubview(btn)

        let cancelBtn = UIButton(type: .custom)
        cancelBtn.frame = CGRect(x: 0, y: quireView.maxY + 30, width: 36, height: 36)
        cancelBtn.setImage(UIImage(named:"version_cancel"), for: .normal)
        cancelBtn.centerX = quireView.centerX
        cancelBtn.tag = 1001
        cancelBtn.addTarget(self, action: #selector(self.quireClick(sender:)), for: .touchUpInside)
        bgView.addSubview(cancelBtn)
    }

    @objc func quireClick(sender:UIButton) {
        UIApplication.shared.keyWindow?.viewWithTag(10001)?.removeFromSuperview()
        if sender.tag == 1000 {
            self.navigationController?.pushViewController(UserReadInfoViewController(), animated: true)
        }
    }
    //添加消息按钮
    func addMessageBtn() {
        let  messageBtn = UIButton(type: .custom)
        messageBtn.tag = 101
        messageBtn.frame = CGRect(x: SCREEN_WIDTH - 28 - 16, y: 32, width: 35, height: 35)
        messageBtn.addTarget(self, action: #selector(self.toMessageControll), for: .touchUpInside)
        self.showTableView.addSubview(messageBtn)

        messageImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        messageImgView.image = UIImage(named: "user_message_no")
        messageImgView.centerX = messageBtn.width / 2
        messageImgView.centerY = messageBtn.height / 2
        messageBtn.addSubview(messageImgView)
    }

    func getMessageNum() {
        GPWNetwork.requetWithGet(url: Message_count, parameters: nil, responseJSON:  {
            [weak self] (json, msg) in
            guard let strongSelf = self else { return }
            if json["un_read"].intValue == 0 {
                strongSelf.messageImgView.image = UIImage(named: "user_message_no")
            }else{
                strongSelf.messageImgView.image = UIImage(named: "user_message")
            }
            }, failure: { error in
        })
    }

    @objc func toMessageControll() {
        MobClick.event("index_message", label: nil)
        if GPWUser.sharedInstance().isLogin {
            self.navigationController?.pushViewController(GPWUserMessageController(), animated: true)
        }else{
            self.navigationController?.pushViewController(GPWLoginViewController(), animated: true)
        }
    }
    
    func setClick(_ sender:UIButton) {
        if sender.tag == 100 {
             MobClick.event("mine", label: "信息")
            self.navigationController?.pushViewController(UserSetViewController(), animated: true)
        }else if sender.tag == 102 {
            self.navigationController?.pushViewController(GPWUserMoneyFundViewController(), animated: true)
        }
    }
    func noLogin() {
        noLoginView = UIView(frame: self.bgView.bounds)
        noLoginView.backgroundColor = UIColor.white
        if GPWUser.sharedInstance().isLogin {
            noLoginView.isHidden = true
        }
        self.bgView.addSubview(noLoginView)
        
        //背景图片
        let  imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: pixw(p: 450)))
        imgView.image = UIImage(named: "user_nologin_top")
        noLoginView.addSubview(imgView)
        
        //注册
        let regiterBtn = UIButton(frame: CGRect(x: 16 , y:  imgView.maxY + 21, width:  SCREEN_WIDTH - 16 * 2, height:  pixw(p: 48)))
        regiterBtn.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        regiterBtn.setTitle("注册领取\(GPWGlobal.sharedInstance().app_exper_amount)元体验金", for: .normal)
        regiterBtn.addTarget(self, action: #selector(self.btnClick(sender:)), for: .touchUpInside)
        regiterBtn.tag = 101
        regiterBtn.titleLabel?.font = UIFont.customFont(ofSize:  18)
        noLoginView.addSubview(regiterBtn)
        
        //登录
        let loginBtn = UIButton(frame: CGRect(x: 0, y:  regiterBtn.maxY + 18, width:  SCREEN_WIDTH, height: 20))
        loginBtn.tag = 100
        loginBtn.addTarget(self, action: #selector(self.btnClick(sender:)), for: .touchUpInside)
        noLoginView.addSubview(loginBtn)
        
        let titleLabel = UILabel(frame: loginBtn.bounds)
        titleLabel.attributedText = NSAttributedString.attributedString( "已有帐号?", mainColor: UIColor.hex("666666"), mainFont: 16, second: "立即登录", secondColor: redColor, secondFont: 16)
        titleLabel.textAlignment = .center
        loginBtn.addSubview(titleLabel)
        
        //图标
        let  botomImgView = UIImageView(frame: CGRect(x:( SCREEN_WIDTH - 90 - 3 - 11 ) / 2, y: SCREEN_HEIGHT - 40 - 44, width: 11, height: 13))
        botomImgView.image = UIImage(named: "home_bottom")
        noLoginView.addSubview(botomImgView)
        
        //标题
        let  bottomTitleLabel = UILabel(frame: CGRect(x: botomImgView.maxX + 3, y: 0, width: 108, height: 12))
        bottomTitleLabel.font = UIFont.customFont(ofSize: 12)
        bottomTitleLabel.text = "资金由银行存管"
        bottomTitleLabel.centerY = botomImgView.centerY
        bottomTitleLabel.textColor = UIColor.hex("999999")
        noLoginView.addSubview(bottomTitleLabel)
    }
    
    @objc func btnClick(sender:UIButton)  {
        if sender.tag == 100 {
             MobClick.event("mine_login", label: nil)
            self.navigationController?.pushViewController(GPWLoginViewController(), animated: true)
        }else{
             MobClick.event("mine_register", label: nil)
            self.navigationController?.pushViewController(GPWUserRegisterViewController(), animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return  180 + 90 + 8
        }else if indexPath.section == 1 {
            if GPWUser.sharedInstance().is_idcard == 0{
                return  76 + 32 + 10
            }else{
                if GPWUser.sharedInstance().show_iden == 0 {
                    return  76 + 32 + 10
                }else{
                    return  76 + 10
                }
            }
        }else{
            return  290
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "topCell") as? UserTopCell
            if cell == nil {
                cell = UserTopCell(style: .default, reuseIdentifier: "topCell")
                cell?.callBack = { [weak self] flag in
                    guard let strongSelf = self else { return }
                    let  indexPath = IndexPath.init(row: 0, section: 3)
                    let tempCell = tableView.cellForRow(at: indexPath) as! UserThridCell
                    tempCell.updata(strongSelf.getDic(), superControl: strongSelf)
                }
            }
            if GPWUser.sharedInstance().isLogin {
                //余额  GPWUser.sharedInstance().money
                var phone = GPWUser.sharedInstance().telephone!
                if GPWUser.sharedInstance().is_idcard == 1 {
                    phone = GPWUser.sharedInstance().name ?? ""
                }
                cell?.updata(GPWUser.sharedInstance().accrual!, acountMoney: GPWUser.sharedInstance().totalMoney!, phone: phone, partMoney: GPWUser.sharedInstance().money!, superC: self)
            }else{
                cell?.updata("0.00", acountMoney: "0.00", phone: "***********", partMoney: "0.00",superC: self)
            }
            return cell!
        } else if indexPath.section == 1 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "secCell") as? UserSecondCell
            if cell == nil {
                cell = UserSecondCell(style: .default, reuseIdentifier: "secCell")
            }
            cell?.superControl = self
            if GPWUser.sharedInstance().is_idcard == 0{
               cell?.updata(flag: false)
            }else{
                 cell?.updata(flag: true)
                if GPWUser.sharedInstance().show_iden == 0 {
                    cell?.safeViewShow(flag: false)
                }else{
                     cell?.safeViewShow(flag: true)
                }
            }
            return cell!
        }else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "UserThridCell") as? UserThridCell
            if cell == nil {
                cell = UserThridCell(style: .default, reuseIdentifier: "UserThridCell")
            }
          let   dicArray = self.getDic()
            cell?.updata(dicArray, superControl: self)
            return cell!
        }
    }
    
    func checkRiskType() -> String {
        var  type = "保守型"
        if GPWUser.sharedInstance().risk <= 30 {
            //保守型
            type = "保守型"
        }else if GPWUser.sharedInstance().risk > 37 && GPWUser.sharedInstance().risk <= 72 {
            //稳健型
            type = "稳健型"
        }else{
            //进取型
            type = "进取型"
        }
        return type
    }

    //获取数据
    func getDic() -> [[String:String]] {
        var dicArray = [
            [ "img":"user_center_jilu","title":"出借记录","detail":"待收:\(GPWUser.sharedInstance().money_collection)"],
            [ "img":"user_center_rili","title":"回款日历","detail":"提前做好资金规划"],
            [ "img":"user_center_liushui","title":"资金流水","detail":"资金流水在这里"],
            [ "img":"user_center_rg","title":"红包加息券","detail":"0元红包可用"]
        ]
        dicArray.append( [ "img":"user_center_yaoqing","title":"我的邀请","detail":"查看邀请收益"])
        dicArray.append( [ "img":"user_center_kefu","title":"我的客服","detail":"有问题点这里"])
        return dicArray
    }
}
