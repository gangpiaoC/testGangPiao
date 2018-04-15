//
//  GPWFirstDetailCell3.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/20.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

class GPWFirstDetailCell3: UITableViewCell {
    let leftImgView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "project_detail_chujie"))
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 16)
        label.textColor = titleColor
        label.text = "出借10000元，30天后预计可赚"
        return label
    }()
    
    //赚的钱
    private var returnLabel: UILabel = {
        let label = UILabel()
        label.textColor = redColor
        label.font = UIFont.customFont(ofSize: 32)
        label.text = "52.65元"
        return label
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
        contentView.addSubview(leftImgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(returnLabel)
        
        leftImgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(contentView).offset(16)
            maker.centerY.equalTo(titleLabel)
        }
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority.init(rawValue: 249), for: .horizontal)
        titleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(22)
            maker.left.equalTo(leftImgView.snp.right).offset(12)
            maker.right.equalTo(contentView).offset(-16)
        }
        returnLabel.setContentCompressionResistancePriority(UILayoutPriority.init(rawValue: 249), for: .horizontal)
        returnLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
        returnLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel)
            maker.top.equalTo(titleLabel.snp.bottom).offset(18)
            maker.bottom.equalTo(contentView).offset(-24)
            maker.right.equalTo(contentView)
        }
    }
    
    func setupCell(day: String, returnStr: String) {
        titleLabel.text = "出借10000元，\(day)天后预计可赚"
        returnLabel.text = returnStr + "元"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
