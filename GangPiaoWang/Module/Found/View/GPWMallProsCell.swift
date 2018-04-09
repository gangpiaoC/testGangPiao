//
//  GPWMallProsCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/12/27.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
class GPWMallProsCell: UITableViewCell {
    fileprivate var scrollview:UIScrollView!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none

        scrollview = UIScrollView(frame: CGRect(x: 16, y: 0, width: SCREEN_WIDTH - 32, height: 201))
        scrollview.showsHorizontalScrollIndicator = false
        self.contentView.addSubview(scrollview)
        for i in 0 ..< 10 {
            let  btn = UIButton(type: .custom)
            btn.frame = CGRect(x: (16 + 126) * CGFloat(i), y: 16, width: 126, height: 170)
            btn.layer.masksToBounds = true
            btn.tag = 1000 + i
            btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
            btn.layer.borderColor = UIColor.hex("e9e9e9").cgColor
            btn.layer.borderWidth = 1
            scrollview.addSubview(btn)

            let  imgView = UIImageView(frame: CGRect(x: 13, y: 10, width: btn.width - 26, height: 87))
            imgView.backgroundColor = UIColor.blue
            btn.addSubview(imgView)

            let proNameLabel = UILabel(frame: CGRect(x: 0, y: imgView.maxY + 20, width: btn.width, height: 14))
            proNameLabel.textAlignment = .center
            proNameLabel.text = "200元京东E卡"
            proNameLabel.font = UIFont.customFont(ofSize: 14)
            proNameLabel.textColor = UIColor.hex("555555")
            btn.addSubview(proNameLabel)

            let  moneyView = UIImageView(frame: CGRect(x: 0, y: proNameLabel.maxY + 10, width: 16, height: 13))
            moneyView.image = UIImage(named:"found_center_mall")
            btn.addSubview(moneyView)

            let  moneyLabel = RTLabel(frame: CGRect(x: 0, y: 0, width: btn.width, height: 20))
            moneyLabel.text = "<font size=14 color='#fc9e02'>12000</font>"
            moneyLabel.size = moneyLabel.optimumSize
            moneyLabel.centerY = moneyView.centerY
            moneyView.x = ( btn.width - moneyView.width - 3 - moneyLabel.width ) / 2
            moneyLabel.x = moneyView.maxX + 3
            btn.addSubview(moneyLabel)
        }
        scrollview.contentSize = CGSize(width: 142 * 10, height: 201)
    }

    @objc func btnClick( _ sender:UIButton) {
        printLog(message: sender.tag)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
