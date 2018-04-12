//
//  GPWHomeBottomCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/11/25.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWHomeBottomCell: UITableViewCell {


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        initView()
    }


    /// 初始化界面
    func initView() {

        let topTitleLabel = UILabel(frame: CGRect(x: 16, y: 22, width: 300, height: 18))
        topTitleLabel.text = "靠谱的互联网金融平台"
        topTitleLabel.textColor = UIColor.hex("222222")
        topTitleLabel.font = UIFont.customFont(ofSize: 18)
        contentView.addSubview(topTitleLabel)

        let topLine = UIView(frame: CGRect(x: topTitleLabel.x, y: topTitleLabel.maxY + 16, width: SCREEN_WIDTH - 16, height: 1))
        topLine.backgroundColor = bgColor
        contentView.addSubview(topLine)

        let logoArray = [
            ["img":"home_hengfeng","name":"恒丰银行资金存管"],
            ["img":"home_xinsiban","name":"新四板上市公司"]
        ]

        var maxY:CGFloat = 0.0

        for i in 0 ..< logoArray.count {
            let tempView = UIView(frame: CGRect(x: i == 0 ? 16 : (SCREEN_WIDTH / 2 + 12), y: topLine.maxY + 20, width: 160, height: 87))
            tempView.backgroundColor = bgColor
            tempView.layer.cornerRadius = 4
            contentView.addSubview(tempView)

            let tempImgView = UIImageView(frame: CGRect(x: 0, y: 6, width: 54, height: 45))
            tempImgView.centerX = tempView.width / 2
            tempImgView.image = UIImage(named: logoArray[i]["img"]!)
            tempView.addSubview(tempImgView)

            let tempTtitleLabel = UILabel(frame: CGRect(x: 0, y: tempImgView.maxY + 8, width: tempView.width, height: 14))
            tempTtitleLabel.text = logoArray[i]["name"]!
            tempTtitleLabel.textColor = titleColor
            tempTtitleLabel.font = UIFont.customFont(ofSize: 14)
            tempTtitleLabel.textAlignment = .center
            tempView.addSubview(tempTtitleLabel)
            maxY = tempView.maxY
        }

        let contentArray = [
            "资产来自央企、国企、上市公司",
            "公安部三级等保备案证明",
            "中国互联网金融企业家俱乐部副理事长单位"
        ]

        maxY = maxY + 8

        for i in 0 ..< contentArray.count {

            let tempTtitleLabel = UILabel(frame: CGRect(x: 29, y: maxY + 8, width: 280, height: 14))
            tempTtitleLabel.text = contentArray[i]
            tempTtitleLabel.textColor = titleColor
            tempTtitleLabel.font = UIFont.customFont(ofSize: 14)
            contentView.addSubview(tempTtitleLabel)

            let yuanView = UIView(frame: CGRect(x: 16, y: maxY, width: 5, height: 5))
            yuanView.centerY = tempTtitleLabel.centerY
            yuanView.layer.cornerRadius = 2.5
            yuanView.backgroundColor = titleColor
            contentView.addSubview(yuanView)

            maxY = maxY + 8 + 16

        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
