//
//  GPWUserInvSecCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/1/3.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWUserInvSecCell: UITableViewCell {

    //邀请成功
    var yaoSLabel:RTLabel!
    
    //获取利益
    var getMoneyLabel:RTLabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        yaoSLabel = RTLabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH / 2, height: 0))
        yaoSLabel.text = "<font size=14 color='#333333'>已成功邀请</font><font size=18 color='#f5441b'>0</font><font size=14 color='#333333'>人</font>"
        yaoSLabel.height = yaoSLabel.optimumSize.height
        yaoSLabel.textAlignment = RTTextAlignmentCenter
        yaoSLabel.centerY = 53 / 2
        self.contentView.addSubview(yaoSLabel)
        
        getMoneyLabel = RTLabel(frame: CGRect(x: SCREEN_WIDTH / 2, y: 0, width: SCREEN_WIDTH / 2, height: 30))
        getMoneyLabel.text = "<font size=14 color='#333333'>已赚取奖励</font><font size=18 color='#f5441b'>0</font><font size=14 color='#333333'>元</font>"
        getMoneyLabel.height = getMoneyLabel.optimumSize.height
        getMoneyLabel.textAlignment = RTTextAlignmentCenter
        getMoneyLabel.centerY = 53 / 2
        self.contentView.addSubview(getMoneyLabel)

    }
    
    func updata(peopleNum:String,getMoney:String) {
         yaoSLabel.text = "<font size=14 color='#333333'>已成功邀请</font><font size=18 color='#f5441b'>\(peopleNum)</font><font size=14 color='#333333'>人</font>"
         getMoneyLabel.text = "<font size=14 color='#333333'>已赚取奖励</font><font size=18 color='#f5441b'>\(getMoney)</font><font size=14 color='#333333'>元</font>"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
