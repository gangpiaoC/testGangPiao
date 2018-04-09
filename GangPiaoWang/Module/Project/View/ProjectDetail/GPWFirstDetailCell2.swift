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
    
    weak private var superVC:UIViewController?
    private var clickUrl:String?
    //点击跳转到协议
    private var clickBtn:UIButton = {
        let btn = UIButton()
        return btn
    }()
    
    //距离顶部距离
    private var staticTopHeight: Constraint!
    
    //左侧标签
    private let leftLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.customFont(ofSize: 14)
        label.textColor = timeColor
        label.text = "起息方式"
        return label
    }()
    
    //右侧标签
    private let rightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 14)
        label.textColor = titleColor
        label.text = "立即起息"
        return label
    }()
    
    let markButton: UIButton = {
        let markButton = UIButton(type: .custom)
        markButton.isUserInteractionEnabled = false
        markButton.setImage(UIImage(named: "project_mark"), for: .normal)
        return markButton
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
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
        contentView.addSubview(markButton)
        contentView.addSubview(clickBtn)
        clickBtn.addTarget(self, action: #selector(self.click), for: .touchUpInside)
        
        leftLabel.snp.makeConstraints { (maker) in
           staticTopHeight = maker.top.equalTo(contentView).offset(16).constraint
            maker.left.equalTo(contentView).offset(16)
            maker.width.equalTo(60)
            maker.bottom.equalTo(contentView).offset(-16)
        }
        
        rightLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(leftLabel.snp.right).offset(19)
            maker.top.bottom.equalTo(leftLabel)
        }
        
        clickBtn.snp.makeConstraints { (maker) in
            maker.top.left.equalTo(rightLabel)
            maker.width.equalTo(200)
            maker.height.equalTo(15)
        }
        
        markButton.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(leftLabel)
            maker.centerX.equalTo(rightLabel.snp.right).offset(4 + 20)
            maker.width.height.equalTo(200)
        }
    }
    
    @objc func click()  {
        if leftLabel.text == "计息规则" {
             self.superVC?.navigationController?.pushViewController(GPWProjectIRuleController(), animated: true)
        }else if (self.clickUrl?.characters.count)! > 5 {
            let vc = GPWWebViewController(subtitle: "", url: self.clickUrl!)
            self.superVC?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setupCell(_ dict: [String: String],index:Int,superVC:UIViewController,url:String = "") {
        if index == 0 {
            staticTopHeight.update(offset: 16)
        }else{
            staticTopHeight.update(offset: 0)
        }
        leftLabel.text = dict["left"]
        rightLabel.text = dict["right"]
        self.superVC = superVC
        self.clickUrl = url
        
        if url.characters.count > 7 {
            rightLabel.textColor = urlColor
        }else{
             rightLabel.textColor = titleColor
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
