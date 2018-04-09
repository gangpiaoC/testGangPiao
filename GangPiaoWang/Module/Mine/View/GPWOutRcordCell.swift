//
//  GPWOutRcordCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/23.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWOutRcordCell: UITableViewCell {
    
    //背景
    private var topbgView:UIView!

    //类型
    var typeLabel:RTLabel!
    
    //收益
    var stateLabel:UILabel!
    
    //出借金额
    var inMoneyLabel:UILabel!
    
    //出借日期
    var inTimeLabel:UILabel!
    
    //预计收益
    var getLilvLabel:UILabel!
    
    //还款日期
    var outTimeLabel:UILabel!
    //加息图片
    var jiaxiImgView:UIImageView!
    //加息标签
    var jiaxiLabel:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
         topbgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 146))
        topbgView.backgroundColor = UIColor.white
        self.contentView.addSubview(topbgView)
        
        let imgView = UIImageView(frame: CGRect(x: 16, y: 17, width: 2, height: 16))
        imgView.image = UIImage(named: "user_record_shu")
        topbgView.addSubview(imgView)
        
        typeLabel = RTLabel(frame: CGRect(x: imgView.maxX + 5, y: imgView.y, width: 200, height: 16))
        typeLabel.text = "<font size=16 color='#333333'>新手标</font>"
        typeLabel.size = typeLabel.optimumSize
        typeLabel.centerY = imgView.centerY
        topbgView.addSubview(typeLabel)
        
        stateLabel = UILabel(frame: CGRect(x: typeLabel.maxX + 8, y: 0, width: 55, height: 18))
        stateLabel.text = "出借成功"
        stateLabel.textColor = UIColor.white
        stateLabel.textAlignment = .center
        stateLabel.layer.masksToBounds = true
        stateLabel.layer.cornerRadius = stateLabel.height / 2
        stateLabel.centerY = typeLabel.centerY
        stateLabel.font = UIFont.customFont(ofSize: 12)
        stateLabel.backgroundColor = UIColor.hex("ffeadf")
        topbgView.addSubview(stateLabel)
        
        jiaxiImgView = UIImageView(frame: CGRect(x: stateLabel.x + 6, y: 0, width: 73, height: 18))
        jiaxiImgView.image = UIImage(named: "user_jiaxi")
        jiaxiImgView.centerY = stateLabel.centerY
        topbgView.addSubview(jiaxiImgView)
        jiaxiLabel = UILabel(frame: CGRect(x: 12, y: 0, width: 65, height: jiaxiImgView.height))
        jiaxiLabel.textColor = UIColor.white
        jiaxiLabel.font = UIFont.customFont(ofSize: 11)
        jiaxiLabel.text = "已加息1%"
        jiaxiImgView.addSubview(jiaxiLabel)
        
        let line = UIView(frame: CGRect(x: imgView.x, y: imgView.maxY + 16, width: topbgView.width  - imgView.x * 2, height: 0.5))
        line.backgroundColor = lineColor
        topbgView.addSubview(line)
        
        let temp1Label = UILabel(frame: CGRect(x: 16, y: line.maxY + 22, width: 60, height: 14))
        temp1Label.text = "出借金额"
        temp1Label.textColor = UIColor.hex("999999")
        temp1Label.font = UIFont.customFont(ofSize: 14)
        topbgView.addSubview(temp1Label)
        
        inMoneyLabel = UILabel(frame: CGRect(x: temp1Label.maxX + 10, y: temp1Label.y, width: 200, height: 16))
        inMoneyLabel.text = "1000元"
        inMoneyLabel.textColor = UIColor.hex("777777")
        inMoneyLabel.font = UIFont.customFont(ofSize: 16)
        inMoneyLabel.centerY = temp1Label.centerY
        topbgView.addSubview(inMoneyLabel)
        
        let temp2Label = UILabel(frame: CGRect(x: topbgView.width / 2, y: line.maxY + 23, width: temp1Label.width, height: 14))
        temp2Label.text = "出借日期"
        temp2Label.textColor = UIColor.hex("999999")
        temp2Label.centerY = temp1Label.centerY
        temp2Label.font = UIFont.customFont(ofSize: 14)
        topbgView.addSubview(temp2Label)
        
        inTimeLabel = UILabel(frame: CGRect(x: temp2Label.maxX + 10, y: temp2Label.y, width: 200, height: 16))
        inTimeLabel.text = "2016-12-6"
        inTimeLabel.textColor = UIColor.hex("777777")
        inTimeLabel.centerY = temp1Label.centerY
        inTimeLabel.font = UIFont.customFont(ofSize: 16)
        topbgView.addSubview(inTimeLabel)
        
        let temp3Label = UILabel(frame: CGRect(x: temp1Label.x, y: temp1Label.maxY + 18, width: temp1Label.width, height: 14))
        temp3Label.text = "预计收益"
        temp3Label.textColor = UIColor.hex("999999")
        temp3Label.font = UIFont.customFont(ofSize: 14)
       topbgView.addSubview(temp3Label)
        
        getLilvLabel = UILabel(frame: CGRect(x: temp3Label.maxX + 10, y: temp3Label.y, width: 200, height: 16))
        getLilvLabel.text = "320.0元"
        getLilvLabel.textColor = UIColor.hex("777777")
        getLilvLabel.centerY = temp3Label.centerY
        getLilvLabel.font = UIFont.customFont(ofSize: 16)
        topbgView.addSubview(getLilvLabel)
        
        let temp4Label = UILabel(frame: CGRect(x: topbgView.width / 2, y: getLilvLabel.y, width: temp1Label.width, height: 14))
        temp4Label.text = "还款日期"
        temp4Label.textColor = UIColor.hex("999999")
        temp4Label.font = UIFont.customFont(ofSize: 14)
        temp4Label.centerY = temp3Label.centerY
        topbgView.addSubview(temp4Label)
        
        outTimeLabel = UILabel(frame: CGRect(x: temp4Label.maxX + 10, y: temp4Label.y, width: 200, height: 16))
        outTimeLabel.text = "2016-12-6"
        outTimeLabel.textColor = UIColor.hex("777777")
        outTimeLabel.centerY = temp3Label.centerY
        outTimeLabel.font = UIFont.customFont(ofSize: 16)
        topbgView.addSubview(outTimeLabel)
    }
    
    func updata(dic:JSON)  {
        typeLabel.width = 200
        typeLabel.text = "<font size=16 color='#333333'>\(dic["title"])</font>"
        typeLabel.size = typeLabel.optimumSize
        stateLabel.x = typeLabel.maxX + 8
        let statusStr = dic["status"].stringValue
        stateLabel.text = statusStr
        if statusStr == "已完成" {
            stateLabel.backgroundColor = UIColor.hex("d8d8d8", alpha:0.40)
            stateLabel.textColor = UIColor.hex("9b9b9b")
        }else  if statusStr == "已出借" {
            stateLabel.backgroundColor = UIColor.hex("ffeadf", alpha: 0.58)
            stateLabel.textColor = UIColor.hex("f6390c")
        }else{
            stateLabel.backgroundColor = UIColor.hex("ffb700", alpha:0.15)
            stateLabel.textColor = UIColor.hex("ff9b00")
        }
        stateLabel.text = dic["status"].stringValue
        if  dic["rate"].doubleValue > 0 {
            jiaxiImgView.isHidden = false
            jiaxiImgView.x = stateLabel.maxX + 6 
            jiaxiLabel.text = "已加息\(dic["rate"].stringValue)%"
        }else{
            jiaxiImgView.isHidden = true
        }
        jiaxiImgView.x = stateLabel.maxX + 6
        inMoneyLabel.text = "\(dic["amount"])元"
        getLilvLabel.text = "\(dic["expect_earnings"])元"
        inTimeLabel.text = GPWHelper.strFromDate(dic["add_time"].doubleValue, format: "yyyy-MM-dd")
        outTimeLabel.text = dic["repaying_time"].stringValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
