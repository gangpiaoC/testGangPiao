//
//  GPWHTLCell.swift
//  GangPiaoWang
//  去往体验标记录
//  Created by gangpiaowang on 2017/9/25.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWHTLCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hex("666666")
        label.text = "体验记录"
        label.textAlignment = .center
        label.font = UIFont.customFont(ofSize: 16)
        return label
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.bottom.equalTo(contentView)
            maker.left.equalTo(contentView).offset(16)
            maker.height.equalTo(58)
        }
         let rightImgView: UIImageView = {
            let tempImgView = UIImageView()
            tempImgView.image = UIImage(named:"user_rightImg")
            return tempImgView
        }()
        self.contentView.addSubview(rightImgView)
        rightImgView.snp.makeConstraints { (maker) in
            maker.right.equalTo(contentView).offset(-16)
            maker.centerY.equalTo(titleLabel)
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

