//
//  GPWHomeViewController.swift
//  GangPiaoWang
//   首页
//  Created by GC on 16/12/2.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWHomeViewController: GPWBaseViewController,UITableViewDelegate,UITableViewDataSource {
    fileprivate var maxAplha:CGFloat = 1
    fileprivate var dic:JSON?
    fileprivate var _scrollviewOffY:CGFloat = 0
    fileprivate var showTableView:UITableView!
    fileprivate var  messageImgView:UIImageView!
    
    //首页出现此时
    var  showNum = 0
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNum = showNum + 1
        if showNum == 1 && GYCircleConst.getGestureWithKey(gestureFinalSaveKey) != nil  {
            if GPWGlobal.sharedInstance().initJson?["app_popup"]["img_url"].stringValue.count ?? 0 > 7 {
                if  GPWHelper.getDay()[3] == "0" {
                    GPWHelper.showHomeAD(url: (GPWGlobal.sharedInstance().initJson?["app_popup"]["img_url"].stringValue)!)
                    GPWGlobal.sharedInstance().homeADtoUrl = GPWGlobal.sharedInstance().initJson?["app_popup"]["link"].stringValue
                }
            }
        }
         self.navigationController?.navigationBar.barStyle = .black
        self.getNetData()
          self.appInfo()
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
        GPWHelper.showgestureView(flag: true)
        //初始化界面
        initView()
        //获取数据
        getNetData()
        if GPWGlobal.sharedInstance().pushDic != nil {
            UIApplication.shared.keyWindow?.makeToast("\(String(describing: GPWGlobal.sharedInstance().pushDic!))")
           self.dealMessageFromXG(GPWGlobal.sharedInstance().pushDic!)
            GPWGlobal.sharedInstance().pushDic = nil
        }
    }
    // 接收到推送实现的方法
    func dealMessageFromXG(_ userInfo : [String:Any]) {
        printLog(message: userInfo)
        if  UIApplication.shared.applicationState == .active {
            return
        }
        let  navController = GPWHelper.selectedNavController()
        printLog(message: navController)
        UIApplication.shared.applicationIconBadgeNumber = 0

        if let type = userInfo["type"] {
            let tempType = type as! String
            printLog(message: type)
            if  tempType == "1"{
                let vc = GPWWebViewController(subtitle: "", url: userInfo["link"] as! String)
                navController?.pushViewController(vc, animated: true)
            }else if tempType == "2"{
                let ttzController = GPWFTTZHController()
                ttzController.urlstr = userInfo["link"] as? String
                navController?.pushViewController(ttzController, animated: true)
            }else if tempType == "3"{
                navController?.pushViewController(GPWProjectDetailViewController(projectID: userInfo["link"] as! String), animated: true)
            }
        }
    }

    
    func initView() {
        let iosVersion = UIDevice.current.systemVersion //iOS版本
        let strNum = NSString(string:iosVersion).doubleValue
        self.navigationBar.title = "钢票网"
        self.isBarHidden = false
        self.navigationBar.alpha = 0.0

        if SCREEN_HEIGHT == 812.0 {
            self.bgView.y = self.bgView.y - 25
            self.bgView.height = self.bgView.height  + 25
        }else if strNum != 10 {
            self.bgView.y = 0
            self.bgView.height =   self.bgView.height + 64
        }
        self.navigationBar.backgroundColor = redTitleColor
        self.navigationBar.titleLabel.textColor = UIColor.white
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.navigationBar.bounds

        //设置渐变的主颜色
        gradientLayer.colors = [UIColor.hex("ff790c").cgColor, redTitleColor.cgColor]
        //将gradientLayer作为子layer添加到主layer上
        self.navigationBar.layer.addSublayer(gradientLayer)
        self.navigationBar.insertSubview(self.navigationBar.titleLabel, at: 100)
        
        showTableView = UITableView(frame: self.bgView.bounds, style: .plain)
        showTableView.backgroundColor = bgColor
        showTableView?.delegate = self
        showTableView?.dataSource = self
        showTableView.showsVerticalScrollIndicator = false
        showTableView.separatorStyle = .none
        self.bgView.addSubview(showTableView)
        if #available(iOS 11.0, *) {
            showTableView.estimatedRowHeight = 0
            showTableView.estimatedSectionHeaderHeight = 0
            showTableView.estimatedSectionFooterHeight = 0
            showTableView.contentInsetAdjustmentBehavior = .never
            showTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)//导航栏如果使用系统原生半透明的，top设置为64
            showTableView.scrollIndicatorInsets = showTableView.contentInset
        }

        showTableView.setUpHeaderRefresh {
            [weak self] in
            guard let self1 = self else {return}
            self1.getNetData()
        }
    }
    
    override func getNetData(){
        GPWNetwork.requetWithGet(url: Index, parameters: nil, responseJSON:  {
            [weak self] (json, msg) in
            printLog(message: json)
                guard let strongSelf = self else { return }
                strongSelf.showTableView.endHeaderRefreshing()
                strongSelf.dic = json
                strongSelf.showTableView.reloadData()
            }, failure:  {[weak self] error in
                printLog(message: error.localizedDescription)
                guard let strongSelf = self else { return }
                strongSelf.showTableView.endHeaderRefreshing()
        })
    }
    //版本升级
    func appInfo()  {
        //最新版本
        if let json = GPWGlobal.sharedInstance().appUpdata {
            let newStr = json["ios"].stringValue.replacingOccurrences(of: ".", with: "")
            let newInt = (newStr as NSString).intValue

            //当前版本
            let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
            let currentStr = currentVersion.replacingOccurrences(of: ".", with: "")
            let currentInt = (currentStr as NSString).intValue
            if currentInt < newInt{
                GPWHelper.showVersionView(versionStr:   json["update_content"].stringValue,flag: json["mandatory_update"].intValue, version: json["ios"].stringValue)
                GPWGlobal.sharedInstance().appUpdata = nil
            }
        }
    }
}
extension GPWHomeViewController{
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.dic != nil {
            return 5
        }
       return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else if section == 1 {
            if GPWUser.sharedInstance().isLogin {
                return 1
            }else{
                return 2
            }
        }else if section == 2{
            return self.dic!["Item"].count
        }else if section == 3 {
            return 2
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                   return pixw(p: 206)
            }else{
                return 40
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 114 + 10
            }else{
                return pixw(p: 120) + 10
            }
        }else if indexPath.section == 2{

            if indexPath.row == 0 {
                return 264 + 12
            }else{
                return 151 + 10
            }
        }else if indexPath.section == 3 {
            if indexPath.row == 0 {
                return 40
            }else{
                return 102
            }
        }else{
            return 118 / 2 
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                var cell = tableView.dequeueReusableCell(withIdentifier: "GPWHomeTopCell") as? GPWHomeTopCell
                if cell == nil {
                    cell = GPWHomeTopCell(style: .default, reuseIdentifier: "GPWHomeTopCell")
                }
                cell?.showInfo(array: (self.dic?["banner"])! , control: self)
                return cell!
            }else{
                var cell = tableView.dequeueReusableCell(withIdentifier: "GPWMessagesCell") as? GPWMessagesCell
                if cell == nil {
                    cell = GPWMessagesCell(style: .default, reuseIdentifier: "GPWMessagesCell")
                }
                cell?.updata(array: (self.dic?["indexMessage"])!)
                cell?.superController = self
                return cell!
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                var cell = tableView.dequeueReusableCell(withIdentifier: "GPWHomeSecTableViewCell") as? GPWHomeSecViewCell
                if cell == nil {
                    cell = GPWHomeSecViewCell(style: .default, reuseIdentifier: "GPWHomeSecTableViewCell")
                }
                cell?.updata(dic: (self.dic?["pager"])!, superControl: self)
                return cell!
            }else{
                var cell = tableView.dequeueReusableCell(withIdentifier: "newReisterCell")
                if cell == nil {
                    cell = UITableViewCell(style: .default, reuseIdentifier: "newReisterCell")
                    cell?.selectionStyle = .none
                    let newImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: pixw(p: 120)))
                    newImgView.image = UIImage(named: "home_new_register")
                    cell?.contentView.addSubview(newImgView)
                    
                    let btn = UIButton(type: .custom)
                    btn.frame = CGRect(x: SCREEN_WIDTH - pixw(p: 116), y: pixw(p: 16), width: pixw(p: 100), height: pixw(p: 36))
                    btn.addTarget(self, action: #selector(self.gotoRegister), for: .touchUpInside)
                    cell?.contentView.addSubview(btn)

                    let  label = RTLabel(frame: CGRect(x: pixw(p: 16), y: pixw(p: 79), width: SCREEN_WIDTH - pixw(p: 72 + 29), height: 0))
                    label.text = "<font size=22 color='#666666'>\(GPWGlobal.sharedInstance().app_exper_amount)</font><font size=14 color='#666666'>元</font><font size=14 color='#666666'>体验金+</font><font size=22 color='#666666'>\(GPWGlobal.sharedInstance().app_accountsred)</font><font size=14 color='#666666'>元</font><font size=14 color='#666666'>红包</font>"
                    label.height = label.optimumSize.height
                    cell?.contentView.addSubview(label)

                    
                    let block = UIView(frame: CGRect(x: 0, y: pixw(p: 120), width: SCREEN_WIDTH, height: 10))
                    block.backgroundColor = bgColor
                    cell?.contentView.addSubview(block)
                }
                return cell!
            }
        } else  if indexPath.section == 2{
            if indexPath.row == 0 {
                var cell = tableView.dequeueReusableCell(withIdentifier: "GPWHPTopCell") as? GPWHPTopCell
                if cell == nil {
                    cell = GPWHPTopCell(style: .default, reuseIdentifier: "GPWHPTopCell")
                }
                cell?.setupCell(dict: (self.dic?["Item"][indexPath.row])!, index: indexPath.row)
                return cell!
            }else{
                var cell = tableView.dequeueReusableCell(withIdentifier: "GPWHProjectCell") as? GPWHProjectCell
                if cell == nil {
                    cell = GPWHProjectCell(style: .default, reuseIdentifier: "GPWHProjectCell")
                }
                cell?.setupCell(dict: (self.dic?["Item"][indexPath.row])!)
                return cell!
            }
        }else  if indexPath.section == 3{
            if indexPath.row == 0 {
                var cell = tableView.dequeueReusableCell(withIdentifier: "GPWHThone")
                if cell == nil {
                    cell = UITableViewCell(style: .default, reuseIdentifier: "GPWHThone")
                    cell?.textLabel?.font = UIFont.customFont(ofSize: 14)
                    cell?.textLabel?.text = "恒丰银行资金存管"
                    cell?.textLabel?.textAlignment = .center
                    cell?.textLabel?.textColor = UIColor.hex("9e9e9e")
                    cell?.backgroundColor = UIColor.clear
                }
                return cell!
            }else{
                var cell = tableView.dequeueReusableCell(withIdentifier: "GPWHomeNewsCell") as? GPWHomeNewsCell
                if cell == nil {
                    cell = GPWHomeNewsCell(style: .default, reuseIdentifier: "GPWHomeNewsCell")
                }
                cell?.updata((self.dic?["invest"].arrayValue)!)
                cell?.surperController = self
                return cell!
            }
        }else{
            var cell = tableView.dequeueReusableCell(withIdentifier: "GPWHomeBottomCell") as? GPWHomeBottomCell
            if cell == nil {
                cell = GPWHomeBottomCell(style: .default, reuseIdentifier: "GPWHomeBottomCell")
            }
            cell?.updata()
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var arrayIndex = 0
        if indexPath.section == 2 || indexPath.section == 3{
            if indexPath.section == 3 {
                arrayIndex = 1
            }
            let projectID = self.dic?["Item"][indexPath.row - arrayIndex]["auto_id"]
            let  type = self.dic?["Item"][indexPath.row - arrayIndex]["is_index"].intValue
            if type == 2 {
                MobClick.event("home", label: "体验标")
                self.navigationController?.pushViewController(GPWHomeTiyanViewController(tiyanID:"\(projectID!)"), animated: true)
            }else if type == 1 {
                MobClick.event("home", label: "新手标")
                let vc = GPWProjectDetailViewController(projectID: "\(projectID!)")
                vc.title = self.dic?["Item"][indexPath.row - arrayIndex]["title"].string
                self.navigationController?.show(vc, sender: nil)
            }else{
                MobClick.event("home", label: "热门标")
                let vc = GPWProjectDetailViewController(projectID: "\(projectID!)")
                vc.title = self.dic?["Item"][indexPath.row - arrayIndex]["title"].string
                self.navigationController?.show(vc, sender: nil)
            }
        }
    }
    
    @objc func gotoRegister(){
        MobClick.event("home", label: "新手注册")
        self.navigationController?.pushViewController(GPWUserRegisterViewController(), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var navAlpha = self.navigationBar.alpha
        
        if scrollView.contentOffset.y <= 0 {
            navAlpha = 0.0
        }else  if scrollView.contentOffset.y >= 100 {
            navAlpha = maxAplha
        }else {
            if scrollView.contentOffset.y > _scrollviewOffY {
                navAlpha = navAlpha + maxAplha / 100
            }else if scrollView.contentOffset.y < _scrollviewOffY {
                navAlpha = navAlpha - maxAplha / 100
            }
        }
         self.navigationBar.alpha = navAlpha
        _scrollviewOffY = scrollView.contentOffset.y
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.dic != nil {
            let index = IndexPath(row: 0, section: 4)
            let  cell = showTableView.cellForRow(at: index) as? GPWHomeBottomCell
            if cell != nil {
                cell?.updata()
            }
        }
    }
}
