//
//  AppDelegate.swift
//  GangPiaoWang
//
//  Created by GC on 16/11/21.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,JPUSHRegisterDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        //解析用户信息
        GPWUser.sharedInstance().getUserInfo()

        //初始化全局
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.white
        self.window?.rootViewController = UIViewController()
        self.window!.makeKeyAndVisible()
        self.getAppInit()
        
        //开始监测网络连接状态
        GPWNetwork.shareNetwork.startListening()
        
        //注册分享
        GPWShare.registerShare()
        
        //配置极光推送
        let entity = JPUSHRegisterEntity()
        entity.types = Int(JPAuthorizationOptions.alert.rawValue) |  Int(JPAuthorizationOptions.sound.rawValue) |  Int(JPAuthorizationOptions.badge.rawValue)
        
        //友盟统计
        let config = UMAnalyticsConfig.sharedInstance()
        config?.appKey = MobClickKey
        MobClick.start(withConfigure: config)
        MobClick.setEncryptEnabled(true)
        
        //极光注册
        self.registerJG(launchOptions: launchOptions)
        UIApplication.shared.applicationIconBadgeNumber = 0;
        return true
    }
    
    //获取初始化信息
    func getAppInit()  {
        GPWNetwork.requetWithPost(url: App_initialize, parameters: nil, responseJSON: {
            [weak self] (json, msg) in
            guard let strongSelf = self else { return }
            printLog(message: json)
            GPWGlobal.sharedInstance().initJson = json
            GPWGlobal.sharedInstance().app_accountsred = "\(json["app_accountsred"].intValue)"
            GPWGlobal.sharedInstance().app_invite_link = json["app_invite_link"].stringValue
            GPWGlobal.sharedInstance().app_exper_amount = "\(json["app_exper_amount"].intValue)"
            GPWGlobal.sharedInstance().app_exper_income = "\(json["app_exper_accrual"].stringValue)"
            GPWGlobal.sharedInstance().app_exper_rate = "\(json["app_exper_rate"].intValue)"
            if UserDefaults.standard.value(forKey: "new") as? String == "true" {
                 UIApplication.shared.isStatusBarHidden = false
                if  let  json = GPWGlobal.sharedInstance().initJson {
                    GPWGlobal.sharedInstance().commFlag =   json["app_info"]["give_praise"].stringValue
                    GPWGlobal.sharedInstance().appUpdata = json["app_info"]
                    printLog(message: json)
                    if json["app_info"]["advert_picture"].stringValue.count > 5 && json["app_info"]["is_vaild"].intValue == 1 {
                        let adController = GPWADViewController(imgStr: json["app_info"]["advert_picture"].stringValue, toUrl: json["app_info"]["advert_url"].stringValue)
                        strongSelf.window?.rootViewController = adController
                    }
                }
            }else{
                self?.window?.rootViewController = GPWIntroduceViewController()
                UserDefaults.standard.set("true", forKey: "new")
            }
        }) { (error) in
            
        }
    }
    func registerJG(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        //配置极光推送
        let entity = JPUSHRegisterEntity()
        entity.types = Int(JPAuthorizationOptions.alert.rawValue) |  Int(JPAuthorizationOptions.sound.rawValue) |  Int(JPAuthorizationOptions.badge.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        // 注册极光推送
        JPUSHService.setup(withOption: launchOptions, appKey: "c6e8bb9d040bb6d064c7a7ee", channel:"App Store" , apsForProduction: false);
        // 获取推送消息
        let remote = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String:Any]
        // 如果remote不为空，就代表应用在未打开的时候收到了推送消息
        if remote != nil {
            // 收到推送消息实现的方法
            printLog(message:remote)
            GPWGlobal.sharedInstance().pushDic = remote
        }
    }
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
        let userInfo = notification.request.content.userInfo;
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }else{
            //本地推送
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo as? [String:Any]
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }else{
            //本地推送
        }
        completionHandler()
        self.dealMessageFromXG(userInfo!)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo);
        completionHandler(UIBackgroundFetchResult.newData);
        let remote = userInfo as?  [String:Any]
        self.dealMessageFromXG(remote!)
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

            }else if tempType == "3"{
                navController?.pushViewController(GPWProjectDetailViewController(projectID: userInfo["link"] as! String), animated: true)
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
        printLog(message: "didRegisterForRemoteNotificationsWithDeviceToken")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("进入后台")
        UserDefaults.standard.set(Int(Date().timeIntervalSince1970), forKey: BACKGTOUND)
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        GPWUser.sharedInstance().getUserInfo()
        let timeInterval = UserDefaults.standard.value(forKey: BACKGTOUND)
        if timeInterval == nil {
            return
        }
        let tempTimeInterval = timeInterval as! Int
        let nowInterval = Int(Date().timeIntervalSince1970)
        print("\(timeInterval ?? 00)   ===   \(nowInterval)")
        if nowInterval - tempTimeInterval >= 30 * 60 {
            GPWHelper.showgestureView()
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
