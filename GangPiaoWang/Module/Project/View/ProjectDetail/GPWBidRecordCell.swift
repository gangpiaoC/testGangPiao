//
//  GPWBidRecordCell.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/21.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON

class GPWBidRecordCell: UITableViewCell {
    fileprivate var phoneLabel: UILabel!
    fileprivate var dateLabel: UILabel!
    fileprivate var moneyLabel: UILabel!
    
    //是否截标
    fileprivate var barkLabel: UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        phoneLabel = UILabel(title: "185****2986", color: titleColor, fontSize: 14)
        dateLabel = UILabel(title: "2016-12-28  12：28", color: timeColor, fontSize: 12)
        moneyLabel = UILabel(title: "￥2,000", color: redTitleColor, fontSize: 18)
        barkLabel = UILabel(title: "满标者", color: UIColor.white, fontSize: 12)
        barkLabel.layer.masksToBounds = true
        barkLabel.layer.cornerRadius = 9
        barkLabel.textAlignment = .center
        barkLabel.backgroundColor = UIColor.hex("ffb700")
        
        contentView.addSubview(phoneLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(moneyLabel)
        contentView.addSubview(barkLabel)
        
        let lineView = UIView()
        lineView.backgroundColor = lineColor
        contentView.addSubview(lineView)
        
        phoneLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(22)
            maker.left.equalTo(contentView).offset(16)
        }
        
        barkLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(phoneLabel.snp.right).offset(5)
            maker.width.equalTo(48)
            maker.height.equalTo(18)
            maker.centerY.equalTo(phoneLabel)
        }
        dateLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(phoneLabel.snp.bottom).offset(6)
            maker.left.equalTo(phoneLabel)
        }
        moneyLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(29)
            maker.right.equalTo(contentView).offset(-16)
        }
        lineView.snp.makeConstraints { (maker) in
            maker.top.equalTo(moneyLabel.snp.bottom).offset(29)
            maker.left.equalTo(contentView).offset(16)
            maker.right.equalTo(contentView).offset(-16)
            maker.height.equalTo(0.5)
            maker.bottom.equalTo(contentView)
        }
    }
    
    func setupCell(_ dict: JSON) {
        printLog(message: dict)
        if dict["is_mark"].intValue == 1 {
            barkLabel.isHidden = false
        }else{
            barkLabel.isHidden = true
        }
        phoneLabel.text = dict["telephone"].stringValue
        moneyLabel.text = "￥" + dict["amount"].stringValue
        dateLabel.text = GPWHelper.strFromDate(dict["add_time"].doubleValue, format: "yyyy-MM-dd HH:mm")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
