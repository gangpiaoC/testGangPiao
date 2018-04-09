//
//  GPWHomeSecTableViewCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/19.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWFoundFourCell: UITableViewCell {
    
    var superControl:UIViewController?
    let array = [
        ["img":"found_school","title":"钢票学院"],
        ["img":"found_help","title":"帮助中心"]
    ]
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        for i in 0 ..< array.count {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: CGFloat(i) * SCREEN_WIDTH / 2, y: 0, width: SCREEN_WIDTH / 2 , height: 96)
            btn.tag = 10000 + i
            btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
            self.contentView.addSubview(btn)
            
            let titleLabel = UILabel(frame: CGRect(x:pixw(p: 28), y: 0, width: 70, height: 16))
            titleLabel.text = array[i]["title"]
            titleLabel.font = UIFont.customFont(ofSize: 16)
            titleLabel.centerY = btn.height / 2
            titleLabel.textColor = UIColor.hex("666666")
            btn.addSubview(titleLabel)
            
            let imgView = UIImageView(frame: CGRect(x: titleLabel.maxX + 9, y: 0, width: 65, height: 50))
            imgView.image = UIImage(named: array[i]["img"]!)
            imgView.centerY = titleLabel.centerY
            btn.addSubview(imgView)
            
        }
        
        let block = UIView(frame: CGRect(x: SCREEN_WIDTH / 2, y: 0 , width: 1, height: 96))
        block.backgroundColor = bgColor
        self.contentView.addSubview(block)
        
        
        let bottom = UIView(frame: CGRect(x: 0, y: 96 , width: SCREEN_WIDTH, height: 10))
        bottom.backgroundColor = bgColor
        self.contentView.addSubview(bottom)
    }
    
    func btnClick( _ sender:UIButton) {
        if sender.tag == 10000 {
            //钢票学院
             MobClick.event("found", label: "钢票学院")
            self.superControl?.navigationController?.pushViewController(GPWVFschooliewController(), animated: true)
        }else if sender.tag == 10001{
            //帮助中心
             MobClick.event("found", label: "帮助中心")
            self.superControl?.navigationController?.pushViewController(GPWFHelpViewController(), animated: true)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
