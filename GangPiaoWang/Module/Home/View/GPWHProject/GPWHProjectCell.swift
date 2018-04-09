//
//  GPWHProjectCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/3/21.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit

class GPWHProjectCell: UITableViewCell {
    var buyHandle: (()->Void)?
    fileprivate var companyimgLabelWidth: Constraint!
    fileprivate let topView: UIView = {
        let view = UIView()
        view.backgroundColor = bgColor
        return view
    }()
    fileprivate let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.hex("333333")
        titleLabel.font = UIFont.customFont(ofSize: 16.0)
        return titleLabel
    }()

    //公司背景图
    fileprivate let companyImgView:UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "home_project_commany")
        return imgView
    }()

    //公司名称
    fileprivate let  companyLabel: UILabel = {
        let companyLabel = UILabel()
        companyLabel.text = "中国建业承兑"
        companyLabel.textColor = UIColor.white
        companyLabel.textAlignment = .center
        companyLabel.font = UIFont.customFont(ofSize: 14.0)
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
        label.textColor = UIColor.hex("666666")
        label.font = UIFont.customFont(ofSize: 22.0)
        return label
    }()

    fileprivate let staticDayLabel: UILabel = {
        let label = UILabel()
        label.text = "天"
        label.textColor = UIColor.hex("666666")
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
        contentView.addSubview(topView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(companyImgView)
         contentView.addSubview(companyLabel)
        contentView.addSubview(staticIncomeLabel)
        contentView.addSubview(incomeLabel)
        contentView.addSubview(staticDateLabel)
        contentView.addSubview(staticDayLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        topView.snp.makeConstraints { (maker) in
            maker.top.left.right.equalTo(contentView)
            maker.height.equalTo(10)
        }

        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(topView.snp.bottom)
            maker.left.equalTo(contentView).offset(16)
            maker.height.equalTo(46)
        }

        companyImgView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(titleLabel)
            maker.left.equalTo(titleLabel.snp.right).offset(6)
            maker.width.equalTo(98)
            maker.height.equalTo(22)
        }

        companyLabel.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(companyImgView)
        }

        incomeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(companyImgView.snp.bottom).offset(28)
            maker.left.equalTo(contentView).offset(16)
            maker.width.equalTo(167-16)
            maker.height.equalTo(51)
        }

        staticIncomeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(incomeLabel.snp.bottom).offset(4)
            maker.left.equalTo(titleLabel)
            maker.height.equalTo(14)
        }
        staticDateLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(contentView).offset(pixw(p:189))
            maker.centerY.equalTo(staticIncomeLabel)
            maker.height.equalTo(staticIncomeLabel)
        }

        dateLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(topView.snp.bottom).offset(81)
            maker.left.equalTo(staticDateLabel)
            maker.height.equalTo(17)
        }
        staticDayLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(dateLabel)
            maker.left.equalTo(dateLabel.snp.right)
            maker.width.equalTo(15)
        }

        button.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(contentView).offset(-33)
            maker.right.equalTo(contentView).offset(-7)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(dict: JSON) {
        titleLabel.text = dict["title"].string ?? "钢票宝20161226"
        companyLabel.text = dict["acceptance_enterprise"].string ?? "0"
        let companyWidth = self.getWith(str: companyLabel.text!, font: companyLabel.font)
        companyImgView.snp.remakeConstraints({ (make) in
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right).offset(6)
            make.width.equalTo(companyWidth + 20)
            make.height.equalTo(22)
        })

        dateLabel.text = "\(dict["deadline"].int ?? 0)"
        incomeLabel.text = "<font size=40 color='#f6390c'>\(dict["rate_loaner"])</font><font size=18 color='#f6390c'>%</font>"
        if dict["type"].string == "TIYAN" {

        }else if dict["is_index"].intValue == 1 {
            if GPWUser.sharedInstance().staue == 0 && dict["rate_loaner"].doubleValue > 0 {
                incomeLabel.text = "<font size=40 color='#f6390c'>\(dict["rate_loaner"])</font><font size=18 color='#f6390c'>%</font><font size=24 color='#f6390c'>+</font><font size=24 color='#f6390c'>\(dict["rate_new"])</font><font size=16 color='#f6390c'>%</font>"
            }
        }

        let state = dict["status"].string ?? "COLLECTING"
        switch state {
        case "FULLSCALE":
            button.setBackgroundImage(UIImage(named: "project_list_qiangguang"), for: .normal)
        case "REPAYING":
            button.setBackgroundImage(UIImage(named: "project_list_huikuanzhong"), for: .normal)
        case "FINISH":
            button.setBackgroundImage(UIImage(named: "project_list_yihuikuan"), for: .normal)
        case "COLLECTING":
            button.setBackgroundImage(UIImage(named: "project_list_pay"), for: .normal)
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
