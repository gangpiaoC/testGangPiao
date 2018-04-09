//
//  UserOtherCell.swift
//  test
//
//  Created by gangpiaowang on 2016/12/16.
//  Copyright © 2016年 mutouwang. All rights reserved.
//

import UIKit

class UserOtherCell: UITableViewCell {
    var imgView:UIImageView!
    var titleLabel:UILabel!
    var detailLabel:UILabel!
    weak var superControl:UIViewController?
    var rightImbView:UIImageView!
    var swicth:UISwitch!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        imgView = UIImageView(frame: CGRect(x:  pixw(p: 16),y: 12,width:  pixw(p: 23),height:  pixw(p: 24)))
        imgView.centerY =  56 / 2
        self.contentView.addSubview(imgView)
        
        titleLabel = UILabel(frame: CGRect(x: imgView.maxX +  pixw(p: 10), y: 0, width:  pixw(p: 300),height:  pixw(p: 18)))
        titleLabel.centerY = imgView.centerY
        titleLabel.textColor = UIColor.hex("333333")
        titleLabel.font = UIFont.customFont(ofSize: 16)
        self.contentView.addSubview(titleLabel)
        
        rightImbView = UIImageView(frame: CGRect(x: SCREEN_WIDTH -  pixw(p: 16 + 6), y: 0, width:  pixw(p: 8), height:  pixw(p: 16)))
        rightImbView.image = UIImage(named: "user_rightImg")
        rightImbView.centerY = titleLabel.centerY
        self.contentView.addSubview(rightImbView)

        detailLabel = UILabel(frame: CGRect(x: rightImbView.x -  pixw(p: 300 - 10), y: 0, width: pixw(p:  300),height:  pixw(p: 16)))
        detailLabel.centerY = rightImbView.centerY
        detailLabel.textAlignment = .right
        detailLabel.text = " "
        detailLabel.textColor = UIColor.hex("666666")
        detailLabel.font = UIFont.customFont(ofSize: 16)
        self.contentView.addSubview(detailLabel)
        
        let line = UIView(frame: CGRect(x: 16, y: 56 - 0.5, width: SCREEN_WIDTH, height: 0.5))
        line.backgroundColor = lineColor
        self.contentView.addSubview(line)
        
        swicth = UISwitch()
        swicth.isHidden = true
        swicth.center = CGPoint(x:SCREEN_WIDTH - 45, y:25)
        self.contentView.addSubview(swicth)
    }
    
    func updata(imgName:String? = nil ,title:String,superc:UIViewController? = nil,detail:String? = nil) {
        detailLabel.x = rightImbView.x -  pixw(p: 300 + 10)
        if imgName == nil {
            titleLabel.x =  pixw(p: 16)
        }else{
           titleLabel.x = imgView.maxX +  pixw(p: 10)
            imgView.image = UIImage(named: imgName!)
        }
        self.superControl = superc
        titleLabel.text = title
        
        if detailLabel == nil {
            detailLabel.text = ""
        }else{
            detailLabel.text = detail
        }
    }
    
    func changSwitchValue(title:String,bool:Bool,superc:UIViewController) {
        swicth.isHidden = false
        detailLabel.isHidden = true
        titleLabel.x = pixw(p: 16)
        self.superControl = superc
        titleLabel.text = title
        rightImbView.isHidden = true
        swicth?.isOn = bool
    }
    
    //实名认证
    func updata(title:String,index:Int) {
        detailLabel.x = rightImbView.x -  pixw(p: 300 + 10)
        titleLabel.x =  pixw(p: 16)
        titleLabel.text = title
        detailLabel.textColor = UIColor.hex("666666")
        if index == 0 {
            printLog(message: GPWUser.sharedInstance().is_idcard)
            if GPWUser.sharedInstance().is_idcard == 1{
                let tempName = (GPWUser.sharedInstance().name! as NSString).replacingCharacters(in: NSRange(location: 1,length: 1), with: "*")
                detailLabel.text = tempName
                rightImbView.isHidden = true
                detailLabel.x = rightImbView.x -  pixw(p: 300)
            }else{
                detailLabel.text = "未认证"
                rightImbView.isHidden = false
                detailLabel.x = rightImbView.x -  pixw(p: 300 + 10)
            }
        }else if index == 1 {
            var tempStr = "未绑定"
            if GPWUser.sharedInstance().is_valid == "1" {
                let str = ((GPWUser.sharedInstance().bank_num! as NSString)).substring(with: NSRange(location: (GPWUser.sharedInstance().bank_num?.characters.count)! - 4,length: 4))
                tempStr = "*" + str
            }
            self.updata(imgName: nil, title: title, superc: nil, detail: tempStr)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
