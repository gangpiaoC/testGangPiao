//
//  MallTopCell.swift
//  GangPiaoWang
//  积分商城头部cell
//  Created by gangpiaowang on 2017/12/28.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
class MallTopCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let  imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: pixw(p: 130)))
        imgView.image = UIImage(named:"mall_center_banner")
        self.contentView.addSubview(imgView)

        let  contentArray = [
                                        ["img":"found_center_mall","detail":"534200"],
                                        ["img":"mall_center_jilu","detail":"兑换记录"]
                                        ]
        for i in 0 ..< contentArray.count {
            let topImgView = UIImageView(frame: CGRect(x: ( SCREEN_WIDTH / 2 - 22 - 6 - 64 ) / 2 + SCREEN_WIDTH / 2 * CGFloat(i), y:  imgView.maxY + 26, width: 22, height: 19))
            topImgView.tag = 1000 + i
            topImgView.image = UIImage(named:contentArray[i]["img"]!)
            self.contentView.addSubview(topImgView)

            let  contLabel = RTLabel(frame: CGRect(x: topImgView.maxX + 6, y: 0, width: 100, height: 40))
            contLabel.text = "<font size=16 color='#333333'>\(String(describing: contentArray[i]["detail"]!))</font>"
            contLabel.size = contLabel.optimumSize
            contLabel.centerY = topImgView.centerY
            contLabel.tag = 10000 + i
            self.contentView.addSubview(contLabel)

            if i == 0 {
                let  shu = UIView(frame: CGRect(x: SCREEN_WIDTH / 2, y: imgView.maxY + 26, width: 1 , height: 18))
                shu.backgroundColor = UIColor.hex("d1d1d1")
                self.contentView.addSubview(shu)
            }
        }
    }

    func showInfo(money:String)  {
        let  tempImgView = self.contentView.viewWithTag(1000) as! UIImageView
        let tempLabel = self.contentView.viewWithTag(10000) as! RTLabel
        tempLabel.width = 200
        tempLabel.text = "<font size=18 color='#fc9e02'>\(money)</font><font size=16 color='#333333'>钢镚</font>"
        tempLabel.size = tempLabel.optimumSize
        tempLabel.centerY = tempImgView.centerY
        tempImgView.x = ( SCREEN_WIDTH / 2 - tempImgView.width - 6 - tempLabel.width ) / 2
        tempLabel.x = tempImgView.maxX + 6
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
