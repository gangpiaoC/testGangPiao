//
//  GPWHomeSecTableViewCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/19.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
class GPWFoundSecCell: UITableViewCell {
    
    var superControl:UIViewController?
    fileprivate var userStory:String?
     fileprivate var teamStory:String?
    let array = [
                  ["img":"found_sec_action","title":"热门活动"],
                  ["img":"found_sec_school","title":"钢票学院"],
                  ["img":"found_sec_user","title":"用户故事"],
                  ["img":"found_sec_team","title":"团队故事"]
                ]
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let btnWith = SCREEN_WIDTH / CGFloat(array.count)
        for i in 0..<array.count {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x:btnWith * CGFloat(i), y: 0, width: btnWith, height: 93)
            btn.tag = 100 + i
            btn.addTarget(self, action: #selector(self.btnClick(sender:)), for: .touchUpInside)
            self.contentView.addSubview(btn)
            
            let imgView = UIImageView(frame: CGRect(x: 36, y: 10, width: 40, height: 40))
            imgView.image = UIImage(named: array[i]["img"]!)
            imgView.centerX = btn.width / 2
            btn.addSubview(imgView)
            
            let titleLabel = UILabel(frame: CGRect(x: 0, y: imgView.maxY + 8, width: btn.width, height: 16))
            titleLabel.text = array[i]["title"]
            titleLabel.font = UIFont.customFont(ofSize: 14)
            titleLabel.textAlignment = .center
            titleLabel.textColor = UIColor.hex("666666")
            btn.addSubview(titleLabel)
        }
    }
    
    func updata(userStory:String,teamStory:String,superControl:UIViewController) {
        self.userStory = userStory
        self.teamStory = teamStory
        self.superControl = superControl
    }
    
    @objc func btnClick(sender:UIButton) {
        if sender.tag == 100 {
            MobClick.event("found", label: "菜单-热门活动")
             self.superControl?.navigationController?.pushViewController(GPWActiveViewController(), animated: true)
        }else if sender.tag == 101 {
            MobClick.event("found", label: "菜单-钢票学院")
            self.superControl?.navigationController?.pushViewController(GPWVFschooliewController(), animated: true)
        }else if sender.tag == 102 {
            MobClick.event("found", label: "菜单-用户故事")
            self.superControl?.navigationController?.pushViewController(GPWWebViewController(subtitle: "", url: self.userStory ?? ""), animated: true)
        }else if sender.tag == 103 {
            MobClick.event("found", label: "菜单-团队故事")
                        self.superControl?.navigationController?.pushViewController(GPWWebViewController(subtitle: "", url: self.teamStory ?? ""), animated: true)
        }
    }
    
    //我的客服
    func  myCustem(){
        printLog(message: "客服")
        MobClick.event("mine_chat", label: "客服")
        let initInfo = ZCLibInitInfo()
        initInfo.appKey = "0c7bf5fc11374541be663008ec7d4b8d"
        initInfo.nickName = GPWUser.sharedInstance().user_name ?? "未登录"
        initInfo.phone = GPWUser.sharedInstance().telephone ?? "未填写"
        let uiInfo = ZCKitInfo()
        // self.customer(kitInfo: uiInfo)
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
    }

}
