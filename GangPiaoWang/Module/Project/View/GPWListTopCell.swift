//
//  GPWListTopCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/7/10.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SnapKit
class GPWListTopCell: UITableViewCell {
    private var titleLabelX: Constraint!
    let tempImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "project_list_hengfeng")
        return imgView
    }()
    let titleImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "project_list_hengfeng")
        return imgView
    }()
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = titleColor
        titleLabel.text = "银行存管"
        titleLabel.font = UIFont.customFont(ofSize: 16.0)
        return titleLabel
    }()
    
    let moreLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.hex("666666")
        titleLabel.text = "更多"
        titleLabel.font = UIFont.customFont(ofSize: 14.0)
        return titleLabel
    }()
    
    let rightImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "user_center_topright")
        return imgView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        commonInitialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func commonInitialize() {
        let topView: UIView = {
            let view = UIView()
            view.backgroundColor = bgColor
            return view
        }()
        contentView.addSubview(topView)
        contentView.addSubview(tempImgView)
        contentView.addSubview(titleImgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(moreLabel)
        contentView.addSubview(rightImgView)
        let bottomView: UIView = {
            let view = UIView()
            view.backgroundColor = bgColor
            return view
        }()
        contentView.addSubview(bottomView)
        
        topView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(contentView)
            maker.height.equalTo(10)
        }
        
        titleImgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(topView.snp.bottom).offset(16)
            maker.left.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(topView.snp.bottom).offset(16)
            titleLabelX = maker.left.equalTo(titleImgView.snp.right).offset(6).constraint
            maker.bottom.equalTo(contentView).offset(-16)
        }
        
        tempImgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(contentView).offset(16)
            maker.centerY.equalTo(titleLabel)
        }
        
       
        rightImgView.snp.makeConstraints { (maker) in
            maker.right.equalTo(contentView).offset(-16)
            maker.centerY.equalTo(titleLabel)
        }
        
        moreLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(rightImgView.snp.left).offset(-7)
            maker.centerY.equalTo(rightImgView)
        }
        
        let bottomLine: UIView = {
            let view = UIView()
            view.backgroundColor = lineColor
            return view
        }()
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(contentView)
            maker.height.equalTo(0.5)
        }
        
    }
    /*
     showImg:          是否展示图片
     title:                  标题
     moreHidden:     更多按钮 是否隐藏
     rightimgHidden:右侧图片是否隐藏
     */
    func setupdata( _ showImg:Bool,_ title:String, _ moreHidden:Bool, _ rightimgHidden:Bool, _ titleImg:String){
        titleLabel.text = title
        tempImgView.isHidden = showImg
        titleImgView.image = UIImage(named: titleImg)
        if showImg  {
            titleImgView.isHidden = false
            titleLabelX.update(offset: 6)
        }else{
            titleImgView.isHidden = true
            titleLabelX.update(offset: 40)
        }
        
       moreLabel.isHidden = moreHidden
    rightImgView.isHidden = rightimgHidden
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
