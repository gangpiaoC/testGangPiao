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
    fileprivate var adFlag = 1 //是否有广告位  0 有  1没有
    
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
        
        showTableView = UITableView(frame: self.bgView.bounds, style: .grouped)
        showTableView.backgroundColor = bgColor
        showTableView?.delegate = self
        showTableView?.dataSource = self
        showTableView.showsVerticalScrollIndicator = false
        showTableView.separatorStyle = .none
        showTableView.register(GPWHomeTopCell.self, forCellReuseIdentifier: "GPWHomeTopCell")
        showTableView.register(GPWMessagesCell.self, forCellReuseIdentifier: "GPWMessagesCell")
        showTableView.register(GPWHomeSecViewCell.self, forCellReuseIdentifier: "GPWHomeSecViewCell")
        showTableView.register(GPWHomeAdCell.self, forCellReuseIdentifier: "GPWHomeAdCell")
        showTableView.register(GPWHPTopCell.self, forCellReuseIdentifier: "GPWHPTopCell")
        showTableView.register(GPWProjectCell.self, forCellReuseIdentifier: "GPWProjectCell")
        showTableView.register(GPWHNowCJCell.self, forCellReuseIdentifier: "GPWHNowCJCell")
        showTableView.register(GPWHomeBottomCell.self, forCellReuseIdentifier: "GPWHomeBottomCell")

        self.bgView.addSubview(showTableView)

        showTableView.estimatedRowHeight = 143
        showTableView.estimatedSectionHeaderHeight = 56
        showTableView.estimatedSectionFooterHeight = 0.00001

        if #available(iOS 11.0, *) {

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
            if json["new_banner"].dictionaryObject?.count ?? 0 > 0 {
                strongSelf.adFlag = 0
            }else{
                strongSelf.adFlag = 1
            }
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
            return 4 + (adFlag == 0 ? 1 : 0) + ( GPWUser.sharedInstance().staue == 0 ? 1 : 0)
        }
       return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //是否为新手
        let staue = GPWUser.sharedInstance().staue == 0 ? 0 : 1
        if section == 0 {
            return 3
        }else if section == 1 - adFlag {
            return 1
        }else if section == 2 - adFlag - staue{
            return 1
        }else if section == 3 - adFlag - staue{
            if GPWUser.sharedInstance().staue == 0 {
                return self.dic!["Item"].count - 1
            }else{
                return self.dic!["Item"].count
            }
        }else if section == 4 - adFlag - staue{
            return 1
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //是否为新手
        let staue = GPWUser.sharedInstance().staue ?? 0
        if staue == 1 {
            return 0.0001
        }else{
            if section == 3 - adFlag - staue {
                return 56
            }
        }

        return 0.0001
    }


    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //是否为新手
        let staue = GPWUser.sharedInstance().staue == 0 ? 0 : 1
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                   return pixw(p: 197)
            }else if indexPath.row == 1{
                return 40
            }else{
                return 97 + 10
            }
        }else if indexPath.section == 1 - adFlag{
            return pixw(p: 120) + 10
        }else if indexPath.section == 2 - adFlag - staue{
            return UITableViewAutomaticDimension
        }else if indexPath.section == 3 - adFlag - staue{
            return UITableViewAutomaticDimension
        }else if indexPath.section == 4 - adFlag - staue{
            return 130
        }else{
            return 301
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //是否为新手
        let staue = GPWUser.sharedInstance().staue
        if GPWUser.sharedInstance().staue == 1 {
            return nil
        }else{
            if section == 3 - adFlag - staue! {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 56))
                view.backgroundColor = UIColor.white

                let titleLabel = UILabel(frame: CGRect(x: 16, y: 0, width: SCREEN_WIDTH - 32, height: 56))
                titleLabel.font = UIFont.customFont(ofSize: 18)
                titleLabel.textColor = UIColor.hex("222222")
                titleLabel.text = "推荐产品"
                view.addSubview(titleLabel)


                let bottomLine = UIView(frame: CGRect(x: 16, y: 55, width: SCREEN_WIDTH - 16, height: 1))
                bottomLine.backgroundColor = bgColor
                view.addSubview(bottomLine)
                return view

            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //是否为新手
        let staue = GPWUser.sharedInstance().staue == 0 ? 0 : 1
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GPWHomeTopCell") as? GPWHomeTopCell
                cell?.showInfo(array: (self.dic?["banner"])! , control: self)
                return cell!
            }else if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "GPWMessagesCell") as? GPWMessagesCell
                cell?.updata(array: (self.dic?["indexMessage"])!)
                cell?.superController = self
                return cell!
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "GPWHomeSecViewCell") as? GPWHomeSecViewCell
                cell?.updata(dic: (self.dic?["pager"])!, superControl: self)
                return cell!
            }
        } else if indexPath.section == 1 - adFlag{
            let cell = tableView.dequeueReusableCell(withIdentifier: "GPWHomeAdCell") as? GPWHomeAdCell
            cell?.updata((self.dic?["new_banner"])!, self)
            return cell!

        } else  if indexPath.section == 2 - adFlag - staue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GPWHPTopCell") as? GPWHPTopCell
            cell?.setupCell(dict: self.dic!["Item"][indexPath.row])
            return cell!
        }else  if indexPath.section == 3 - adFlag - staue {
            var tempInedx = indexPath.row
            if GPWUser.sharedInstance().staue == 0 {
                tempInedx = indexPath.row + 1
            }
            var cell = tableView.dequeueReusableCell(withIdentifier: "GPWProjectCell") as? GPWProjectCell
            if cell == nil {
                cell = GPWProjectCell(style: .default, reuseIdentifier: "GPWProjectCell")
            }
           cell?.setupCell(dict: (self.dic?["Item"][tempInedx])!)
            return cell!
        }else  if indexPath.section == 4 - adFlag - staue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GPWHNowCJCell") as? GPWHNowCJCell
            cell?.updata((self.dic?["invest"].arrayValue)!)
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "GPWHomeBottomCell") as? GPWHomeBottomCell
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //是否为新手
        let staue = GPWUser.sharedInstance().staue == 0 ? 0 : 1
        if  indexPath.section == 0 {

        }else if indexPath.section == 1 - adFlag {
            self.navigationController?.pushViewController(GPWWebViewController(subtitle: "", url: self.dic!["new_banner"]["link"].stringValue), animated: true)
        }else if indexPath.section == 2 - adFlag - staue{
            MobClick.event("home", label: "新手标")
            let vc = GPWProjectDetailViewController(projectID: "\(self.dic?["Item"][0]["auto_id"].stringValue ?? "")")
            vc.title = self.dic?["Item"][0]["title"].string
            self.navigationController?.show(vc, sender: nil)
        }else if indexPath.section == 3 - adFlag - staue{
            MobClick.event("home", label: "普通标")
            var tempInedx = indexPath.row
            if GPWUser.sharedInstance().staue == 0 {
                tempInedx = indexPath.row + 1
            }
            let vc = GPWProjectDetailViewController(projectID: "\(self.dic?["Item"][tempInedx]["auto_id"].stringValue ?? "")")
            vc.title = self.dic?["Item"][tempInedx]["title"].string
            self.navigationController?.show(vc, sender: nil)
        }else if indexPath.section == 4 - adFlag - staue{

        }
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
}
