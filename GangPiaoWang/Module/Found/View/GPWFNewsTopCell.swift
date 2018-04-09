//
//  GPWFNewsTopCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/11/15.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWFNewsTopCell: UITableViewCell {
    var imgView:UIImageView!
    var titleLabel:UILabel!
    var rightImbView:UIImageView!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let block = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        block.backgroundColor = bgColor
        self.contentView.addSubview(block)

        imgView = UIImageView(frame: CGRect(x:  16,y: block.maxY + 14,width:  3,height:  16))
        imgView.image = UIImage(named:"user_record_shu")
        self.contentView.addSubview(imgView)

        titleLabel = UILabel(frame: CGRect(x: imgView.maxX +  9, y: block.maxY , width:  200,height:  19))
        titleLabel.centerY = imgView.centerY
        titleLabel.textColor = UIColor.hex("333333")
        titleLabel.text = "媒体报道"
        titleLabel.font = UIFont.customFont(ofSize: 18)
        self.contentView.addSubview(titleLabel)

        rightImbView = UIImageView(frame: CGRect(x: SCREEN_WIDTH -  16 - 8, y: 0, width:  8, height:  16))
        rightImbView.image = UIImage(named: "user_rightImg")
        rightImbView.centerY = titleLabel.centerY
        self.contentView.addSubview(rightImbView)

        let line = UIView(frame: CGRect(x: 16, y: 54 - 0.5, width: SCREEN_WIDTH, height: 0.5))
        line.backgroundColor = lineColor
        self.contentView.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
