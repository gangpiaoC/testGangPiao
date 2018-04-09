//
//  GPWGetFriendsTopCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/3/9.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWGetFriendsTopCell: UITableViewCell {
    //我的邀请码
    var mycodeBtn:UIButton!
    
    //已赚取奖励
    var getMoneyBtn:UIButton!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        //我的邀请码
        let temp1Label = UILabel(frame: CGRect(x: 0, y: pixw(p: 38), width: SCREEN_WIDTH / 2, height: pixw(p: 25)))
        temp1Label.text = "我的邀请码"
        temp1Label.font = UIFont.customFont(ofSize: pixw(p: 18))
        temp1Label.centerX  = SCREEN_WIDTH / 4
        temp1Label.textAlignment = .center
        temp1Label.textColor = UIColor.hex("000000")
        self.contentView.addSubview(temp1Label)
        
        mycodeBtn = UIButton(type: .custom)
        mycodeBtn.frame = CGRect(x: 0, y: temp1Label.maxY + pixw(p: 12), width: pixw(p: 110), height: pixw(p: 36))
        mycodeBtn.setBackgroundImage(UIImage(named:"user_getfriends_getmoney"), for: .normal)
        mycodeBtn.centerX = temp1Label.centerX
        mycodeBtn.setTitle("132033", for: .normal)
        mycodeBtn.setTitleColor(UIColor.hex("653600"), for: .normal)
        mycodeBtn.titleLabel?.font = UIFont.customFont(ofSize: pixw(p: 17))
        self.contentView.addSubview(mycodeBtn)
        
        //已经赚取奖励
        let temp2Label = UILabel(frame: CGRect(x: 0, y: pixw(p: 38), width: SCREEN_WIDTH / 2, height: pixw(p: 25)))
        temp2Label.text = "已赚取奖励"
        temp2Label.font = UIFont.customFont(ofSize: pixw(p: 18))
        temp2Label.textAlignment = .center
        temp2Label.centerX  = SCREEN_WIDTH / 4 * 3
        temp2Label.textColor = UIColor.hex("000000")
        self.contentView.addSubview(temp2Label)
        
        getMoneyBtn = UIButton(type: .custom)
        getMoneyBtn.frame = CGRect(x: 0, y: temp2Label.maxY + pixw(p: 12), width: pixw(p: 110), height: pixw(p: 36))
        getMoneyBtn.setBackgroundImage(UIImage(named:"user_getfriends_getmoney"), for: .normal)
        getMoneyBtn.setTitle("12,890元", for: .normal)
        getMoneyBtn.centerX = temp2Label.centerX
        getMoneyBtn.setTitleColor(UIColor.hex("653600"), for: .normal)
        getMoneyBtn.titleLabel?.font = UIFont.customFont(ofSize: pixw(p: 18))
        self.contentView.addSubview(getMoneyBtn)
        
    }
    func updata(code:String,money:String) {
         mycodeBtn.setTitle(code, for: .normal)
         getMoneyBtn.setTitle(money, for: .normal)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
