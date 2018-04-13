//
//  GPWFNewsTopCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/11/15.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWFNewsTopCell: UITableViewCell {
    var titleLabel:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let block = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        block.backgroundColor = bgColor
        self.contentView.addSubview(block)

        titleLabel = UILabel(frame: CGRect(x: 16, y: 28, width:  200,height:  20))
        titleLabel.textColor = UIColor.hex("222222")
        titleLabel.text = "媒体报道"
        titleLabel.font = UIFont.customFont(ofSize: 18)
        self.contentView.addSubview(titleLabel)


        let line = UIView(frame: CGRect(x: 16, y: 66 - 0.5, width: SCREEN_WIDTH, height: 0.5))
        line.backgroundColor = lineColor
        self.contentView.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
