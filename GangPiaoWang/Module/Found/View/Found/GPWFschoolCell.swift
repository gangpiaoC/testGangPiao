//
//  GPWFschoolCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/8/14.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWFschoolCell:  UITableViewCell {
    
    //图片
    fileprivate let tempImgView:UIImageView = {
       let imgView = UIImageView()
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = 4
        return imgView
    }()
    
    //标题
    fileprivate let tempTitleLabel:UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.hex("222222")
        titleLabel.numberOfLines = 2
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.font = UIFont.customFont(ofSize: 16.0)
        return titleLabel
    }()
    
    //类型
    fileprivate let typeLabel:UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.hex("f5a623")
        titleLabel.layer.masksToBounds = true
        titleLabel.layer.cornerRadius = 10
        titleLabel.textAlignment = .center
        titleLabel.layer.borderColor = titleLabel.textColor.cgColor
        titleLabel.layer.borderWidth = 0.5
        titleLabel.font = UIFont.customFont(ofSize: 14.0)
        return titleLabel
    }()
    
    //时间
    fileprivate let timeLabel:UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.hex("999999")
        titleLabel.font = UIFont.customFont(ofSize: 14.0)
        return titleLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
       self.selectionStyle = .none
        self.contentView.addSubview(tempTitleLabel)
        self.contentView.addSubview(tempImgView)
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(typeLabel)
        
        tempImgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(18)
            maker.left.equalTo(contentView).offset(16)
            maker.width.equalTo(112)
            maker.height.equalTo(81)
        }
        
        tempTitleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(tempImgView)
            maker.left.equalTo(tempImgView.snp.right).offset(12)
            maker.right.equalTo(contentView).offset(-16)
        }
        
        typeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(tempImgView.snp.right).offset(12)
            maker.width.equalTo(71)
            maker.height.equalTo(20)
            maker.bottom.equalTo(tempImgView.snp.bottom)
        }
        
        let dianView:UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.hex("e6e6e6")
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 1.5
            return view
        }()
        self.contentView.addSubview(dianView)
        
        dianView.snp.makeConstraints { (maker) in
            maker.left.equalTo(typeLabel.snp.right).offset(7)
            maker.width.height.equalTo(3)
            maker.centerY.equalTo(typeLabel.snp.centerY)
        }
        
        timeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(typeLabel)
            maker.centerY.equalTo(dianView)
            maker.left.equalTo(dianView.snp.right).offset(7)
        }
        
        let line:UIView = {
            let titleLabel = UIView()
            titleLabel.backgroundColor = bgColor
            return titleLabel
        }()
        self.contentView.addSubview(line)
        line.snp.makeConstraints { (maker) in
            maker.top.equalTo(typeLabel.snp.bottom).offset(14)
            maker.left.equalTo(contentView).offset(16)
            maker.right.equalTo(contentView)
            maker.bottom.equalTo(contentView)
            maker.height.equalTo(1)
        }
    }
    
    func updata(dic:JSON) {
        tempTitleLabel.text = dic["title"].stringValue
        tempImgView.image = UIImage(named: "")
        tempImgView.downLoadImg(imgUrl: dic["media_logo"].stringValue, placeImg: "placeholderImage")
        typeLabel.text = "\(dic["name"])"
        timeLabel.text = GPWHelper.strFromDate(dic["add_time"].doubleValue, format: "yyyy-MM-dd")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
