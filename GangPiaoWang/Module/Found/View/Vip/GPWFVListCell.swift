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

class GPWFVListCell: UITableViewCell {
    var buyHandle: (()->Void)?
    fileprivate var companyLabelWidth: Constraint!
    fileprivate let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = bgColor
        return view
    }()
    fileprivate let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.hex("666666")
        titleLabel.font = UIFont.customFont(ofSize: 16.0)
        return titleLabel
    }()
    fileprivate let  companyLabel: UILabel = {
        let companyLabel = UILabel()
        companyLabel.text = "中国建业承兑"
        companyLabel.textColor = redTitleColor
        companyLabel.textAlignment = .center
        companyLabel.layer.masksToBounds = true
        companyLabel.layer.cornerRadius = 11
        companyLabel.font = UIFont.customFont(ofSize: 14.0)
        companyLabel.backgroundColor = UIColor.hex("ffecdf")
        return companyLabel
    }()
    fileprivate let staticIncomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hex("999999")
        label.text = "年化利率"
        label.font = UIFont.customFont(ofSize: 12.0)
        return label
    }()
    fileprivate let incomeLabel: RTLabel = {
        let label = RTLabel()
        return label
    }()

    fileprivate let staticDateLabel: UILabel = {
        let label = UILabel()
        label.text = "借款期限"
        label.textColor = UIColor.hex("999999")
        label.font = UIFont.customFont(ofSize: 12.0)
        return label
    }()
    fileprivate let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = titleColor
        label.font = UIFont.customFont(ofSize: 22.0)
        return label
    }()
    fileprivate let staticDayLabel: UILabel = {
        let label = UILabel()
        label.text = "天"
        label.textColor = titleColor
        label.font = UIFont.customFont(ofSize: 12.0)
        return label
    }()
    fileprivate let balanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hex("999999")
        label.font = UIFont.customFont(ofSize: 12.0)
        return label
    }()
    fileprivate let button: UIButton = {
        let button = UIButton(type: .custom)
        button.isUserInteractionEnabled = false
        button.titleLabel?.font = UIFont.customFont(ofSize: 16.0)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage(named: "project_list_pay"), for: .normal)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    @objc private func buttonAction() {
        guard let buyHandle = buyHandle else { return }
        buyHandle()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        commonInitialize()
    }
    
    private func commonInitialize() {
        contentView.addSubview(bottomView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(companyLabel)
        contentView.addSubview(staticIncomeLabel)
        contentView.addSubview(incomeLabel)
        contentView.addSubview(staticDateLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(staticDayLabel)
        contentView.addSubview(balanceLabel)
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        bottomView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(contentView)
            maker.left.equalTo(16)
            maker.right.equalTo(-16)
            maker.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(contentView)
            maker.left.equalTo(contentView).offset(16)
            maker.height.equalTo(46)
        }
        companyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(titleLabel.snp.right).offset(6)
            make.height.equalTo(22)
        }
        
        staticIncomeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(25)
            maker.left.equalTo(contentView).offset(16)
            maker.height.equalTo(12)
        }
        
        staticDateLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(contentView).offset(167)
            maker.centerY.equalTo(staticIncomeLabel)
            maker.height.equalTo(staticIncomeLabel)
        }
        
        balanceLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(staticDateLabel)
            maker.height.equalTo(staticDateLabel)
            maker.right.equalTo(contentView).offset(-16)
        }
        
        incomeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(staticIncomeLabel.snp.bottom).offset(14)
            maker.left.equalTo(contentView).offset(16)
            maker.width.equalTo(167-16)
            maker.height.equalTo(43)
        }
        
        dateLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(staticDateLabel.snp.bottom).offset(27)
            maker.left.equalTo(staticDateLabel)
            maker.height.equalTo(22)
        }
        
        staticDayLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(dateLabel)
            maker.left.equalTo(dateLabel.snp.right)
            maker.width.equalTo(15)
            maker.bottom.equalTo(contentView.snp.bottom).offset(-26)
            
        }
        button.snp.makeConstraints { (maker) in
            maker.top.equalTo(balanceLabel.snp.bottom).offset(18)
            maker.right.equalTo(contentView).offset(-7)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(dict: JSON) {
        titleLabel.text = dict["title"].string ?? "钢票宝20161226"
        let  dic = dict["acceptance_enterprise"].string ?? "0"
        if dic == "0" {
            companyLabel.isHidden = true
        }else{
            companyLabel.isHidden = false
            companyLabel.text = dict["acceptance_enterprise"].string ?? "0"
            let companyWidth = self.getWith(str: companyLabel.text!, font: companyLabel.font)
            companyLabel.snp.remakeConstraints({ (make) in
                make.top.equalTo(12)
                make.left.equalTo(titleLabel.snp.right).offset(6)
                make.width.equalTo(companyWidth + 20)
                make.height.equalTo(22)
            })
        }
        balanceLabel.text = "剩余:\(dict["balance_amount"].string ?? "1,000,000")元"
        dateLabel.text = "\(dict["deadline"].int ?? 0)"
        incomeLabel.text = "<font size=36 color='#f6390c'>\(dict["rate_loaner"])</font><font size=18 color='#f6390c'>%</font>"
        balanceLabel.isHidden = false
        if dict["type"].string == "TIYAN" {
            balanceLabel.isHidden = true
        }else if dict["is_index"].intValue == 1 {
            if GPWUser.sharedInstance().staue == 0 && dict["rate_loaner"].doubleValue > 0 {
                incomeLabel.text = "<font size=36 color='#f6390c'>\(dict["rate_loaner"])</font><font size=18 color='#f6390c'>%</font><font size=24 color='#f6390c'>+</font><font size=24 color='#f6390c'>\(dict["rate_new"])</font><font size=16 color='#f6390c'>%</font>"
            }
        }
        
        let state = dict["status"].string ?? "COLLECTING"
        switch state {
        case "FULLSCALE":
            button.setBackgroundImage(UIImage(named: "project_list_qiangguang"), for: .normal)
            balanceLabel.text = "已满标"
        case "REPAYING":
            button.setBackgroundImage(UIImage(named: "project_list_huikuanzhong"), for: .normal)
            balanceLabel.text = "已满标"
        case "FINISH":
            button.setBackgroundImage(UIImage(named: "project_list_yihuikuan"), for: .normal)
            balanceLabel.text = "已满标"
        case "COLLECTING":
            button.setBackgroundImage(UIImage(named: "project_list_pay"), for: .normal)
            if dict["amount_collect"].intValue > 0 {
                button.setBackgroundImage(UIImage(named: "f_vip_list_firstpay"), for: .normal)
            }
        case "RELEASE":
            button.setBackgroundImage(UIImage(named: "project_list_rightnow"), for: .normal)
        default:
            button.setBackgroundImage(UIImage(named: "project_list_qiangguang"), for: .normal)
            break
        }
    }
    func getWith(str:String,font:UIFont) -> CGFloat{
        let options:NSStringDrawingOptions = .usesLineFragmentOrigin
        let boundingRect = str.boundingRect(with:  CGSize(width: 300, height: 22), options: options, attributes:[NSFontAttributeName:font], context: nil)
        return boundingRect.width
    }
}
