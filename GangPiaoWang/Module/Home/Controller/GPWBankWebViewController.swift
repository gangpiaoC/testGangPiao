//
//  GPWOhterWebViewController.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/2/14.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import WebKit
import SwiftyJSON
class GPWBankWebViewController:  GPWSecBaseViewController,WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler {
   //充值成功
    fileprivate let  GPWRECHARGE = "api_user_rece_addresucces"
    //充值失败
    fileprivate let GPWRECHARGEERROR = "api_user_rece_error"
    //提现成功
    fileprivate let  GPWWITHDRAWALS = "gpw_cunguan_withdrawals"
    //提现失败
    fileprivate let  GPWWITHDRAWALSERROR = "gpw_cunguan_withdraw_error"
    //出借成功
    fileprivate let GPWINVESTMENT = "gpwInvestment"
    //出借失败
    fileprivate let GPWINVESTMENTERROR = "gpwInvestmentError"
    //网页失败（暂时为实名认证失败）
    fileprivate let GPWFAIL = "api_user_deposit_realname_faile"
    
    //修改支付密码
    fileprivate let GPWMODIFEPAYMENT = "api_user_trade_rece_pwdsucces"
    
    //投资成功使用的json
    fileprivate var sureJson:JSON?
   
    //出借项目名称
    var proName:String?
    
    //出借收益
    var shouyi:String?
    
    //出借满标奖励
    var market_regamount:Int = 0
    
    //是否为vip领头人（团团赚）
    var vipFlag = false
    
    //作废
    fileprivate var subSitle: String?
    
    //跳转链接
    fileprivate var url:String?
    fileprivate var _webView:WKWebView!
    
    //充值或者提现金额
    var moneyStr:String?
    var shouxu:CGFloat = 0

    var startImgView:UIImageView!

    init(subtitle:String,url:String){
        super.init(nibName: nil, bundle: nil)
        self.subSitle = subtitle
        self.url = url
    }
    
    init(url:String,sureJson:JSON){
        super.init(nibName: nil, bundle: nil)
        self.url = url
        self.sureJson = sureJson
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if  let urlStr = self.url {
           let tempStr =  urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            _webView.load(URLRequest(url: URL(string:tempStr!)!))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.subSitle
        
        // 创建配置
        let config = WKWebViewConfiguration()
        // 创建UserContentController（提供JavaScript向webView发送消息的方法）
        let userContent = WKUserContentController()
        // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
        userContent.add(self , name: "NativeMethod")
        
        //注入cookie
        if let cookies = HTTPCookieStorage.shared.cookies{
            print(cookies)
            let script = getJSCookiesString(cookies: cookies)
            let cookieScript = WKUserScript(source: script, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
            userContent.addUserScript(cookieScript)
        }
        
        // 将UserConttentController设置到配置文件
        config.userContentController = userContent
        _webView = WKWebView(frame: self.bgView.bounds, configuration: config)
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
        startImgView.stopAnimating()
        self.bgView.addSubview(startImgView)
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title
        if startImgView != nil {
            startImgView.removeFromSuperview()
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url?.absoluteString{
            printLog(message: url)
         if  url.contains(GPWRECHARGEERROR){
                //充值失败
                GPWUser.sharedInstance().getUserInfo()
                //获取描述
                let tempArray = url.components(separatedBy: "resp_desc=")
               self.navigationController?.pushViewController(GPWFailController(type: FailType.CHONGTYPE, tip: tempArray[1]), animated: true)
                decisionHandler(.cancel)
         }else  if  url.hasSuffix(GPWRECHARGE){
            //充值成功
            GPWUser.sharedInstance().getUserInfo()
            let control = GPWTiorChongSucessController()
            control.type = TiorChongType.CHONGZHI
            control.money = self.moneyStr ?? "0"
            self.navigationController?.pushViewController(control, animated: true)
            decisionHandler(.cancel)
         }else  if  url.contains(GPWWITHDRAWALSERROR){
            //提现失败
            GPWUser.sharedInstance().getUserInfo()
            //获取描述
            let tempArray = url.components(separatedBy: "resp_desc=")
            self.navigationController?.pushViewController(GPWFailController(type: FailType.TIXIANTYPE, tip: tempArray[1]), animated: true)
            decisionHandler(.cancel)
         }else  if  url.hasSuffix(GPWWITHDRAWALS){
                //提现成功
                GPWUser.sharedInstance().getUserInfo()
                let control = GPWTiorChongSucessController()
                control.type = TiorChongType.TIXIAN
                control.money = self.moneyStr ?? "0"
                control.shouxu = self.shouxu
                self.navigationController?.pushViewController(control, animated: true)
                decisionHandler(.cancel)
            }else  if  url.hasSuffix(GPWMODIFEPAYMENT){
                //修改交易密码成功
                let time: TimeInterval = 1.0
                self.bgView.makeToast("修改交易密码成功")
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                    _ = self.navigationController?.popViewController(animated: true)
                }
                decisionHandler(.cancel)
         }else  if  url.contains(GPWINVESTMENTERROR){
            //出借失败
            GPWUser.sharedInstance().getUserInfo()
            //获取描述
            let tempArray = url.components(separatedBy: "resp_desc=")
            self.navigationController?.pushViewController(GPWFailController(type: FailType.CHUJIETYPE, tip: tempArray[1]), animated: true)
            decisionHandler(.cancel)
         }else  if (url.range(of: GPWINVESTMENT) != nil){
                if GPWUser.sharedInstance().identity == 2 {
                    MobClick.event("__cust_event_4")
                }
                GPWUser.sharedInstance().getUserInfo()
                //投标成功
                printLog(message: url)
                var strArray = Array<String>()
                if url.contains("invest_id=") {
                    strArray = url.components(separatedBy: "invest_id=")
                }
                let  vc = GPWInvestSuccessViewController(money: self.moneyStr ?? "0",shareJson:self.sureJson!,shouyi:self.shouyi!,proName:proName ?? "未知",prizeNum:self.market_regamount)
                vc.vipFlag = self.vipFlag
                vc.sureSucessID = strArray.count > 1 ? strArray[1]:""
                self.navigationController?.pushViewController( vc, animated: true)
                decisionHandler(.cancel)
            } else  if (url.range(of: GPWFAIL) != nil){
               //失败
                self.navigationController?.popViewController(animated: true)
                decisionHandler(.cancel)
            }else{
                decisionHandler(.allow)
            }
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        printLog(message: userContentController)
        // 判断是否是调用原生的
      
    }
    
    public func getJSCookiesString(cookies: [HTTPCookie]) -> String {
        var result = ""
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        
        for cookie in cookies {
            result += "document.cookie='\(cookie.name)=\(cookie.value); domain=\(cookie.domain); path=\(cookie.path); "
            if let date = cookie.expiresDate {
                result += "expires=\(dateFormatter.string(from: date)); "
            }
            if (cookie.isSecure) {
                result += "secure; "
            }
            result += "'; "
        }
        return result
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
extension GPWBankWebViewController{
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
    
}

