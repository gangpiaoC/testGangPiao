//
//  GPWUserBottom1Cell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/1/3.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWUserBottom1Cell: UITableViewCell {
    var  line:UIView!
    var superControl:UserController?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none

        line = UIView(frame: CGRect(x: 0, y:46 + 51 - 8 - 30,  width: 0.5, height: 50))
        line.centerX = SCREEN_WIDTH / 2 + 69
        line.backgroundColor = UIColor.hex("999999", alpha: 0.8)
        self.contentView.addSubview(line)

        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 78, y: 42, width: 183, height: 50)
        btn.setImage(UIImage(named: "user_tishi"), for: .normal)
        btn.centerX = SCREEN_WIDTH / 2
        btn.addTarget(self, action: #selector(self.btnClick), for: .touchUpInside)
        self.contentView.addSubview(btn)
    }

    //设置线是否隐藏
    func lineisHidden( _ flag:Bool) {
       line.isHidden = flag
    }
    func btnClick() {
        let index:IndexPath?
        MobClick.event("mine_chat", label: nil)
        if superControl?.flag == false {
            superControl?.flag = true
            index = IndexPath(row: 2, section: 4)
            superControl?.showTableView.reloadData()
            superControl?.showTableView.scrollToRow(at: index!, at:.bottom, animated:true)
        }else{
            superControl?.flag = false
            superControl?.showTableView.reloadData()
            index = IndexPath(row: 0, section: 4)
            superControl?.showTableView.scrollToRow(at: index!, at:.top, animated:true)
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
