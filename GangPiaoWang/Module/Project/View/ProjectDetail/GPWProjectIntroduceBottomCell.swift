//
//  GPWProjectIntroduceBottomCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/6/13.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWProjectIntroduceBottomCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        let bottomView = UIView()
        contentView.addSubview(bottomView)
        
        let arrowView = UIImageView(image: UIImage(named: "project_arrowUp"))
        bottomView.addSubview(arrowView)
        let toastLabel = createLabel("向上滑动，查看更多详情", color: timeColor, fontSize: 12)
        bottomView.addSubview(toastLabel)
        
        bottomView.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(18)
            maker.left.right.bottom.equalTo(contentView)
            maker.height.equalTo(49)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createLabel(_ title: String, color: UIColor = titleColor, fontSize: CGFloat = 14) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = color
        label.font = UIFont.customFont(ofSize: fontSize)
        label.text = title
        return label
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
