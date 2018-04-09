//
//  GPWAddMoneyOtherCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/23.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWAddMoneyOtherCell: UITableViewCell {

    var timeLabel:UILabel!
    var moneyLabel:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        timeLabel = UILabel(frame: CGRect(x: 16, y: 0, width: 200, height: 46))
        timeLabel.font = UIFont.customFont(ofSize: 16)
        timeLabel.text = "2016-12-04"
        self.contentView.addSubview(timeLabel)
        
        moneyLabel = UILabel(frame: CGRect(x: SCREEN_WIDTH / 2, y: 0, width: SCREEN_WIDTH / 2 - 16, height: 46))
        moneyLabel.font = UIFont.customFont(ofSize: 16)
        moneyLabel.text = "7.43"
        moneyLabel.textAlignment = .right
        self.contentView.addSubview(moneyLabel)
    }
    
    func update(dic:[String:Any],index:Int) {
        if index == 0 {
            timeLabel.textColor = redColor
            moneyLabel.textColor = redColor
        }else{
            timeLabel.textColor = UIColor.hex("666666")
            moneyLabel.textColor = UIColor.hex("666666")
        }
        timeLabel.text = GPWHelper.strFromDate(Double(dic["time"] as! String)!, format: "yyyy-MM-dd")
        moneyLabel.text = dic["accrual"] as? String
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
