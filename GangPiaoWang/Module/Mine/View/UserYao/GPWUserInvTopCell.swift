//
//  GPWUserInvTopCell.swift
//  GangPiaoWang
//  我的邀请码顶部
//  Created by gangpiaowang on 2017/1/3.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWUserInvTopCell: UITableViewCell {

    //邀请码
    var numLabel:UILabel!
    //事件链接
    var inUrl:String?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let tempLabel = UILabel(frame: CGRect(x: 44, y: 23, width: 83, height: 22))
        tempLabel.text = "我的邀请码"
        tempLabel.font = UIFont.customFont(ofSize: 16)
        tempLabel.textColor = UIColor.hex("333333")
        self.contentView.addSubview(tempLabel)
        
        numLabel = UILabel(frame: CGRect(x: tempLabel.maxX + 20, y: tempLabel.y, width: 120, height: 22))
        numLabel.text = "[363724]"
        numLabel.font = UIFont.customFont(ofSize: 16)
        numLabel.textColor = UIColor.hex("333333")
        self.contentView.addSubview(numLabel)
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: SCREEN_WIDTH - 40 - 76, y: 0, width: 76, height: 27)
        btn.setTitle("立即邀请", for: .normal)
        btn.centerY = numLabel.centerY
        btn.titleLabel?.font = UIFont.customFont(ofSize: 14)
        btn.backgroundColor = UIColor.hex("f5441b")
        btn.addTarget(self, action: #selector(self.btnClick), for: .touchUpInside)
        self.contentView.addSubview(btn)
        
        let  line = UIView(frame: CGRect(x: 16, y: 63 - 0.5, width: SCREEN_WIDTH - 32, height: 0.5))
        line.backgroundColor = bgColor
        self.contentView.addSubview(line)
    }
    
    func updata(intaNum:String, inUrl:String) {
        numLabel.text = "[\(intaNum)]"
        self.inUrl = inUrl
    }
    @objc func btnClick() {
        if let url = self.inUrl {
            let navController = GPWHelper.selectedNavController()
            if let navC = navController {
                for vc in navC.viewControllers {
                    if vc.isKind(of: GPWWebViewController.self) {
                        _ = navC.popViewController(animated: true)
                        return
                    }
                }
            }
            navController?.pushViewController(GPWWebViewController(subtitle: "", url: url + "?user_id=\(GPWUser.sharedInstance().user_id!)"), animated: true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
