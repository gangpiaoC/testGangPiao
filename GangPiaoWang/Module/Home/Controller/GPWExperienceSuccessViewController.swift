//
//  GPWExperienceSuccessViewController.swift
//  GangPiaoWang
//
//  Created by GC on 17/1/6.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWExperienceSuccessViewController: GPWSecBaseViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "出借成功"
        self.leftButton.isHidden = true
        GPWUser.sharedInstance().getUserInfo()
        setupViews()
    }

    private func setupViews() {
        bgView.backgroundColor = UIColor.white
        let imgView = UIImageView(image: UIImage(named: "project_investSucess"))
        bgView.addSubview(imgView)
        
        let staticLabel = UILabel()
        staticLabel.font = UIFont.customFont(ofSize: 18)
        staticLabel.textColor = subTitleColor
        staticLabel.textAlignment = .center
        staticLabel.text = "已成功加入体验标"
        bgView.addSubview(staticLabel)
        
        let completeButton = UIButton(type: .custom)
        completeButton.setTitle("完成", for: .normal)
        completeButton.setTitleColor(UIColor.white, for: .normal)
        completeButton.setBackgroundImage(UIImage(named: "project_right_pay"), for: .normal)
        completeButton.titleLabel?.font = UIFont.customFont(ofSize: 18)
        completeButton.layer.masksToBounds = true
        completeButton.layer.cornerRadius = 5.0
        completeButton.addTarget(self, action: #selector(complete), for: .touchUpInside)
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
    
    @objc private func complete() {
        (navigationController as! GPWNavigationController).canDrag = true
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (navigationController as! GPWNavigationController).canDrag = false
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
