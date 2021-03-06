//
//  GPWHomeNewsCell.swift
//  GangPiaoWang
//  出借实况
//  Created by gangpiaowang on 2017/3/21.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWHNowCJCell: UITableViewCell {
    weak var surperController:UIViewController?
    fileprivate var bankurl:String?
    fileprivate var scrollview:InvestScrollView!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        topView.backgroundColor = bgColor
        contentView.addSubview(topView)

        let rightImgView = UIImageView(frame: CGRect(x: 16, y: topView.maxY + 32, width: 42, height: 40))
        rightImgView.image = UIImage(named:"home_bottom_right")
        contentView.addSubview(rightImgView)

        let shuLine = UIView(frame: CGRect(x: rightImgView.maxX + 14, y: topView.maxY + 24, width: 0.5, height: 54))
        shuLine.backgroundColor = UIColor.hex("d8d8d8")
        contentView.addSubview(shuLine)

        scrollview = InvestScrollView(frame: CGRect(x: shuLine.maxX + 8, y: topView.maxY + 18, width: SCREEN_WIDTH - shuLine.maxX - 6 - 16, height: 66))
        let  gradientLayer = CAGradientLayer()
        gradientLayer.frame = scrollview.bounds
        //设置渐变的主颜色
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.hex("ffffff", alpha: 0.05).cgColor,UIColor.white.cgColor]
        //将gradientLayer作为子layer添加到主layer上
        scrollview.layer.addSublayer(gradientLayer)
        
        let  titileArray = [
            [ "<font size=14 color='#333333'>138****41212</font>", "<font size=14 color='#333333'>钢融宝-第132期</font>","<font size=14 color='#f6390c'>2000元</font>"],
            [ "<font size=14 color='#333333'>138****41212</font>", "<font size=14 color='#333333'>钢融宝-第132期</font>","<font size=14 color='#f6390c'>2000元</font>"],
            [ "<font size=14 color='#333333'>138****41212</font>", "<font size=14 color='#333333'>钢融宝-第132期</font>","<font size=14 color='#f6390c'>2000元</font>"],
            [ "<font size=14 color='#333333'>138****41212</font>", "<font size=14 color='#333333'>钢融宝-第132期</font>","<font size=14 color='#f6390c'>2000元</font>"],
            [ "<font size=14 color='#333333'>138****41212</font>", "<font size=14 color='#333333'>钢融宝-第132期</font>","<font size=14 color='#f6390c'>2000元</font>"],
            [ "<font size=14 color='#333333'>138****41212</font>", "<font size=14 color='#333333'>钢融宝-第132期</font>","<font size=14 color='#f6390c'>2000元</font>"],
            [ "<font size=14 color='#333333'>138****41212</font>", "<font size=14 color='#333333'>钢融宝-第132期</font>","<font size=14 color='#f6390c'>2000元</font>"],
            [ "<font size=14 color='#333333'>138****41212</font>", "<font size=14 color='#333333'>钢融宝-第132期</font>","<font size=14 color='#f6390c'>2000元</font>"],
            [ "<font size=14 color='#333333'>138****41212</font>", "<font size=14 color='#333333'>钢融宝-第132期</font>","<font size=14 color='#f6390c'>2000元</font>"],
            [ "<font size=14 color='#333333'>138****41212</font>", "<font size=14 color='#333333'>钢融宝-第132期</font>","<font size=14 color='#f6390c'>2000元</font>"],
            [ "<font size=14 color='#333333'>138****41212</font>", "<font size=14 color='#333333'>钢融宝-第132期</font>","<font size=14 color='#f6390c'>2000元</font>"],
            [ "<font size=14 color='#333333'>138****41212</font>", "<font size=14 color='#333333'>钢融宝-第132期</font>","<font size=14 color='#f6390c'>2000元</font>"],
            [ "<font size=14 color='#333333'>138****41212</font>", "<font size=14 color='#333333'>钢融宝-第132期</font>","<font size=14 color='#f6390c'>2000元</font>"],
            [ "<font size=14 color='#333333'>138****41212</font>", "<font size=14 color='#333333'>钢融宝-第132期</font>","<font size=14 color='#f6390c'>2000元</font>"],
            [ "<font size=14 color='#333333'>138****41212</font>", "<font size=14 color='#333333'>钢融宝-第132期</font>","<font size=14 color='#f6390c'>2000元</font>"],
            [ "<font size=14 color='#333333'>138****41212</font>", "<font size=14 color='#333333'>钢融宝-第132期</font>","<font size=14 color='#f6390c'>2000元</font>"]
        ]
        scrollview.push(titileArray, withW: scrollview.width)
        contentView.addSubview(scrollview)

        let bottomView = UIView(frame: CGRect(x: 0, y: 120, width: SCREEN_WIDTH, height: 10))
        bottomView.backgroundColor = bgColor
        contentView.addSubview(bottomView)
    }
    
    func updata(_ inveArray:[JSON])  {
        var titleArray = [[String]]()
        for tempJson in inveArray {
            titleArray.append([ "<font size=13 color='#333333'>\(tempJson["telephone"])</font>", "<font size=12 color='#333333'>\(tempJson["title"])</font>","<font size=12 color='#f6390c'>\(tempJson["amount"])元</font>"])
        }
        scrollview.push(titleArray, withW: scrollview.width)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
