//
//  GPWAddMoneyCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/23.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWAddMoneyCell: UITableViewCell {

    //截止到昨日收益
    var beforeTodayLabel:UILabel!
    
    //所有收益
    var allinDayLabel:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let temp1Label = UILabel(frame: CGRect(x: 30, y: 21, width: 80, height: 14))
        temp1Label.text = "累计收益(元)"
        temp1Label.font = UIFont.customFont(ofSize: 13)
        temp1Label.textColor = UIColor.hex("666666")
        self.contentView.addSubview(temp1Label)
        
        let temp3Label = UILabel(frame: CGRect(x: temp1Label.maxX + 5, y: 21, width: 48, height: 16))
        temp3Label.text = "截止昨日"
        temp3Label.font = UIFont.customFont(ofSize: 10)
        temp3Label.textAlignment = .center
        temp1Label.layer.masksToBounds = true
        temp3Label.layer.cornerRadius = 2
        temp3Label.backgroundColor = redColor
        temp3Label.centerY = temp1Label.centerY
        temp3Label.textColor = UIColor.white
        self.contentView.addSubview(temp3Label)
        
        beforeTodayLabel = UILabel(frame: CGRect(x: temp1Label.x, y: temp1Label.maxY + 14, width: SCREEN_WIDTH / 2 - temp1Label.x, height: 26))
        beforeTodayLabel.text = "283.05"
        beforeTodayLabel.font = UIFont.customFont(ofSize: 24)
        beforeTodayLabel.textColor = redColor
        self.contentView.addSubview(beforeTodayLabel)

        
        
        let temp2Label = UILabel(frame: CGRect(x:SCREEN_WIDTH / 2 + 30, y: temp1Label.y, width: 80, height: 14))
        temp2Label.text = "累计收益(元)"
        temp2Label.font = UIFont.customFont(ofSize: 13)
        temp2Label.textColor = UIColor.hex("666666")
        self.contentView.addSubview(temp2Label)
        
        allinDayLabel = UILabel(frame: CGRect(x: temp2Label.x, y: temp2Label.maxY + 14, width: SCREEN_WIDTH - temp2Label.x - 16, height: 26))
        allinDayLabel.text = "283.05"
        allinDayLabel.font = UIFont.customFont(ofSize: 26)
        allinDayLabel.textColor = redColor
        allinDayLabel.centerY = beforeTodayLabel.centerY
        self.contentView.addSubview(allinDayLabel)
    }
    
    func updata(addMoney:String,allMoney:String) {
        beforeTodayLabel.text = addMoney
        allinDayLabel.text = allMoney
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
