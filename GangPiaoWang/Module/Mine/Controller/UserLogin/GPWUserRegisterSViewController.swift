//
//  GPWUserRegisterSViewController.swift
//  GangPiaoWang
//  注册成功
//  Created by gangpiaowang on 2016/12/19.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWUserRegisterSViewController: GPWSecBaseViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (navigationController as! GPWNavigationController).canDrag = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
          (navigationController as! GPWNavigationController).canDrag = true
    }
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView(bgColor: UIColor.white)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "注册成功"
        MobClick.event("__cust_event_1")
        MobClick.event("__register", attributes:["userid":GPWUser.sharedInstance().user_name ?? "00"])
        leftButton.removeFromSuperview()
        
        let topImgView = UIImageView(image: #imageLiteral(resourceName: "project_investSucess") )
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "注册成功"
            label.textAlignment = .center
            label.font = UIFont.customFont(ofSize: 20)
            label.textColor = UIColor.hex("4f4f4f")
            return label
        }()
        
        let subTitleLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.customFont(ofSize: 18)
            label.textColor = UIColor.hex("4f4f4f")
            label.attributedText = NSAttributedString.attributedString("\(GPWGlobal.sharedInstance().app_exper_amount)元", mainColor: UIColor.hex("fa713d"), mainFont: 18, second: "体验金已到账", secondColor: UIColor.hex("4f4f4f"), secondFont: 18)
            return label
        }()
        
        let hatImgView = UIImageView(image: #imageLiteral(resourceName: "user_register_successHat"))
        let hatLabel = UILabel(title: "专享体验标", color: UIColor.white, fontSize: 16)
        let outBgView: UIView = {
            let view = UIView(bgColor: UIColor.hex("ffbe52"))
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 3.0
            return view
        }()
        
        let outBgImgView = UIImageView(image: #imageLiteral(resourceName: "user_register_successOutBg"))
        
        let innerBgView: UIView = {
           let view = UIView(bgColor: UIColor.hex("fff6e5"))
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 12.0
            return view
        }()
        let rateLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.attributedText = NSAttributedString.attributedString("\(GPWGlobal.sharedInstance().app_exper_rate)", mainColor: UIColor.hex("f65d23"), mainFont: 64, second: "%", secondColor: UIColor.hex("f65d23"), secondFont: 30)
            return label
        }()
        
        let lendButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setBackgroundImage(#imageLiteral(resourceName: "user_register_successButtonBg"), for: .normal)
            button.setTitle("立即出借体验金", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            button.setTitleColor(UIColor.white, for: .normal)
            button.addTarget(self, action: #selector(lendHandle), for: .touchUpInside)
            return button
        }()
        
        let bottomTipLabel: UILabel = {
            let label = UILabel()
            label.text = "收益可提现"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            label.textColor = UIColor.hex("f76832")
            return label
        }()
        
        
        
        scrollView.addSubview(topImgView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(subTitleLabel)
        scrollView.addSubview(outBgView)
        outBgView.addSubview(outBgImgView)
        outBgView.addSubview(innerBgView)
        innerBgView.addSubview(rateLabel)
        innerBgView.addSubview(lendButton)
        outBgView.addSubview(bottomTipLabel)
        scrollView.addSubview(hatImgView)
        scrollView.addSubview(hatLabel)
        bgView.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(bgView)
        }
        topImgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(scrollView).offset(42)
            maker.centerX.equalTo(scrollView)
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(topImgView.snp.bottom).offset(27)
            maker.left.right.equalTo(scrollView)
            maker.width.equalTo(bgView)
        }
        subTitleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(12)
            maker.left.right.equalTo(scrollView)
        }
        hatImgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(subTitleLabel.snp.bottom).offset(61)
            maker.centerX.equalTo(scrollView)
        }
        hatLabel.snp.makeConstraints { (maker) in
            maker.center.equalTo(hatImgView)
        }
        outBgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(subTitleLabel.snp.bottom).offset(67)
            maker.left.right.equalTo(scrollView).inset(24)
            maker.bottom.equalTo(scrollView).offset(-134)
        }
        outBgImgView.setContentHuggingPriority(UILayoutPriority(rawValue: 49), for: .horizontal)
        outBgImgView.setContentHuggingPriority(UILayoutPriority(rawValue: 49), for: .vertical)
        outBgImgView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 49), for: .horizontal)
        outBgImgView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 49), for: .vertical)
        outBgImgView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(outBgView)
        }
        innerBgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(outBgView).offset(pixw(p: 48))
            maker.left.right.equalTo(outBgView).inset(16)
        }
        
        rateLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(innerBgView).offset(pixw(p: 38))
            maker.centerX.equalTo(innerBgView)
        }
        
        lendButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(rateLabel.snp.bottom).offset(pixw(p: 30))
            maker.left.right.equalTo(innerBgView).inset(23)
            maker.height.equalTo(42)
            maker.bottom.equalTo(innerBgView).offset(-pixw(p: 18))
        }
        
        bottomTipLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(innerBgView.snp.bottom).offset(pixw(p: 9))
            maker.centerX.equalTo(outBgView)
            maker.bottom.equalTo(outBgView).offset(-pixw(p: 19))
        }
        
    }
    
    @objc func btnclick(sender:UIButton) {
        (navigationController as! GPWNavigationController).canDrag = true
        if sender.tag == 100 {
            //身份验证
            let userInfoControl = UserReadInfoViewController()
            userInfoControl.type = "shenfen"
            self.navigationController?.pushViewController(userInfoControl, animated: true)
        }else{
            //设置手势密码
            let gesture = GestureViewController()
            gesture.type = GestureViewControllerType.setting
            gesture.flag = true
            _ = GPWHelper.selectedNavController()?.pushViewController(gesture, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func lendHandle() {
       let vc = GPWLendSuccessViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
