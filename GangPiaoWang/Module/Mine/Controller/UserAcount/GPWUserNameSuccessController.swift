//
//  GPWUserNameSuccessController.swift
//  GangPiaoWang
//  实名认证成功
//  Created by gangpiaowang on 2016/12/22.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWUserNameSuccessController:  GPWSecBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        MobClick.event("__cust_event_2")
        self.title = "认证成功"
        self.leftButton.isHidden = true
        GPWUser.sharedInstance().getUserInfo()
        setupViews()
        // Do any additional setup after loading the view.
    }
    
    private func setupViews() {
        bgView.backgroundColor = UIColor.white
        let imgView = UIImageView(image: UIImage(named: "project_investSucess"))
        bgView.addSubview(imgView)
        
        let staticLabel = UILabel()
        staticLabel.font = UIFont.customFont(ofSize: 18)
        staticLabel.textColor = subTitleColor
        staticLabel.textAlignment = .center
        staticLabel.text = "身份认证已成功"
        bgView.addSubview(staticLabel)
        
        let completeButton = UIButton(type: .custom)
        completeButton.setTitle("完成", for: .normal)
        completeButton.setTitleColor(UIColor.white, for: .normal)
        completeButton.setBackgroundImage(UIImage(named: "project_right_pay"), for: .normal)
        completeButton.titleLabel?.font = UIFont.customFont(ofSize: 18)
        completeButton.layer.masksToBounds = true
        completeButton.layer.cornerRadius = 5.0
        completeButton.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        bgView.addSubview(completeButton)
        
        
        
        imgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(bgView).offset(98)
            maker.centerX.equalTo(bgView)
            maker.width.height.equalTo(70)
        }
        
        staticLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(imgView.snp.bottom).offset(36)
            maker.left.right.equalTo(bgView)
        }
        
        completeButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(staticLabel.snp.bottom).offset(42)
            maker.left.equalTo(bgView).offset(16)
            maker.right.equalTo(bgView).offset(-16)
            maker.height.equalTo(44)
        }
    }
    
    @objc func btnClick() {
        (navigationController as! GPWNavigationController).canDrag = true
        //设置手势密码
        let gesture = GestureViewController()
        gesture.type = GestureViewControllerType.setting
        gesture.flag = true
       self.navigationController?.pushViewController(gesture, animated: true)
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
