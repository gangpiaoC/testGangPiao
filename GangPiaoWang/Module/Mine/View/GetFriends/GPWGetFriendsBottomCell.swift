//
//  GPWGetFriendsBottomCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/3/10.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
typealias GPWGetFriendsCallBack = (Bool) -> Void
class GPWGetFriendsBottomCell: UITableViewCell {
 var friendsBottomCallBack: GPWGetFriendsCallBack?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let  imgView = UIImageView(frame: CGRect(x: pixw(p: 8), y: 0, width: SCREEN_WIDTH - pixw(p: 15), height: pixw(p: 91)))
        imgView.image = UIImage(named: "user_getfriends_bottom")
        self.contentView.addSubview(imgView)
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
