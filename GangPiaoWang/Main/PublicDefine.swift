
//
//  PublicDefine.swift
//  GangPiaoWang
//
//  Created by GC on 16/11/24.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
func printLog<T>(message: T,
              file: String = #file,
              line: Int = #line)
{
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("\(fileName)第\(line)行：\(message)")
    #endif
}

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let kMainScreenBounds = UIScreen.main.bounds

//首页
let INDEXBARTAG = 0

//项目列表
let PROJECTBARTAG = 1

//发现
let FINDBARTAG = 2

//我的
let MINEBARTAG = 3

//根据当前屏幕宽度得到宽度
func pixw(p:CGFloat) ->CGFloat{
    return (SCREEN_WIDTH/375.0)*p
}

//根据当前屏幕高度得到高度
func pixh(p:CGFloat) ->CGFloat{
    return (SCREEN_HEIGHT/667.0)*p
}
//用户手机和手势密码
let  USERPHONEGETURE = "USERPHONEGETURE"
//退出到后台的时间
let  BACKGTOUND = "BACKGTOUND"
//用户登录手机号
let USER了OGINPHONE = "USER了OGINPHONE"
let baseColor = UIColor.hex("ffffff")
let lineColor = UIColor.hex("e6e6e6")
let bgColor = UIColor.hex("f2f2f2")
let titleColor = UIColor.hex("333333")
let subTitleColor = UIColor.hex("666666")
let timeColor = UIColor.hex("999999")
let urlColor = UIColor.hex("00affe")
let redColor = UIColor.hex("f6390d")
let redTitleColor = UIColor.hex("f6390c")

#if DEBUG
//测试服务器地址
    let SERVER = "https://tapi.gangpiaowang.com/Api/"
    let SHARE_URL = "https://tpc.gangpiaowang.com/Web/share"
    let HTML_SERVER = "https://tpc.gangpiaowang.com"
#else
//正式服务器地址
let SERVER = "https://api.gangpiaowang.com/Api/"
let SHARE_URL = "https://www.gangpiaowang.com/Web/share"
//网页前缀
let HTML_SERVER = "https://www.gangpiaowang.com"
#endif

//友盟统计
let MobClickKey = "5872f1f465b6d63ee0003c52"

////Share 分享
//let MobShareAppKey = "14bea45816cef"
//let MobShareAppSecret = "1dfef35d99735e08638f81eca631d133"


//微信分享
let WeChatAppKey = "wx00b1f177d1f6da3d"
let WeChatAppSecret = "678a0dc8a55a424098b0cf27bb5e6d45"

//分享再定向网址
let RedirectUri = "https://www.gangpiaow.com"

//分享自带图片
let SHARE_IMG_URL =  "https://www.gangpiaowang.com/resource/img/ic_launcher.png"

//用户信息路径
let APP_DATA_PATH = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/user.data"

//项目列表列表
let Financing_list = "financing_list"

//混合项目列表
let Financing_lists = "financing_lists"

//理财详情
let Financing_details = "financing_details"

//项目简介，常见问题，出借记录
let Financing_details_jct = "financing_details_jct"

//确认出借初始
let Financing_display = "financing_display"

//确认出借投资
let Confirm_invest = "zhongzhuan"

//登录
let Login = "login"

//注册
let Depose_register = "depose_register"

//首页
let Index = "index"

//平台公告
let  News = "news"

//回款公告
let  Payment = "payment"

//出借记录
let Invest_record = "invest_record"

//修改密码
let User_pwd = "user_pwd"

//退出
let Login_outs = "login_outs"

//忘记密码
let Forget = "forget"

//我的红包
let  Useraccounts_myred = "useraccounts_myred"

//我的加息券
let User_ticket = "user_ticket"

//我的体验金
let  User_experient = "user_experient"

//日历
let  Api_refund_calendar = "api_refund_calendar"

//获取充值最小金额
let Api_user_accounts_recharge = "api_user_accounts_recharge"

//充值提交
let Api_user_deposit_recharge = "api_user_deposit_recharge"

//获取个人信息
let User_informition = "user_informition"

//资金流水
let Money_record = "money_record"

//实名认证
let Auth_user = "auth_user"

//提现手续费
let Api_cash_fee = "api_cash_fee"

//提现
let Api_user_withdrawals = "api_user_withdrawals"

//体验标详情
let  Exper_details = "exper_details"

//体验标
let Exper_bid = "exper_bid"

//消息  平台公告
let User_message = "user_message"

//更新消息数量
let Update_messages = "update_messages"

//我的邀请
let Api_my_invite = "api_my_invite"

//消息数量
let Message_count = "message_count"

//反馈
let Feedback = "feedback"

//累计收益
let Api_cumulative = "api_cumulative"

//是否注册
let Num_phone = "num_phone"

//短信验证
let Get_news_captcha_app = "get_news_captcha_app"

//短信验证（注册下一步）
let Register_next = "register_next"

//短信验证（找回密码下一步）
let Forget_next = "forget_next"

//支付密码修改
let Api_user_trade_succes = "api_user_trade_succes"

//出借详情
let Invest_record_content = "invest_record_content"

//配置信息
let  Api_comment = "api_comment"

//快捷登录获取验证码
let  Quick_captcha = "quick_captcha"

//快捷登录
let  Quick_login = "quick_login"

//获取短信验证码  1.2
let  Get_news_quickcaptcha = "get_news_quickcaptcha"

//媒体报道
let  Media_report = "media_report"

//设置密码（快捷登录）
let User_setpwd = "user_setpwd"

//初始化接口
let App_initialize = "app_initialize"

//提现信息
let Api_newcash_fee = "api_newcash_fee"

//活动列表
let  Api_active = "api_active"

//分享成功后
let  Api_sendaward = "api_sendaward"

//风险测评
let  Risk_score = "risk_score"

//红包列表
let Gredred_moneylist = "gredred_moneylist"

//抢红包
let Gredred_money = "gredred_money"

//银行限额
let Bank_limit = "bank_limit"

//解绑手机号
let  Api_unbundphone = "api_unbundphone"

//绑定手机号
let  Api_bind_phone = "api_bind_phone"

//钢票学院
let  Find_ticket = "find_ticket"

//发现
//发现首页
let  Find = "find"

//帮助中心
let Help_center = "help_center"


//团团赚
//vip列表
let  TTZ_list  = "TTZ_list"

//二级界面立即加入
let  TTZ_join = "TTZ_join"

//标的详情
let  TTZ_details = "TTZ_details"

//vip领投成功分享接口
let  Invest_success_share = "invest_success_share"

//体验金记录
let Exper_invest_list = "exper_invest_list"

//城市列表
let  CityAddress = "address"

//网贷课堂
let  Net_loan = "net_loan"

//法律法规
let  Statute = "statute"

//设置登录密码
let Setup = "setup"
