//
//  GPWFirstDetailCell1.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/20.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

class GPWFVFirstDetailCell1: UITableViewCell {
    private var staticNoviceLabelHeight: Constraint!
    private var staticDateLabelTop: Constraint!
    private let staticIncomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = subTitleColor
        label.text = "年化利率"
        label.textAlignment = .center
        label.font = UIFont.customFont(ofSize: 14)
        return label
    }()
    private let incomeLabel: RTLabel = {
        let label = RTLabel()
        label.textAlignment = RTTextAlignmentCenter
        return label
    }()

    private let staticNoviceLabel: UILabel = {
        let label = UILabel()
        label.text = "新手专享"
        label.textAlignment = .center
        label.textColor = redTitleColor
        label.font = UIFont.customFont(ofSize: 11.0)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 3.0
        label.layer.borderWidth = 0.5
        label.layer.borderColor = redTitleColor.cgColor
        label.isHidden = true
        return label
    }()
    
    private let staticLimitLabel: UILabel = {
        let label = UILabel()
        label.text = "限投3万"
        label.textAlignment = .center
        label.textColor = redTitleColor
        label.font = UIFont.customFont(ofSize: 11.0)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 3.0
        label.layer.borderWidth = 0.5
        label.layer.borderColor = redTitleColor.cgColor
        label.isHidden = true
        return label
    }()

    private let staticDateLabel: UILabel = {
        let label = UILabel()
        label.text = "借款期限"
        label.textColor = UIColor.hex("999999")
        label.font = UIFont.customFont(ofSize: 14.0)
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.customFont(ofSize: 18)
        label.text = "30天"
        return label
    }()
    
    private let staticMoneyLabel: UILabel = {
        let label = UILabel()
        label.text = "借款金额"
        label.textColor = UIColor.hex("999999")
        label.font = UIFont.customFont(ofSize: 14.0)
        return label
    }()
    private let moneyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.customFont(ofSize: 18)
        label.text = "20万元"
        return label
    }()
    
    private let staticStartInvestLabel: UILabel = {
        let label = UILabel()
        label.text = "起投金额"
        label.textColor = UIColor.hex("999999")
        label.font = UIFont.customFont(ofSize: 14.0)
        return label
    }()
    private let startInvestLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "100元"
        return label
    }()
    
    private let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .bar)
        progress.backgroundColor = UIColor.hex("efefef")
        progress.progressTintColor = UIColor.hex("fcc30c")
        progress.layer.masksToBounds = true
        progress.layer.cornerRadius = 4
        return progress
    }()
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hex("999999")
        label.text = "剩余金额：10,000元"
        label.font = UIFont.customFont(ofSize: 14.0)
        return label
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hex("999999")
        label.text = "65%"
        label.font = UIFont.customFont(ofSize: 14.0)
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
        contentView.addSubview(staticNoviceLabel)
        contentView.addSubview(staticLimitLabel)
        contentView.addSubview(staticDateLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(staticMoneyLabel)
        contentView.addSubview(moneyLabel)
        contentView.addSubview(staticStartInvestLabel)
        contentView.addSubview(startInvestLabel)
        contentView.addSubview(progressView)
        contentView.addSubview(balanceLabel)
        contentView.addSubview(progressLabel)
        
        let placeholderView = UIView()
        placeholderView.backgroundColor = bgColor
        contentView.addSubview(placeholderView)
     
        staticIncomeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(25)
            maker.left.right.equalTo(contentView)
        }
        
        incomeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(staticIncomeLabel.snp.bottom).offset(10)
            maker.left.right.equalTo(contentView)
            maker.height.equalTo(100)
        }
        
        staticNoviceLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(incomeLabel.snp.bottom).offset(18)
            maker.centerX.equalTo(contentView).offset(-40)
            staticNoviceLabelHeight = maker.height.equalTo(0).constraint
            maker.width.equalTo(58)
        }
        
        staticLimitLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(staticNoviceLabel)
            maker.centerX.equalTo(contentView).offset(40)
            maker.height.equalTo(staticNoviceLabel)
            maker.width.equalTo(staticNoviceLabel)
        }
        
        staticDateLabel.snp.makeConstraints { (maker) in
            staticDateLabelTop =  maker.top.equalTo(staticNoviceLabel.snp.bottom).offset(11).constraint
            maker.left.equalTo(contentView).offset(36)
        }
        
        dateLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(staticDateLabel.snp.bottom).offset(9)
            maker.left.equalTo(staticDateLabel)
        }
        
        staticMoneyLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(staticDateLabel)
            maker.centerX.equalTo(contentView)
        }
        
        moneyLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(dateLabel)
            maker.centerX.equalTo(contentView)
        }
        
        staticStartInvestLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(staticDateLabel)
            maker.right.equalTo(contentView).offset(-36)
        }
        
        startInvestLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(dateLabel)
            maker.centerX.equalTo(staticStartInvestLabel)
        }
        
        progressView.snp.makeConstraints { (maker) in
            maker.top.equalTo(dateLabel.snp.bottom).offset(17)
            maker.left.equalTo(contentView).offset(32)
            maker.right.equalTo(contentView).offset(-32)
            maker.height.equalTo(6)
        }
        
        balanceLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(progressView.snp.bottom).offset(11)
            maker.left.equalTo(contentView).offset(32)
        }
        
        progressLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(balanceLabel)
            maker.right.equalTo(contentView).offset(-31)
        }
        
        placeholderView.snp.makeConstraints { (maker) in
            maker.top.equalTo(balanceLabel.snp.bottom).offset(21)
            maker.left.right.equalTo(contentView)
            maker.height.equalTo(8)
            maker.bottom.equalTo(contentView)
        }
    }
    
    func setupCell(_ dict: JSON) {
         incomeLabel.text = "<font size=70 color='#f6390c'>\(dict["rate_loaner"])</font><font size=36 color='#f6390c'>%</font>"
        
        //是否为新手标
        if GPWUser.sharedInstance().identity == 2 || GPWUser.sharedInstance().identity == 4{
            staticNoviceLabel.isHidden = false
            staticLimitLabel.isHidden = false
            staticNoviceLabelHeight.update(offset: 19)
            staticDateLabelTop.update(offset: 30)
            setNeedsUpdateConstraints()
            staticNoviceLabel.text = "新手专享"
            staticLimitLabel.text = "限投\(dict["begin_amount_sx"].stringValue)万"
            if dict["rate_loaner"].doubleValue > 0 {
                incomeLabel.text = "<font size=70 color='#f6390c'>\(dict["rate_loaner"])</font><font size=36 color='#f6390c'>%</font><font size=36 color='#f6390c'>+</font><font size=48 color='#f6390c'>\(dict["rate_new"])</font><font size=24 color='#f6390c'>%</font>"
            }
        }
        dateLabel.attributedText = NSAttributedString.attributedString(dict["deadline"].stringValue, second: "天")
        moneyLabel.attributedText = NSAttributedString.attributedString(dict["amount"].stringValue, second: "万元")
        startInvestLabel.attributedText = NSAttributedString.attributedString(dict["begin_amount"].stringValue, second: "元")
        balanceLabel.text = "剩余金额: \(dict["balance_amount"].stringValue)元"
        progressLabel.text =  "\(dict["jindu"].floatValue)%"
        progressView.progress = dict["jindu"].floatValue / 100
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
