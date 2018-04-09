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
                  ["img":"home_zhiyin","title":"平台介绍"],
                  ["img":"home_safe","title":"安全保障"],
                  ["img":"home_yaoqing","title":"邀请有礼"],
                  ["img":"home_getrb_bg","title":"拼手气"]
                ]
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let btnWith = SCREEN_WIDTH / 4
        for i in 0..<array.count {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: btnWith * CGFloat(i), y: 0, width: btnWith, height: 114)
            btn.tag = 100 + i
            btn.addTarget(self, action: #selector(self.btnClick(sender:)), for: .touchUpInside)
            self.contentView.addSubview(btn)
            
            let imgView = UIImageView(frame: CGRect(x: 36, y: 21, width: 46, height: 46))
            imgView.image = UIImage(named: array[i]["img"]!)
            imgView.centerX = btn.width / 2
            btn.addSubview(imgView)
            if i == 3 {
                //红包
                let bgImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 46, height: 46))
                bgImgView.center = imgView.center
                 btn.addSubview(bgImgView)
                bgImgView.tag = 1000
                bgImgView.image = UIImage.gif(name: "redbag")
            }
            let titleLabel = UILabel(frame: CGRect(x: 0, y: imgView.maxY + 7, width: btn.width, height: 16))
            titleLabel.text = array[i]["title"]
            titleLabel.font = UIFont.customFont(ofSize: 16)
            titleLabel.textAlignment = .center
            titleLabel.textColor = UIColor.hex("555555")
            btn.addSubview(titleLabel)
        }
        
        let block = UIView(frame: CGRect(x: 0, y: 114, width: SCREEN_WIDTH, height: 10))
        block.backgroundColor = bgColor
        self.contentView.addSubview(block)
    }
    
    func updata(dic:JSON,superControl:UIViewController) {
        self.dataDic = dic
        self.superControl = superControl
        let  btn = self.contentView.viewWithTag(103) as! UIButton
        let  imgView = btn.viewWithTag(1000) as! UIImageView
        imgView.image = UIImage.gif(name: "redbag")
    }
    
    @objc func btnClick(sender:UIButton) {
        if sender.tag == 100 {
            MobClick.event("home", label: "菜单栏-新手指引")
           self.superControl?.navigationController?.pushViewController(GPWWebViewController(subtitle: "", url: HTML_SERVER +  (self.dataDic?["new_head"].string)!), animated: true)
        }else if sender.tag == 101 {
            MobClick.event("home", label: "菜单栏-安全保障")
            self.superControl?.navigationController?.pushViewController(GPWWebViewController(subtitle: "", url:  HTML_SERVER +  (self.dataDic?["insurance"].string)!), animated: true)
        }else if sender.tag == 102 {
            MobClick.event("home", label: "菜单栏-邀请有礼")
            self.superControl?.navigationController?.pushViewController(GPWWebViewController(subtitle: "", url:  HTML_SERVER +  (self.dataDic?["invite_courtesy"].string)!), animated: true)
        }else if sender.tag == 103 {
            MobClick.event("home", label: "菜单栏-拼手气")
            if GPWUser.sharedInstance().isLogin {
                self.superControl?.navigationController?.pushViewController(GPWHomeGetBageController(), animated: true)
            }else{
                self.superControl?.navigationController?.pushViewController(GPWLoginViewController(), animated: true)
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
