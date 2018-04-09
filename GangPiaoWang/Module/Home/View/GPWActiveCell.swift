//
//  GPWActiveCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/5/8.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWActiveCell: UITableViewCell {
    fileprivate var json:JSON?
    fileprivate var titleLabel:UILabel!
    fileprivate var timeLabel:UILabel!
    fileprivate var imgShowView:UIImageView!
    fileprivate var coverImgView:UIImageView!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let blokView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 16))
        blokView.backgroundColor = bgColor
        contentView.addSubview(blokView)
        
        titleLabel = UILabel(frame: CGRect(x: 16 , y: blokView.maxY + 18, width: SCREEN_WIDTH - 64 - 16, height: 16))
        titleLabel.textColor = UIColor.hex("333333")
        titleLabel.font = UIFont.customFont(ofSize: 16)
        titleLabel.text = "邀请好友赚现金红包金额"
        contentView.addSubview(titleLabel)
        
        timeLabel = UILabel(frame: CGRect(x: titleLabel.x, y: titleLabel.maxY + 6, width: titleLabel.width, height: 14))
        timeLabel.textColor = UIColor.hex("999999")
        timeLabel.font = UIFont.customFont(ofSize: 14)
        timeLabel.text = "2017-03-02"
        contentView.addSubview(timeLabel)
        
        imgShowView =  UIImageView(frame: CGRect(x: titleLabel.x, y: timeLabel.maxY + 14, width: SCREEN_WIDTH - 32, height: pixw(p: 140)))
        contentView.addSubview(imgShowView)
        
        coverImgView = UIImageView(frame: CGRect(x: SCREEN_WIDTH - 64, y: blokView.maxY, width: 64, height: 48))
        coverImgView.image = UIImage(named: "home_active_end")
        contentView.addSubview(coverImgView)
    }
    
    func updata(json:JSON) {
        self.json = json
        titleLabel.text = json["ad_name"].stringValue
        timeLabel.text = GPWHelper.strFromDate(json["add_time"].doubleValue, format: "yyyy.MM.dd") + " - " + GPWHelper.strFromDate(json["due_time"].doubleValue, format: "yyyy.MM.dd")
        imgShowView.downLoadImg(imgUrl: json["img_url"].stringValue, placeImg: "")
        if json["statue"].stringValue == "1" {
            coverImgView.isHidden = false
        }else{
             coverImgView.isHidden = true
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
