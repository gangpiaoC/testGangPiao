//
//  GPWProjectCell.swift
//  GangPiaoWang
//
//  Created by GC on 16/11/30.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

class GPWProjectCell: UITableViewCell {
    fileprivate let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.hex("4f4f4f")
        titleLabel.font = UIFont.customFont(ofSize: 16.0)
        titleLabel.text = "新手专享"
        return titleLabel
    }()
    
    let newbieButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.customFont(ofSize: 14.0)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("新手加息", for: .normal)
        button.backgroundColor = UIColor.hex("f5a623")
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 11
        button.setImage(#imageLiteral(resourceName: "project_xinshouzhuanxiang"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "project_xinshouzhuanxiang"), for: .highlighted)
        button.adjustsImageWhenHighlighted = false
        button.isUserInteractionEnabled = false
        return button
    }()
    
    let rightArrowImgView:UIImageView = UIImageView(image: #imageLiteral(resourceName: "project_rightArrow"))
    
    let  statusLabel: UILabel = {
        let label = UILabel()
        label.text = "即将开放"
        label.textColor = UIColor.hex("b7b7b7")
        label.font = UIFont.customFont(ofSize: 12.0)
        return label
    }()
    
    let statusImgView = UIImageView(image: #imageLiteral(resourceName: "project_statusCompleted"))
    
    let staticIncomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hex("b7b7b7")
        label.text = "历史年化利率"
        label.font = UIFont.customFont(ofSize: 12.0)
        return label
    }()
    
    let incomeLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.attributedString("9.0", mainColor: UIColor.hex("fa713d"), mainFont: 40, mainFontWeight: .medium, second: "%", secondColor: UIColor.hex("fa713d"), secondFont: 20, secondFontWeight: .medium)
        return label
    }()

    let staticDateLabel: UILabel = {
        let label = UILabel()
        label.text = "期限"
        label.textColor = UIColor.hex("4f4f4f")
        label.font = UIFont.customFont(ofSize: 18.0)
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hex("fa713d")
        label.font = UIFont.customFont(ofSize: 18.0)
        label.text = "30天"
        return label
    }()
    
    fileprivate let balanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hex("4f4f4f")
        label.font = UIFont.customFont(ofSize: 12.0)
        label.text = "100元起投 剩余651,000元"
        return label
    }()

    let lineView = UIView(bgColor: UIColor.hex("f2f2f2"))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        commonInitialize()
    }
    
    private func commonInitialize() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(newbieButton)
        contentView.addSubview(statusLabel)
        contentView.addSubview(rightArrowImgView)
        contentView.addSubview(statusImgView)
        contentView.addSubview(staticIncomeLabel)
        contentView.addSubview(incomeLabel)
        contentView.addSubview(staticDateLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(balanceLabel)
        contentView.addSubview(lineView)
        newbieButton.setButtonImageTitleStyle(.imagePositionLeft, padding: 2)
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(28)
            maker.left.equalTo(staticIncomeLabel)
        }
        newbieButton.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(titleLabel)
            maker.left.equalTo(titleLabel.snp.right).offset(8)
            maker.width.equalTo(90)
            maker.height.equalTo(22)
        }
        rightArrowImgView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(titleLabel)
            maker.right.equalTo(contentView).offset(-16)
        }
        statusLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(rightArrowImgView)
            maker.right.equalTo(rightArrowImgView.snp.left).offset(-4)
        }
        statusImgView.snp.makeConstraints { (maker) in
            maker.right.equalTo(contentView)
            maker.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        incomeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(18)
            maker.left.equalTo(staticIncomeLabel)
        }
        staticDateLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(incomeLabel).offset(-3)
            maker.left.equalTo(contentView.centerX)
        }
        dateLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(staticDateLabel)
            maker.left.equalTo(staticDateLabel.snp.right).offset(3)
        }
        staticIncomeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(incomeLabel.snp.bottom).offset(7)
            maker.left.equalTo(contentView).offset(16)
        }
        balanceLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(staticIncomeLabel)
            maker.left.equalTo(staticDateLabel)
            maker.right.equalTo(contentView).offset(-16)
        }
        lineView.snp.makeConstraints { (maker) in
            maker.top.equalTo(staticIncomeLabel.snp.bottom).offset(28)
            maker.left.equalTo(staticIncomeLabel)
            maker.height.equalTo(1.0)
            maker.right.bottom.equalTo(contentView)
        }
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(dict: JSON) {
        titleLabel.text = dict["title"].string ?? "钢票宝20161226"
        if dict["is_index"].intValue == 1 && GPWUser.sharedInstance().staue == 0 {   //新手标
            newbieButton.isHidden = false
            let attrText = NSMutableAttributedString()
            attrText.append(NSAttributedString.attributedString("\(dict["rate_loaner"])", mainColor: UIColor.hex("fa713d"), mainFont: 40, mainFontWeight: .medium, second: "+\(dict["rate_new"])", secondColor: UIColor.hex("fa713d"), secondFont: 26, secondFontWeight: .medium))
            attrText.append(NSAttributedString(string: "%", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedStringKey.foregroundColor: UIColor.hex("fa713d")]))
            incomeLabel.attributedText = attrText
        } else {
            newbieButton.isHidden = true
            incomeLabel.attributedText = NSAttributedString.attributedString("\(dict["rate_loaner"])", mainColor: UIColor.hex("fa713d"), mainFont: 40, mainFontWeight: .medium, second: "%", secondColor: UIColor.hex("fa713d"), secondFont: 20, secondFontWeight: .medium)
        }
        dateLabel.text = "\(dict["deadline"].int ?? 0)天"
       
        statusLabel.text = "即将开放"
        statusImgView.isHidden = true
        balanceLabel.text = "\(dict["begin_amount"])元起投 剩余:\(dict["balance_amount"].string ?? "1,000,000")元"
        titleLabel.textColor = UIColor.hex("4f4f4f")
        balanceLabel.textColor = UIColor.hex("4f4f4f")
        staticDateLabel.textColor = UIColor.hex("4f4f4f")
        dateLabel.textColor = UIColor.hex("fa713d")
        staticIncomeLabel.textColor = UIColor.hex("b7b7b7")
        let state = dict["status"].string ?? "COLLECTING"
        switch state {
        case "FINISH", "REPAYING", "FULLSCALE":
            statusLabel.text = ""
            statusImgView.isHidden = false
            balanceLabel.text = "\(dict["begin_amount"])元起投 总额:\(dict["amount"].string ?? "1,000,000")元"
            newbieButton.isHidden = true
             incomeLabel.attributedText = NSAttributedString.attributedString("\(dict["rate_loaner"])", mainColor: UIColor.hex("b9b9b9"), mainFont: 40, mainFontWeight: .medium, second: "%", secondColor: UIColor.hex("b9b9b9"), secondFont: 20, secondFontWeight: .medium)
            titleLabel.textColor = UIColor.hex("b9b9b9")
            balanceLabel.textColor = UIColor.hex("b9b9b9")
            staticDateLabel.textColor = UIColor.hex("b9b9b9")
            dateLabel.textColor = UIColor.hex("b9b9b9")
            staticIncomeLabel.textColor = UIColor.hex("b9b9b9")
        case "COLLECTING":
            statusLabel.text = "立即加入"
            statusImgView.isHidden = true
            balanceLabel.text = "\(dict["begin_amount"])元起投 剩余:\(dict["balance_amount"].string ?? "1,000,000")元"
        case "RELEASE":
            statusLabel.text = "即将开放"
            statusImgView.isHidden = true
            balanceLabel.text = "\(dict["begin_amount"])元起投 总额:\(dict["amount"].string ?? "1,000,000")元"
        default:
            statusImgView.isHidden = true
            statusLabel.text = "即将开放"
            balanceLabel.text = "\(dict["begin_amount"])元起投 总额:\(dict["amount"].string ?? "1,000,000")元"
            break
        }
    }
}
