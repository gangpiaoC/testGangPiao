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
    let clickNumButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "found_eye"), for: .normal)
        button.setTitle("2201", for: .normal)
        button.setTitleColor(UIColor.hex("b7b7b7"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.isEnabled = false
        button.contentHorizontalAlignment = .right
        return button
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        titleLabel = RTLabel(frame: CGRect(x:16, y: 17, width:  SCREEN_WIDTH - 16 * 2 - 120 - 12, height: 30))
        titleLabel.text = "<font size=16 color='#4f4f4f'>专注于钢铁产业金融，\"钢票网\"将挺进互联网理财市场</font>"
        titleLabel.height = titleLabel.optimumSize.height
        self.contentView.addSubview(titleLabel)
        
        iconImgView = UIImageView(frame: CGRect(x: titleLabel.maxX + 12, y: 20, width: 120, height: 80))
        iconImgView.backgroundColor = UIColor.hex("f6f6f6")
        self.contentView.addSubview(iconImgView)
        
        fromAndTimeLabel = RTLabel(frame: CGRect(x:titleLabel.x, y: iconImgView.maxY - 13, width:  100, height: 30))
        fromAndTimeLabel.text = "<font size=12 color='#b7b7b7'>新浪网    2017-03-13</font>"
        fromAndTimeLabel.height = fromAndTimeLabel.optimumSize.height
        self.contentView.addSubview(fromAndTimeLabel)
        
        clickNumButton.setButtonImageTitleStyle(.imagePositionLeft, padding: 5)
        clickNumButton.frame = CGRect(x: SCREEN_WIDTH - 16 - 120 - 12 - 100, y: iconImgView.maxY - 13, width: 100, height: 14)
       contentView.addSubview(clickNumButton)
        
        let line = UIView(frame: CGRect(x: 0, y: 120 - 0.5, width: SCREEN_WIDTH, height: 0.5))
        line.backgroundColor = lineColor
        self.contentView.addSubview(line)
    }
    func updata(dic:JSON)  {
        printLog(message: dic)
        iconImgView.downLoadImg(imgUrl: dic["media_logo"].string ?? "")
        titleLabel.text = dic["title"].string ?? ""
        fromAndTimeLabel.text = "<font size=12 color='#b7b7b7'>\(GPWHelper.strFromDate(dic["add_time"].doubleValue, format: "yyyy-MM-dd"))</font>"
        fromAndTimeLabel.height = fromAndTimeLabel.optimumSize.height
        clickNumButton.setTitle(dic["cai"].stringValue, for: .normal)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
