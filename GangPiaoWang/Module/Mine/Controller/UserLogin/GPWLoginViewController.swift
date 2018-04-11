//
//  GPWLoginViewController.swift
//  GangPiaoWang
//
//  Created by GC on 16/11/29.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWLoginViewController: GPWSecBaseViewController {
    private var havePWView:GPWHavePWView!
    private var quiretView:GPWQuirstView!
    
    var flag = "0"
    
    //如果为0 返回  如果未1设置手势密码
    var setGestureFlag = "0"
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgView.backgroundColor = UIColor.white
        self.title = "登录"
        let btntitleArray = ["短信登录", "密码登录"]
        for i in 0 ..< btntitleArray.count {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: SCREEN_WIDTH / 2 * CGFloat(i), y: 0, width: SCREEN_WIDTH / 2, height: 56)
            btn.setTitle(btntitleArray[i], for: .normal)
            btn.setTitleColor(UIColor.hex("aaaaaa"), for: .normal)
            btn.backgroundColor = UIColor.hex("f9f9f9")
            btn.tag = 1000 + i
            btn.addTarget(self, action: #selector(self.changBtn(sender:)), for: .touchUpInside)
            btn.titleLabel?.font = UIFont.customFont(ofSize: 16)
            self.bgView.addSubview(btn)
        }
        let tempBtn = self.bgView.viewWithTag(1000) as! UIButton
        tempBtn.setTitleColor(redColor, for: .normal)
        tempBtn.backgroundColor = UIColor.white
        
        havePWView = GPWHavePWView(frame: CGRect(x: 0, y: tempBtn.maxY + 20, width: SCREEN_WIDTH, height: 300))
        havePWView.superController = self
        havePWView.flag = flag
        havePWView.setGestureFlag = flag
        havePWView.isHidden = true
        self.bgView.addSubview(havePWView)
        
        quiretView = GPWQuirstView(frame: CGRect(x: 0, y: tempBtn.maxY + 20, width: SCREEN_WIDTH, height: 300))
        quiretView.superController = self
        quiretView.setGestureFlag = flag
        quiretView.flag = flag
        self.bgView.addSubview(quiretView)
    }
    
    @objc func changBtn(sender:UIButton) {
        sender.setTitleColor(UIColor.hex("fa713d"), for: .normal)
        sender.backgroundColor = UIColor.white
        var  btnTag = 1000
        if sender.tag == 1000 {
            btnTag = 1001
            self.havePWView.isHidden = true
            self.quiretView.isHidden = false
        }else{
            self.havePWView.isHidden = false
            self.quiretView.isHidden = true
        }
        let tempBtn = self.bgView.viewWithTag(btnTag) as! UIButton
        tempBtn.setTitleColor(UIColor.hex("aaaaaa"), for: .normal)
        tempBtn.backgroundColor = UIColor.hex("f9f9f9")
    }
    
    override func back(sender: GPWButton) {
        var flag = false
        if let viewControllers = self.navigationController?.viewControllers {
            for vc in viewControllers {
                 printLog(message: vc.self)
                if vc.isKind(of: GestureViewController.self) {
                    _ = self.navigationController?.popToRootViewController(animated: true)
                    flag = true
                }
            }
        }
        
        if flag == false {
            super.back(sender: sender)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
