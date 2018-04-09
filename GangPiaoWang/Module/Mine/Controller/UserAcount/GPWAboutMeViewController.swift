//
//  GPWAboutMeViewController.swift
//  GangPiaoWang
//  关于我们
//  Created by gangpiaowang on 2017/3/6.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWAboutMeViewController: GPWSecBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关于"
        
        //顶部背景
        let  topBgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 222))
        topBgView.backgroundColor = UIColor.white
        self.bgView.addSubview(topBgView)
        
        let logoImgView = UIImageView(frame: CGRect(x: 0, y: 46, width: 120, height: 111))
        logoImgView.image = UIImage(named: "user_about_logo")
        logoImgView.centerX = SCREEN_WIDTH / 2
        self.bgView.addSubview(logoImgView)
        
        //版本
        let editionLabel = UILabel(frame: CGRect(x: 0, y: logoImgView.maxY + 24, width: 72, height: 22))
          let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        editionLabel.text = "V\(currentVersion)"
        editionLabel.textAlignment = .center
        editionLabel.centerX = logoImgView.centerX
        editionLabel.textColor = redTitleColor
        editionLabel.layer.masksToBounds = true
        editionLabel.layer.cornerRadius = editionLabel.height / 2
        editionLabel.layer.borderColor = editionLabel.textColor.cgColor
        editionLabel.layer.borderWidth = 0.5
        editionLabel.font = UIFont.customFont(ofSize: 14)
        self.bgView.addSubview(editionLabel)
        
        //给好评
        let goodBtn =  self.createBtn(title: "给好评", maxY: topBgView.maxY)
        goodBtn.tag = 100
        if GPWGlobal.sharedInstance().commFlag == "0" {
            goodBtn.isHidden = true
        }
        
        //意见反馈
        let feekBtn = self.createBtn(title: "意见反馈", maxY: goodBtn.maxY)
        feekBtn.tag = 101
    }
    
    func createBtn(title:String,maxY:CGFloat) -> UIButton {
        let btn =  UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: maxY + 8, width: SCREEN_WIDTH, height: 46)
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(btnCilck(_:)), for: .touchUpInside)
        self.bgView.addSubview(btn)
        let btnTitleLabel = UILabel(frame: CGRect(x: 16, y: 0, width: 100, height: btn.height))
        btnTitleLabel.text = title
        btnTitleLabel.font = UIFont.customFont(ofSize: 14)
        btn.titleLabel?.textColor = UIColor.hex("333333")
        btn.addSubview(btnTitleLabel)
        let   rightImbView = UIImageView(frame: CGRect(x: SCREEN_WIDTH - 16 - 6, y: 0, width: 6, height: 11))
        rightImbView.image = UIImage(named: "user_rightImg")
        rightImbView.centerY = btn.height / 2
        btn.addSubview(rightImbView)
        return btn
    }
    
    @objc func btnCilck(_ sender:UIButton)  {
        if sender.tag == 100 {
            MobClick.event("info_about", label: "好评")
            let urlString = "https://itunes.apple.com/cn/app/%E9%92%A2%E7%A5%A8%E7%BD%91/id1197187486?mt=8"
            let url = NSURL(string: urlString)
            UIApplication.shared.openURL(url! as URL)
        }else{
            let vc = GPWUserFackViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
