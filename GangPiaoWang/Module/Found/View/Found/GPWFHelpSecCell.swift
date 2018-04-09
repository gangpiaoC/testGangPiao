//
//  GPWHomeSecTableViewCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/19.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWFHelpSecCell: UITableViewCell {
    
    var superControl:UIViewController?
    var dataDic:JSON?
    fileprivate var btnArray = [UIButton]()
    let array = [
                      [
                        ["img":"found_help_bd","title":"必读"],
                        ["img":"found_help_zc","title":"注册"],
                        ["img":"found_help_cj","title":"出借"]
                    ],
                    [
                        ["img":"found_help_cz","title":"充值"],
                        ["img":"found_help_zh","title":"账户"],
                        ["img":"found_help_mc","title":"名词"]
                    ]
                ]
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        let btnWith = SCREEN_WIDTH / 3
        let  btnHeight:CGFloat = 94
        for i in 0 ..< 2 {
            for j in 0 ..< 3 {
                let btn = UIButton(type: .custom)
                btn.frame = CGRect(x: btnWith * CGFloat(j), y: btnHeight * CGFloat(i), width: btnWith, height: btnHeight)
                btn.tag = 100 + i * 3 + j
                btn.addTarget(self, action: #selector(self.btnClick(sender:)), for: .touchUpInside)
                self.contentView.addSubview(btn)
                btnArray.append(btn)
                
                let bgImgView = UIImageView(frame: CGRect(x: 0, y: 15, width: 44, height: 44))
                bgImgView.image = UIImage(named: "found_help_oval")
                bgImgView.centerX = btn.width / 2
                bgImgView.tag = 1000
                btn.addSubview(bgImgView)
                
                if btn.tag == 100 {
                    bgImgView.isHidden = false
                }else{
                    bgImgView.isHidden = true
                }
                
                let imgView = UIImageView(frame: CGRect(x: 36, y: 18, width: 30, height: 30))
                imgView.image = UIImage(named: array[i][j]["img"]!)
                imgView.center = bgImgView.center
                btn.addSubview(imgView)
                
                let titleLabel = UILabel(frame: CGRect(x: 0, y: imgView.maxY + 12, width: btn.width, height: 16))
                titleLabel.text = array[i][j]["title"]
                titleLabel.tag = 1001
                titleLabel.font = UIFont.customFont(ofSize: 16)
                titleLabel.textAlignment = .center
                titleLabel.textColor = UIColor.hex("666666")
                btn.addSubview(titleLabel)
            }
        }
        let line = UIView(frame: CGRect(x: 0, y: 188 - 1, width: SCREEN_WIDTH, height: 1))
        line.backgroundColor = bgColor
        self.contentView.addSubview(line)
    }
    
    @objc func btnClick(sender:UIButton) {
        for btn in btnArray {
            let tempImgView = btn.viewWithTag(1000) as! UIImageView
            tempImgView.isHidden = true
            let tempLabel = btn.viewWithTag(1001) as! UILabel
            tempLabel.textColor = UIColor.hex("666666")
        }
        
        //设置选中状态
        let tempImgView = sender.viewWithTag(1000) as! UIImageView
        tempImgView.isHidden = false
        let tempLabel = sender.viewWithTag(1001) as! UILabel
        tempLabel.textColor = UIColor.hex("f5a623")
        var type = "bidu"
        if sender.tag == 100 {
            //必读
            type = "bidu"
        }else if sender.tag == 101 {
            //注册
            type = "zhuce"
        }else if sender.tag == 102 {
            //出借
            type = "chujie"
        }else if sender.tag == 103 {
            //充值
            type = "chongzhi"
        }else if sender.tag == 104 {
            //账户
            type = "zhanghu"
        }else if sender.tag == 105 {
            //名词
            type = "mingci"
        }
        let controller = self.superControl as! GPWFHelpViewController
        controller.changeArray(type: type)
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
