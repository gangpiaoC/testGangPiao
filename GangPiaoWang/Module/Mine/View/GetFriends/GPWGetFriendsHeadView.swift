//
//  HeaderView.swift
//  FoldTableView
//
//  Created by ShaoFeng on 16/7/29.
//  Copyright © 2016年 Cocav. All rights reserved.
//

import UIKit

typealias HeaderViewClickCallBack = (Bool) -> Void

class GPWGetFriendsHeadView: UITableViewHeaderFooterView {

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

    var expandCallBack: HeaderViewClickCallBack?
    var model: GPWFriendSectionModel? = nil

    var sectionModel: GPWFriendSectionModel? {
        didSet {
            yaotypeLabel.text = sectionModel?.yaotypeStr
            if  let name = sectionModel?.nameStr {
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
            if let phone = sectionModel?.phoneStr  {
                if phone.count > 4 {
                    let index = phone.index(phone.endIndex, offsetBy: -4)
                    phoneLabel.text = phone.substring(from: index)
                }else{
                      phoneLabel.text = sectionModel?.phoneStr
                }
            }else{
                phoneLabel.text = sectionModel?.phoneStr
            }
            
            timeLabel.text = sectionModel?.timeStr
            moneyLabel.text = sectionModel?.moneyStr
            //设置test
            if ((self.sectionModel!.isExpanded) != false) {
                self.directionImageView.transform =  CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
            } else {
                self.directionImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }
            if (sectionModel?.cellModels.count)! > 0 {
                self.directionImageView.isHidden = false
            }else{
                self.directionImageView.isHidden = true
            }
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
         bgView = UIView(frame: CGRect(x: pixw(p: 8), y: 0, width: SCREEN_WIDTH - pixw(p: 8) * 2, height: pixw(p: 40)))
        self.contentView.addSubview(bgView)
        
        yaotypeLabel = UILabel(frame: CGRect(x: pixw(p: 12), y: 0, width: pixw(p: 52), height: pixw(p: 40)))
        yaotypeLabel.text = "直接邀请"
        yaotypeLabel.font = UIFont.customFont(ofSize: 12)
        yaotypeLabel.textColor = UIColor.hex("333333")
        bgView.addSubview(yaotypeLabel)
        
        nameLabel = UILabel(frame: CGRect(x: yaotypeLabel.maxX + pixw(p: 10), y: 0, width: pixw(p: 54), height: pixw(p: 45)))
        nameLabel.text = "张**"
        nameLabel.centerY = yaotypeLabel.centerY
        nameLabel.font = UIFont.customFont(ofSize: 12)
        nameLabel.textColor = UIColor.hex("333333")
        bgView.addSubview(nameLabel)
        
        phoneLabel = UILabel(frame: CGRect(x: nameLabel.maxX + pixw(p: 5), y: 0, width: pixw(p: 63), height: pixw(p: 40)))
        phoneLabel.text = "8998"
        phoneLabel.centerY = yaotypeLabel.centerY
        phoneLabel.textAlignment = .center
        phoneLabel.font = UIFont.customFont(ofSize: 12)
        phoneLabel.textColor = UIColor.hex("333333")
        bgView.addSubview(phoneLabel)
        
        timeLabel = UILabel(frame: CGRect(x: phoneLabel.maxX + pixw(p: 12), y: 0, width: pixw(p: 61), height: pixw(p: 40)))
        timeLabel.text = "2017.02.14"
        timeLabel.centerY = yaotypeLabel.centerY
        timeLabel.font = UIFont.customFont(ofSize: 11.8)
        timeLabel.textColor = UIColor.hex("333333")
        bgView.addSubview(timeLabel)
        
        moneyLabel = UILabel(frame: CGRect(x: timeLabel.maxX + pixw(p: 18), y: 0, width: pixw(p: 61), height: pixw(p: 40)))
        moneyLabel.text = "500000"
        moneyLabel.centerY = yaotypeLabel.centerY
        moneyLabel.font = UIFont.customFont(ofSize: 12)
        moneyLabel.textColor = UIColor.hex("333333")
        bgView.addSubview(moneyLabel)
        
        directionImageView = UIImageView.init(image: UIImage.init(named: "expanded"))
        directionImageView.frame = CGRect(x: bgView.width - pixw(p: 20), y:pixw(p:  (40 - 8) / 2), width: pixw(p: 12), height: pixw(p: 6))
        bgView.addSubview(directionImageView)

        let button = UIButton.init(frame: CGRect(x: 0, y: 0, width: bgView.width, height: pixw(p: 40)))
        bgView.addSubview(button)
        button.addTarget(self, action: #selector(clickHeader(sender:)), for: UIControlEvents.touchUpInside)
        button.showsTouchWhenHighlighted = false
       self.backgroundView = UIView(frame: self.bounds)
        self.backgroundView?.backgroundColor = UIColor.clear
    }
    
    @objc //不接受返回值
    func clickHeader(sender: UIButton) {
        sectionModel?.isExpanded = !((sectionModel?.isExpanded)!)
//        UIView.animate(withDuration: 0.25) {
//            if ((self.sectionModel?.isExpanded) != false) {
//                self.directionImageView.transform = CGAffineTransform.identity
//            } else {
//                self.directionImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
//            }
//        }
        if (self.expandCallBack != nil) {
            expandCallBack!((self.sectionModel?.isExpanded)!)
        }
    }
    
    private lazy var directionImageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

