//
//  GPWUserInvOtherCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/1/3.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWUserInvOtherCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        let array = ["2016-12-32","王芝宝","出借成功"]
        let titleWith = (SCREEN_WIDTH - 32) / 3
        for i in 0 ..< array.count {
            let titleLabel = UILabel(frame: CGRect(x: 16 + titleWith * CGFloat(i), y: 0, width: titleWith, height: 35))
            titleLabel.textAlignment = .center
            titleLabel.text = array[i]
            titleLabel.tag = 100 + i
            titleLabel.font = UIFont.customFont(ofSize: 13)
            titleLabel.textColor = UIColor.hex("666666")
            self.contentView.addSubview(titleLabel)
        }
    }
    
    func updata(dic:[String:Any]?) {
        let timeLabel = self.contentView.viewWithTag(100) as! UILabel
        timeLabel.text = GPWHelper.strFromDate(dic!["add_time"]! as! Double, format: "yyy-MM-dd")
        
        let nameLabel = self.contentView.viewWithTag(101) as! UILabel
        nameLabel.text = dic?["user_name"] as? String
        let stateLabel = self.contentView.viewWithTag(102) as! UILabel
        if let status = dic?["status"] {
            if status as? String == "1" {
                stateLabel.text = "已出借"
            } else {
                stateLabel.text = "未出借"
            }
        } else {
             stateLabel.text = "未出借"
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
