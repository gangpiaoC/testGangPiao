//
//  GPWWebViewController.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/1/3.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON
class GPWWebViewController: GPWSecBaseViewController,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler {

    //跳转列表
    fileprivate let APPACT = "appAct"

    //网页分享
     fileprivate let H5SHARE = "h5share"
    
    //跳转标的
    fileprivate let BIAODI = "biaodi"
    
   //邀请
    fileprivate let  INVITATION = "invitation"
    
    //判断是否邀请
    fileprivate let CLOSE = "close"
    
    //邀请记录
    fileprivate let INVITATIONUM = "invitationNum"
    
    //登录APP
    fileprivate let LOGINAPP = "loginapp"
    
    //消息标志
    var  messageFlag = "0"
    
    //如果队列中有手势试图  返回时候直接到根试图
    var  backRootFlag = false
    
    //分享json
    fileprivate var shareJson:JSON?
    
    //传过来的标题
    fileprivate var subSitle: String?
    fileprivate var url:String?
    fileprivate var _webView:WKWebView!

    //是否从原生跳出
    fileprivate var goFlag =  true

    // 创建配置
     fileprivate var config:WKWebViewConfiguration?

    var startImgView:UIImageView!
    init(subtitle:String,url:String){
        super.init(nibName: nil, bundle: nil)
        self.subSitle = subtitle
        self.url = url
    }
    
