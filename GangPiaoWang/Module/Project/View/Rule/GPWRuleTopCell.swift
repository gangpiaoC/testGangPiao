//
//  GPWRuleTopCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/3/24.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWRuleTopCell: UITableViewCell {

    private let coImgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "project_role_top")
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        commonInitialize()
    }
    
    private func commonInitialize() {
        contentView.addSubview(coImgView)
        contentView.snp.remakeConstraints { (make) in
            make.top.equalTo(0)
            make.width.equalTo(SCREEN_WIDTH)
            make.height.equalTo(129)
        }
        coImgView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(38)
            make.centerX.equalTo(SCREEN_WIDTH / 2)
            make.width.equalTo(295)
            make.height.equalTo(59)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
