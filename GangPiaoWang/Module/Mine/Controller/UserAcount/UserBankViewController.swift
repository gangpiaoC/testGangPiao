//
//  UserBankViewController.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/18.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
class UserBankViewController: GPWSecBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "银行卡"
        self.bgView.backgroundColor = bgColor
        let imgView = UIImageView(frame: CGRect(x: 16, y: 16, width: SCREEN_WIDTH - 32, height: 125))
        imgView.image = UIImage(named: "user_bank_bg")
        self.bgView.addSubview(imgView)
        
        let bankIconView = UIImageView(frame: CGRect(x: 16, y: 20, width: 38, height: 38))
        bankIconView.backgroundColor = UIColor.red
        bankIconView.layer.masksToBounds = true
        bankIconView.downLoadImg(imgUrl: GPWUser.sharedInstance().bank_logo ?? "")
        bankIconView.layer.cornerRadius = 19
        imgView.addSubview(bankIconView)
        
        //银行名称
        let bankNameLabel = UILabel(frame: CGRect(x: bankIconView.maxX + 16, y: 20, width: 200, height: 19))
        bankNameLabel.font = UIFont.customFont(ofSize: 18)
        bankNameLabel.centerY = bankIconView.centerY
        bankNameLabel.text = "未绑定银行"
        bankNameLabel.textColor = UIColor.white
        if GPWUser.sharedInstance().is_valid == "1" {
            bankNameLabel.text = GPWUser.sharedInstance().bank_name
        }
        imgView.addSubview(bankNameLabel)
        
        let nameLabel = UILabel(frame: CGRect(x: SCREEN_WIDTH - 150, y: 20, width: 130, height: 38))
        nameLabel.text = "***"
        if GPWUser.sharedInstance().is_valid == "1" {
             let tempName = (GPWUser.sharedInstance().name! as NSString).replacingCharacters(in: NSRange(location: 1,length: 1), with: "*")
            nameLabel.text = tempName
        }
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.customFont(ofSize: 16)
        imgView.addSubview(nameLabel)
        
        let bankNumLabel = UILabel(frame: CGRect(x: 0, y: bankIconView.maxY + 27, width: imgView.width, height: 24))
        bankNumLabel.text = "**** **** **** 6666"
        if GPWUser.sharedInstance().is_valid == "1" {
            let str = ((GPWUser.sharedInstance().bank_num! as NSString)).substring(with: NSRange(location: (GPWUser.sharedInstance().bank_num?.characters.count)! - 4,length: 4))
             bankNumLabel.text = "**** **** **** " + str
        }
    
        bankNumLabel.textAlignment = .center
        bankNumLabel.textColor = UIColor.white
        bankNumLabel.font = UIFont.customFont(ofSize: 16)
        imgView.addSubview(bankNumLabel)
        
        let indictorView = GPWIndicatorView.indicatorView()
        indictorView.frame = CGRect(x: 16, y: imgView.maxY + 27, width: 3, height: 14)
        self.bgView.addSubview(indictorView)
        
        let titleLabel = UILabel(frame: CGRect(x: 24, y: imgView.maxY + 26, width: 300, height: 16))
        titleLabel.font = UIFont.customFont(ofSize: 16)
        titleLabel.textColor = UIColor.hex("333333")
        titleLabel.text = "温馨提示"
        self.bgView.addSubview(titleLabel)
        
        let contentLabel = RTLabel(frame: CGRect(x: 16, y: titleLabel.maxY + 10, width: SCREEN_WIDTH - 32, height: 240))
        contentLabel.text = "<font size=14 color='#888888'>1、根据国家监管条例规定，参与网络借贷的借款人与出借人需进行实名认证。\n2、为保障资金安全，用户需遵循同卡进出的规则，即充值与提现使用同一张银行卡。\n3､ 如果需更换银行卡或有其他问题，请联系客服：400-900-9017。</font>"
        contentLabel.height = contentLabel.optimumSize.height
        self.bgView.addSubview(contentLabel)
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
