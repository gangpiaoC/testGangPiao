//
//  GPWUserBottom3Cell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/3/6.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWUserBottom3Cell: UITableViewCell  {
    
    weak var superControl:UserController?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        let line = UIView(frame: CGRect(x:  270, y:  -1, width: 0.5, height:  11))
        line.backgroundColor = UIColor.hex("999999", alpha: 0.8)
        line.centerX = SCREEN_WIDTH / 2 + 69
        self.contentView.addSubview(line)
        
        let  btn = UIButton(type: .custom)
        btn.frame =  CGRect(x: 0, y: line.maxY - 1, width: 242, height: 30)
        btn.setImage(UIImage(named:"user_bottom_kefu"), for: .normal)
        btn.centerX =  SCREEN_WIDTH / 2
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.contentView.addSubview(btn)
    }
    @objc func btnClick(){
        MobClick.event("mine", label: "客服电话")
        UIApplication.shared.openURL(URL(string: "tel://4009009017")!)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
