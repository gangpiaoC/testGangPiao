//
//  GPWUserExpCell.swift
//  GangPiaoWang
//  我的体验金
//  Created by gangpiaowang on 2017/4/26.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWUserExpCell:  UITableViewCell {
    
    //背景图
    var bgImgView:UIImageView!
    
    //红包
    var bagLabel:UILabel!
    
    //过期图片
    var  timeImgView:UIImageView!
    
    //限制条件
    var temp1Label:UILabel!
    
    //截止时间
    var temp2Label:UILabel!
    
    var superControl:UIViewController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        
        let block = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 16))
        block.backgroundColor = bgColor
        self.contentView.addSubview(block)
        
        //整体背景
        let  conBgImgView:UIImageView = UIImageView(frame: CGRect(x: 16, y: block.maxY, width: SCREEN_WIDTH - 32, height: 120))
        conBgImgView.image = UIImage(named: "user_inc_exp_bg")
        self.contentView.addSubview(conBgImgView)
        
        bgImgView = UIImageView(frame: CGRect(x: 15, y: 11, width: 96, height: 95))
        bgImgView.image = UIImage(named: "user_inc_exp_use")
        conBgImgView.addSubview(bgImgView)
        
        bagLabel = UILabel(frame: CGRect(x: bgImgView.x, y: 66, width: bgImgView.width, height: 24))
        bagLabel.text = "￥80000"
        bagLabel.attributedText = NSAttributedString.attributedString( "￥", mainColor: UIColor.white, mainFont: 14, second: "80000", secondColor: UIColor.white, secondFont: 23)
        bagLabel.textAlignment = .center
        conBgImgView.addSubview(bagLabel)
        
        timeImgView = UIImageView(frame: CGRect(x: bgImgView.x + 21 , y: 37, width: 67, height: 47))
        conBgImgView.addSubview(timeImgView)
        
        temp1Label = UILabel(frame: CGRect(x: pixw(p: 163), y: 36, width: conBgImgView.width - pixw(p: 163) - 16, height: 15))
        temp1Label.text = "仅限≥30天产品"
        temp1Label.textColor = UIColor.hex("333333")
        temp1Label.font = UIFont.customFont(ofSize: 14)
        conBgImgView.addSubview(temp1Label)
        
        temp2Label = UILabel(frame: CGRect(x: temp1Label.x, y: temp1Label.maxY + 10, width: temp1Label.width, height: 15))
        temp2Label.text = "有效期至2016-07-05"
        temp2Label.textColor = UIColor.hex("999999")
        temp2Label.font = UIFont.customFont(ofSize: 14)
        conBgImgView.addSubview(temp2Label)
    }
    
    func setInfo(dic:JSON,superC:UIViewController) {
        self.superControl = superC
       bagLabel.attributedText = NSAttributedString.attributedString( "￥", mainColor: UIColor.white, mainFont: 16, second: "\(dic["amount"])", secondColor: UIColor.white, secondFont: 23)
        temp1Label.text = dic["limitse"].stringValue
        temp2Label.text = "有效期至" + GPWHelper.strFromDate(dic["due_time"].doubleValue, format: "yyyy-MM-dd")
        let status = dic["status"].stringValue
        printLog(message: status)
        if status == "AVAILABLE" {
            
            //立即使用
            bgImgView.image = UIImage(named: "user_inc_exp_use")
            temp1Label.textColor = UIColor.hex("333333")
            timeImgView.image = UIImage(named: "")
        }else if status == "ACTIVATE" {
            
            //已使用
            bgImgView.image = UIImage(named: "user_inc_exp_used")
            timeImgView.isHidden = false
            temp1Label.textColor = UIColor.hex("999999")
            timeImgView.image = UIImage(named: "user_reward_usedd")
        }else if status == "HAS_USED" {
            
            //已使用
            bgImgView.image = UIImage(named: "user_inc_exp_used")
            temp1Label.textColor = UIColor.hex("999999")
            timeImgView.image = UIImage(named: "user_reward_usedd")
        }else if status == "PAST_DUE" {
            
            //已过期
            bgImgView.image = UIImage(named: "user_inc_exp_used")
            temp1Label.textColor = UIColor.hex("999999")
            timeImgView.image = UIImage(named: "user_reward_overtime")
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
