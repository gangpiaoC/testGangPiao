//
//  GPWNetwork.swift
//  GangPiaoWang
//
//  Created by GC on 16/11/28.
//  Copyright © 2016年 GC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class GPWSessionManager: SessionManager {
    
    enum ServerHost: String {
        case trust1 = ".gangpiaowang.com"
    }
    
    static let share: GPWSessionManager = {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            ServerHost.trust1.rawValue: .pinCertificates(
                certificates: ServerTrustPolicy.certificates(),
                validateCertificateChain: true,
                validateHost: true
            ),

        ]
        let sessionManager = GPWSessionManager(serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        return sessionManager
    }()
}

class GPWNetwork: NSObject {
    static let shareNetwork = GPWNetwork()
    //区分接口路径
    var urlPath: String! = ""
    let reachabilityManager = NetworkReachabilityManager(host: "https://www.baidu.com")
    
    class func isReachable() -> Bool {
        if let isReachable = GPWNetwork.shareNetwork.reachabilityManager?.isReachable {
            return isReachable
        }
        return false
    }
    
    func startListening() {
        reachabilityManager?.listener = { status in
            printLog(message: "Network Status Changed: \(status)")
        }
        reachabilityManager?.startListening()
    }
    
    fileprivate func notReachable() {
        if !GPWNetwork.isReachable() {
            UIApplication.shared.keyWindow?.makeToast("网络加载失败")
            return
        }
    }
    
    //MARK: /*************GET***************
    class func requetWithGet(url: String, parameters: [String: Any]?, responseJSON:@escaping (_ json: JSON, _ msg: String) -> Void, failure:@escaping (_ error: Error) -> Void) {
        GPWNetwork.shareNetwork.urlPath = url
        var urlString = ""
        if (url.range(of: "https")) != nil {
            urlString =  url
        }else{
            urlString = SERVER + url
        }
        UIApplication.shared.keyWindow?.makeToastActivity(.center)
        var headers:Dictionary = [String:String]()
        headers["Cookie"] = GPWNetwork.shareNetwork.getCookie()
        GPWSessionManager.share.request(urlString, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .validate()
            .responseJSON { (response) in
                let msg1 = JSON(response.result)["msg"].stringValue
                GPWGlobal.sharedInstance().msg = msg1
                switch response.result {
                case .success(let value):
                    UIApplication.shared.keyWindow?.hideToastActivity()
                    let json = JSON(value)
                    let code = json["code"]
                    var  msg = json["msg"]
                    if (url.range(of: "https")) != nil {
                        msg = json["reason"]
                    }
                    let data = json["data"]
                    if code == 1000 {
                        responseJSON(data, msg.stringValue)
                    }else if json["error_code"] == 0 {
                        responseJSON(json["result"], "银行卡信息查询")
                    } else if code == 935 {
                        if GPWUser.sharedInstance().isLogin{
                            GPWUser.sharedInstance().outLogin()
                            GPWHelper.gotoLogin()
                        }
                    }else {
                        UIApplication.shared.keyWindow?.makeToast("\(msg)")
                        GPWGlobal.sharedInstance().msg = msg.stringValue
                        let error: Error = NSError(domain: "code", code: code.intValue, userInfo: nil)
                        failure(error)
                    }
                case .failure(let error):
                    UIApplication.shared.keyWindow?.hideToastActivity()
                    UIApplication.shared.keyWindow?.makeToast("网络加载失败")
                    failure(error)
                }
        }
    }
    
    //MARK: /*************POST***************
    class func requetWithPost(url: String, parameters: [String: Any]?, responseJSON: @escaping (_ json: JSON, _ msg: String) -> Void, failure:@escaping (_ error: Error) -> Void) {
        GPWNetwork.shareNetwork.urlPath = url
        var urlString = ""
        if (url.range(of: "https")) != nil {
             urlString =  url
        }else{
            urlString = SERVER + url
        }
        UIApplication.shared.keyWindow?.makeToastActivity(.center)
        var headers:Dictionary = [String:String]()
        headers["Cookie"] = GPWNetwork.shareNetwork.getCookie()
        GPWSessionManager.share.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseJSON { response in
                let msg1 = JSON(response.result)["msg"].stringValue
                GPWGlobal.sharedInstance().msg = msg1
                switch response.result {
                case .success(let value):
                    UIApplication.shared.keyWindow?.hideToastActivity()
                    let json = JSON(value)
                    let code = json["code"]
                    let msg = json["msg"]
                    let data = json["data"]
                    if code == 1000{
                        responseJSON(data, msg.stringValue)
                    } else if json["reason"] == "Succes" {
                         responseJSON(data, "银行卡信息查询")
                    }else if code == 935 {
                        if GPWUser.sharedInstance().isLogin{
                            GPWUser.sharedInstance().outLogin()
                            GPWHelper.gotoLogin()
                        }
                    } else {
                        UIApplication.shared.keyWindow?.makeToast("\(msg)")
                        GPWGlobal.sharedInstance().msg = msg.stringValue
                        let error: Error = NSError(domain: "code", code: code.intValue, userInfo: nil)
                        failure(error)
                    }
                case .failure(let error):
                    UIApplication.shared.keyWindow?.hideToastActivity()
                    UIApplication.shared.keyWindow?.makeToast("网络加载失败")
                    failure(error)
                }
        }
    }
    
    //MARK: /*************UPLOAD***************
    class func upload(urlDict: [String: String], toUrl: String) {
        GPWSessionManager.share.upload(multipartFormData: { multipartFormData in
            for (name, path) in urlDict {
                guard let url = URL(string: path) else {
                    return
                }
                multipartFormData.append(url, withName: name)
            }
        }, to: toUrl, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    printLog(message: response)
                }
            case .failure(let encodingError):
                printLog(message: encodingError)
            }
        })
    }
    
    func getCookie()  -> String{
        var properties = [String:AnyObject]()
         let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"]
        properties["version"] =  currentVersion as AnyObject?
         properties["system"] = "ios" as AnyObject?
         properties["phone_ip"] = GPWGetIP.getip() as AnyObject?
         properties["phone_origin"] = "ios" as AnyObject?
         properties["phone_brand"] = "App Store" as AnyObject?
        var cookies = [HTTPCookie]()
        for property in properties {
            var cookieProperties = [HTTPCookiePropertyKey:AnyObject]()
            cookieProperties[HTTPCookiePropertyKey.name] = property.0 as AnyObject?
            cookieProperties[HTTPCookiePropertyKey.value] = property.1 as AnyObject
            cookieProperties[HTTPCookiePropertyKey.domain] = ".gangpiaowang.com" as AnyObject?
            cookieProperties[HTTPCookiePropertyKey.path] = "/" as AnyObject?
            let expriresDate = Date(timeIntervalSinceNow: 3600*24)
            cookieProperties[HTTPCookiePropertyKey.expires] = expriresDate as AnyObject
            if let cookie = HTTPCookie(properties: cookieProperties) {
                cookies.append(cookie)
                HTTPCookieStorage.shared.setCookie(cookie)
            }
        }
        
        //去除相同名字的cookie
        var cookieDic = [String:String]()
        for tempCookie in HTTPCookieStorage.shared.cookies! {
            cookieDic[tempCookie.name] = tempCookie.value
        }
        
       //printLog(message: HTTPCookieStorage.shared.cookies)
        //拼接字符串
        var cookieStr:String = ""
        for (key,value) in cookieDic {
            cookieStr = "\(cookieStr)\(key)=\(value);"
        }
        return cookieStr
    }
}
