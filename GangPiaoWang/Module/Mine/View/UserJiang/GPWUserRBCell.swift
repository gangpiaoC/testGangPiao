//
//  GPWUserRBTableViewCell.swift
//  GangPiaoWang
//  红包
//  Created by gangpiaowang on 2016/12/21.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWUserRBCell: UITableViewCell {

    //背景图
    var bgImgView:UIImageView!
    
    //红包
    var bagLabel:RTLabel!
    
    //过期图片
    var  timeImgView:UIImageView!
    
    //单笔出借满1000元
    var temp1Label:UILabel!
    
    //限制条件
    var temp2Label:UILabel!
    
    //截止时间
    var temp3Label:UILabel!
    
    //是否被选择（确认出资中选择红包使用）
    fileprivate var  selectImgView:UIImageView!
    
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
        conBgImgView.image = UIImage(named: "user_reward_bg")
        self.contentView.addSubview(conBgImgView)
        
        bgImgView = UIImageView(frame: CGRect(x: 25, y: block.maxY + 4, width: 75, height: 69))
        bgImgView.image = UIImage(named: "user_reward_use")
        conBgImgView.addSubview(bgImgView)
        
        selectImgView = UIImageView(frame: CGRect(x: conBgImgView.width - 16 - 18, y: 0, width: 18, height: 18))
        selectImgView.image = UIImage(named: "project_sure_select")
        selectImgView.centerY = bgImgView.centerY
        conBgImgView.addSubview(selectImgView)
        
        
        bagLabel = RTLabel(frame: CGRect(x: 0, y: 36, width: bgImgView.width, height: 24))
        bagLabel.text = "<font size=24 color='#ffffff'>￥200</font>"
        bagLabel.textAlignment = RTTextAlignmentCenter
        bagLabel.height = bagLabel.optimumSize.height
        bgImgView.addSubview(bagLabel)
       
        timeImgView = UIImageView(frame: CGRect(x: 50, y: 35, width: 65, height: 46))
        conBgImgView.addSubview(timeImgView)
        
        temp1Label = UILabel(frame: CGRect(x:pixw(p: 163), y: 26, width: conBgImgView.width - bagLabel.maxX - 64 - 16, height: 15))
        temp1Label.text = "单笔出借满10000元"
        temp1Label.textColor = UIColor.hex("333333")
        temp1Label.font = UIFont.customFont(ofSize: 14)
        conBgImgView.addSubview(temp1Label)
        
        temp2Label = UILabel(frame: CGRect(x: temp1Label.x, y: temp1Label.maxY + 5, width: temp1Label.width, height: 15))
        temp2Label.text = "仅限≥30天产品"
        temp2Label.textColor = UIColor.hex("333333")
        temp2Label.font = UIFont.customFont(ofSize: 14)
        conBgImgView.addSubview(temp2Label)
        
        temp3Label = UILabel(frame: CGRect(x: temp1Label.x, y: temp2Label.maxY + 10, width: temp1Label.width, height: 15))
        temp3Label.text = "有效期至2016-07-05"
        temp3Label.textColor = UIColor.hex("999999")
        temp3Label.font = UIFont.customFont(ofSize: 14)
        conBgImgView.addSubview(temp3Label)
    }
    
    func setInfo(dic:JSON,superC:UIViewController) {
        self.selectImgView.isHidden = true
        self.superControl = superC
        bagLabel.text = "<font size=24 color='#ffffff'>￥\(dic["amount"])</font>"
        temp1Label.text = "单笔出借满\(dic["restrict_amount"])元"
        temp2Label.text = "\(dic["limitse"])"

        temp3Label.text = "有效期至" + GPWHelper.strFromDate(dic["due_time"].doubleValue, format: "yyyy-MM-dd")
        let status = dic["status"].stringValue
        printLog(message: status)
        if status == "AVAILABLE" {
           
            //立即使用
            bgImgView.image = UIImage(named: "user_reward_use")
            temp1Label.textColor = UIColor.hex("333333")
            temp2Label.textColor = UIColor.hex("333333")
             timeImgView.image = UIImage(named: "")
        }else if status == "ACTIVATE" {
            
            //已使用
            bgImgView.image = UIImage(named: "user_reward_used")
            timeImgView.isHidden = false
            temp1Label.textColor = UIColor.hex("999999")
            temp2Label.textColor = UIColor.hex("999999")
            timeImgView.image = UIImage(named: "user_reward_usedd")
        }else if status == "HAS_USED" {
            
            //已使用
            bgImgView.image = UIImage(named: "user_reward_used")
            temp1Label.textColor = UIColor.hex("999999")
            temp2Label.textColor = UIColor.hex("999999")
            timeImgView.image = UIImage(named: "user_reward_usedd")
        }else if status == "PAST_DUE" {
            
            //已过期
            bgImgView.image = UIImage(named: "user_reward_used")
            //timeImgView.isHidden = false
            temp1Label.textColor = UIColor.hex("999999")
            temp2Label.textColor = UIColor.hex("999999")
            timeImgView.image = UIImage(named: "user_reward_overtime")
        }
    }
    
    func setupCell(_ redCoupon: RedEnvelop, selectFlag:Bool) {
        self.selectImgView.isHidden = false
        bagLabel.text = "<font size=24 color='#ffffff'>￥\(redCoupon.amount)</font>"
        temp1Label.text = "单笔出借满\(redCoupon.restrict_amount)元"
        temp2Label.text = redCoupon.limitse
        temp3Label.text = "有效期至" + GPWHelper.strFromDate(redCoupon.expire, format: "yyyy-MM-dd")
        let status = redCoupon.status
        printLog(message: status)
        bgImgView.image = UIImage(named: "user_reward_use")
        temp1Label.textColor = UIColor.hex("333333")
        temp2Label.textColor = UIColor.hex("333333")
        timeImgView.image = UIImage(named: "")
        
        if selectFlag {
            selectImgView.image = UIImage(named: "project_sure_selected")
        }else{
            selectImgView.image = UIImage(named: "project_sure_select")
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


}
