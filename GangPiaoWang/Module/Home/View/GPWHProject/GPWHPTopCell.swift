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

    //顶部名称（新手专享）
    fileprivate var topLabel:UILabel!

    //横线
    fileprivate var topLine:UIView!

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


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        commonInitialize()
    }

    private func commonInitialize() {

        topLabel = UILabel(frame: CGRect(x: 16, y: 22, width: SCREEN_WIDTH - 32, height: 18))
        topLabel.font = UIFont.boldSystemFont(ofSize: 18)
        topLabel.textColor = UIColor.hex("222222")
        topLabel.text = "新手专享"
        contentView.addSubview(topLabel)

        topLine = UIView(frame: CGRect(x: 16, y: topLabel.maxY + 16, width: SCREEN_WIDTH - 16, height: 1))
        topLine.backgroundColor = UIColor.hex("f2f2f2")
        contentView.addSubview(topLine)

        timeLabel = RTLabel(frame: CGRect(x: SCREEN_WIDTH / 2, y: topLine.maxY + 39, width: 200, height: 36))
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

        btn = UIButton(frame: CGRect(x: 16, y: histonryLvLabel.maxY + 32, width: SCREEN_WIDTH - 32, height: 46))
        btn.setBackgroundImage(UIImage(named: "home_pf"), for: .normal)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 18)
        btn.titleLabel?.textColor = UIColor.white
        btn.setTitle("已满标", for: .normal)
        contentView.addSubview(btn)

        let block = UIView(frame: CGRect(x: 0, y: 232, width: SCREEN_WIDTH, height: 10))
        block.backgroundColor = bgColor
        self.contentView.addSubview(block)


    }
    func setupCell(dict: JSON,index:NSInteger) {
         lvLabel.text = "<font face='Arial' size=36 color='#fa713d'>\(dict["rate_loaner"])</font><font face='Arial' size=20 color='#fa713d'>%</font>"
        lvLabel.text = "<font size=50 color='#f6390c'>\(dict["rate_loaner"])</font><font size=22 color='#f6390c'>%</font>"
        if GPWUser.sharedInstance().staue == 0 && dict["rate_loaner"].doubleValue > 0  {
             lvLabel.text = "<font face='Arial' size=36 color='#fa713d'>\(dict["rate_loaner"])</font><font face='Arial' size=26 color='#fa713d'>+\(dict["rate_new"])</font><font face='Arial' size=22 color='#fa713d'>%</font>"
        }
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
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
