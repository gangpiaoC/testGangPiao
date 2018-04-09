//
//  GPWFirstDetailCell3.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/20.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

class GPWFirstDetailCell3: UITableViewCell {
    private let bottomView = UIView()
    private var timeLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.lineBreakMode = .byWordWrapping
        descLabel.textColor = UIColor.hex("666666")
        descLabel.font = UIFont.customFont(ofSize: 12)
        descLabel.numberOfLines = 0
        return descLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        //顶部横条
        let placeholderView = UIView()
        placeholderView.backgroundColor = bgColor
        contentView.addSubview(placeholderView)
        
        let titleArray = ["开始计息","收益到期日","提现到账"]
        let timeArray = ["加入成功立即起息","2017-08-12","T+1工作日"]
        let pointX = [SCREEN_WIDTH / 6 ,SCREEN_WIDTH / 2 ,SCREEN_WIDTH / 6 * 5 ]
        
        for i in 0 ..< 3 {
            let img1View = UIImageView()
            img1View.image = UIImage(named: "project_detail_time\(i)")
            contentView.addSubview(img1View)
            
            img1View.snp.makeConstraints { (maker) in
                maker.top.equalTo(placeholderView.snp.bottom).offset(24)
                maker.width.height.equalTo(54)
                maker.centerX.equalTo(pointX[i])
            }
            
            if i < 2 {
                let tempImgView = UIImageView()
                tempImgView.image = UIImage(named: "project_detail_jiantou")
                contentView.addSubview(tempImgView)
                tempImgView.snp.makeConstraints({ (maker) in
                    maker.centerY.equalTo(img1View)
                    maker.centerX.equalTo(pointX[i] + SCREEN_WIDTH / 6)
                })
            }
            
            let  title1Label = UILabel()
            title1Label.textColor = UIColor.hex("333333")
            title1Label.textAlignment = .center
            title1Label.text = titleArray[i]
            title1Label.font = UIFont.systemFont(ofSize: 14)
            contentView.addSubview(title1Label)
            title1Label.snp.makeConstraints { (maker) in
                maker.centerX.equalTo(img1View)
                maker.top.equalTo(img1View.snp.bottom).offset(15)
            }
            
            if i == 1 {
                timeLabel = UILabel()
                timeLabel.textColor = UIColor.hex("666666")
                timeLabel.textAlignment = .center
                timeLabel.text = timeArray[i]
                timeLabel.font = UIFont.systemFont(ofSize: 12)
                contentView.addSubview(timeLabel)
                timeLabel.snp.makeConstraints { (maker) in
                    maker.centerX.equalTo(img1View)
                    maker.top.equalTo(title1Label.snp.bottom).offset(6)
                    maker.bottom.equalTo(contentView).offset(-20)
                }
                
            }else{
                let  time1Label = UILabel()
                time1Label.textColor = UIColor.hex("666666")
                time1Label.textAlignment = .center
                time1Label.text = timeArray[i]
                time1Label.font = UIFont.systemFont(ofSize: 12)
                contentView.addSubview(time1Label)
                time1Label.snp.makeConstraints { (maker) in
                    maker.centerX.equalTo(img1View)
                    maker.top.equalTo(title1Label.snp.bottom).offset(6)
                    maker.bottom.equalTo(contentView).offset(-20)
                }
            }
        }
        
        placeholderView.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(10)
            maker.left.right.equalTo(contentView)
            maker.height.equalTo(8)
        }
    }
    
    private func createLabel(_ title: String, color: UIColor = titleColor, fontSize: CGFloat = 14) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = color
        label.font = UIFont.customFont(ofSize: fontSize)
        label.text = title
        return label
    }
    
    func update(desStr:String?)  {
        timeLabel.text = desStr
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
