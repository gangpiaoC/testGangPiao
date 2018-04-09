//
//  GPWHTTopCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/20.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit

class GPWHTTopCell: UITableViewCell {
    private let staticIncomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hex("999999")
        label.text = "年化利率"
        label.textAlignment = .center
        label.font = UIFont.customFont(ofSize: 14)
        return label
    }()
    
    private let incomeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.customFont(ofSize: 46)
        label.textColor = redTitleColor
        label.textAlignment = .center
        label.attributedText = NSAttributedString.attributedString( "0", mainColor: redTitleColor, mainFont: 46, second: "%", secondColor: redTitleColor, secondFont: 26)
        return label
    }()
    
    private let staticDateLabel: UILabel = {
        let label = UILabel()
        label.text = "借款期限"
        label.textColor = UIColor.hex("999999")
        label.textAlignment = .center
        label.font = UIFont.customFont(ofSize: 14.0)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.customFont(ofSize: 36)
        label.attributedText = NSAttributedString.attributedString( "1", mainColor: redTitleColor, mainFont: 36, second: "天", secondColor: redTitleColor, secondFont: 18)
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
        contentView.addSubview(staticIncomeLabel)
        contentView.addSubview(incomeLabel)
        contentView.addSubview(staticDateLabel)
        contentView.addSubview(dateLabel)
        
        incomeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(43)
            maker.left.equalTo(contentView)
            maker.width.equalTo(SCREEN_WIDTH / 2)
        }
        
        staticIncomeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(incomeLabel.snp.bottom).offset(18)
            maker.left.equalTo(contentView)
            maker.width.equalTo(incomeLabel)
            maker.bottom.equalTo(contentView).offset(-43)
        }
        
        dateLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(SCREEN_WIDTH / 2)
            maker.bottom.equalTo(incomeLabel)
            maker.width.equalTo(SCREEN_WIDTH / 2)
        }
        
        staticDateLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(staticIncomeLabel)
            maker.left.width.equalTo(dateLabel)
        }
    }
    
    func setupCell(_ dict: JSON) {
        incomeLabel.attributedText = NSAttributedString.attributedString( dict["expect_rate"].stringValue, mainColor: redTitleColor, mainFont: 46, second: "%", secondColor: redTitleColor, secondFont: 26)
        dateLabel.attributedText = NSAttributedString.attributedString( dict["deadline"].stringValue, mainColor: UIColor.hex("333333"), mainFont: 36, second: "天", secondColor: UIColor.hex("333333"), secondFont: 18)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
