//
//  GPWBankQCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/8/13.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWBankQCell: UITableViewCell {
    fileprivate var bankImgView:UIImageView!
    fileprivate var tempTitleLabel:UILabel!
    fileprivate var tempDetailLabel:UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       
        bankImgView = UIImageView(frame: CGRect(x: 16, y: 18, width: 34, height: 36))
        self.contentView.addSubview(bankImgView)
        
        tempTitleLabel = UILabel(frame: CGRect(x: bankImgView.maxX + 12, y: 27, width: 300, height: 18))
        tempTitleLabel.textColor = UIColor.hex("333333")
        tempTitleLabel.font = UIFont.customFont(ofSize: 18)
        self.contentView.addSubview(tempTitleLabel)
        
        tempDetailLabel = UILabel(frame: CGRect(x: tempTitleLabel.x, y: tempTitleLabel.maxY + 10, width: 300, height: 18))
        tempDetailLabel.textColor = UIColor.hex("666666")
        tempDetailLabel.font = UIFont.customFont(ofSize: 16)
        self.contentView.addSubview(tempDetailLabel)
        
        let line = UIView(frame: CGRect(x: 16, y: 90 - 0.5, width: SCREEN_WIDTH - 16, height: 0.5))
        line.backgroundColor = UIColor.hex("e0e0e0")
        self.contentView.addSubview(line)
    }
    
    func updata(dic:JSON) {
        bankImgView.downLoadImg(imgUrl: dic["bank_logo"].stringValue, placeImg: "")
        tempTitleLabel.text = dic["bank_name"].stringValue
        tempDetailLabel.text = "单笔限额\(dic["single_limit"])万，单日限额\(dic["day_limit"].stringValue)万"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
