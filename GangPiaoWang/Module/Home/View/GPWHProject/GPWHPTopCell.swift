//
//  GPWHPTopCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/11/13.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
class GPWHPTopCell: UITableViewCell {

    fileprivate let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.hex("222222")
        titleLabel.font = UIFont.customFont(ofSize: 18.0)
        titleLabel.text = "新手专享"
        return titleLabel
    }()

    fileprivate let btn: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setBackgroundImage(UIImage(named: "home_p_pay"), for: UIControlState.normal)
        btn.setTitle("新手加息，立即加入", for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 18)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.isUserInteractionEnabled = false
        return btn
    }()

    let staticIncomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hex("b7b7b7")
        label.text = "历史年化利率"
        label.font = UIFont.customFont(ofSize: 12.0)
        return label
    }()

    let incomeLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString.attributedString("9.0", mainColor: redColor, mainFont: 40, mainFontWeight: .medium, second: "%", secondColor: redColor, secondFont: 20, secondFontWeight: .medium)
        return label
    }()

    let staticDateLabel: UILabel = {
        let label = UILabel()
        label.text = "期限"
        label.textColor = titleColor
        label.font = UIFont.customFont(ofSize: 18.0)
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = redColor
        label.font = UIFont.customFont(ofSize: 18.0)
        label.text = "30天"
        return label
    }()

    fileprivate let balanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = titleColor
        label.font = UIFont.customFont(ofSize: 12.0)
        label.text = "100元起投 剩余651,000元"
        return label
    }()

    fileprivate let bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = bgColor
        return bottomView
    }()

    let lineView = UIView(bgColor: UIColor.hex("f2f2f2"))

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        commonInitialize()
    }

    private func commonInitialize() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(lineView)
        contentView.addSubview(staticIncomeLabel)
        contentView.addSubview(incomeLabel)
        contentView.addSubview(staticDateLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(balanceLabel)
        contentView.addSubview(btn)
        contentView.addSubview(bottomView)


        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(22)
            maker.left.equalTo(16)
        }
        lineView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(16)
            maker.left.equalTo(titleLabel)
            maker.height.equalTo(1.0)
            maker.right.equalTo(contentView)
        }

        incomeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(lineView.snp.bottom).offset(22)
            maker.left.equalTo(lineView)
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
        btn.snp.makeConstraints { (maker) in
            maker.top.equalTo(balanceLabel.snp.bottom).offset(32)
            maker.left.equalTo(16)
            maker.right.equalTo(contentView).offset(-16)
            maker.height.equalTo(46)
        }
        bottomView.snp.makeConstraints { (maker) in
            maker.top.equalTo(btn.snp.bottom).offset(22)
            maker.height.equalTo(10)
            maker.bottom.width.equalTo(contentView)

        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(dict: JSON) {

        if dict["is_index"].intValue == 1 && GPWUser.sharedInstance().staue == 0 {   //新手标
            let attrText = NSMutableAttributedString()
            attrText.append(NSAttributedString.attributedString("\(dict["rate_loaner"])", mainColor: redColor, mainFont: 40, mainFontWeight: .medium, second: "+\(dict["rate_new"])", secondColor: redColor, secondFont: 26, secondFontWeight: .medium))
            attrText.append(NSAttributedString(string: "%", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedStringKey.foregroundColor: redColor]))
            incomeLabel.attributedText = attrText
        } else {
            incomeLabel.attributedText = NSAttributedString.attributedString("\(dict["rate_loaner"])", mainColor: redColor, mainFont: 40, mainFontWeight: .medium, second: "%", secondColor: redColor, secondFont: 20, secondFontWeight: .medium)
        }
        dateLabel.text = "\(dict["deadline"].int ?? 0)天"

        balanceLabel.text = "\(dict["begin_amount"])元起投 剩余:\(dict["balance_amount"].string ?? dict["left_amount"].string ?? "10000"))元"
        balanceLabel.textColor = titleColor
        staticDateLabel.textColor = titleColor
        dateLabel.textColor = redColor
        staticIncomeLabel.textColor = UIColor.hex("b7b7b7")
        let state = dict["status"].string ?? "COLLECTING"
        switch state {
        case "FINISH", "REPAYING", "FULLSCALE":
            btn.setBackgroundImage(UIImage(named: "home_p_no"), for: UIControlState.normal)
            balanceLabel.text = "\(dict["begin_amount"])元起投 总额:\(dict["amount"].string ?? "1,000,000")元"
            incomeLabel.attributedText = NSAttributedString.attributedString("\(dict["rate_loaner"])", mainColor: UIColor.hex("b9b9b9"), mainFont: 40, mainFontWeight: .medium, second: "%", secondColor: UIColor.hex("b9b9b9"), secondFont: 20, secondFontWeight: .medium)
            balanceLabel.textColor = UIColor.hex("b9b9b9")
            staticDateLabel.textColor = UIColor.hex("b9b9b9")
            dateLabel.textColor = UIColor.hex("b9b9b9")
            staticIncomeLabel.textColor = UIColor.hex("b9b9b9")
        case "COLLECTING":
            btn.setBackgroundImage(UIImage(named: "home_p_pay"), for: UIControlState.normal)
            btn.setTitle("新手加息，立即加入", for: UIControlState.normal)
            balanceLabel.text = "\(dict["begin_amount"])元起投 剩余:\(dict["balance_amount"].string ?? dict["left_amount"].string ?? "10000")元"
        case "RELEASE":
            btn.setBackgroundImage(UIImage(named: "home_p_right"), for: UIControlState.normal)
            btn.setTitle("即将开放", for: UIControlState.normal)
            balanceLabel.text = "\(dict["begin_amount"])元起投 总额:\(dict["amount"].string ?? "1,000,000")元"
        default:
            btn.setBackgroundImage(UIImage(named: "home_p_right"), for: UIControlState.normal)
            btn.setTitle("即将开放", for: UIControlState.normal)
            balanceLabel.text = "\(dict["begin_amount"])元起投 总额:\(dict["amount"].string ?? "1,000,000")元"
            break
        }
    }
}
