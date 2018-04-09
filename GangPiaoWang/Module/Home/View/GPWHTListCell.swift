//
//  GPWHTListCell.swift
//  GangPiaoWang
//  体验金投资列表cell
//  Created by gangpiaowang on 2017/9/25.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWHTListCell: UITableViewCell {

    //预计收益
    var getLilvLabel:UILabel!
    //出借日期
    var inTimeLabel:UILabel!
    //出借金额
    var inMoneyLabel:UILabel!
    //还款日期
    var outTimeLabel:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let topBlock = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        topBlock.backgroundColor = bgColor
        self.contentView.addSubview(topBlock)

        let temp1Label = UILabel(frame: CGRect(x: 16, y: 37, width: 60, height: 14))
        temp1Label.text = "体验收益"
        temp1Label.textColor = UIColor.hex("999999")
        temp1Label.font = UIFont.customFont(ofSize: 14)
        self.contentView.addSubview(temp1Label)

        getLilvLabel = UILabel(frame: CGRect(x: temp1Label.maxX + 10, y: 0, width: 200, height: 14))
        getLilvLabel.text = "320.0元"
        getLilvLabel.textColor = redColor
        getLilvLabel.centerY = temp1Label.centerY
        getLilvLabel.font = UIFont.customFont(ofSize: 14)
        self.contentView.addSubview(getLilvLabel)

        let temp2Label = UILabel(frame: CGRect(x: contentView.width / 2 + 16, y: 0, width: 60, height: 14))
        temp2Label.text = "体验时间"
        temp2Label.textColor = UIColor.hex("999999")
        temp2Label.centerY = temp1Label.centerY
        temp2Label.font = UIFont.customFont(ofSize: 14)
        self.contentView.addSubview(temp2Label)

        inTimeLabel = UILabel(frame: CGRect(x: temp2Label.maxX + 10, y: temp2Label.y, width: 200, height: 14))
        inTimeLabel.text = "2016-12-6"
        inTimeLabel.textColor = UIColor.hex("666666")
        inTimeLabel.centerY = temp1Label.centerY
        inTimeLabel.font = UIFont.customFont(ofSize: 14)
        self.contentView.addSubview(inTimeLabel)

        let temp3Label = UILabel(frame: CGRect(x: temp1Label.x, y: temp1Label.maxY + 17, width: 60, height: 14))
        temp3Label.text = "体验金额"
        temp3Label.textColor = UIColor.hex("999999")
        temp3Label.font = UIFont.customFont(ofSize: 14)
        self.contentView.addSubview(temp3Label)

        inMoneyLabel = UILabel(frame: CGRect(x: temp3Label.maxX + 10, y: 0, width: 200, height: 14))
        inMoneyLabel.text = "1000元"
        inMoneyLabel.textColor = UIColor.hex("666666")
        inMoneyLabel.font = UIFont.customFont(ofSize: 14)
        inMoneyLabel.centerY = temp3Label.centerY
        self.contentView.addSubview(inMoneyLabel)

        let temp4Label = UILabel(frame: CGRect(x: temp2Label.x, y: 0, width: 60, height: 14))
        temp4Label.text = "回款时间"
        temp4Label.textColor = UIColor.hex("999999")
        temp4Label.font = UIFont.customFont(ofSize: 14)
        temp4Label.centerY = temp3Label.centerY
        self.contentView.addSubview(temp4Label)

        outTimeLabel = UILabel(frame: CGRect(x: temp4Label.maxX + 10, y: temp4Label.y, width: 200, height: 14))
        outTimeLabel.text = "2016-12-6"
        outTimeLabel.textColor = UIColor.hex("666666")
        outTimeLabel.centerY = temp3Label.centerY
        outTimeLabel.font = UIFont.customFont(ofSize: 14)
        self.contentView.addSubview(outTimeLabel)
    }

    func updata(dic:JSON)  {
        printLog(message: dic)
        inMoneyLabel.text = "\(dic["exper_amount"])元"
        getLilvLabel.text = "\(dic["return_money"])元"
        inTimeLabel.text = dic["exper_time"].stringValue
        outTimeLabel.text = dic["return_expertime"].stringValue
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
