//
//  GPWMoneyToCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/21.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWMoneyToCell: UITableViewCell {
    
    //类型
    var typeLabel:UILabel!
    
    //加减资金
    var inMoneyLabel:UILabel!
    
    //时间
    var timeLabel:UILabel!
    
    //账户余额
    var partMoneyLabel:UILabel!
    
    var superControl:UIViewController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        typeLabel = UILabel(frame: CGRect(x: 16, y: 21, width: SCREEN_WIDTH * 2 / 3 - 32, height: 16))
        typeLabel.text = "充值"
        typeLabel.textColor = UIColor.hex("333333")
        typeLabel.font = UIFont.customFont(ofSize: 16)
        self.contentView.addSubview(typeLabel)
        
        inMoneyLabel = UILabel(frame: CGRect(x: SCREEN_WIDTH / 2, y: 21, width: SCREEN_WIDTH / 2 - 16, height: 18))
        inMoneyLabel.text = "+￥1000.00"
        inMoneyLabel.textAlignment = .right
        inMoneyLabel.textColor = redColor
        inMoneyLabel.font = UIFont.customFont(ofSize: 18)
        self.contentView.addSubview(inMoneyLabel)
        
        timeLabel = UILabel(frame: CGRect(x: 16, y: typeLabel.maxY + 16, width: SCREEN_WIDTH / 2, height: 13))
        timeLabel.text = "2016-11-22  15:00"
        timeLabel.textColor = UIColor.hex("666666")
        timeLabel.font = UIFont.customFont(ofSize: 12)
        self.contentView.addSubview(timeLabel)
        
        partMoneyLabel = UILabel(frame: CGRect(x: inMoneyLabel.x, y: timeLabel.y, width: inMoneyLabel.width, height: 13))
        partMoneyLabel.textColor = UIColor.hex("333333")
        partMoneyLabel.text = "账户余额：0.00元"
        partMoneyLabel.font = UIFont.customFont(ofSize: 12)
        partMoneyLabel.textAlignment = .right
        self.contentView.addSubview(partMoneyLabel)
        
        let line = UIView(frame: CGRect(x: 0, y: 85 - 0.5, width: SCREEN_WIDTH, height: 0.5))
        line.backgroundColor = lineColor
        self.contentView.addSubview(line)
    }
    
    func setInfo(dic:JSON,superC:UIViewController) {
        self.superControl = superC
        typeLabel.text = dic["type"].stringValue
        timeLabel.text = GPWHelper.strFromDate(dic["add_time"].doubleValue, format: "yyyy-MM-dd  HH:mm")
        let  amount = dic["amount"].stringValue
        if amount.hasPrefix("-") {
            inMoneyLabel.textColor = UIColor.hex("3ebe18")
        }else{
            inMoneyLabel.textColor = redColor
        }
        inMoneyLabel.text = "\(dic["amount"])"
        partMoneyLabel.text = "账户余额:\(dic["update_after"])元"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

