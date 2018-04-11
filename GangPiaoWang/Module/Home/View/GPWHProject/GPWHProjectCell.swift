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
    //横线
    fileprivate var topLine:UIView!

    //标题
    fileprivate var templitleLabel:UILabel!

    //利率
    fileprivate var lvLabel: RTLabel!

    //期限
    fileprivate var timeLabel:RTLabel!

    //历史年华利率
    fileprivate var histonryLvLabel:UILabel!

    //起投和剩余  100元起投 剩余651,000元
    fileprivate var bsLabel:UILabel!

    //项目按钮
    fileprivate var btn:UIButton!
    var buyHandle: (()->Void)?
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

        topLine = UIView(frame: CGRect(x: 16, y: 0, width: SCREEN_WIDTH - 16, height: 1))
        topLine.backgroundColor = UIColor.hex("f2f2f2")
        contentView.addSubview(topLine)

        templitleLabel = UILabel(frame: CGRect(x: 16, y: 28, width: SCREEN_WIDTH * 2 / 3 , height: 16))
        templitleLabel.font = UIFont.customFont(ofSize: 16)
        templitleLabel.textColor = UIColor.hex("4f4f4f")
        templitleLabel.text = "项目名称"
        contentView.addSubview(templitleLabel)

        timeLabel = RTLabel(frame: CGRect(x: SCREEN_WIDTH / 2, y: templitleLabel.maxY + 28, width: 200, height: 36))
        timeLabel.text = "<font face='Arial' size=18 color='#4f4f4f'>期限</font><font face='Arial' size=18 color='#fa713d'>30天</font>"
        timeLabel.size = timeLabel.optimumSize
        contentView.addSubview(timeLabel)

        bsLabel = UILabel(frame: CGRect(x: timeLabel.x, y: timeLabel.maxY + 2, width: 150, height: 12))
        bsLabel.font = UIFont.customFont(ofSize: 12)
        bsLabel.textColor = UIColor.hex("4f4f4f")
        bsLabel.text = "100元起投 剩余651,000元"
        contentView.addSubview(bsLabel)

        lvLabel = RTLabel(frame: CGRect(x: topLine.x, y: topLine.maxY + 22, width: 200, height: 36))
        lvLabel.text = "<font face='Arial' size=36 color='#fa713d'>6.0</font><font face='Arial' size=26 color='#fa713d'>+4.0</font><font face='Arial' size=22 color='#fa713d'>%</font>"
        lvLabel.size = lvLabel.optimumSize
        lvLabel.maxY = timeLabel.maxY
        contentView.addSubview(lvLabel)

        histonryLvLabel = UILabel(frame: CGRect(x: lvLabel.x, y: lvLabel.maxY + 5, width: 150, height: 12))
        histonryLvLabel.font = UIFont.customFont(ofSize: 12)
        histonryLvLabel.textColor = UIColor.hex("b7b7b7")
        histonryLvLabel.text = "历史年化利率"
        contentView.addSubview(histonryLvLabel)
        histonryLvLabel.maxY = bsLabel.maxY

        btn = UIButton(frame: CGRect(x: SCREEN_WIDTH - 100 - 16, y: histonryLvLabel.maxY + 32, width: 100, height: 46))
        btn.titleLabel?.font = UIFont.customFont(ofSize: 18)
        btn.titleLabel?.textColor = UIColor.white
        btn.setTitle("", for: .normal)
        contentView.addSubview(btn)

        let rightImgView = UIImageView(frame: CGRect(x: btn.width - 6, y: 0, width: 6, height: 11))
        rightImgView.image = UIImage(named: "home_project_pay")
        btn.addSubview(rightImgView)
        rightImgView.centerY = btn.height / 2

        let tempLabel = UILabel(frame: CGRect(x: 0, y: 0, width: rightImgView.x , height: btn.height))
        tempLabel.text = "立即加入"
        tempLabel.font = UIFont.customFont(ofSize: 12)
        tempLabel.textColor = UIColor.hex("b7b7b7")
        btn.addSubview(tempLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(dict: JSON) {
        lvLabel.text = "<font face='Arial' size=36 color='#fa713d'>\(dict["rate_loaner"])</font><font face='Arial' size=20 color='#fa713d'>%</font>"
        lvLabel.text = "<font size=50 color='#f6390c'>\(dict["rate_loaner"])</font><font size=22 color='#f6390c'>%</font>"
        if GPWUser.sharedInstance().staue == 0 && dict["rate_loaner"].doubleValue > 0  {
            lvLabel.text = "<font face='Arial' size=36 color='#fa713d'>\(dict["rate_loaner"])</font><font face='Arial' size=26 color='#fa713d'>+\(dict["rate_new"])</font><font face='Arial' size=22 color='#fa713d'>%</font>"
        }
        templitleLabel.text = "\(dict["title"])"
        bsLabel.text = "\(dict["deadline"])元起投 剩余\(dict["left_amount"])元"

        let state1 = dict["status"].stringValue
        switch state1 {
        case "FULLSCALE":
            btn.setTitle("已满标", for: .normal)
            break
        case "REPAYING":
            btn.setTitle("回款中", for: .normal)
            break
        case "FINISH":
            btn.setTitle("已满标", for: .normal)
            break
        case "COLLECTING":
            btn.setTitle("立即抢购", for: .normal)
            break
        case "RELEASE":
            btn.setTitle("即将开始", for: .normal)
            break
        default:
            btn.setTitle("即将开始", for: .normal)
            break
        }
        if GPWUser.sharedInstance().isLogin == false {
            btn.setTitle("立即抢购", for: .normal)
        }
    }
}
