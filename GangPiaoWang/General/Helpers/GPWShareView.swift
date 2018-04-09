//
//  GPWShareView.swift
//  GangPiaoWang
//
//  Created by GC on 17/1/6.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWShare: NSObject {
    static let shared = GPWShare()
    fileprivate var title: String = ""
    fileprivate var subtitle: String = ""
    fileprivate var imgUrl: String = ""
    fileprivate var toUrl: String = ""
    private var coverView: UIView!
    func show(title: String, subtitle: String, imgUrl: String, toUrl: String) {
        self.title = title
        self.subtitle = subtitle
        self.imgUrl = imgUrl
        self.toUrl = toUrl
        let window = UIApplication.shared.keyWindow
        coverView = UIView(frame: kMainScreenBounds)
        coverView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancel))
        coverView.addGestureRecognizer(tapGesture)
        window?.addSubview(coverView)
        window?.bringSubview(toFront: coverView)
        
        let contentBgView = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 170))
        contentBgView.backgroundColor = UIColor.clear
        coverView.addSubview(contentBgView)
        
        let contentView = UIView()
        contentView.backgroundColor = UIColor.white
        contentView.frame = CGRect(x: 8, y: 0, width: SCREEN_WIDTH - 16, height: 110)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8.0
        contentBgView.addSubview(contentView)
        
        let titles = ["微信", "朋友圈"]
        let icons = ["share_0", "share_1"]
        for i in 0..<icons.count {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 0, y: 20, width: 54, height: 54)
            if i == 0 {
                button.centerX = (SCREEN_WIDTH - 16) / 3
            } else {
                button.centerX = (SCREEN_WIDTH - 16) / 3 * 2
            }
            button.setTitle(titles[i], for: .normal)
            button.setTitleColor(titleColor, for: .normal)
            button.titleLabel?.font = UIFont.customFont(ofSize: 12)
            button.setBackgroundImage(UIImage(named: icons[i]), for: .normal)
            button.setBackgroundImage(UIImage(named: icons[i]), for: .selected)
            button.titleEdgeInsets = UIEdgeInsetsMake(80, 0, 0, 0)
            button.tag = 5000 + i
            button.addTarget(self, action: #selector(handleButton(button:)), for: .touchUpInside)
            contentView.addSubview(button)
        }
      
        let cancelButton = UIButton(type: .custom)
        cancelButton.frame = CGRect(x: 8, y: 120, width: SCREEN_WIDTH - 16, height: 44)
        cancelButton.backgroundColor = UIColor.white
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(timeColor, for: .normal)
        cancelButton.titleLabel?.font = UIFont.customFont(ofSize: 16)
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 8.0
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        contentBgView.addSubview(cancelButton)
        
        UIView.animate(withDuration: 0.25) { 
            contentBgView.frame = CGRect(x: 0, y: SCREEN_HEIGHT - 170 , width: SCREEN_WIDTH, height: 110)
        }
    }
    
    @objc private func handleButton(button: UIButton) {
        coverView.removeFromSuperview()
        let shareParames = NSMutableDictionary()
        let url = URL(string: toUrl)
        shareParames.ssdkSetupShareParams(byText: subtitle,
                                          images : imgUrl,
                                          url : url,
                                          title : title,
                                          type : SSDKContentType.auto)
        let index = button.tag - 5000
        var type: SSDKPlatformType = .subTypeWechatSession
        if index == 1 {
            MobClick.event("index_sec", label: "立即邀请_朋友圈")
            type = .subTypeWechatTimeline
        }else{
            MobClick.event("index_sec", label: "立即邀请_微信")
        }
        if WXApi.isWXAppInstalled() {
            ShareSDK.share(type, parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
                switch state {
                case SSDKResponseState.success:
                    UIApplication.shared.keyWindow?.makeToast("分享成功")
                case SSDKResponseState.fail:
                    UIApplication.shared.keyWindow?.makeToast("授权失败")
                case SSDKResponseState.cancel:
                    UIApplication.shared.keyWindow?.makeToast("操作取消")
                default:
                    break
                }
            }
        } else {
            UIApplication.shared.keyWindow?.makeToast("未安装该程序")
        }
    }
    
    @objc private func cancel() {
        coverView.removeFromSuperview()
    }
    
    //默认邀请分享
    func shareYao() {
        let title = "“钱”行的路，“钢”好有你！\(GPWGlobal.sharedInstance().app_accountsred)元红包，点击立即领取！"
        let subtitle = "来钢票网，票据理财新选择，预期年化利率最高可达13%，朋友推荐，靠谱！"
        var toUrl = SHARE_URL
        if let inviteCode = GPWUser.sharedInstance().invite_code {
            toUrl = SHARE_URL + "?invite_code=\(inviteCode)"
            printLog(message: toUrl)
        }
        GPWShare.shared.show(title: title, subtitle: subtitle, imgUrl: SHARE_IMG_URL, toUrl: toUrl)
    }
    
}

extension GPWShare {
    //MARK: /*************注册分享***************
    static func registerShare() {
        /**
         *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
         *  在将生成的AppKey传入到此方法中。
         *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
         *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
         *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
         */
        
        WXApi.registerApp(WeChatAppKey)
        ShareSDK.registerActivePlatforms(
            [
                SSDKPlatformType.subTypeWechatSession.rawValue,
                SSDKPlatformType.subTypeWechatTimeline.rawValue,
                ],
            onImport: {(platform : SSDKPlatformType) -> Void in
                switch platform
                {
                case .typeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                default:
                    break
                }
        },
            onConfiguration: {(platform: SSDKPlatformType, appInfo: NSMutableDictionary?) in
                switch platform
                {
                case .typeWechat:
                    //设置微信应用信息
                    appInfo?.ssdkSetupWeChat(byAppId: WeChatAppKey, appSecret: WeChatAppSecret)
                default:
                    break
                }
        })
    }
}
