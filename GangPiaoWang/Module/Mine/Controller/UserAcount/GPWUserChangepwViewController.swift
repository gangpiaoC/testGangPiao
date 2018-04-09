//
//  GPWUserChangepwViewController.swift
//  GangPiaoWang
//  修改密码
//  Created by gangpiaowang on 2016/12/20.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWUserChangepwViewController: GPWSecBaseViewController {

    let array = [
                    ["title":"原密码","place":"请输入原密码"],
                    ["title":"新密码","place":"含字母+数字和符号的6-16个字符"]
                ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改密码"
        self.bgView.backgroundColor = UIColor.white
        var maxHeight:CGFloat = 0
        for i in 0 ..< array.count{
            
            let titleLabel = UILabel(frame: CGRect(x: 16, y: maxHeight, width: 50, height: 56))
            titleLabel.text = array[i]["title"]
            titleLabel.font = UIFont.customFont(ofSize: 16)
            titleLabel.textColor = UIColor.hex("333333")
            self.bgView.addSubview(titleLabel)
            
            let textField = UITextField(frame: CGRect(x: titleLabel.maxX + 15, y: maxHeight, width: 300, height: titleLabel.height))
            textField.placeholder = array[i]["place"]
            textField.textColor = UIColor.hex("333333")
            textField.tag = 100 + i
            textField.isSecureTextEntry = true
            textField.font = UIFont.customFont(ofSize: 16)
            self.bgView.addSubview(textField)
            
            let line = UIView(frame: CGRect(x: 0, y: textField.maxY, width: SCREEN_WIDTH, height: 0.5))
            line.backgroundColor = lineColor
            self.bgView.addSubview(line)
            if i == 0 {
                line.x = 16
            }
            maxHeight = line.maxY
        }
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 16, y: maxHeight + 30, width: SCREEN_WIDTH - 16 * 2, height: 64)
        btn.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        btn.setTitle("确定", for: .normal)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 18)
        btn.addTarget(self, action: #selector(self.btnClick), for: .touchUpInside)
        self.bgView.addSubview(btn)
    }
    
    @objc func btnClick() {
        
        let oldPw = (self.bgView.viewWithTag(100) as! UITextField).text!
        let newPw = (self.bgView.viewWithTag(101) as! UITextField).text!
        if oldPw.characters.count == 0 {
            bgView.makeToast("请输入原密码")
            return
        }
        if newPw.characters.count == 0 {
            bgView.makeToast("请输入新密码")
            return
        }else if  GPWHelper.judgePw(pw: newPw){
            GPWNetwork.requetWithPost(url: User_pwd, parameters: ["oldpwd":oldPw,"newpwd":newPw], responseJSON:  { [weak self] (json,msg) in
                guard let strongSelf = self else { return }
                 UIApplication.shared.keyWindow?.makeToast("密码修改成功")
                GPWUser.sharedInstance().getUserInfo()
                _ = strongSelf.navigationController?.popViewController(animated: true)
                }, failure: { error in
            })
        }else{
             bgView.makeToast("请输入有效密码")
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
