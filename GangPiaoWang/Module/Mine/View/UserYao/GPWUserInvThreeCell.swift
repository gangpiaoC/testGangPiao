//
//  GPWUserInvThreeCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/1/3.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWUserInvThreeCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let bgView = UIView(frame: CGRect(x: 16, y: 0, width: SCREEN_WIDTH - 32, height: 37))
        bgView.backgroundColor = bgColor
        self.contentView.addSubview(bgView)
        
        let array = ["邀请日期","被邀请人","出借状态"]
        let titleWith = bgView.width / 3
        for i in 0 ..< array.count {
            
            let titleLabel = UILabel(frame: CGRect(x: titleWith * CGFloat(i), y: 0, width: titleWith, height: bgView.height))
            titleLabel.textAlignment = .center
            titleLabel.text = array[i]
            titleLabel.font = UIFont.customFont(ofSize: 14)
            titleLabel.textColor = UIColor.hex("666666")
            bgView.addSubview(titleLabel)
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
