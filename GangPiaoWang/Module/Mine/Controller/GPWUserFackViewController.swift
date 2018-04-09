//
//  GPWUserFackViewController.swift
//  GangPiaoWang
//  意见反馈
//  Created by gangpiaowang on 2016/12/20.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
class GPWUserFackViewController: GPWSecBaseViewController,RTLabelDelegate ,UITextViewDelegate{

    var textView:UITextView!
    var textField:UITextField!
    var palceLabel:RTLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "意见反馈"
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 148 + 46))
        bgView.backgroundColor = UIColor.white
        self.bgView.addSubview(bgView)
        
        textView = UITextView(frame: CGRect(x: 16, y: 13, width: SCREEN_WIDTH - 32, height: 113 + 14))
        textView.tag = 100
        textView.delegate = self
        textView.font = UIFont.customFont(ofSize: 14)
        textView.textColor = UIColor.hex("333333")
        bgView.addSubview(textView)
        
        //palce
        palceLabel = RTLabel(frame: CGRect(x: 5, y: 7, width: 200, height: 18))
        textView.addSubview(palceLabel)
        palceLabel.delegate = self
        palceLabel.text = "<a href='close'><font size=14 color='#999999'>请输入问题或者意见</font></a>"
        palceLabel.size = palceLabel.optimumSize
        let block = UIView(frame: CGRect(x: 0, y: textView.maxY, width: SCREEN_WIDTH, height: 8))
        block.backgroundColor = bgColor
        bgView.addSubview(block)
        
        textField = UITextField(frame: CGRect(x: 16, y: block.maxY, width: SCREEN_WIDTH - 32, height: 46))
        textField.tag = 101
        textField.placeholder = "联系电话(选填)"
        textField.keyboardType = .numberPad
        textField.font = UIFont.customFont(ofSize: 14)
        textField.textColor = UIColor.hex("333333")
        bgView.addSubview( textField)
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 16, y: bgView.maxY + 30, width: SCREEN_WIDTH - 16 * 2, height: 64)
        btn.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        btn.setTitle("确定", for: .normal)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 18)
        btn.addTarget(self, action: #selector(self.btnClick), for: .touchUpInside)
        self.bgView.addSubview(btn)
        
    }
    func rtLabel(_ rtLabel: Any!, didSelectLinkWithURL url: String!) {
        printLog(message: url)
        if url == "close" {
            textView.becomeFirstResponder()
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let  num1 = textView.text.count
        let num2 = text.count
        if num1 + num2 < 1 {
            palceLabel.isHidden = false
        }else{
            palceLabel.isHidden = true
        }
        return true
    }
    
    @objc func btnClick() {
        printLog(message: "确定")
        var dic = [String:String]()
        if textView.text.count == 0 {
            self.bgView.makeToast("请输入问题或者意见")
            return
        }
        dic["content"] = textView.text
        if (textField.text?.count)! > 0 {
            if GPWHelper.judgePhoneNum(textField.text) {
                dic["phone"] = textField.text
            }else{
                 self.bgView.makeToast("请输入正确手机号")
                return
            }
        }
        
        GPWNetwork.requetWithPost(url: Feedback, parameters: dic, responseJSON:  {
            [weak self] (json, msg) in
            guard let strongSelf = self else { return }
         UIApplication.shared.keyWindow?.makeToast("反馈已成功提交")
              _ = strongSelf.navigationController?.popViewController(animated: true)
            }, failure: { error in
                
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
