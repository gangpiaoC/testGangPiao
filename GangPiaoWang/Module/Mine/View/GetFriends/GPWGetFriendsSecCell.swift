//
//  GPWGetFriendsSecCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/3/9.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWGetFriendsSecCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    func updata(array:[String]) {
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        let bgImgView = UIImageView(frame: CGRect(x: pixw(p: 10), y: 0, width: pixw(p: 357), height: pixw(p:235)))
        bgImgView.centerX = SCREEN_WIDTH / 2
        bgImgView.image = UIImage(named: "user_getfriends_tongji")
        self.backgroundColor = UIColor.clear
        self.contentView.addSubview(bgImgView)
        let withArray = [pixw(p: 0),pixw(p: 60) ,pixw(p: 108),pixw(p: 92)]
        for  i  in 0 ..< 3{
            for  j  in 0 ..< 3{
                var with = pixw(p: 87)
                for k in  0 ... j {
                    with = with + withArray[k]
                }
                let  numLabel = UILabel(frame: CGRect(x:with , y: pixw(p: 107) + CGFloat(i) * pixw(p: 38), width: withArray[j + 1], height: pixw(p: 38)))
                if i * 3 + j < array.count{
                    numLabel.text = array[i * 3 + j]
                }else{
                    numLabel.text = ""
                }
                
                numLabel.textAlignment = .center
                numLabel.font = UIFont.customFont(ofSize: 14)
                numLabel.textColor = UIColor.hex("111111")
                bgImgView.addSubview(numLabel)
            }
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