    init(dic:JSON) {
        super.init(nibName: nil, bundle: nil)
        self.url = dic["link"].stringValue
        shareJson = dic
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func shareClick() {
            let title = self.shareJson?["ad_name"].stringValue
            let subtitle = self.shareJson?["descion"].stringValue
            let toUrl = self.shareJson?["share_link"].stringValue
            let logo = self.shareJson?["logo"].stringValue
            GPWShare.shared.show(title: title!, subtitle: subtitle!, imgUrl: logo!, toUrl: toUrl!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if  let urlStr = self.url {
             var tempUrl = urlStr
            if tempUrl.range(of: "?") == nil {
                tempUrl = tempUrl + "?"
            }else{
                tempUrl = tempUrl + "&"
            }
            tempUrl = tempUrl + "comefrom=ios&"
            if GPWUser.sharedInstance().isLogin {
                tempUrl = tempUrl + "user_id=\(GPWUser.sharedInstance().user_id!)"
                tempUrl = tempUrl + "&invite_code=\(GPWUser .sharedInstance().invite_code ?? "00")"
                tempUrl += "&real=\(GPWUser.sharedInstance().is_idcard ?? 0)"
            }
            printLog(message: tempUrl)
            if let url = URL(string:tempUrl) {
                if goFlag {
                    _webView.load(URLRequest(url: url))
                }else{
                    goFlag = true
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for (_,subControl) in (self.navigationController?.viewControllers.enumerated())! {
            if subControl.isKind(of: GestureViewController.self) {
                backRootFlag = true
            }
        }
        let date = NSDate()
        let timeInterval = date.timeIntervalSince1970
        if let tempDic = shareJson{
            if tempDic["due_time"].doubleValue > timeInterval && tempDic["descion"].stringValue.count > 0 {
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: SCREEN_WIDTH  - 40, y: 23, width: 40, height: 40)
                button.setImage(UIImage(named: "share"), for: .normal)
                button.adjustsImageWhenHighlighted = false
                button.addTarget(self, action: #selector(shareClick), for: .touchUpInside)
                navigationBar.addSubview(button)
            }
        }

        // 创建配置
        config = WKWebViewConfiguration()
        // 创建UserContentController（提供JavaScript向webView发送消息的方法）
        let userContent = WKUserContentController()
        // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
        userContent.add(self , name: "NativeMethod")

        // 将UserConttentController设置到配置文件
        config?.userContentController = userContent
        _webView = WKWebView(frame: self.bgView.bounds, configuration: config!)
        _webView.uiDelegate = self
        _webView.navigationDelegate = self
        self.bgView.addSubview(_webView)
        if let url = URL(string: self.url!) {
            _webView.load(URLRequest(url: url))
        }

        let gifImgView = UIImage.gif(name: "pageStart")
        startImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        startImgView.center = CGPoint(x: self.bgView.width / 2, y: self.bgView.height / 2)
        startImgView.image = gifImgView
        self.bgView.addSubview(startImgView)

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if startImgView != nil {
            startImgView.removeFromSuperview()
        }
        if self.messageFlag == "0" {
              self.title = webView.title
        }else{
            self.title = subSitle
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        printLog(message: "wwwwwwww=====\(userContentController) eeeeee===\(message.body)")
        // 判断是否是调用原生的
        if "NativeMethod" == message.name {
            let date = NSDate()
            let timeInterval = date.timeIntervalSince1970
            if let tempDic = shareJson{
                if tempDic["due_time"].doubleValue < timeInterval{
                    let  alertViewContoll = UIAlertController(title: "", message: "活动已经过期", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "确定", style: .default, handler: { (alert) in
                        
                    })
                    alertViewContoll.addAction(okAction)
                    self.navigationController?.present(alertViewContoll, animated: true, completion: nil)
                    return
                }
            }
            
            // 判断message的内容，然后做相应的操作
            if CLOSE == message.body as! String {
                if GPWUser.sharedInstance().isLogin {
                    self.bgView.makeToast("您已注册过")
                }else{
                   self.navigationController?.pushViewController(GPWUserRegisterViewController(), animated: true)
                }
            }else if  INVITATION == message.body as! String  {
                //邀请
                if GPWUser.sharedInstance().isLogin {
                    let title = "“钱”行的路，“钢”好有你！\(GPWGlobal.sharedInstance().app_accountsred)元红包，点击立即领取！"
                    let subtitle = "来钢票网，票据理财新选择，预期年化利率最高可达12%，朋友推荐，靠谱！"
                    var toUrl = SHARE_URL
                    if let inviteCode = GPWUser.sharedInstance().invite_code {
                        toUrl = SHARE_URL + "?invite_code=\(inviteCode)"
                        printLog(message: toUrl)
                    }
                    GPWShare.shared.show(title: title, subtitle: subtitle, imgUrl: SHARE_IMG_URL, toUrl: toUrl)
                }else{
                    self.navigationController?.pushViewController(GPWLoginViewController(), animated: true)
                }
            }else if  INVITATIONUM == message.body as! String  {
                //邀请记录
                if GPWUser.sharedInstance().isLogin {
//                    if let navC = self.navigationController {
//                        for vc in navC.viewControllers {
//                            if vc.isKind(of: GPWUserInviteViewController.self) {
//                                _ = navC.popViewController(animated: true)
//                                return
//                            }
//                        }
//                    }
                    self.navigationController?.pushViewController(GPWGetFriendRcordController(), animated: true)
                }else{
                    self.navigationController?.pushViewController(GPWLoginViewController(), animated: true)
                }
            }else if  LOGINAPP == message.body as! String  {
                //登录    
                if GPWUser.sharedInstance().isLogin {
                    GPWHelper.selectTabBar(index: PROJECTBARTAG)
                }else{
                     self.navigationController?.pushViewController(GPWLoginViewController(), animated: true)
                }
            }else if BIAODI == message.body as! String {
                //跳转标的
                let  strArray = self.url?.components(separatedBy: "id=")
                if (strArray?.count)! > 1 {
                    self.navigationController?.pushViewController( GPWProjectDetailViewController(projectID: strArray?[1] ?? "0"), animated: true)
                }
            }else if APPACT == message.body as! String {
                //跳转标列表
             GPWHelper.selectTabBar(index: PROJECTBARTAG)
            }else if H5SHARE == message.body as! String{
                //h5分享
                self.shareClick()
                printLog(message: "eeee====\(message.body)")
            }else{
                printLog(message: "eeee====\(message.body)")
                if ((message.body as! String).range(of: "linkShare") != nil){

                    //分享
                    let  array = (message.body as! String).components(separatedBy: "***")
                    let title = (array[2].components(separatedBy: "title="))[1]
                    let subtitle = (array[3].components(separatedBy: "content="))[1]
                    let toUrl = (array[4].components(separatedBy: "url="))[1]
                    let logo = (array[5].components(separatedBy: "urlicon="))[1]
                    GPWShare.shared.show(title: title, subtitle: subtitle, imgUrl: logo, toUrl: toUrl)
                }else if ((message.body as! String).range(of: "linkHome") != nil) {
                    //跳转标列表
                    GPWHelper.selectTabBar(index: INDEXBARTAG)
                }else if ((message.body as! String).range(of: "linkProject") != nil) {
                    //项目列表
                    GPWHelper.selectTabBar(index: PROJECTBARTAG)
                }else if ((message.body as! String).range(of: "linkLogin") != nil) {
                    //登录
                    self.navigationController?.pushViewController( GPWLoginViewController(), animated: true)
                }else if ((message.body as! String).range(of: "linkUser") != nil) {
                    //我的
                    GPWHelper.selectTabBar(index: MINEBARTAG)
                }else if ((message.body as! String).range(of: "linkDetail") != nil) {
                    //项目详情
                    let  array = (message.body as! String).components(separatedBy: "***")
                    let auto_id = (array[2].components(separatedBy: "title="))[1] as String
                    self.navigationController?.pushViewController( GPWProjectDetailViewController(projectID: auto_id), animated: true)
                }else if ((message.body as! String).range(of: "linkReadName") != nil) {
                    //实名
                    self.navigationController?.pushViewController( UserReadInfoViewController(), animated: true)
                }else if ((message.body as! String).range(of: "linkOpenPDF") != nil) {
                    //合同
                    let  array = (message.body as! String).components(separatedBy: "***")
                    let url = (array[2].components(separatedBy: "url_pdf="))[1] as String
                    let title = (array[3].components(separatedBy: "url_pdfName="))[1] as String
                    let  control = DownHTongController()
                    control.urlStr = url
                    print(control.urlStr)
                    control.navTitle = title
                    control.navigationItem.hidesBackButton = true
                    self.goFlag = false
                    self.navigationController?.pushViewController(control, animated: false)
                }
            }
        }
    }
    
    override func back(sender: GPWButton) {

        if self._webView.canGoBack {
            self._webView.goBack()
        }else{
            _webView.configuration.userContentController.removeScriptMessageHandler(forName: "NativeMethod")
            if backRootFlag {
                _ = self.navigationController?.popToRootViewController(animated: true)
            }else{
                _ = self.navigationController?.popViewController(animated: true)
            }
        }


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
extension GPWWebViewController{


    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController:UIAlertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确认", style: .default, handler: { (action) in
            completionHandler()
        }))
        self.present(alertController, animated: true) {
            
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController:UIAlertController = UIAlertController(title: "提示", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确认", style: .default, handler: { (action) in
            completionHandler(true)
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .default, handler: { (action) in
            completionHandler(false)
        }))
        self.present(alertController, animated: true) {
            
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertController:UIAlertController = UIAlertController(title: prompt, message: "", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.text = defaultText
        }
        alertController.addAction(UIAlertAction(title: "完成", style: .default, handler: { (action) in
            completionHandler(alertController.textFields?.first?.text)
        }))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
