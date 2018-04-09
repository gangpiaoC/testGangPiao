//
//  GPWUser.swift
//  GangPiaoWang
//     
//  Created by GC on 16/11/29.
//  Copyright © 2016年 GC. All rights reserved.
//

import Foundation
import SwiftyJSON
public class GPWUser:NSObject {
    
    fileprivate static var userAccount: GPWUser?

    //红包钱数
    var  data_award:String = ""

    //加息券个数
    var  data_ticket:String = ""

    //体验金
    var  data_exper:String = ""

    //真实名字
    var name:String? = ""
    
    //无用  服务端会去除
    var salt:String?
    
    //实名认证是否通过“1”通过
    var is_idcard:Int? = 0
    
    //用户是否被锁定。“1”锁定
    var is_locked:String? = "0"
    
    //密码
    var password:String? = ""
    
    //用户id
    var user_id:Int? = 0
    
    //用户名称
    var user_name:String? = ""
    
    //用户手机号
    var telephone:String? = ""
    
    //可用余额
    var money:String? = "0.00"
    
    //展示修改支付密码弹窗 0 展示  1隐藏
    var real:Int? = 1
    
    //待收本金
    var capital:String? = "0.00"
    
    //待收利息
    var wait_accrual:String?="0.00"
    
    //待收本金加利息
    var money_collection:String = "0.00"
    
    //累计收益
    var accrual:String? = "0.00"
    
    //累计昨日盈利
    var totalAccrual:String? = "0.00"
    
    //冻结资金
    var money_freeze:String? = "0.00"

    //全部资产
    var totalMoney:String? = "0.00"
    
    //已收利息
    var alreadyRefundAccrual:String? = "0.00"
    
    //红包利息
    var award:String? = "0.00"
    
    //待收利息
    var waitRefundAccrual:String? = "0.00"
    
    //加息收益
    var ticket:String? = "0.00"
    
    //活动奖励
    var activity_money:String? = "0.00"
    
    //体验金收益
    var tiyanItemMoney:String? = "0.00"
    
    //银行code
    var bank_code:String?
    
    //银行logo
    var bank_logo:String?
    
    //银行名称
    var bank_name:String?
    
    //银行卡号
    var bank_num:String?
    
    //是否有效
    var is_valid:String? = "0"
    
    //邀请码
    var invite_code:String? = "0"
    
    //用户类型分值
    var risk:Int = 0
    
    //是否设置密码  1设置 0 未设置
    var set_pwd:Int = 0
    
    //是否出借过新手标
    var staue:Int? = 0
    
    //银行卡单笔限额
    var single_limit:Int? = 0
    
    //银行卡单日限额
    var day_limit:Int? = 0
    
    //是否登录
    var isLogin = false
    
    //是否显示我的邀请
    var show_iden:Int = 0
    
    //是否是新手（vip专用） 1:领头人  2：新用户未投资  3：已投资用户 4:vip新用户 投资过
    var identity:Int = 3
    
    //口令码
    var kouling:Int = 0

    //用户体验金
    var userTiyanMoney:Int = 58888

    //账户真实金额
    var real_money:String? = "0.00"
    
     let userPath = "userPath"
    public static func sharedInstance() ->GPWUser {
        if userAccount == nil {
            userAccount = GPWUser()
            let str = try? NSString(contentsOfFile: APP_DATA_PATH, encoding: String.Encoding.utf8.rawValue)
            if str != nil {
                let dic = JSON.parse(str! as String) as JSON
                userAccount?.analyUser(dic: dic)
            }
        }
        return userAccount!
    }
    
