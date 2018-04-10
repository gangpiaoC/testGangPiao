//
//  GPWFirstDetailCell4.swift
//  GangPiaoWang
//
//  Created by GC on 2018/4/10.
//  Copyright © 2018年 GC. All rights reserved.
//

import UIKit

class GPWFirstDetailCell4: UITableViewCell {
    
    let projectDetailButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "project_detail_projectDetail"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "project_detail_projectDetail"), for: .highlighted)
        button.setTitle("项目详情", for: .normal)
        button.setTitleColor(UIColor.hex("4f4f4f"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    let dangerControlButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "project_detail_dangerControl"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "project_detail_dangerControl"), for: .highlighted)
        button.setTitle("风险控制", for: .normal)
        button.setTitleColor(UIColor.hex("4f4f4f"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    let addRecordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "project_detail_addRecord"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "project_detail_addRecord"), for: .highlighted)
        button.setTitle("加入记录", for: .normal)
        button.setTitleColor(UIColor.hex("4f4f4f"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    let separateView = UIView(bgColor: UIColor.hex("f4f4f4"))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        contentView.addSubview(projectDetailButton)
        contentView.addSubview(dangerControlButton)
        contentView.addSubview(addRecordButton)
        contentView.addSubview(separateView)
        projectDetailButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        dangerControlButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        addRecordButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
        projectDetailButton.setButtonImageTitleStyle(.imagePositionTop, padding: 10)
        dangerControlButton.setButtonImageTitleStyle(.imagePositionTop, padding: 10)
        addRecordButton.setButtonImageTitleStyle(.imagePositionTop, padding: 10)
        
        projectDetailButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(26)
            maker.left.equalTo(contentView).offset(30)
        }
        dangerControlButton.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(contentView)
            maker.centerY.equalTo(projectDetailButton)
        }
        addRecordButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(contentView).offset(-30)
            maker.centerY.equalTo(projectDetailButton)
        }
        separateView.snp.makeConstraints { (maker) in
            maker.top.equalTo(projectDetailButton.snp.bottom).offset(26)
            maker.height.equalTo(10)
            maker.left.right.bottom.equalTo(contentView)
        }
    }

    func buttonAction(_ sender: UIButton) {
        switch sender {
        case projectDetailButton:
            break
        case dangerControlButton:
            break
        case addRecordButton:
            break
        default:
            break
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
