//
//  GPWProjectIntroduceCell0Cell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/4/12.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SnapKit
class GPWProjectIntroduceCell0: UITableViewCell {
    private var staticbottomViewHeight: Constraint!
    private var staticTopViewHeight: Constraint!
     private var staticbottomTop: Constraint!
    private let bottomView = UIView()
    private let descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.lineBreakMode = .byWordWrapping
        descLabel.textColor = UIColor.hex("999999")
        descLabel.font = UIFont.customFont(ofSize: 14)
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
        
        
        let indictorView = GPWIndicatorView.indicatorView()
        contentView.addSubview(indictorView)
        
        let headerLabel = UILabel()
        headerLabel.font = UIFont.customFont(ofSize: 14)
        headerLabel.textColor = titleColor
        headerLabel.text = "产品描述"
        contentView.addSubview(headerLabel)
        contentView.addSubview(descLabel)
        
        let lineView = UIView()
        lineView.backgroundColor = bgColor
        contentView.addSubview(lineView)
        
        bottomView.backgroundColor = bgColor
        contentView.addSubview(bottomView)
        
        let arrowView = UIImageView(image: UIImage(named: "project_arrowUp"))
        bottomView.addSubview(arrowView)
        let toastLabel = createLabel("向上滑动，查看更多详情", color: timeColor, fontSize: 12)
        bottomView.addSubview(toastLabel)
        
        placeholderView.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView)
            maker.left.right.equalTo(contentView)
            staticTopViewHeight = maker.height.equalTo(8).constraint
        }
        
        indictorView.snp.makeConstraints { (maker) in
            maker.top.equalTo(placeholderView.snp.bottom).offset(17)
            maker.left.equalTo(contentView).offset(16)
            maker.height.equalTo(14)
            maker.width.equalTo(3)
        }
        
        headerLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(indictorView)
            maker.left.equalTo(indictorView.snp.right).offset(7)
            maker.right.equalTo(contentView)
        }
        
        descLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(headerLabel.snp.bottom).offset(12)
            maker.left.equalTo(headerLabel)
            maker.right.equalTo(contentView).offset(-16)
        }
        
        lineView.snp.makeConstraints { (maker) in
            maker.left.equalTo(contentView).offset(16)
            maker.right.equalTo(contentView).offset(-16)
            maker.height.equalTo(0.5)
            maker.bottom.equalTo(contentView)
        }
        
        bottomView.snp.makeConstraints { (maker) in
            staticbottomTop = maker.top.equalTo(descLabel.snp.bottom).offset(22).constraint
            maker.left.right.bottom.equalTo(contentView)
             staticbottomViewHeight = maker.height.equalTo(49).constraint
        }
        
        arrowView.snp.makeConstraints { (maker) in
            maker.top.equalTo(bottomView).offset(10)
            maker.centerX.equalTo(bottomView)
            maker.width.equalTo(16)
            maker.height.equalTo(7)
        }
        
        toastLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(arrowView.snp.bottom).offset(1)
            maker.centerX.equalTo(bottomView)
            maker.bottom.equalTo(bottomView).offset(-10)
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
    
    func update(desStr:String? = "",flag:Int? = 1)  {
        descLabel.text = desStr
        if flag == 2 {
            staticbottomViewHeight.update(offset: 0)
            bottomView.isHidden = true
            staticTopViewHeight.update(offset: 0)
            staticbottomTop.update(offset: 15)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
