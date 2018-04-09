//
//  GPWADView.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/4/5.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
class GPWADViewController: UIViewController {
    fileprivate var isRemoved = false
    fileprivate var btn:UIButton!
    fileprivate var imgStr = ""
    fileprivate var urlStr = ""
    fileprivate var  timer:Timer!
    init(imgStr:String,toUrl:String) {
        super.init(nibName: nil, bundle: nil)
        MobClick.beginLogPageView("广告界面")
        self.imgStr = imgStr
        self.urlStr = toUrl
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         commonInit()
    }
    
    private func commonInit() {
        self.view.alpha = 1.0
        self.view.backgroundColor = UIColor.white
        let imgView = UIImageView(frame: self.view.bounds)
        imgView.downLoadImg(imgUrl: self.imgStr,placeImg: "meiyou")
        imgView.isUserInteractionEnabled = true
        self.view.addSubview(imgView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imgClick))
       imgView.addGestureRecognizer(tapGesture)
        
        //按钮
        btn = UIButton(type: .custom)
        btn.frame = CGRect(x: SCREEN_WIDTH - 16 - 70, y: 32, width: 70, height: 25)
        btn.backgroundColor = UIColor.hex("000000", alpha: 0.4)
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 12.5
        btn.setTitle("跳过3s", for: .normal)
        btn.addTarget(self, action: #selector(self.remove), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        self.view.addSubview(btn)
        
        let timer:Timer = Timer(timeInterval: 1.0,
                                target: self,
                                selector: #selector(self.updateTimer(timer:)),
                                userInfo: nil,
                                repeats: true)
        
        // 将定时器添加到运行循环
        RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    @objc func updateTimer(timer:Timer) {
        let title = btn.title(for: .normal)
        if  title == "跳过3s"{
            btn.setTitle("跳过2s", for: .normal)
        }else if title == "跳过2s"{
            btn.setTitle("跳过1s", for: .normal)
        }else if title == "跳过1s"{
            btn.setTitle("跳过0s", for: .normal)
        }else if title == "跳过0s"{
            timer.invalidate()
            CFRunLoopStop(CFRunLoopGetCurrent())
            self.remove()
            if GYCircleConst.getGestureWithKey(gestureFinalSaveKey) == nil {
                if GPWGlobal.sharedInstance().initJson?["app_popup"]["img_url"].stringValue.count ?? 0 > 7 {
                    if  GPWHelper.getDay()[3] == "0" {
                        GPWHelper.showHomeAD(url: (GPWGlobal.sharedInstance().initJson?["app_popup"]["img_url"].stringValue)!)
                        GPWGlobal.sharedInstance().homeADtoUrl = GPWGlobal.sharedInstance().initJson?["app_popup"]["link"].stringValue
                    }
                }
            }
        }
    }
    
    func buttonAction() {
        remove()
    }
    
    @objc func imgClick() {
        MobClick.endLogPageView("广告界面")
        printLog(message: "图片点击")
        if GYCircleConst.getGestureWithKey(gestureFinalSaveKey) != nil {
            GPWGlobal.sharedInstance().gotoUrl = self.urlStr
            let gestureVC = GestureViewController()
            gestureVC.type = GestureViewControllerType.login
            gestureVC.flag = true
            _ = GPWHelper.selectedNavController()?.pushViewController(gestureVC, animated: false)
        }else{
            gotoController()
        }
    }
    
    //去往web或者标的
    func gotoController() {
        if self.urlStr.replacingOccurrences(of: " ", with: "", options: .literal, range: nil).count < 2 {
            return
        }
        let wid = UIApplication.shared.delegate?.window
        wid??.rootViewController = GPWGlobal.sharedInstance().gpwbarController
        if (self.urlStr.range(of: "https")) != nil{
            if self.urlStr.count > 6 {
                GPWHelper.selectedNavController()?.pushViewController(GPWWebViewController(subtitle: "", url: self.urlStr), animated: true)
            }
        }else{
            if NSString(string:self.urlStr).intValue > 10 {
                GPWHelper.selectedNavController()?.pushViewController(GPWProjectDetailViewController(projectID: self.urlStr), animated: true)
            }
        }
    }
    
    @objc func remove() {
        isRemoved = true
        MobClick.endLogPageView("广告界面")
        let wid = UIApplication.shared.delegate?.window
        wid??.rootViewController = GPWGlobal.sharedInstance().gpwbarController
    }
}

