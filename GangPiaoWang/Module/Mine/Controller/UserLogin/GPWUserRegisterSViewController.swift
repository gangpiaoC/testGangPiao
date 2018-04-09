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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "注册成功"
        MobClick.event("__cust_event_1")
        MobClick.event("__register", attributes:["userid":GPWUser.sharedInstance().user_name ?? "00"])
        self.bgView.backgroundColor = UIColor.white
        self.leftButton.removeFromSuperview()
        let  imgView = UIImageView(frame: CGRect(x: 0, y: 70, width: 69, height: 70))
        imgView.centerX = SCREEN_WIDTH / 2
        imgView.image = UIImage(named: "project_investSucess")
        self.bgView.addSubview(imgView)
        
        let  temp1Label = UILabel(frame: CGRect(x: 0, y: imgView.maxY + 38, width: SCREEN_WIDTH, height: 21))
        temp1Label.text = "恭喜您，注册成功"
        temp1Label.textAlignment = .center
        temp1Label.font = UIFont.customFont(ofSize: 20)
        temp1Label.textColor = UIColor.hex("666666")
        self.bgView.addSubview(temp1Label)
        
        let  temp2Label = RTLabel(frame: CGRect(x: 0, y: temp1Label.maxY + 66, width: SCREEN_WIDTH, height: 21))
        temp2Label.text =  "<font size=18 color='#666666'>已成功获得</font><font size=18 color='#f6390d'>\(GPWGlobal.sharedInstance().app_exper_amount)元</font><font size=18 color='#666666'>体验金</font>"
        temp2Label.textAlignment = RTTextAlignmentCenter
        temp2Label.height = temp2Label.optimumSize.height
        self.bgView.addSubview(temp2Label)
        
        let btn = UIButton(frame: CGRect(x: 16, y: temp2Label.maxY + 20, width: SCREEN_WIDTH - 16 * 2, height: 64))
        btn.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        btn.setTitle("开通存管帐户领取\(GPWGlobal.sharedInstance().app_accountsred)元红包", for: .normal)
        btn.tag = 100
        btn.addTarget(self, action: #selector(self.btnclick(sender:)), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 18)
        self.bgView.addSubview(btn)
        
        let noBtn = UIButton(frame: CGRect(x: 38, y: btn.maxY + 10, width: SCREEN_WIDTH - 38 * 2, height: 44))
        noBtn.setTitleColor(UIColor.hex("999999"), for: .normal)
        noBtn.setTitle("稍后认证", for: .normal)
        noBtn.tag = 101
        noBtn.addTarget(self, action: #selector(self.btnclick(sender:)), for: .touchUpInside)
        noBtn.titleLabel?.font = UIFont.customFont(ofSize: 16)
        self.bgView.addSubview(noBtn)
        
    }
    
    func btnclick(sender:UIButton) {
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

    override func back(sender: GPWButton) {
        self.navigationController?.popToRootViewController(animated: true)
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
