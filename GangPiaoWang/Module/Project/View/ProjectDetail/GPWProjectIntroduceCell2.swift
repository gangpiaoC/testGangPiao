//
//  GPWProjectIntroduceCell2.swift
//  GangPiaoWang
//  融资企业
//  Created by GC on 16/12/20.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWProjectIntroduceCell2: UITableViewCell {
    private let descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.lineBreakMode = .byWordWrapping
        descLabel.textColor = UIColor.hex("999999")
        descLabel.font = UIFont.customFont(ofSize: 14)
        descLabel.numberOfLines = 0
        return descLabel
    }()
    
    private let headerLabel: UILabel = {
        let headerLabel = UILabel(title: "融资企业", color: titleColor, fontSize: 14)
        return headerLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        let indictorView = GPWIndicatorView.indicatorView()
        contentView.addSubview(indictorView)
        
        contentView.addSubview(headerLabel)
        
          contentView.addSubview(descLabel)
        
        let lineView = UIView()
        lineView.backgroundColor = lineColor
        contentView.addSubview(lineView)
        
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
        
        descLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(headerLabel.snp.bottom).offset(12)
            maker.left.equalTo(headerLabel)
            maker.right.equalTo(contentView).offset(-16)
        }
        
        lineView.snp.makeConstraints { (maker) in
            maker.top.equalTo(descLabel.snp.bottom).offset(15)
            maker.left.equalTo(contentView).offset(16)
            maker.right.equalTo(contentView).offset(-16)
            maker.height.equalTo(0.5)
            maker.bottom.equalTo(contentView)
        }
    }
    
    func update(desStr:String? ,title:String)  {
        descLabel.text = desStr
        headerLabel.text = title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
