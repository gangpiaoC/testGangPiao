//
//  GPWFirstDetailCell2.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/20.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SnapKit

class GPWFirstDetailCell2: UITableViewCell {
    
    let leftImgView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "project_detail_ asset"))
    
    private let rightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 16)
        label.textColor = UIColor.hex("4f4f4f")
        label.text = "资产来自于央企、国企、上市公司"
        return label
    }()
    
    let lineView = UIView(bgColor: UIColor.hex("f2f2f2"))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        contentView.addSubview(leftImgView)
        contentView.addSubview(rightLabel)
        contentView.addSubview(lineView)
        
        leftImgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(contentView).offset(16)
            maker.centerY.equalTo(rightLabel)
        }
        
        rightLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
        rightLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 249), for: .horizontal)
        rightLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(leftImgView.snp.right).offset(12)
            maker.top.equalTo(contentView).offset(22)
            maker.right.equalTo(contentView).offset(-16)
        }
        
        lineView.snp.makeConstraints { (maker) in
            maker.top.equalTo(rightLabel.snp.bottom).offset(22)
            maker.left.equalTo(contentView).offset(16)
            maker.right.equalTo(contentView)
            maker.height.equalTo(1)
            maker.bottom.equalTo(contentView)
        }
        
    }
    
    func setupCell(dict: [String: Any]) {
        leftImgView.image = dict["img"] as? UIImage
        rightLabel.text = dict["text"] as? String
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
