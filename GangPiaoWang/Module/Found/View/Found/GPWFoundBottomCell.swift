//
//  GPWFoundBottomCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/8/18.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWFoundBottomCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        let  tempImgView = UIImageView(frame: CGRect(x: 0, y: 18, width: 88, height: 15))
        tempImgView.image = UIImage(named: "found_kddsy")
        tempImgView.centerX = SCREEN_WIDTH / 2
        self.contentView.addSubview(tempImgView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
