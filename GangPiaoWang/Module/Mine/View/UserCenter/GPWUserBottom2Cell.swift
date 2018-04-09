//
//  GPWUserBottom2Cell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/1/3.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWUserBottom2Cell: UITableViewCell {
    
    weak var superControl:UserController?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        let line = UIView(frame: CGRect(x: 270, y: 0, width: 0.5, height: 30))
        line.centerX = SCREEN_WIDTH / 2 + 69
        line.backgroundColor = UIColor.hex("999999", alpha: 0.8)
        self.contentView.addSubview(line)
        
        let  btn = UIButton(type: .custom)
        btn.frame =  CGRect(x: 0, y: line.maxY, width: 242, height: 30)
        btn.setImage(UIImage(named:"user_bottom_linekefu"), for: .normal)
        btn.centerX =  SCREEN_WIDTH / 2
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        self.contentView.addSubview(btn)
    }
    
    func  btnClick(){
        MobClick.event("mine", label: "在线客服")
        let initInfo = ZCLibInitInfo()
        initInfo.appKey = "0c7bf5fc11374541be663008ec7d4b8d"
        initInfo.nickName = GPWUser.sharedInstance().user_name ?? "未登录"
        initInfo.phone = GPWUser.sharedInstance().telephone ?? "未填写"
        let uiInfo = ZCKitInfo()
        uiInfo.info = initInfo
        
        //启动
        ZCSobot.startZCChatView(uiInfo, with: self.superControl?.navigationController, pageBlock: { (object, type) in
            
        }) { (msg) in
            
        }
    }
    func customer(kitInfo:ZCKitInfo)  {
        //点击返回是否出发满意度评价
        kitInfo.isOpenEvaluation = true
        //是否显示语音按钮
        kitInfo.isOpenRecord = true
        kitInfo.isShowTansfer = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
