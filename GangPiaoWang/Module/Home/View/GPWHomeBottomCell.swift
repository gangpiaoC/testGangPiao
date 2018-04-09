//
//  GPWHomeBottomCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/11/25.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWHomeBottomCell: UITableViewCell {

    fileprivate let array = [
        ["img":"home_bottom_01","detail":"除非亲自尝试，否则你永远不知来自我的默默关心"],
        ["img":"home_bottom_02","detail":"你并不孤单，毕竟我还在你身边"],
        ["img":"home_bottom_03","detail":"看尘世沧海桑田，我就在这里，等你归来"],
        ["img":"home_bottom_04","detail":"关于未来，关于我，敬请期待"],
        ["img":"home_bottom_05","detail":"365天，钢宝儿在这里，为你守住每一分财富"],
        ["img":"home_bottom_06","detail":"时间和金钱，钢票网都在竭尽全力为您争取"]
    ]
    fileprivate var index = 0
    var imgView:UIImageView!
    var  bottomLabel:UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        imgView = UIImageView(frame: CGRect(x: 0, y: 4, width: 90, height: 90))
        imgView.image = UIImage(named:array[0]["img"]!)
        imgView.centerX = SCREEN_WIDTH / 2
        self.contentView.addSubview(imgView)

        bottomLabel = UILabel(frame: CGRect(x: 0, y: imgView.maxY - 4, width: SCREEN_WIDTH, height: 12))
        bottomLabel.font = UIFont.customFont(ofSize: 12)
        bottomLabel.text = array[0]["detail"]!
        bottomLabel.textAlignment = .center
        bottomLabel.textColor = UIColor.hex("999999")
        self.contentView.addSubview(bottomLabel)
    }

    func updata() {
        index = index + 1
        if index == array.count{
            index = 0
        }
        imgView.image = UIImage(named:array[index]["img"]!)
        bottomLabel.text = array[index]["detail"]!
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
