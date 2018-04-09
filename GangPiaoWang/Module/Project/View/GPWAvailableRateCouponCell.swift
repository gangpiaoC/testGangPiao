//
//  GPWAvailableRateCouponCell.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/22.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWAvailableRateCouponCell: UITableViewCell {
    fileprivate var lilvLabel:RTLabel!
    fileprivate var temp1Label:UILabel!
    fileprivate var temp2Label:UILabel!
    
    //是否被选择（确认出资中选择红包使用）
    fileprivate var  selectImgView:UIImageView!
    
    //整体背景
    fileprivate var  conBgImgView:UIImageView!
    fileprivate var superControl:UIViewController?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.backgroundColor = UIColor.clear
        
        let block = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 16))
        block.backgroundColor = bgColor
        self.contentView.addSubview(block)
        
        //整体背景
        conBgImgView = UIImageView(frame: CGRect(x: 16, y: block.maxY, width: SCREEN_WIDTH - 32, height: 100))
        conBgImgView.backgroundColor = UIColor.white
        conBgImgView.image = UIImage(named: "user_inc_use")
        self.contentView.addSubview(conBgImgView)
        
        lilvLabel = RTLabel(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        lilvLabel.text = "<font size=48 color='#ffffff'>1</font><font size=20 color='#ffffff'>%</font>"
        lilvLabel.textAlignment = RTTextAlignmentCenter
        lilvLabel.height = lilvLabel.optimumSize.height
        lilvLabel.centerY = conBgImgView.height / 2
        conBgImgView.addSubview(lilvLabel)
        
        temp1Label = UILabel(frame: CGRect(x: 157, y: 30, width: conBgImgView.width - 157 - 16, height: 14))
        temp1Label.text = "适用所有产品"
        temp1Label.textColor = UIColor.hex("333333")
        temp1Label.font = UIFont.customFont(ofSize: 14)
        conBgImgView.addSubview(temp1Label)
        
        temp2Label = UILabel(frame: CGRect(x: temp1Label.x, y: temp1Label.maxY + 9, width: temp1Label.width, height: 14))
        temp2Label.text = "有效期至2016-07-05"
        temp2Label.textColor = UIColor.hex("999999")
        temp2Label.font = UIFont.customFont(ofSize: 14)
        conBgImgView.addSubview(temp2Label)
        
        selectImgView = UIImageView(frame: CGRect(x: conBgImgView.width - 16 - 18, y: 0, width: 18, height: 18))
        selectImgView.image = UIImage(named: "project_sure_select")
        selectImgView.centerY = conBgImgView.height / 2
        conBgImgView.addSubview(selectImgView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupCell(_ rateCoupon: RateCoupon,selectFlag:Bool) {
         lilvLabel.text = "<font size=46 color='#ffffff'>\(rateCoupon.rate)</font><font size=18 color='#ffffff'>%</font>"
         temp1Label.text = "\(rateCoupon.restrict_time)"
        temp2Label.text = "有效期至" + GPWHelper.strFromDate(rateCoupon.expire, format: "yyyy-MM-dd")
        if selectFlag {
            selectImgView.image = UIImage(named: "project_sure_selected")
        }else{
            selectImgView.image = UIImage(named: "project_sure_select")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
