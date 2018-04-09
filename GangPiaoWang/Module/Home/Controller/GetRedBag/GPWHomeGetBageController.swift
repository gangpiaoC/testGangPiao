//
//  GPWHomeGetBageController.swift
//  GangPiaoWang
//  拼手气
//  Created by gangpiaowang on 2017/7/21.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWHomeGetBageController: GPWSecBaseViewController {
    
    //背景图
    fileprivate var  bgimgView:UIImageView!
   
    //规则视图tag
    fileprivate let ROLEVIEWTAG = 1000
    
    //今日还有几次机会
    fileprivate var chanceLabel:UILabel!
    
    //底部图片
    fileprivate var  bottomImgView:UIImageView!
    
    //滚动视图
    fileprivate var  scrollview:InvestScrollView!
    
    //可抽奖次数
     fileprivate var  num:Int!
    
    //人数
    fileprivate var numLabel:UILabel!
    
    //抢按钮
   fileprivate var  qiangBtn:UIButton!
    
    //滑动视图
      fileprivate var  bgScrollview:UIScrollView!
    
    //中奖数组
    fileprivate var dicArray:[String]?
    
    //中奖人数
    fileprivate var  count:Int?
    
    //获得的奖品
    fileprivate var prizeDic:JSON?
    
    //底部视图
    fileprivate var bottomView:UIView!
    
    //每日可抢可抽奖次数
    fileprivate var allnumber:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "拼手气"
        num = 2
        allnumber = 2
        dicArray = [String]()
        self.getNetData()
    }

    override func getNetData() {
        GPWNetwork.requetWithGet(url: Gredred_moneylist, parameters: nil, responseJSON: { [weak self] (json, msg) in
            printLog(message: json)
            guard let strongSelf = self else { return }
            strongSelf.num = json["number"].intValue
            strongSelf.count = json["count"].intValue
            strongSelf.allnumber = json["allnumber"].intValue
            strongSelf.dicArray?.removeAll()
            for tempDic in json["data"].arrayValue {
                strongSelf.dicArray?.append("<font size=14 color='#ffffff'>拼友\(tempDic["telephone"])获得    \(tempDic["content"])</font>")
            }
            strongSelf.initView()
            if strongSelf.num == 0 {
                strongSelf.qiangBtn.isHidden = true
                strongSelf.chanceLabel.width = pixw(p: 200)
                strongSelf.chanceLabel.centerX = SCREEN_WIDTH / 2
                strongSelf.chanceLabel.text = "今天机会已用完，明天再来哦"
                strongSelf.bgimgView.image = UIImage(named: "home_getbag_end_bg")
                strongSelf.showTodayPrize()
            }
        }) { (error) in

        }
    }

    func initView()  {
        bgScrollview = UIScrollView(frame: self.bgView.bounds)
        bgScrollview.backgroundColor = UIColor.clear
        self.bgView.addSubview(bgScrollview)
        
        //背景图片
        bgimgView = UIImageView(frame: self.bgView.bounds)
        bgimgView.image = UIImage(named: "home_getbag_bg")
        bgimgView.contentMode = .scaleAspectFill
        bgScrollview.addSubview(bgimgView)
        

        
        //顶部图片
        let  bgtopImgView = UIImageView(frame: CGRect(x: 0, y: pixh(p: 68), width: pixw(p: 272), height: pixw(p: 133)))
        bgtopImgView.centerX = SCREEN_WIDTH / 2
        bgtopImgView.image = UIImage(named: "home_getbag_top")
        bgScrollview.addSubview(bgtopImgView)
        
        chanceLabel = UILabel(frame: CGRect(x: 0, y: bgtopImgView.maxY + pixh(p: 15), width: pixw(p: 150), height: pixw(p: 20)))
        chanceLabel.textColor = UIColor.hex("ffffff")
        chanceLabel.font = UIFont.customFont(ofSize: pixw(p: 14))
        chanceLabel.text = "您今日还有 \(num!) 次机会"
        chanceLabel.textAlignment = .center
        chanceLabel.backgroundColor = UIColor.hex("7700ad")
        chanceLabel.centerX = SCREEN_WIDTH / 2
        chanceLabel.layer.masksToBounds = true
        chanceLabel.layer.cornerRadius = chanceLabel.height / 2
        bgScrollview.addSubview(chanceLabel)
        
        //规则按钮
        let  roleBtn = UIButton(type: .custom)
        roleBtn.frame = CGRect(x: SCREEN_WIDTH - pixw(p: 52), y: pixh(p: 144), width: pixw(p: 52), height: pixw(p: 28))
        roleBtn.setImage(UIImage(named:"home_getbag_role"), for: .normal)
        roleBtn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        roleBtn.tag = 100
        bgScrollview.addSubview(roleBtn)
        
        qiangBtn = UIButton(type: .custom)
        qiangBtn.frame = CGRect(x: 0, y: bgtopImgView.maxY + pixh(p: 45), width: pixw(p: 180), height: pixw(p: 180))
        qiangBtn.setImage(UIImage(named:"home_getbag_qiang"), for: .normal)
        qiangBtn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        qiangBtn.tag = 101
        qiangBtn.centerX = SCREEN_WIDTH / 2
        bgScrollview.addSubview(qiangBtn)
        
        let  animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.5
        animation.repeatCount = HUGE
        animation.autoreverses = true
        animation.fromValue = NSNumber(value: 1.0)
        animation.toValue = NSNumber(value: 1.1)
        qiangBtn.layer.add(animation, forKey: "scale-layer")
        
        bottomView = UIView(frame: CGRect(x: 0, y: qiangBtn.maxY + pixh(p: 7), width: SCREEN_WIDTH, height: 0))
        bottomView.backgroundColor = UIColor.clear
        bgScrollview.addSubview(bottomView)
        
        numLabel = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: pixw(p: 18)))
        numLabel.textColor = UIColor.hex("ffffff")
        numLabel.font = UIFont.customFont(ofSize: pixw(p: 16))
        numLabel.text = "已有\(self.count ?? 0)位用户获得拼手气大礼"
        numLabel.textAlignment = .center
        bottomView.addSubview(numLabel)
        
        //底部图片
        bottomImgView = UIImageView(frame: CGRect(x: pixw(p: 23), y: numLabel.maxY + pixh(p: 14), width: SCREEN_WIDTH - pixw(p: 23) * 2 , height: pixh(p: 120)))
        bottomImgView.centerX = SCREEN_WIDTH / 2
        bottomImgView.image = UIImage(named: "home_getbag_bottom")
        bottomView.addSubview(bottomImgView)
        
        scrollview = InvestScrollView(frame: CGRect(x: 30, y: 20, width: bottomImgView.width - 30*2, height: bottomImgView.height - 20 * 2))
        scrollview.investArray = self.dicArray
        bottomImgView.addSubview(scrollview)
        
        let  temp1Label = UILabel(frame: CGRect(x: 0, y: bottomImgView.maxY + 15, width: bottomView.width, height: 12))
        temp1Label.textAlignment = .center
        temp1Label.textColor = UIColor.white
        temp1Label.text = "此活动由钢票网提供"
        temp1Label.font = UIFont.customFont(ofSize: 12)
        bottomView.addSubview(temp1Label)
        
        let  temp2Label = UILabel(frame: CGRect(x: 0, y: temp1Label.maxY + 3, width: bottomView.width, height: 12))
        temp2Label.textAlignment = .center
        temp2Label.textColor = UIColor.white
        temp2Label.text = "与设备生产商Apple Inc.公司无关"
        temp2Label.font = UIFont.customFont(ofSize: 12)
        bottomView.addSubview(temp2Label)
        
        bottomView.height = temp2Label.maxY + 15
        bgimgView.height = bottomView.maxY
        bgScrollview.contentSize = CGSize(width: SCREEN_WIDTH, height: bottomView.maxY)
    }
    @objc fileprivate func btnClick( _ sender:UIButton){
        if sender.tag == 100 {
            //规则
            self.roleClick()
        }else if sender.tag == 101 {
            //抢红包
            self.showrRedBags()
        }
    }
    
    //规则
    func roleClick() {
        let tempView = UIView(frame: bgScrollview.bounds)
        tempView.backgroundColor = UIColor.hex("000000", alpha: 0.6)
        tempView.tag = ROLEVIEWTAG
        bgScrollview.addSubview(tempView)
        
        let roleBgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 320, height: 183))
        roleBgView.image = UIImage(named: "home_getbag_role_bg")
        roleBgView.center = tempView.center
        tempView.addSubview(roleBgView)
        
        let titleImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 104, height: 33))
        titleImgView.image = UIImage(named: "home_getbag_role_title")
        titleImgView.centerX = roleBgView.centerX
        titleImgView.centerY = roleBgView.y + 11
        tempView.addSubview(titleImgView)
        
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.frame = CGRect(x: 0, y: roleBgView.maxY + 26, width: 40, height: 40)
        cancelBtn.setImage(UIImage(named: "home_getbag_role_cancel"), for: .normal)
        cancelBtn.centerX = roleBgView.centerX
        cancelBtn.addTarget(self, action: #selector(self.cancelClick), for: .touchUpInside)
        tempView.addSubview(cancelBtn)
        
        let  contentArray = [
                                      "每人每天有\(self.allnumber ?? 2)次拼手气机会。",
                                      "参加可获得红包、体验金、加息券等奖励，所得奖励放入个人账户。",
                                      "若出现作弊行为，将取消您参加的资格。"
                                    ]
        
        var maxY:CGFloat = 46
        for i in 0 ..< contentArray.count {
            let numLabel = UILabel(frame: CGRect(x: 30, y: maxY + 2, width: 23, height: 15))
            numLabel.text = "\(i+1)、"
            numLabel.textColor = UIColor.hex("333333")
            numLabel.font = UIFont.customFont(ofSize: 14)
            roleBgView.addSubview(numLabel)
            
            let contentLabel = RTLabel(frame: CGRect(x: numLabel.maxX + 2, y: maxY, width: roleBgView.width - numLabel.maxX - 2, height: 0))
            contentLabel.text = "<font size=14 color='#333333'>\(contentArray[i])</font>"
            contentLabel.height = contentLabel.optimumSize.height
            roleBgView.addSubview(contentLabel)
            maxY = maxY +  contentLabel.height + 14
        }
        bgScrollview.contentSize = CGSize(width: SCREEN_WIDTH, height: bottomView.maxY)
    }
    
    //红包雨
    func showrRedBags() {
        let  redbagVC = RedBagViewController()
        bgScrollview.addSubview(redbagVC.view)
        redbagVC.buttonBlock = {
            MobClick.event("home", label: "菜单栏-拼手气-点击")
            GPWNetwork.requetWithPost(url: Gredred_money, parameters: nil, responseJSON: { [weak self] (json, msg) in
                printLog(message: json)
                guard let strongSelf = self else { return }
                strongSelf.prizeDic = json
                strongSelf.count = strongSelf.count! + 1
                strongSelf.numLabel.text = "已有\(strongSelf.count ?? 0)位用户获得拼手气大礼"
                strongSelf.getPrize()
            }) { (error) in
                
            }
            self.num = self.num - 1
            if self.num <= 0 {
                self.num = 0
                self.qiangBtn.isHidden = true
                self.chanceLabel.width = pixw(p: 200)
                self.chanceLabel.text = "今天机会已用完，明天再来哦"
                self.chanceLabel.centerX = SCREEN_WIDTH / 2
                self.bgimgView.image = UIImage(named: "home_getbag_end_bg")
                self.bgimgView.height = pixw(p: 826)
            }else{
                self.qiangBtn.isHidden = false
                self.chanceLabel.width = pixw(p: 150)
                self.chanceLabel.text = "您今日还有 \(self.num!) 次机会"
                self.chanceLabel.centerX = SCREEN_WIDTH / 2
            }
            redbagVC.view.removeFromSuperview()
        }
    }
    
    //取消
    func cancelClick() {
        if self.num == 0 {
            self.qiangBtn.isHidden = true
            self.chanceLabel.text = "今天机会已用完，明天再来哦"
            self.bgimgView.image = UIImage(named: "home_getbag_end_bg")
            self.bgimgView.height = pixw(p: 826)
            self.chanceLabel.width = pixw(p: 200)
            self.chanceLabel.centerX = SCREEN_WIDTH / 2
            self.showTodayPrize()
        }
        bgScrollview.viewWithTag(ROLEVIEWTAG)?.removeFromSuperview()
    }
    
    //结束后的商品展示
    func  showTodayPrize(){
        
        GPWNetwork.requetWithGet(url: Gredred_moneylist, parameters: nil, responseJSON: { [weak self] (json, msg) in
            printLog(message: json)
            guard let strongSelf = self else { return }
        
            var  tempMaxY = strongSelf.chanceLabel.maxY + 43
            for i in 0 ..< json["award_windata"].arrayValue.count {
                let tempJson = json["award_windata"][i]
                let topImgView = UIImageView(frame: CGRect(x: 15, y: tempMaxY, width: 304, height: 107))
                topImgView.image = UIImage(named: "home_getbag_getprize")
                topImgView.centerX = SCREEN_WIDTH / 2
                strongSelf.bgScrollview.addSubview(topImgView)
                
                let  moneyLabel = RTLabel(frame: CGRect(x: 0, y: 0, width: 115, height: 32))
                moneyLabel.textAlignment = RTTextAlignmentCenter
                if tempJson["type"].stringValue == "exper"  || tempJson["type"].stringValue == "award" {
                    moneyLabel.text = "<font size=20 color='#ffffff'>￥</font><font size=26 color='#ffffff'>\(tempJson["amount"].stringValue)</font>"
                }else{
                    moneyLabel.text = "<font size=28 color='#ffffff'>\(tempJson["amount"].stringValue)</font><font size=24 color='#ffffff'>%</font>"
                }
                moneyLabel.height = moneyLabel.optimumSize.height
                moneyLabel.centerY = topImgView.height / 2
                topImgView.addSubview(moneyLabel)
                
                //限制
                let  roleLabel = UILabel(frame: CGRect(x: 141, y: 33, width: topImgView.width - 141 - 16, height: 15))
                roleLabel.text = tempJson["restrict_amount"].stringValue
                roleLabel.font = UIFont.customFont(ofSize: 14)
                roleLabel.textColor = UIColor.hex("4a4a4a")
                topImgView.addSubview(roleLabel)
                
                //时间
                let  timeLabel = UILabel(frame: CGRect(x: roleLabel.x, y: roleLabel.maxY + 10, width: roleLabel.width, height: 15))
                 timeLabel.text = "有效期至\(GPWHelper.strFromDate(tempJson["due_time"].doubleValue, format:  "yyyy-MM-dd"))"
                timeLabel.font = UIFont.customFont(ofSize: 14)
                timeLabel.textColor = UIColor.hex("4a4a4a")
                topImgView.addSubview(timeLabel)
                
                tempMaxY = topImgView.maxY + 10
            }
            tempMaxY = tempMaxY + 20
            
            //去使用
            let toBtn = UIButton(type: .custom)
            toBtn.frame = CGRect(x: 0, y: tempMaxY, width: 330, height: 64)
            toBtn.setImage(UIImage(named: "home_getbag_topay"), for: .normal)
            toBtn.centerX = SCREEN_WIDTH / 2
            toBtn.tag = 1001
            toBtn.addTarget(self, action: #selector(strongSelf.priseClick(_:)), for: .touchUpInside)
            strongSelf.bgScrollview.addSubview(toBtn)
            tempMaxY = toBtn.maxY + 25
            strongSelf.bottomView.y = tempMaxY
            strongSelf.bgScrollview.contentSize = CGSize(width: SCREEN_WIDTH, height: strongSelf.bottomView.maxY)
            strongSelf.bgimgView.height = strongSelf.bgScrollview.contentSize.height
        }) { (error) in
            
        }
    }
    
    //获取奖品
    func getPrize(){
        let tempView = UIView(frame: bgScrollview.bounds)
        tempView.backgroundColor = UIColor.hex("000000", alpha: 0.6)
        tempView.tag = ROLEVIEWTAG
        bgScrollview.addSubview(tempView)
        
        let prizeBgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 343, height: 310))
        prizeBgView.center = tempView.center
        prizeBgView.backgroundColor = UIColor.white
        prizeBgView.layer.masksToBounds = true
        prizeBgView.isUserInteractionEnabled = true
        prizeBgView.layer.cornerRadius = 5
        tempView.addSubview(prizeBgView)
        
        let topImgView = UIImageView(frame: CGRect(x: 15, y: 22, width: prizeBgView.width - 15 * 2, height: 107))
        topImgView.image = UIImage(named: "home_getbag_getprize")
        topImgView.centerX = prizeBgView.width / 2
        prizeBgView.addSubview(topImgView)
        
        let  moneyLabel = RTLabel(frame: CGRect(x: 9, y: 0, width: 115, height: 30))
        moneyLabel.textAlignment = RTTextAlignmentCenter
        if self.prizeDic!["type"].stringValue == "exper"  || self.prizeDic!["type"].stringValue == "award" {
            moneyLabel.text = "<font size=20 color='#ffffff'>￥</font><font size=26 color='#ffffff'>\(self.prizeDic?["amount"].intValue ?? 0)</font>"
        }else{
            moneyLabel.text = "<font size=28 color='#ffffff'>\(String(describing: self.prizeDic?["amount"].stringValue ?? "0"))</font><font size=24 color='#ffffff'>%</font>"
        }
        
        moneyLabel.height = moneyLabel.optimumSize.height
        moneyLabel.centerY = topImgView.height / 2
        topImgView.addSubview(moneyLabel)
        
        //限制
        let  roleLabel = UILabel(frame: CGRect(x: 141, y: 33, width: topImgView.width - 141 - 16, height: 15))
        roleLabel.text = self.prizeDic?["restrict_amount"].stringValue ?? ""
        roleLabel.font = UIFont.customFont(ofSize: 14)
        roleLabel.textColor = UIColor.hex("4a4a4a")
        topImgView.addSubview(roleLabel)
        
        //时间
        let  timeLabel = UILabel(frame: CGRect(x: roleLabel.x, y: roleLabel.maxY + 10, width: roleLabel.width, height: 15))
        timeLabel.text = "有效期至\(GPWHelper.strFromDate(self.prizeDic?["due_time"].doubleValue ?? 0.00, format:  "yyyy-MM-dd"))"
        timeLabel.font = UIFont.customFont(ofSize: 14)
        timeLabel.textColor = UIColor.hex("4a4a4a")
        topImgView.addSubview(timeLabel)
        
        //提示
        let  tipLabel = UILabel(frame: CGRect(x:0, y: topImgView.maxY + 22, width: topImgView.width, height: 19))
        if self.prizeDic!["type"].stringValue == "exper"  {
            tipLabel.text = "恭喜您，抽中\(self.prizeDic?["amount"].intValue ?? 0)元体验金"
        }else if self.prizeDic!["type"].stringValue == "award" {
             tipLabel.text = "恭喜您，抽中\(self.prizeDic?["amount"].intValue ?? 0)元红包"
        }else{
            tipLabel.text = "恭喜您，抽中\(self.prizeDic?["amount"].stringValue ?? "0")%加息券"
        }
        tipLabel.textAlignment = .center
        tipLabel.font = UIFont.customFont(ofSize: 16)
        tipLabel.textColor = UIColor.hex("666666")
        prizeBgView.addSubview(tipLabel)
        
        //在拼一次
        let nextBtn = UIButton(type: .custom)
        nextBtn.frame = CGRect(x: 0, y: tipLabel.maxY + 25, width: 136, height: 52)
        nextBtn.setImage(UIImage(named: "home_getbag_getprize_next"), for: .normal)
        nextBtn.centerX = prizeBgView.width / 4
        nextBtn.tag = 1000
        nextBtn.addTarget(self, action: #selector(self.priseClick(_:)), for: .touchUpInside)
        prizeBgView.addSubview(nextBtn)
        
        //去使用
        let toBtn = UIButton(type: .custom)
        toBtn.frame = CGRect(x: 0, y: tipLabel.maxY + 25, width: 136, height: 52)
        toBtn.setImage(UIImage(named: "home_getbag_getprize_use"), for: .normal)
        toBtn.centerX = prizeBgView.width / 4 * 3
        toBtn.tag = 1001
        toBtn.addTarget(self, action: #selector(self.priseClick(_:)), for: .touchUpInside)
        prizeBgView.addSubview(toBtn)
        
        //取消
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.frame = CGRect(x: 0, y: prizeBgView.maxY + 26, width: 40, height: 40)
        cancelBtn.setImage(UIImage(named: "home_getbag_role_cancel"), for: .normal)
        cancelBtn.centerX = prizeBgView.centerX
        cancelBtn.addTarget(self, action: #selector(self.cancelClick), for: .touchUpInside)
        tempView.addSubview(cancelBtn)
        
        let  temp1Label = UILabel(frame: CGRect(x: 0, y: nextBtn.maxY + 15, width: prizeBgView.width, height: 12))
        temp1Label.textAlignment = .center
        temp1Label.textColor = UIColor.hex("999999")
        temp1Label.text = "此活动由钢票网提供"
        temp1Label.font = UIFont.customFont(ofSize: 12)
        prizeBgView.addSubview(temp1Label)
        
        let  temp2Label = UILabel(frame: CGRect(x: 0, y: temp1Label.maxY + 3, width: prizeBgView.width, height: 12))
        temp2Label.textAlignment = .center
        temp2Label.textColor = UIColor.hex("999999")
        temp2Label.text = "与设备生产商Apple Inc.公司无关"
        temp2Label.font = UIFont.customFont(ofSize: 12)
        prizeBgView.addSubview(temp2Label)
        
        
        
    }
    
    func priseClick( _ sender:UIButton) {
        self.cancelClick()
        if sender.tag == 1000 {
            if self.num == 0 {
                self.qiangBtn.isHidden = true
                self.chanceLabel.text = "今天机会已用完，明天再来哦"
                self.bgimgView.image = UIImage(named: "home_getbag_end_bg")
                self.bgimgView.height = pixw(p: 826)
                self.chanceLabel.width = pixw(p: 200)
                self.chanceLabel.centerX = SCREEN_WIDTH / 2
                self.showTodayPrize()
            }else{
                //再来一次
                 self.chanceLabel.width = pixw(p: 150)
                self.chanceLabel.centerX = SCREEN_WIDTH / 2
                self.showrRedBags()
            }
        }else{
            //去使用
            GPWHelper.selectTabBar(index: PROJECTBARTAG)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollview.viewDealloc()
        bgScrollview.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
