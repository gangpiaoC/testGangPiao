//
//  GPWGetFriendsThreeCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/3/9.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWGetFriendsThreeCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        let  imgView = UIImageView(frame: CGRect(x: pixw(p: 8), y: pixw(p: 28), width: pixw(p: 359), height: pixw(p: 88)))
        imgView.image = UIImage(named: "user_getfriends_info")
        self.contentView.addSubview(imgView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
