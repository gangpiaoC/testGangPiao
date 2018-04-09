//
//  GPWUserMessageCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/22.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWUserMessageCell: UITableViewCell {
    
    //图标
    var readImgView:UIImageView!
    
    //标题
    var titleLabel:UILabel!
    
    //时间
    var timeLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        readImgView = UIImageView(frame: CGRect(x: 16, y: 15, width: 19, height: 20))
        self.contentView.addSubview(readImgView)
        
        titleLabel = UILabel(frame: CGRect(x:readImgView.maxX + 13, y: 16, width: SCREEN_WIDTH - 32, height: 16))
        titleLabel.text = "关于钢票网系统维护公告"
        titleLabel.textColor = UIColor.hex("333333")
        titleLabel.font = UIFont.customFont(ofSize: 16)
        self.contentView.addSubview(titleLabel)
        
        
        timeLabel = UILabel(frame: CGRect(x: titleLabel.x, y: titleLabel.maxY + 7, width: titleLabel.width, height: 12))
        timeLabel.text = "2016-11-22  15:00"
        timeLabel.textColor = UIColor.hex("999999")
        timeLabel.font = UIFont.customFont(ofSize: 12)
        self.contentView.addSubview(timeLabel)
        
        let line = UIView(frame: CGRect(x: 0, y: 67 - 0.5, width: SCREEN_WIDTH, height: 0.5))
        line.backgroundColor = lineColor
        self.contentView.addSubview(line)
    }
    
    func setInfo(dic:JSON,superC:UIViewController,type:String) {
        
        if type == "message" {
            readImgView.isHidden = false
            titleLabel.x = readImgView.maxX + 13
            timeLabel.x = titleLabel.x
            if dic["is_read"].stringValue == "0" {
                titleLabel.textColor = UIColor.hex("333333")
                readImgView.image = UIImage(named: "user_message_noread")
            }else{
                titleLabel.textColor = UIColor.hex("999999")
                readImgView.image = UIImage(named: "user_message_read")
            }
        }else{
            readImgView.isHidden = true
            titleLabel.x = readImgView.x
            timeLabel.x = titleLabel.x
            titleLabel.textColor = UIColor.hex("333333")
        }
         titleLabel.text = dic["title"].stringValue
         timeLabel.text =  GPWHelper.strFromDate(dic["add_time"].doubleValue, format: "yyyy-MM-dd  HH:mm")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

