//
//  GPWUserBCTopCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/11/22.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
class GPWUserBCTopCell: UITableViewCell {
    fileprivate  let array = [
                        ["img":"user_bc_huikuan","title":"当月已回款(元)","money":"20,186.72"],
                        ["img":"user_bc_daishou","title":"当月待回款(元)","money":"80,186.25"]
    ]
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 149 + 20)

        //设置渐变的主颜色
        gradientLayer.colors = [UIColor.hex("fa481a").cgColor, UIColor.hex("f76b1c").cgColor]
        //将gradientLayer作为子layer添加到主layer上
        self.layer.addSublayer(gradientLayer)
        self.layer.insertSublayer(gradientLayer, at: 0)

        for i in 0 ..< array.count {
            let tempImgView = UIImageView(frame: CGRect(x: pixw(p: 32) + CGFloat(i) * SCREEN_WIDTH / 2, y: 79 + 20, width: 20, height: 20))
            tempImgView.image = UIImage(named:array[i]["img"]!)
            self.contentView.addSubview(tempImgView)

            let  tempTLabel = UILabel(frame: CGRect(x: tempImgView.maxX + 7, y: 0, width: 100, height: 15))
            tempTLabel.textColor = UIColor.hex("ffa189")
            tempTLabel.centerY = tempImgView.centerY
            tempTLabel.font = UIFont.customFont(ofSize: 14)
            tempTLabel.text = array[i]["title"]
            contentView.addSubview(tempTLabel)

            let  tempMoneyLabel = UILabel(frame: CGRect(x: tempTLabel.x, y:tempTLabel.maxY + 10, width: 100, height: 19))
            tempMoneyLabel.textColor = UIColor.white
            tempMoneyLabel.font = UIFont.customFont(ofSize: 18)
            tempMoneyLabel.text = array[i]["money"]
            contentView.addSubview(tempMoneyLabel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
