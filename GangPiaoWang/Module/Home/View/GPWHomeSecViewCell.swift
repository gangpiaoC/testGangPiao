//
//  GPWHomeSecTableViewCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/19.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWHomeSecViewCell: UITableViewCell {
    
   weak var superControl:UIViewController?
    var dataDic:JSON?
    let array = [
                  ["img":"home_zhiyin","title":"平台实力"],
                  ["img":"home_safe","title":"安全保障"],
                  ["img":"home_yaoqing","title":"邀请赚钱"],
                  ["img":"home_pinshouqi","title":"签到有奖"]
                ]
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let btnWith = SCREEN_WIDTH / 4
        for i in 0..<array.count {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: btnWith * CGFloat(i), y: 0, width: btnWith, height: 97)
            btn.tag = 100 + i
            btn.addTarget(self, action: #selector(self.btnClick(sender:)), for: .touchUpInside)
            self.contentView.addSubview(btn)
            
            let imgView = UIImageView(frame: CGRect(x: 36, y: 18, width: 38, height: 38))
            imgView.image = UIImage(named: array[i]["img"]!)
            imgView.centerX = btn.width / 2
            btn.addSubview(imgView)

            let titleLabel = UILabel(frame: CGRect(x: 0, y: imgView.maxY + 6, width: btn.width, height: 14))
            titleLabel.text = array[i]["title"]
            titleLabel.font = UIFont.customFont(ofSize: 14)
            titleLabel.textAlignment = .center
            titleLabel.textColor = titleColor
            btn.addSubview(titleLabel)
        }
        
        let block = UIView(frame: CGRect(x: 0, y: 97, width: SCREEN_WIDTH, height: 10))
        block.backgroundColor = bgColor
        self.contentView.addSubview(block)
    }
    
    func updata(dic:JSON,superControl:UIViewController) {
        self.dataDic = dic
        self.superControl = superControl

    }
    
    @objc func btnClick(sender:UIButton) {
        if sender.tag == 100 {
            MobClick.event("home", label: "菜单栏-平台实力")
            //self.superControl?.navigationController?.pushViewController(GPWLendSuccessViewController(), animated: true)
           self.superControl?.navigationController?.pushViewController(GPWWebViewController(subtitle: "", url: HTML_SERVER +  (self.dataDic?["new_head"].string)!), animated: true)
        }else if sender.tag == 101 {
            MobClick.event("home", label: "菜单栏-安全保障")
            self.superControl?.navigationController?.pushViewController(GPWWebViewController(subtitle: "", url:  HTML_SERVER +  (self.dataDic?["insurance"].string)!), animated: true)
        }else if sender.tag == 102 {
            MobClick.event("home", label: "菜单栏-邀请赚钱")
            self.superControl?.navigationController?.pushViewController(GPWWebViewController(subtitle: "", url:  HTML_SERVER +  (self.dataDic?["invite_courtesy"].string)!), animated: true)
        }else if sender.tag == 103 {
            MobClick.event("home", label: "菜单栏-签到有奖")
            if (self.dataDic?["invitation"].stringValue ?? "").count > 6 {
                 self.superControl?.navigationController?.pushViewController(GPWWebViewController(subtitle: "", url:  HTML_SERVER +  (self.dataDic?["invitation"].string)!), animated: true)
            }else{
                if GPWUser.sharedInstance().isLogin {
                     self.superControl?.navigationController?.pushViewController(GPWHomeGetBageController(), animated: true)
                }else{
                    self.superControl?.navigationController?.pushViewController(GPWLoginViewController(), animated: true)
                }
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
