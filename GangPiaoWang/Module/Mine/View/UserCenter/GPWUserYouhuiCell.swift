//
//  GPWUserYouhuiCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/11/17.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWUserYouhuiCell: UITableViewCell {

    weak var superControl:UIViewController?
    let array = [
        ["img":"user_menu_hongbao","title":"红包","num":"120元"],
        ["img":"user_menu_jiaxi","title":"加息券","num":"5张"],
        ["img":"user_menu_tiyan","title":"体验金","num":"58,888元"]
    ]
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let btnWith = SCREEN_WIDTH / CGFloat(array.count)
        for i in 0..<array.count {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: btnWith * CGFloat(i), y: 0, width: btnWith, height: 105)
            btn.tag = 100 + i
            btn.addTarget(self, action: #selector(self.btnClick(sender:)), for: .touchUpInside)
            self.contentView.addSubview(btn)

            let imgView = UIImageView(frame: CGRect(x: 0, y: 21, width: 31, height: 25))
            imgView.image = UIImage(named: array[i]["img"]!)
            imgView.centerX = btn.width / 2
            btn.addSubview(imgView)

            let titleLabel = UILabel(frame: CGRect(x: 0, y: imgView.maxY + 5, width: btn.width, height: 15))
            titleLabel.text = array[i]["title"]
            titleLabel.font = UIFont.customFont(ofSize: 14)
            titleLabel.textAlignment = .center
            titleLabel.textColor = UIColor.hex("999999")
            btn.addSubview(titleLabel)

            let numLabel = UILabel(frame: CGRect(x: 0, y: titleLabel.maxY + 7, width: btn.width, height: 15))
            numLabel.text = array[i]["num"]
            numLabel.font = UIFont.customFont(ofSize: 14)
            numLabel.textAlignment = .center
            numLabel.tag = 1000
            numLabel.textColor = UIColor.hex("666666")
            btn.addSubview(numLabel)
        }

        let block = UIView(frame: CGRect(x: 0, y: 105, width: SCREEN_WIDTH, height: 10))
        block.backgroundColor = bgColor
        self.contentView.addSubview(block)
    }

    func updata() {
        let  redLabel = self.contentView.viewWithTag(100)?.viewWithTag(1000) as! UILabel
        redLabel.text = "\(GPWUser.sharedInstance().data_award)元"
        let  jiaxiLabel = self.contentView.viewWithTag(101)?.viewWithTag(1000) as! UILabel
        jiaxiLabel.text = "\(GPWUser.sharedInstance().data_ticket)张"
        let  tiyanLabel = self.contentView.viewWithTag(102)?.viewWithTag(1000) as! UILabel
        tiyanLabel.text = "\(GPWUser.sharedInstance().data_exper)元"
    }

    @objc func btnClick(sender:UIButton) {
        if sender.tag == 100 {
            MobClick.event("mine", label: "菜单栏-红包")
        }else if sender.tag == 101 {
            MobClick.event("mine", label: "菜单栏-加息券")
        }else if sender.tag == 102 {
            MobClick.event("mine", label: "菜单栏-体验金")
        }
        let  tempControl = UserRewardViewController()
        tempControl._startIndex = sender.tag - 100
        self.superControl?.navigationController?.pushViewController(tempControl, animated: true)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
