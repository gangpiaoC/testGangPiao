//
//  GPWFAQCell.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/21.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

class GPWFAQCell: UITableViewCell {
    private var answerInfoLabel: UILabel!
    private var questionInfoLabel: UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        let questionLabel = UILabel(title: "问", color: UIColor.hex("9013fe"), fontSize: 14, weight: UIFont.Weight.thin.rawValue, numberOfLines: 0)
        contentView.addSubview(questionLabel)
        let answerLabel = UILabel(title: "答", color: redTitleColor, fontSize: 14, weight: UIFont.Weight.thin.rawValue, numberOfLines: 0)
        contentView.addSubview(answerLabel)
        questionInfoLabel = UILabel(title: "什么是票据质押借款类产品？", color: UIColor.hex("111111"), fontSize: 14, weight: UIFont.Weight.thin.rawValue, numberOfLines: 0)
        contentView.addSubview(questionInfoLabel)
        answerInfoLabel = UILabel(title: "票据产品收益=购买金额*预期年化收益率*产品期限/365", color: subTitleColor, fontSize: 14, weight: UIFont.Weight.thin.rawValue, numberOfLines: 0)
        contentView.addSubview(answerInfoLabel)

        let lineView = UIView()
        lineView.backgroundColor = lineColor
        contentView.addSubview(lineView)
        
        questionLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(20)
            maker.left.equalTo(contentView).offset(16)
            maker.width.equalTo(13)
        }
        questionInfoLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(questionLabel)
            maker.left.equalTo(questionLabel.snp.right).offset(13)
            maker.right.equalTo(contentView).offset(-20)
        }
        answerLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(questionLabel.snp.bottom).offset(9)
            maker.left.equalTo(questionLabel)
            maker.width.equalTo(13)
        }
        answerInfoLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(questionInfoLabel.snp.bottom).offset(9)
            maker.left.equalTo(questionInfoLabel)
            maker.right.equalTo(questionInfoLabel)
        }
        
        lineView.snp.makeConstraints { (maker) in
            maker.top.equalTo(answerInfoLabel.snp.bottom).offset(17)
            maker.left.equalTo(contentView).offset(16)
            maker.right.equalTo(contentView).offset(-20)
            maker.height.equalTo(0.5)
            maker.bottom.equalTo(contentView)
        }
        
    }
    
    func setupCell(_ dict: JSON) {
        questionInfoLabel.text = dict["question"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        answerInfoLabel.text = dict["answer"].stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
