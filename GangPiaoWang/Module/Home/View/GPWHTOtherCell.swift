//
//  GPWHTOtherCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/20.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SnapKit

class GPWHTOtherCell: UITableViewCell {
    private var num1Label:UILabel = {
        let numLabel = UILabel()
        numLabel.font = UIFont.customFont(ofSize: 14)
        numLabel.text = "1、"
        numLabel.textColor = UIColor.hex("666666")
        return numLabel
    }()
    private let desc1Label: UILabel = {
        let descLabel = UILabel()
        descLabel.lineBreakMode = .byWordWrapping
        descLabel.numberOfLines = 0
        descLabel.textColor = UIColor.hex("666666")
        descLabel.font = UIFont.customFont(ofSize: 14)
        descLabel.text = "获得体验金后，即可在体验标使用。"
        return descLabel
    }()
    private var num2Label:UILabel = {
        let numLabel = UILabel()
        numLabel.font = UIFont.customFont(ofSize: 14)
        numLabel.text = "2、"
        numLabel.textColor = UIColor.hex("666666")
        return numLabel
    }()
    private let desc2Label: UILabel = {
        let descLabel = UILabel()
        descLabel.lineBreakMode = .byWordWrapping
        descLabel.numberOfLines = 0
        descLabel.textColor = UIColor.hex("666666")
        descLabel.font = UIFont.customFont(ofSize: 14)
        descLabel.text = "应第三方存管要求，涉及回款的项目，需进行实名认证。"
        return descLabel
    }()
    private var num3Label:UILabel = {
        let numLabel = UILabel()
        numLabel.font = UIFont.customFont(ofSize: 14)
        numLabel.text = "3、"
        numLabel.textColor = UIColor.hex("666666")
        return numLabel
    }()
    private let desc3Label: UILabel = {
        let descLabel = UILabel()
        descLabel.lineBreakMode = .byWordWrapping
        descLabel.numberOfLines = 0
        descLabel.textColor = UIColor.hex("666666")
        descLabel.font = UIFont.customFont(ofSize: 14)
        descLabel.text = "体验金项目到期后，本金平台收回，获得的收益归用户所有，可直接提现。"
        return descLabel
    }()
    private var num4Label:UILabel = {
        let numLabel = UILabel()
        numLabel.font = UIFont.customFont(ofSize: 14)
        numLabel.text = "4、"
        numLabel.textColor = UIColor.hex("666666")
        return numLabel
    }()
    private let desc4Label: UILabel = {
        let descLabel = UILabel()
        descLabel.lineBreakMode = .byWordWrapping
        descLabel.numberOfLines = 0
        descLabel.textColor = UIColor.hex("666666")
        descLabel.font = UIFont.customFont(ofSize: 14)
         descLabel.attributedText = NSAttributedString.attributedString( "本项目最终解释权归钢票网平台所有，若有其他疑问，请联系客服咨询", mainColor: UIColor.hex("666666"), mainFont: 14, second: "400-900-9017。", secondColor: redTitleColor, secondFont: 14)
        return descLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let indictorView = GPWIndicatorView.indicatorView()
        contentView.addSubview(indictorView)
        
        let headerLabel = UILabel()
        headerLabel.font = UIFont.customFont(ofSize: 14)
        headerLabel.textColor = titleColor
        headerLabel.text = "体验标说明"
        contentView.addSubview(headerLabel)
        
        contentView.addSubview(num1Label)
        contentView.addSubview(desc1Label)
        contentView.addSubview(num2Label)
        contentView.addSubview(desc2Label)
        contentView.addSubview(num3Label)
        contentView.addSubview(desc3Label)
        contentView.addSubview(num4Label)
        contentView.addSubview(desc4Label)
        
        indictorView.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(17)
            maker.left.equalTo(contentView).offset(16)
            maker.height.equalTo(14)
            maker.width.equalTo(3)
        }
        
        headerLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(indictorView)
            maker.left.equalTo(indictorView.snp.right).offset(7)
            maker.right.equalTo(contentView)
        }
        
        num1Label.snp.makeConstraints { (maker) in
            maker.top.equalTo(headerLabel.snp.bottom).offset(12)
            maker.left.equalTo(headerLabel)
            maker.width.equalTo(25)
        }
        
        desc1Label.snp.makeConstraints { (maker) in
            maker.top.equalTo(num1Label)
            maker.left.equalTo(num1Label.snp.right)
            maker.right.equalTo(contentView).offset(-16)
        }
        
        num2Label.snp.makeConstraints { (maker) in
            maker.top.equalTo(desc1Label.snp.bottom).offset(5)
            maker.left.width.equalTo(num1Label)
        }
        desc2Label.snp.makeConstraints { (maker) in
            maker.top.equalTo(num2Label)
            maker.left.width.equalTo(desc1Label)
        }
        
        num3Label.snp.makeConstraints { (maker) in
            maker.top.equalTo(desc2Label.snp.bottom).offset(5)
            maker.left.width.equalTo(num2Label)
        }
        
        desc3Label.snp.makeConstraints { (maker) in
            maker.top.equalTo(num3Label)
            maker.left.width.equalTo(desc2Label)
        }
        
        num4Label.snp.makeConstraints { (maker) in
            maker.top.equalTo(desc3Label.snp.bottom).offset(5)
            maker.left.width.equalTo(num3Label)
        }
        desc4Label.snp.makeConstraints { (maker) in
            maker.top.equalTo(num4Label)
            maker.left.width.equalTo(desc3Label)
            maker.bottom.equalTo(contentView).offset(-16)
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
