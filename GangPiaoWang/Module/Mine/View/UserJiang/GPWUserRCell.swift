//
//  GPWUserRCell.swift
//  GangPiaoWang
//  加息券
//  Created by gangpiaowang on 2016/12/21.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWUserRCell: UITableViewCell {
    var lilvLabel:RTLabel!
    var temp1Label:UILabel!
    var temp2Label:UILabel!
    
    //整体背景
    var  conBgImgView:UIImageView!
    var superControl:UIViewController?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.backgroundColor = UIColor.clear
        
        //整体背景
        conBgImgView = UIImageView(frame: CGRect(x: 16, y: 16, width: SCREEN_WIDTH - 32, height: 100))
        conBgImgView.image = UIImage(named: "user_inc_use")
        self.contentView.addSubview(conBgImgView)
        
        lilvLabel = RTLabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        lilvLabel.text = "<font size=48 color='#ffffff'>1</font><font size=20 color='#ffffff'>%</font>"
        lilvLabel.textAlignment = RTTextAlignmentCenter
        lilvLabel.height = lilvLabel.optimumSize.height
        lilvLabel.centerY = conBgImgView.height / 2
        conBgImgView.addSubview(lilvLabel)
        
        temp1Label = UILabel(frame: CGRect(x: pixw(p: 157), y: 30, width: conBgImgView.width - 157 - 16, height: 14))
        temp1Label.text = "试用所有产品"
        temp1Label.textColor = UIColor.hex("333333")
        temp1Label.font = UIFont.customFont(ofSize: 14)
        conBgImgView.addSubview(temp1Label)
        
        temp2Label = UILabel(frame: CGRect(x: temp1Label.x, y: temp1Label.maxY + 9, width: temp1Label.width, height: 14))
        temp2Label.text = "有效期至2016-07-05"
        temp2Label.textColor = UIColor.hex("999999")
        temp2Label.font = UIFont.customFont(ofSize: 14)
        conBgImgView.addSubview(temp2Label)
    }
    func setInfo(dic:JSON,superC:UIViewController) {
        self.superControl = superC
        lilvLabel.text = "<font size=46 color='#ffffff'>\(dic["rate"])</font><font size=18 color='#ffffff'>%</font>"
        temp1Label.text = dic["restrict_item"].stringValue
        temp2Label.text = "有效期至" + GPWHelper.strFromDate(dic["due_time"].doubleValue, format: "yyyy-MM-dd")
        let status = dic["status"].stringValue
        if status == "AVAILABLE" {
            //立即使用
             temp1Label.textColor = UIColor.hex("333333")
            conBgImgView.image = UIImage(named: "user_inc_use")
        }else if status == "IN_USE" {
            //加息中
             temp1Label.textColor = UIColor.hex("333333")
            conBgImgView.image = UIImage(named: "user_inc_using")
        }else if status == "HAS_USED" {
            //已使用
             temp1Label.textColor = UIColor.hex("999999")
            conBgImgView.image = UIImage(named: "user_inc_overuse")
        }else if status == "PAST_DUE" {
            //已失效
             temp1Label.textColor = UIColor.hex("999999")
            conBgImgView.image = UIImage(named: "user_inc_overtime")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
