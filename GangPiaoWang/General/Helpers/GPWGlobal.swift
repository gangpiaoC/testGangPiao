//
//  GPWGlobal.swift
//  GangPiaoWang
//
//  Created by GC on 16/11/28.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWGlobal {
    
    fileprivate static var userAccount: GPWGlobal?
    fileprivate(set) var deviceToken: String = ""
    fileprivate(set) var deviceModel = ""
    fileprivate(set) var OSType = ""
    
    //当前控制器
    var  currentViewController:UIViewController?
    
    //初始化信息
    var  initJson:JSON?
    
    //跳转链接（首页前的弹窗用）
    var gotoUrl:String? = ""
    
    //跳转链接（首页广告弹窗用）
    var homeADtoUrl:String? = ""
    
    //是否给好评
    var  commFlag : String = "0"

    var  appUpdata:JSON?
    
    //体验金
    var app_exper_amount:String = "58888"
    
    //红包
    var app_accountsred:String = "618"
    
    //是否有首页前的弹窗
    var beforeADFlag = false
    
    //首页弹窗使用
    var  homePopDic:JSON?
    
    //针对团团赚 (领头人投资成功)
    var  vipSucessFlag = false

    //最新网络接口返回的msg
    var msg = ""

    //快捷注册后弹窗去实名~
    var  gotoNiceNameFlag = false

    //推送字段
    var  pushDic:[String:Any]?

    //初始化app tabbar
    var gpwbarController:GPWTabBarController?
    static func sharedInstance() ->GPWGlobal {
        if userAccount == nil {
            userAccount = GPWGlobal()
        }
        return userAccount!
    }
    init() {
        emptyData()
        if  gpwbarController == nil {
            gpwbarController = GPWTabBarController()
        }
    }
    fileprivate func emptyData() {
        deviceToken = ""
        //设备名
        deviceModel = GPWHelper.phonetype()
        //系统名
        OSType = UIDevice.current.systemName
        //系统版本
        let systemVersion = UIDevice.current.systemVersion
        let infoDict = Bundle.main.infoDictionary
        if let info = infoDict {
            // app名称
            let appName = info["CFBundleName"] as! String
            // app版本
            let appVersion = info["CFBundleShortVersionString"] as! String
            printLog(message: "app名称：\(appName)---\(appVersion)---\(systemVersion)")
        }
    }
}
