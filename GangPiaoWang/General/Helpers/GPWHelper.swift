//
//  GPWHelper.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/1.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWHelper {
    
    var buyHandle: (()->Void)?
    
    //MARK: /*************验证手机号***************
    static func judgePhoneNum(_ num: String? = "") -> Bool {
        if num == "" {
            return false
        }
        let regex = "[1][35789]\\d{9}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: num)
    }
    
    //MARK: /*************验证纯数字***************
    static func judgeDecimalNum(_ num: String) -> Bool {
        let regex = "^[0-9]*$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: num)
    }
    
    static func judgePw(pw:String = "") ->Bool {
        let regex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if predicate.evaluate(with: pw) {
            return true
        }else{
            return false
        }
    }
    
    //MARK: /*************切换tabbar***************
    static func selectTabBar(index: Int) {
        guard let rootVC = (UIApplication.shared.delegate?.window??.rootViewController as? GPWTabBarController) else {
            return
        }
        guard let navC = rootVC.selectedViewController as? GPWNavigationController else {
            return
        }
        let _ = navC.popToRootViewController(animated: false)
        rootVC.selectedIndex = index
    }
    
    //MARK: /*************当前navgationController***************
    static func selectedNavController() -> GPWNavigationController? {
        guard let rootVC = (UIApplication.shared.delegate?.window??.rootViewController as? GPWTabBarController) else {
            return nil
        }
        guard let navC = rootVC.selectedViewController as? GPWNavigationController else {
            return nil
        }
        return navC
    }
    
    /*
     手势
     */
    static func showgestureView(flag :Bool = false){
        if GPWGlobal.sharedInstance().currentViewController != nil {
            if (GPWGlobal.sharedInstance().currentViewController?.isKind(of: GestureViewController.self))!{
                return
            }
        }
        
        if GYCircleConst.getGestureWithKey(gestureFinalSaveKey) != nil {
            let gestureVC = GestureViewController()
            gestureVC.type = GestureViewControllerType.login
            gestureVC.flag = flag
            _ = GPWHelper.selectedNavController()?.pushViewController(gestureVC, animated: false)
        } 
    }
    
    /*
     *版本升级
     */
    static func  showVersionView(versionStr:String,flag:Int,version:String){
        let  array = versionStr.components(separatedBy: "&")
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        bgView.backgroundColor = UIColor.hex("000000", alpha: 0.75)
        bgView.tag = 10001
         let wid = UIApplication.shared.keyWindow
        wid?.addSubview(bgView)
        var  maxHeight:CGFloat = 0.0
        
        //内部背景
        let  contentBgView = UIImageView(frame: CGRect(x: 0, y: 87, width: 300, height: 420))
        contentBgView.image = UIImage(named: "version_bg")
        contentBgView.isUserInteractionEnabled = true
        contentBgView.centerX = SCREEN_WIDTH / 2
        bgView.addSubview(contentBgView)

        let  lineImgView = UIImageView(frame: CGRect(x: 0, y: 176, width: 220, height: 1))
        lineImgView.image = UIImage(named: "version_topLine")
        lineImgView.centerX = contentBgView.width / 2
        contentBgView.addSubview(lineImgView)

        //哪个版本
        let versionLabel = UILabel(frame: CGRect(x: 0, y: 0, width: contentBgView.width, height: 19))
        let infoDictionary = Bundle.main.infoDictionary
        let majorVersion  = infoDictionary!["CFBundleShortVersionString"] as! String
        versionLabel.text = "V\(majorVersion)发现新版本"
        versionLabel.textColor = UIColor.hex("333333")
        versionLabel.textAlignment = .center
        versionLabel.font = UIFont.customFont(ofSize: 18)
        versionLabel.centerY = lineImgView.centerY
        contentBgView.addSubview(versionLabel)

        maxHeight = versionLabel.maxY + 14

        let  scrollview = UIScrollView(frame: CGRect(x: 0, y: maxHeight, width: contentBgView.width, height: 146 - 14 - 20))
        contentBgView.addSubview(scrollview)
        maxHeight = 0
        for i in 0 ..< array.count {
            let numLabel = UILabel(frame: CGRect(x: 25, y: maxHeight + 5, width: 20, height: 10))
            numLabel.text = "\(i + 1)、"
            numLabel.font = UIFont.customFont(ofSize: 12)
            numLabel.textColor = UIColor.hex("333333")
            scrollview.addSubview(numLabel)
            
            let contLabel = RTLabel(frame: CGRect(x: numLabel.maxX + 4, y: maxHeight, width: contentBgView.width - numLabel.maxX - 4 - 25, height: 0))
            contLabel.text = "<font size=12 color='333333'>\(array[i])</font>"
            contLabel.height = contLabel.optimumSize.height
            scrollview.addSubview(contLabel)
            maxHeight = contLabel.maxY + 9
        }
        scrollview.contentSize = CGSize(width: scrollview.width, height: maxHeight + 10)
        maxHeight = scrollview.height + 31
        
        let  btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: contentBgView.height - 34 - 56, width: 248, height: 56)
        btn.setImage(UIImage(named:"version_updata"), for: .normal)
        btn.addTarget(self, action: #selector(GPWHelper.updataVersion), for: .touchUpInside)
        btn.centerX = contentBgView.width / 2
        contentBgView.addSubview(btn)
        maxHeight = btn.maxY + 34
        
        if flag == 1 {
            let  cancelBtn = UIButton(type: .custom)
            cancelBtn.frame = CGRect(x: 0, y: contentBgView.maxY + 28, width: 30, height: 30)
            cancelBtn.setImage(UIImage(named:"version_cancel"), for: .normal)
            cancelBtn.centerX = bgView.width / 2
            cancelBtn.addTarget(self, action: #selector(GPWHelper.deleClick), for: .touchUpInside)
            bgView.addSubview(cancelBtn)
        }
    }
    @objc static private func updataVersion() {
        let urlString = "https://itunes.apple.com/cn/app/%E9%92%A2%E7%A5%A8%E7%BD%91/id1197187486?mt=8"
        let url = NSURL(string: urlString)
        UIApplication.shared.openURL(url! as URL)
    }
    
     //MARK: /*************删除界面***************
    @objc static private func deleClick() {
       UIApplication.shared.keyWindow?.viewWithTag(10001)?.removeFromSuperview()
    }
    
    //MARK: /*************跳转登录界面***************
    static func gotoLogin() {
        let navContoller = GPWHelper.selectedNavController()
        navContoller?.pushViewController(GPWLoginViewController(), animated: true)
    }
    
    //MARK: /*************根据格式获取日期***************
    static func strFromDate(_ date: Double, format:String) -> String {
        let date = Date(timeIntervalSince1970: date)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: date)
    }
    
    //MARK: /*************截取小数不四舍五入***************
    static func notRounding(_ price: Double, afterPoint position: Int) -> String {
        let roundingBehavior = NSDecimalNumberHandler(roundingMode: .down, scale: Int16(position), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let ouncesDecimal = NSDecimalNumber(value: price)
        let roundedOunces = ouncesDecimal.rounding(accordingToBehavior: roundingBehavior)
        return "\(roundedOunces)"
    }
    
    /**
     *  展示首页广告弹窗
     */
    static func showHomeAD(url:String){
        let wid = UIApplication.shared.keyWindow
        
        let  bgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        bgView.backgroundColor = UIColor.hex("000000", alpha: 0.6)
        bgView.tag = 10001
        wid?.addSubview(bgView)
        
        //跳转
        let sureBtn = UIButton(type: .custom)
        sureBtn.addTarget(self, action: #selector(GPWHelper.HomeADClick), for: .touchUpInside)
        bgView.addSubview(sureBtn)
        
        sureBtn.snp.makeConstraints { (maker) in
            maker.center.equalTo(bgView)
            maker.width.equalTo(306)
            maker.height.equalTo(292)
        }

        let imgView = UIImageView()
        sureBtn.addSubview(imgView)
        
        imgView.snp.makeConstraints { (maker) in
            maker.top.left.bottom.right.equalTo(sureBtn)
        }
        
        imgView.downLoadImg(imgUrl: url, placeImg: "")
        
        //取消
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.setImage(UIImage(named: "version_cancel"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(GPWHelper.deleClick), for: .touchUpInside)
        bgView.addSubview(cancelBtn)
        
        cancelBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(imgView.snp.bottom).offset(30)
            maker.centerX.equalTo(SCREEN_WIDTH / 2)
        }
    }
    
    /**
     *  首页广告弹窗跳转
     */
    @objc private static func HomeADClick(){
        GPWHelper.gotoController(url:  GPWGlobal.sharedInstance().homeADtoUrl! )
    }
    
    /**
     *  实名认证成功
     */
    static func authNameSucess(){
        let wid = UIApplication.shared.keyWindow
        
        let  bgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        bgView.backgroundColor = UIColor.hex("000000", alpha: 0.6)
        bgView.tag = 10001
        wid?.addSubview(bgView)
        
        let  tempBgView = UIView(frame: CGRect(x: 0, y: 0, width: 296, height: 279))
        tempBgView.layer.masksToBounds = true
        tempBgView.layer.cornerRadius = 4
        tempBgView.centerX = bgView.width / 2
        tempBgView.backgroundColor = UIColor.white
        tempBgView.center = CGPoint(x: bgView.width / 2, y: bgView.height / 2)
        bgView.addSubview(tempBgView)
        
        let  imgView = UIImageView(frame: CGRect(x: 0, y: 42, width: 69, height: 70))
        imgView.centerX = tempBgView.width / 2
        imgView.image = UIImage(named: "project_investSucess")
        tempBgView.addSubview(imgView)
        
        let  temp1Label = UILabel(frame: CGRect(x: 0, y: imgView.maxY + 30, width: tempBgView.width, height: 21))
        temp1Label.text = "存管帐户开通成功"
        temp1Label.textAlignment = .center
        temp1Label.font = UIFont.customFont(ofSize: 20)
        temp1Label.textColor = titleColor
        tempBgView.addSubview(temp1Label)
        
        let  temp2Label = RTLabel(frame: CGRect(x: 0, y: temp1Label.maxY + 32, width: tempBgView.width, height: 21))
        temp2Label.text =  "<font size=18 color='#666666'>已成功获得</font><font size=18 color='#f8703d'>\(GPWGlobal.sharedInstance().app_accountsred)元</font><font size=18 color='#666666'>红包</font>"
        temp2Label.textAlignment = RTTextAlignmentCenter
        temp2Label.height = temp2Label.optimumSize.height
        tempBgView.addSubview(temp2Label)
        
        //取消
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.frame = CGRect(x: 0, y: tempBgView.maxY + 28, width: 38, height: 38)
        cancelBtn.setImage(UIImage(named: "ad_cancel"), for: .normal)
        cancelBtn.imageView?.contentMode = .scaleAspectFill 
        cancelBtn.centerX = tempBgView.centerX
        cancelBtn.addTarget(self, action: #selector(GPWHelper.deleClick), for: .touchUpInside)
        bgView.addSubview(cancelBtn)
    }
    
    /**
     *  首投
     */
    @objc private static func gotoFirstPay(){
        GPWHelper.deleClick()
        GPWHelper.selectTabBar(index: PROJECTBARTAG)
    }
    
    static func gotoController(url:String = ""){
        
        GPWHelper.deleClick()
        if url == "" {
            return
        }
        
        if (url.range(of: "https")) != nil{
            if(url.count) > 6 {
                 _ = GPWHelper.selectedNavController()?.pushViewController(GPWWebViewController(subtitle: "", url: url), animated: true)
            }
        }else{
             _ = GPWHelper.selectedNavController()?.pushViewController(GPWProjectDetailViewController(projectID: url), animated: true)
        }
    }
    
    /**
     *  获取当前Day 年、月、日、是否为当天 1是  0不是
     */
    static func getDay() ->[String] {
        //获取当前时间
        let now = Date()
        
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy"
        let  year = dformatter.string(from: now)
        
        dformatter.dateFormat = "MM"
        let  m = dformatter.string(from: now)
        
        dformatter.dateFormat = "dd"
        let  dd = dformatter.string(from: now)
        
        let tempDay = UserDefaults.standard.value(forKey: "dd") as? String ?? ""
        if tempDay != dd {
              UserDefaults.standard.set(dd, forKey: "dd")
              return [year,m,dd,"0"]
        }else{
             return [year,m,dd,"1"]
        }
    }
    
    
    //MARK: /*************获得手机型号***************
    static func phonetype () -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        
        switch identifier {
        //iPhone
        case "iPhone1,1":                return "iPhone 1G"
        case "iPhone1,2":                return "iPhone 3G"
        case "iPhone2,1":                return "iPhone 3GS"
        case "iPhone3,1", "iPhone3,2":   return "iPhone 4"
        case "iPhone4,1":                return "iPhone 4S"
        case "iPhone5,1", "iPhone5,2":   return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":   return "iPhone 5C"
        case "iPhone6,1", "iPhone6,2":   return "iPhone 5S"
        case "iPhone7,1":                return "iPhone 6 Plus"
        case "iPhone7,2":                return "iPhone 6"
        case "iPhone8,1":                return "iPhone 6s"
        case "iPhone8,2":                return "iPhone 6s Plus"
        case "iPhone8,4":                return "iPhone SE"
        case "iPhone9,1":                return "iPhone 7"
        case "iPhone9,2":                return "iPhone 7 Plus"
            
        case "iPad3,1":                 return "iPad 3"
        case "iPad3,2":                 return "iPad 3"
        case "iPad3,3":                 return "iPad 3"
            
        case "iPad3,4":                 return "iPad 4"
        case "iPad3,5":                 return "iPad 4"
        case "iPad3,6":                 return "iPad 4"
        case "iPad4,1":                 return "iPad Air"
        case "iPad4,2":                 return "iPad Air"
        case "iPad4,3":                 return "iPad Air"
        default: return identifier
        }
    }
}

