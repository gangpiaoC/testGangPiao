//
//  TableViewCell.swift
//  FoldTableView
//
//  Created by ShaoFeng on 16/7/29.
//  Copyright © 2016年 Cocav. All rights reserved.
//

import UIKit

class GPWGetFriendsCell: UITableViewCell {

    var  bgView:UIView!
    //邀请方式
    var yaotypeLabel : UILabel!
    //名称
    var nameLabel:UILabel!
    //手机号
    var phoneLabel:UILabel!
    //时间
    var timeLabel:UILabel!
    //金额
    var moneyLabel:UILabel!
    var cellModel: GPWFriendCellModel? {
        didSet {
            //设置text
            yaotypeLabel.text = cellModel?.yaotypeStr
            if  let name = cellModel?.nameStr {
                if name.count == 3 {
                    let index = name.index(after: name.startIndex)
                    let  tempName = name.substring(to: index)
                    nameLabel.text = tempName + "**"
                }else if name.count == 2 {
                    let index = name.index(after: name.startIndex)
                    let  tempName = name.substring(to: index)
                    nameLabel.text = tempName + "*"
                }else{
                    nameLabel.text = "未实名"
                }
                
            }else{
                nameLabel.text = "未实名"
            }
            if let phone = cellModel?.phoneStr  {
                if phone.count > 4 {
                    let index = phone.index(phone.endIndex, offsetBy: -4)
                    phoneLabel.text = phone.substring(from: index)
                }else{
                    phoneLabel.text = cellModel?.phoneStr
                }
            }else{
                phoneLabel.text = cellModel?.phoneStr
            }
            timeLabel.text = cellModel?.timeStr
            moneyLabel.text = cellModel?.moneyStr
        }
    }
    func showYaoType(flag:Bool)  {
        if flag == true {
            yaotypeLabel.isHidden = false
        }else{
               yaotypeLabel.isHidden = true
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
          self.selectionStyle = .none
         bgView = UIView(frame: CGRect(x: pixw(p: 8), y: 0, width: SCREEN_WIDTH - pixw(p: 8) * 2, height: pixw(p: 40)))
        bgView.backgroundColor = UIColor.hex("aadefa")
        self.contentView.addSubview(bgView)
        
        yaotypeLabel = UILabel(frame: CGRect(x: pixw(p: 12), y: 0, width: pixw(p: 64), height: pixw(p: 40)))
        yaotypeLabel.text = "直接邀请"
        yaotypeLabel.font = UIFont.customFont(ofSize: pixw(p: 11.8))
        yaotypeLabel.textColor = UIColor.hex("333333")
        bgView.addSubview(yaotypeLabel)
        
        nameLabel = UILabel(frame: CGRect(x: yaotypeLabel.maxX + pixw(p: 0), y: 0, width: pixw(p: 50), height: pixw(p: 40)))
        nameLabel.text = "张**"
        nameLabel.centerY = yaotypeLabel.centerY
        nameLabel.font = UIFont.customFont(ofSize: pixw(p: 12))
        nameLabel.textColor = UIColor.hex("333333")
        bgView.addSubview(nameLabel)
        
        phoneLabel = UILabel(frame: CGRect(x: nameLabel.maxX + pixw(p: 5), y: 0, width: pixw(p: 63), height: pixw(p: 40)))
        phoneLabel.text = "8998"
        phoneLabel.centerY = yaotypeLabel.centerY
        phoneLabel.textAlignment = .center
        phoneLabel.font = UIFont.customFont(ofSize: pixw(p: 12))
        phoneLabel.textColor = UIColor.hex("333333")
        bgView.addSubview(phoneLabel)
        
        timeLabel = UILabel(frame: CGRect(x: phoneLabel.maxX + pixw(p: 12), y: 0, width: pixw(p: 61), height: pixw(p: 40)))
        timeLabel.text = "2017.02.14"
        timeLabel.centerY = yaotypeLabel.centerY
        timeLabel.font = UIFont.customFont(ofSize: pixw(p: 11.8))
        timeLabel.textColor = UIColor.hex("333333")
        bgView.addSubview(timeLabel)
        
        moneyLabel = UILabel(frame: CGRect(x: timeLabel.maxX + pixw(p: 18), y: 0, width: pixw(p: 61), height: pixw(p: 40)))
        moneyLabel.text = "500000"
        moneyLabel.centerY = yaotypeLabel.centerY
        moneyLabel.font = UIFont.customFont(ofSize: pixw(p: 12))
        moneyLabel.textColor = UIColor.hex("333333")
        bgView.addSubview(moneyLabel)
        
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        
        let  line = UIImageView(frame: CGRect(x: nameLabel.x, y: pixw(p: 40) - 1, width: bgView.width - nameLabel.x, height: 1))
        line.image = UIImage(named: "user_getfriends_line")
        bgView.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
