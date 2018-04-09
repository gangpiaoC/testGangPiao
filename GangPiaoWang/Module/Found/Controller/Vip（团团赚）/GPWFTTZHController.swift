//
//  GPWFTTZHController.swift
//  GangPiaoWang
//  团团赚入口
//  Created by gangpiaowang on 2017/8/31.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import WebKit

class GPWFTTZHController: GPWSecBaseViewController,WKNavigationDelegate{
    
    //顶部输入框
    fileprivate var codeFiled:UITextField!
    
    fileprivate var  _webView:WKWebView!
    
    fileprivate var  topView:UIView!
    
    //背景链接
    var  urlstr:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "团团赚"
        initView()
    }
    
    func initView(){
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: SCREEN_HEIGHT - pixw(p: 44) - 64, width: SCREEN_WIDTH, height: pixw(p: 44))
        btn.addTarget(self, action: #selector(self.btnClick), for: .touchUpInside)
        btn.setBackgroundImage(UIImage(named:"f_vip_rightgo"), for: .normal)
        self.bgView.addSubview(btn)
        
        _webView = WKWebView(frame: self.bgView.bounds)
        _webView.height = btn.y
        _webView.navigationDelegate = self
        self.bgView.addSubview(_webView)
        if let url = URL(string: self.urlstr!) {
            _webView.load(URLRequest(url: url))
        }
        self.topnumView()
    }
    
    func topnumView() {
        topView = UIView(frame: CGRect(x: 16, y: 0, width: SCREEN_WIDTH - 32, height: 23 + 26 + 23))
        topView.backgroundColor = UIColor.clear
        topView.isHidden = true
        _webView.scrollView.addSubview(topView)
        
        let  titleLabel = UILabel(frame: topView.bounds)
        titleLabel.width = 110
        titleLabel.text = "您的邀请口令"
        titleLabel.font = UIFont.customFont(ofSize: 16)
        titleLabel.textColor = UIColor.white
        topView.addSubview(titleLabel)
        
        var louLingArray = [String]()
        let strkl = "\(GPWUser.sharedInstance().kouling)"
        for i in 0 ..< strkl.count {
             let tempNum = (strkl as NSString).substring(with: NSRange(location: i,length: 1))
            louLingArray.append(tempNum)
        }
        
        for i in 0 ..< louLingArray.count {
            let  numBgImgView = UIImageView(frame: CGRect(x: titleLabel.maxX + CGFloat(i) * (8 + 26), y: 0, width: 26, height: 26))
            numBgImgView.image = UIImage(named: "f_vip_numbg")
            numBgImgView.centerY = titleLabel.centerY
            topView.addSubview(numBgImgView)
            
            let  numLabel = UILabel(frame: numBgImgView.bounds)
            numLabel.text = louLingArray[i]
            numLabel.textAlignment = .center
            numLabel.font = UIFont.customFont(ofSize: 20)
            numLabel.textColor = UIColor.hex("333333")
            numBgImgView.addSubview(numLabel)
        }
    }
    
    //展示输入验证码
    func showCodeView() {
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        bgView.backgroundColor = UIColor.hex("000000", alpha: 0.75)
        bgView.tag = 10000
        let wid = UIApplication.shared.keyWindow
        wid?.addSubview(bgView)
        
        let  cancelBtn = UIButton(type: .custom)
        cancelBtn.frame = CGRect(x: SCREEN_WIDTH - 72 - 44, y: 147, width: 44, height: 44)
        cancelBtn.setImage(UIImage(named: "f_vip_code_cancel"), for: .normal)
        cancelBtn.tag = 1000
        cancelBtn.addTarget(self, action: #selector(codeBtnClick(_:)), for: .touchUpInside)
        bgView.addSubview(cancelBtn)
        
        let topImgView = UIImageView(frame: CGRect(x: 0, y: cancelBtn.maxY + 31, width: 230, height: 127))
        topImgView.image = UIImage(named: "f_vip_code_top")
        topImgView.centerX = SCREEN_WIDTH / 2
        bgView.addSubview(topImgView)
        
        let  imgView = UIImageView(frame: CGRect(x: 0 + 2, y: topImgView.maxY + 2, width: 250, height: 36))
        imgView.image = UIImage(named: "f_vip_code_sec")
        imgView.isUserInteractionEnabled = true
        imgView.centerX = topImgView.centerX
        bgView.addSubview(imgView)
        
        codeFiled = UITextField(frame: CGRect(x: 20, y: 0, width: imgView.width - 40, height: imgView.height))
        codeFiled.backgroundColor = UIColor.clear
        codeFiled.font = UIFont.customFont(ofSize: 16)
        codeFiled.keyboardType = .numberPad
        codeFiled.placeholder = "请输入您的邀请口令"
        codeFiled.textAlignment = .center
        codeFiled.textColor = UIColor.hex("1d0251")
        if GPWUser.sharedInstance().kouling > 0{
            codeFiled.text = "\(GPWUser.sharedInstance().kouling)"
        }
        imgView.addSubview(codeFiled)
        let  sureBtn = UIButton(type: .custom)
        sureBtn.frame = CGRect(x: 0, y: imgView.maxY + 24, width: 160, height: 44)
        sureBtn.setImage(UIImage(named: "f_vip_code_btn"), for: .normal)
        sureBtn.tag = 1001
        sureBtn.centerX = imgView.centerX
        sureBtn.addTarget(self, action: #selector(codeBtnClick(_:)), for: .touchUpInside)
        bgView.addSubview(sureBtn)
    }
    
    @objc func codeBtnClick( _ sender:UIButton) {
         let wid = UIApplication.shared.keyWindow
        wid?.viewWithTag(10000)?.removeFromSuperview()
        if sender.tag == 1001{
            //调用接口去详情
            if codeFiled.text?.count == 0 {
                self.view.makeToast("请输入正确口令")
                return
            }else if codeFiled.text?.count != 6 {
                self.view.makeToast("请输入正确口令")
                return
            }
            self.getNetData(codeFiled.text ?? "")
        }
    }
    
    @objc func btnClick() {
        if GPWUser.sharedInstance().isLogin {
            if GPWUser.sharedInstance().identity == 1{
                self.navigationController?.pushViewController(GPWVipListViewController(), animated: true)
            }else if GPWUser.sharedInstance().identity == 2 {
                self.showCodeView()
            }else if GPWUser.sharedInstance().identity == 4 {
                getNetData("\(GPWUser.sharedInstance().kouling)")
            }else if GPWUser.sharedInstance().identity == 3 {
                self.view.makeToast("对不起，您未满足本活动参加条件，请关注平台其他活动，谢谢")
            }
        }else{
            self.navigationController?.pushViewController(GPWLoginViewController(), animated: true)
        }
    }
    
    func getNetData( _ code:String)  {
        if GPWUser.sharedInstance().isLogin {
            if GPWUser.sharedInstance().identity == 1 {
                self.navigationController?.pushViewController(GPWVipListViewController(), animated: true)
            }else if GPWUser.sharedInstance().identity == 2 || GPWUser.sharedInstance().identity == 4 {
                GPWNetwork.requetWithGet(url: TTZ_join, parameters: ["kouling":code], responseJSON: { [weak self] (json, msg) in
                    printLog(message: json)
                    guard let strongSelf = self else { return }
                    let auto_id = json["auto_id"].intValue
                    if auto_id == 0 {
                        strongSelf.view.makeToast("请检查口令是否正确")
                        return
                    }else if json["is_ttz"].intValue == 1 {
                         strongSelf.navigationController?.pushViewController(GPWVipPDetailViewController(projectID: json["auto_id"].stringValue), animated: true)
                    }else if json["is_ttz"].intValue == 0 {
                        if GPWUser.sharedInstance().identity == 4 {
                             strongSelf.navigationController?.pushViewController(GPWVipPDetailViewController(projectID: json["auto_id"].stringValue), animated: true)
                        }else{
                            if GPWUser.sharedInstance().kouling == 0 {
                                strongSelf.view.makeToast("此口令已经失效")
                            }
                        }
                    }
                    }, failure: { (error) in
                        
                })
            }
        }else{
            self.navigationController?.pushViewController(GPWLoginViewController(), animated: true)
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if GPWUser.sharedInstance().identity == 1 && GPWUser.sharedInstance().kouling > 0 {
            topView.isHidden = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
