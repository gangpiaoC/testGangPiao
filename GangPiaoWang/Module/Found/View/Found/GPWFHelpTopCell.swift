//
//  GPWHomeSecTableViewCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/19.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWFHelpTopCell: UITableViewCell {
    
    var superControl:UIViewController?
    fileprivate var titleArray = [
                                                ["img":"found_help_kefu","title":"在线客服","detail":"专人为您解答"],
                                                ["img":"found_help_phone","title":"客服热线","detail":"400-900-9017"]
                                            ]
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        let topBlock = UIView(frame: CGRect(x: 0, y: 0 , width: SCREEN_WIDTH, height: 10))
        topBlock.backgroundColor = bgColor
        self.contentView.addSubview(topBlock)
        
        let timeLabel = UILabel(frame: CGRect(x: 0, y: topBlock.maxY, width: SCREEN_WIDTH, height: 52))
        timeLabel.attributedText = NSAttributedString.attributedBoldString( "服务时间：", mainColor: UIColor.hex("999999"), mainFont: 16, second: "工作日 9:30-18:30", secondColor: UIColor.hex("333333"), secondFont: 16)
        timeLabel.textAlignment = .center
        self.contentView.addSubview(timeLabel)
        
        let timeBlock = UIView(frame: CGRect(x: 16, y: timeLabel.height - 1 , width: SCREEN_WIDTH - 32, height: 1))
        timeBlock.backgroundColor = bgColor
        timeLabel.addSubview(timeBlock)
        
        for i in 0 ..< titleArray.count {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x:CGFloat(i) * SCREEN_WIDTH / 2, y: timeLabel.maxY, width: CGFloat(SCREEN_WIDTH / 2), height: 27 + 36 + 27)
            btn.setTitleColor(UIColor.hex("333333"), for: .normal)
            btn.tag = 1000 + i
            btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
            self.contentView.addSubview(btn)
            
            let  tempImgView = UIImageView(frame: CGRect(x: pixh(p: 20), y: 27, width: 36, height: 36))
            tempImgView.image = UIImage(named:titleArray[i]["img"]! )
            btn.addSubview(tempImgView)
            
            let titleLabel = UILabel(frame: CGRect(x: tempImgView.maxX + 14, y: tempImgView.y, width: 70, height: 16))
            titleLabel.text = titleArray[i]["title"]
            titleLabel.font = UIFont.customFont(ofSize: 16)
            titleLabel.textColor = UIColor.hex("999999")
            btn.addSubview(titleLabel)
            
            let detailLabel = UILabel(frame: CGRect(x: titleLabel.x, y: titleLabel.maxY + 8, width: 100, height: 14))
            detailLabel.text = titleArray[i]["detail"]
            detailLabel.font = UIFont.customFont(ofSize: 14)
            detailLabel.textColor = UIColor.hex("333333")
            btn.addSubview(detailLabel)
        }
        
        let block = UIView(frame: CGRect(x: SCREEN_WIDTH / 2, y: timeLabel.maxY + 8 , width: 1.5, height: 66))
        block.backgroundColor = bgColor
        self.contentView.addSubview(block)
        
        let bottomBlock = UIView(frame: CGRect(x: 0, y: 153, width: SCREEN_WIDTH, height: 10))
        bottomBlock.backgroundColor = bgColor
        self.contentView.addSubview(bottomBlock)
    }
    
    @objc func btnClick( _ sender:UIButton) {
        if sender.tag == 1000 {
            //在线客服
            self.myCustem()
        }else if sender.tag == 1001{
            //客服电话
            UIApplication.shared.openURL(URL(string: "tel://4009009017")!)
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
    
    func updata(dic:JSON,superControl:UIViewController) {
        self.superControl = superControl
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
