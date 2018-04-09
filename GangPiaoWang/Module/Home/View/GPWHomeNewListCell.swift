//
//  GPWHomeNewListCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/3/21.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWHomeNewListCell: UITableViewCell {
    private var iconImgView:UIImageView!
    private var titleLabel:RTLabel!
    private var fromAndTimeLabel:RTLabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        iconImgView = UIImageView(frame: CGRect(x: 16, y: 20, width: 120, height: 80))
        iconImgView.backgroundColor = UIColor.hex("f6f6f6")
        self.contentView.addSubview(iconImgView)
        titleLabel = RTLabel(frame: CGRect(x:iconImgView.maxX + 13, y: 17, width:  SCREEN_WIDTH - 16 - iconImgView.maxX - 13, height: 30))
        titleLabel.text = "<font size=16 color='#333333'>专注于钢铁产业金融，\"钢票网\"将挺进互联网理财市场</font>"
        titleLabel.height = titleLabel.optimumSize.height
        self.contentView.addSubview(titleLabel)
        
        fromAndTimeLabel = RTLabel(frame: CGRect(x:titleLabel.x, y: iconImgView.maxY - 13, width:  300, height: 30))
        fromAndTimeLabel.text = "<font size=12 color='#999999'>新浪网    2017-03-13</font>"
        fromAndTimeLabel.height = fromAndTimeLabel.optimumSize.height
        self.contentView.addSubview(fromAndTimeLabel)
        
        let line = UIView(frame: CGRect(x: 0, y: 120 - 0.5, width: SCREEN_WIDTH, height: 0.5))
        line.backgroundColor = lineColor
        self.contentView.addSubview(line)
    }
    func updata(dic:JSON)  {
        printLog(message: dic)
        iconImgView.downLoadImg(imgUrl: dic["media_logo"].string ?? "")
        titleLabel.text = dic["title"].string ?? ""
        fromAndTimeLabel.text = "<font size=12 color='#999999'>\(dic["media_source"].string ?? "")    \(GPWHelper.strFromDate(dic["add_time"].doubleValue, format: "yyyy-MM-dd"))</font>"
        fromAndTimeLabel.height = fromAndTimeLabel.optimumSize.height
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
