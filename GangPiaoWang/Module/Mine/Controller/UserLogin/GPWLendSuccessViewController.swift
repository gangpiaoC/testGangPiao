//
//  GPWLendSuccessViewController.swift
//  GangPiaoWang
//
//  Created by GC on 2018/4/12.
//  Copyright © 2018年 GC. All rights reserved.
//

import UIKit

class GPWLendSuccessViewController: GPWSecBaseViewController {

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
        title = "出借成功"
//        MobClick.event("__cust_event_1")
//        MobClick.event("__register", attributes:["userid":GPWUser.sharedInstance().user_name ?? "00"])
        
        let topImgView = UIImageView(image: #imageLiteral(resourceName: "project_investSucess") )
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "体验金出借成功"
            label.textAlignment = .center
            label.font = UIFont.customFont(ofSize: 20)
            label.textColor = titleColor
            return label
        }()
        
        let subTitleLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = UIFont.customFont(ofSize: 18)
            label.textColor = titleColor
            label.attributedText = NSAttributedString.attributedString("\(GPWGlobal.sharedInstance().app_exper_income)元", mainColor: redColor, mainFont: 18, second: "体验金收益已到账", secondColor: titleColor, secondFont: 18)
            return label
        }()
        
        let contentBgImgView = UIImageView(image: #imageLiteral(resourceName: "user_register_lendSucContentBg"))
       
        let contentBgView = UIView(bgColor: UIColor.clear)
        
        let identityImgView = UIImageView(image: #imageLiteral(resourceName: "user_register_lendSucIdentity"))
        
        let redCouponLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = titleColor
            label.font = UIFont.systemFont(ofSize: 18)
            let attrText = NSMutableAttributedString()
            attrText.append(NSAttributedString(string: "完成身份验证即送"))
            attrText.append(NSAttributedString(string: "\(GPWGlobal.sharedInstance().app_accountsred)元", attributes: [NSAttributedStringKey.foregroundColor: redColor]))
            attrText.append(NSAttributedString(string: "红包"))
            label.attributedText = attrText
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            return label
        }()
        
        let verifyIdentityButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setBackgroundImage(#imageLiteral(resourceName: "user_register_successButtonBg"), for: .normal)
            button.setTitle("身份验证", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
            button.setTitleColor(UIColor.white, for: .normal)
            button.addTarget(self, action: #selector(verifyIdentityHandle), for: .touchUpInside)
            return button
        }()
        
        scrollView.addSubview(topImgView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(subTitleLabel)
        scrollView.addSubview(contentBgView)
        contentBgView.addSubview(contentBgImgView)
        contentBgView.addSubview(identityImgView)
        contentBgView.addSubview(redCouponLabel)
        contentBgView.addSubview(verifyIdentityButton)
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
       
        contentBgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(subTitleLabel.snp.bottom).offset(85)
            maker.left.right.equalTo(scrollView).inset(16)
            maker.bottom.equalTo(scrollView).offset(-134)
        }
        
        contentBgImgView.setContentHuggingPriority(UILayoutPriority(rawValue: 49), for: .horizontal)
        contentBgImgView.setContentHuggingPriority(UILayoutPriority(rawValue: 49), for: .vertical)
        contentBgImgView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 49), for: .horizontal)
        contentBgImgView.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 49), for: .vertical)
        contentBgImgView.snp.makeConstraints { (maker) in
            maker.edges.equalTo(contentBgView)
        }
        
        identityImgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(contentBgView).offset(40)
            maker.centerY.equalTo(redCouponLabel)
        }
        redCouponLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentBgView).offset(pixw(p: 59))
            maker.left.equalTo(identityImgView.snp.right).offset(8)
            maker.right.equalTo(contentBgView).offset(-40)
        }
        
        verifyIdentityButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(redCouponLabel.snp.bottom).offset(pixw(p: 34))
            maker.left.right.equalTo(contentBgView).inset(40)
            maker.height.equalTo(42)
            maker.bottom.equalTo(contentBgView).offset(-pixw(p: 35))
        }
    }
    
    
    
    @objc func verifyIdentityHandle() {
        let vc = UserReadInfoViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