    func analyUser(dic: JSON) {
        saveAccount(dic: dic)
        printLog(message: dic)
        self.isLogin = true
        
        self.data_award = dic["data_award"].stringValue
        self.data_ticket = dic["data_ticket"].stringValue
        self.data_exper = dic["data_exper"].stringValue

        self.userTiyanMoney = dic["tiyan_amount"].intValue
        self.staue = dic["staue"].intValue
        self.kouling = dic["kouling"].intValue
        self.identity = dic["identity"].intValue
        self.real = dic["real"].intValue
        self.show_iden = dic["show_iden"].intValue
        self.set_pwd = dic["set_pwd"].intValue
        self.name = dic["userinfo"]["name"].string
        self.is_idcard = dic["userinfo"]["is_idcard"].int
        self.risk = dic["userinfo"]["risk"].intValue
        self.salt = dic["userinfo"]["salt"].string
        self.is_locked = dic["userinfo"]["is_locked"].string
        self.password = dic["userinfo"]["password"].string
        self.user_id = dic["userinfo"]["user_id"].int
        self.user_name = dic["userinfo"]["user_name"].string
        self.telephone = dic["userinfo"]["telephone"].string
        JPUSHService.setAlias(self.telephone, completion: { (num1, msg, num2) in

        }, seq: 1)
        self.invite_code = dic["userinfo"]["invite_code"].string
        self.money = dic["amount"]["money"].string
        self.capital = dic["amount"]["capital"].string
        self.real_money = dic["amount"]["real_money"].string
        self.wait_accrual = dic["amount"]["wait_accrual"].string
        self.money_collection = "\(dic["amount"]["money_collection"])"
        self.accrual = dic["amount"]["accrual"].string
        self.money_freeze = dic["amount"]["money_freeze"].string
        self.totalAccrual = dic["amount"]["totalAccrual"].string
        self.totalMoney = dic["amount"]["totalMoney"].string
        self.alreadyRefundAccrual = dic["amount"]["alreadyRefundAccrual"].string
        self.award = dic["amount"]["award"].string
        self.waitRefundAccrual = dic["amount"]["waitRefundAccrual"].string
        self.ticket = dic["amount"]["ticket"].string
        self.activity_money = dic["amount"]["activity_money"].string
        self.tiyanItemMoney = dic["amount"]["tiyanItemMoney"].string
        
        self.bank_code = dic["bank"]["bank_code"].string
        self.bank_logo = dic["bank"]["bank_logo"].string
        self.bank_name = dic["bank"]["bank_name"].string
        self.is_valid = dic["bank"]["is_valid"].string
         self.day_limit = dic["bank"]["day_limit"].intValue
         self.single_limit = dic["bank"]["single_limit"].intValue
        if self.is_valid == ""{
        self.is_valid = "0"
        }
        self.bank_num = dic["bank"]["bank_num"].string
    }
    
    func toLgoin(control:UIViewController) {
        if self.isLogin == false {
            control.navigationController?.pushViewController(control, animated: true)
        }
    }
    
    func getUserInfo() {
        if GPWUser.sharedInstance().isLogin {
            GPWNetwork.requetWithGet(url: User_informition, parameters: nil, responseJSON: {
                [weak self] (json, msg) in
                guard let strongSelf = self else { return }
                strongSelf.analyUser(dic: json)
                }, failure: { error in
            })
        }
    }
    fileprivate func saveAccount(dic: JSON) {
        do{
            try? dic.description.write(toFile: APP_DATA_PATH, atomically: true, encoding: String.Encoding.utf8)
        }
    }

    func outLogin() {
        let  cookieArray = HTTPCookieStorage.shared.cookies
        for tempcookie in cookieArray! {
            HTTPCookieStorage.shared.deleteCookie(tempcookie)
        }
         GYCircleConst.saveGesture(nil, key: gestureFinalSaveKey)
        self.isLogin = false
        JPUSHService.setAlias("", callbackSelector: nil, object: nil)
        let fileManager = FileManager.default
        let  isExist = fileManager.fileExists(atPath: APP_DATA_PATH)
        if isExist {
              try! fileManager.removeItem(atPath: APP_DATA_PATH)
        }
        self.name = ""
        self.is_idcard = 0
        self.salt = ""
        self.is_locked = "0"
        self.password = ""
        self.user_id = 0
        self.user_name = ""
        self.telephone = ""
        self.money = "0.00"
        self.capital = "0.00"
        self.accrual = "0.00"
        self.money_freeze = "0.00"
        self.totalAccrual = "0.00"
        self.totalMoney = "0.00"
        self.alreadyRefundAccrual = "0.00"
        self.award = "0.00"
        self.waitRefundAccrual = "0.00"
        self.ticket = "0.00"
        self.activity_money = "0.00"
        self.tiyanItemMoney = "0.00"
        self.bank_code = ""
        self.bank_logo = ""
        self.bank_name = ""
        self.is_valid = "0"
        self.bank_num = ""
        self.staue = 0
        self.kouling = 0
        self.identity = 3
        self.userTiyanMoney = 58888
        self.show_iden = 0
        self.real_money = "0.00"
        self.data_award = ""
        self.data_ticket = ""
        self.data_exper = ""
    }
}
