//
//  GPWRuleContentCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/3/24.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWRuleContentCell: UITableViewCell {
    private let numLabel: UILabel = {
        let view = UILabel()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        view.text = "1"
        view.textAlignment = .center
        view.textColor = UIColor.white
        view.font = UIFont.customFont(ofSize: 13)
        view.backgroundColor = UIColor.hex("f5a623")
        return view
    }()
    private let contentLabel: UILabel = {
        let view = UILabel()
        view.lineBreakMode = .byWordWrapping
        view.font = UIFont.customFont(ofSize: 14)
        view.textColor = UIColor.hex("666666")
        view.numberOfLines = 0
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        commonInitialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInitialize() {
        contentView.addSubview(numLabel)
         contentView.addSubview(contentLabel)
        numLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(15)
            make.left.equalTo(contentView).offset(28)
            make.width.equalTo(16)
            make.height.equalTo(16)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(numLabel)
            make.left.equalTo(numLabel.snp.right).offset(11)
            make.right.equalTo(contentView).offset(-10)
        }
    }
    func updata(index:Int,content:String) {
        numLabel.text = "\(index)"
        contentLabel.text = content
    }
}
