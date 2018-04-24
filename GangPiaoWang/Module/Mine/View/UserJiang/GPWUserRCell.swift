//
//  GPWUserRCell.swift
//  GangPiaoWang
//  加息券
//  Created by gangpiaowang on 2016/12/21.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWUserRCell: UITableViewCell {
    var lilvLabel:UILabel!
    var temp1Label:UILabel!
    var temp2Label:UILabel!

    //背景图
    var bgImgView:UIImageView!

    //过期图片
    var  timeImgView:UIImageView!

    //是否被选择（确认出资中选择红包使用）
    fileprivate var  selectImgView:UIImageView!
    
    var superControl:UIViewController?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.backgroundColor = UIColor.clear

        let block = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 16))
        block.backgroundColor = bgColor
        self.contentView.addSubview(block)
        
        //整体背景
        let  conBgImgView:UIImageView = UIImageView(frame: CGRect(x: 16, y: block.maxY, width: SCREEN_WIDTH - 32, height: 120))
        conBgImgView.image = UIImage(named: "user_reward_bg")
        self.contentView.addSubview(conBgImgView)

        bgImgView = UIImageView(frame: CGRect(x: 22, y: block.maxY + 34, width: 83, height: 52))
        bgImgView.image = UIImage(named: "user_inc_use")
        bgImgView.centerY = conBgImgView.height / 2
        conBgImgView.addSubview(bgImgView)

        timeImgView = UIImageView(frame: CGRect(x: 11, y: block.maxY + 5, width: 65, height: 46))
        conBgImgView.addSubview(timeImgView)

        selectImgView = UIImageView(frame: CGRect(x: conBgImgView.width - 16 - 18, y: 0, width: 18, height: 18))
        selectImgView.image = UIImage(named: "project_sure_select")
        selectImgView.centerY = bgImgView.centerY
        conBgImgView.addSubview(selectImgView)
        
        lilvLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bgImgView.width, height: bgImgView.height))
        lilvLabel.textAlignment = .center
        let attrText = NSMutableAttributedString()
        attrText.append(NSAttributedString.attributedString("   3", mainColor: UIColor.hex("ffffff"), mainFont: 27, mainFontWeight: .medium, second: "%", secondColor: UIColor.hex("ffffff"), secondFont: 16, secondFontWeight: .medium))
        lilvLabel.attributedText = attrText
        bgImgView.addSubview(lilvLabel)
        
        temp1Label = UILabel(frame: CGRect(x: pixw(p: 157), y: 35, width: conBgImgView.width - 157 - 16, height: 20))
        temp1Label.text = "试用所有产品"
        temp1Label.textColor = UIColor.hex("4f4f4f")
        temp1Label.font = UIFont.customFont(ofSize: 14)
        conBgImgView.addSubview(temp1Label)
        
        temp2Label = UILabel(frame: CGRect(x: temp1Label.x, y: temp1Label.maxY + 10, width: temp1Label.width, height: 20))
        temp2Label.text = "有效期至2016-07-05"
        temp2Label.textColor = UIColor.hex("4f4f4f")
        temp2Label.font = UIFont.customFont(ofSize: 14)
        conBgImgView.addSubview(temp2Label)
    }
    func setInfo(dic:JSON,superC:UIViewController) {
        temp1Label.textColor = UIColor.hex("4f4f4f")
        temp2Label.textColor = UIColor.hex("4f4f4f")
        self.superControl = superC
        self.selectImgView.isHidden = true
        let attrText = NSMutableAttributedString()
        attrText.append(NSAttributedString.attributedString("   \(dic["rate"])", mainColor: UIColor.hex("ffffff"), mainFont: 25, mainFontWeight: .medium, second: "%", secondColor: UIColor.hex("ffffff"), secondFont: 14, secondFontWeight: .medium))
        lilvLabel.attributedText = attrText
        temp1Label.text = dic["restrict_item"].stringValue
        temp2Label.text = "有效期至" + GPWHelper.strFromDate(dic["due_time"].doubleValue, format: "yyyy-MM-dd")
        let status = dic["status"].stringValue
        if status == "AVAILABLE" {
            //立即使用
            bgImgView.image = UIImage(named: "user_inc_use")
            timeImgView.image = UIImage(named: "")
        }else if status == "IN_USE" {
            //加息中
            timeImgView.image = UIImage(named: "")
            bgImgView.image = UIImage(named: "user_inc_using")
            timeImgView.image = UIImage(named: "user_reward_using")
            
        }else if status == "HAS_USED" {
            //已使用
            temp1Label.textColor = UIColor.hex("999999")
            temp2Label.textColor = UIColor.hex("999999")
            timeImgView.image = UIImage(named: "user_reward_usedd")
            bgImgView.image = UIImage(named: "user_inc_overuse")
        }else if status == "PAST_DUE" {
            //已失效
            temp1Label.textColor = UIColor.hex("999999")
            temp2Label.textColor = UIColor.hex("999999")
            bgImgView.image = UIImage(named: "user_inc_overtime")
            timeImgView.image = UIImage(named: "user_reward_overtime")
        }
    }

    func setupCell(_ rateCoupon: RateCoupon, selectFlag:Bool) {
        self.selectImgView.isHidden = false
        let attrText = NSMutableAttributedString()
        attrText.append(NSAttributedString.attributedString("   \(rateCoupon.rate)", mainColor: UIColor.hex("ffffff"), mainFont: 28, mainFontWeight: .medium, second: "%", secondColor: UIColor.hex("ffffff"), secondFont: 18, secondFontWeight: .medium))
        lilvLabel.attributedText = attrText
        temp1Label.text = "\(rateCoupon.restrict_time)"
        temp2Label.text = "有效期至" + GPWHelper.strFromDate(rateCoupon.expire, format: "yyyy-MM-dd")

        if selectFlag {
            selectImgView.image = UIImage(named: "project_sure_selected")
        }else{
            selectImgView.image = UIImage(named: "project_sure_select")
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
