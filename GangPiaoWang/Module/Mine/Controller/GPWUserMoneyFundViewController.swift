//
//  GPWUserMoneyFundViewController.swift
//  GangPiaoWang
//  资金统计
//  Created by gangpiaowang on 2016/12/20.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWUserMoneyFundViewController: GPWSecBaseViewController {
    
    fileprivate var bgScrllView:UIScrollView!
    fileprivate var maxHight:CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "资金统计"
        maxHight = 0.00
        bgScrllView = UIScrollView(frame: self.bgView.bounds)
        bgScrllView.backgroundColor = UIColor.white
        self.bgView.addSubview(bgScrllView)
        
        let  topView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        topView.backgroundColor = bgColor
        self.bgScrllView.addSubview(topView)
        
        initTopView()
        initbottomView()
    }
    
    fileprivate func initTopView(){
        
        let  bgV  = UIView(frame: CGRect(x: 0, y: 10, width: SCREEN_WIDTH, height: 0))
        bgScrllView.addSubview(bgV)
        
        let items = [
            PNPieChartDataItem(value: self.stringToFloat(str: GPWUser.sharedInstance().money!), color: UIColor.hex("f16848")),
            PNPieChartDataItem(value: self.stringToFloat(str: GPWUser.sharedInstance().capital!), color: UIColor.hex("fcc30c")),
            PNPieChartDataItem(value: self.stringToFloat(str: GPWUser.sharedInstance().money_freeze!), color: UIColor.hex("55a7f2")),
            PNPieChartDataItem(value: self.stringToFloat(str: GPWUser.sharedInstance().wait_accrual!), color: UIColor.hex("a95bee"))]
        
        let pieChart = PNPieChart(frame: CGRect( x: (SCREEN_WIDTH - 260 ) / 2, y: 25.0, width: 188.0, height: 188.0), items: items)
        pieChart?.outerCircleRadius = 188
        pieChart?.innerCircleRadius = 164
        pieChart?.descriptionTextColor = UIColor.white
        pieChart?.descriptionTextFont = UIFont.customFont(ofSize: 14)
        pieChart?.stroke()
        pieChart?.center.x = SCREEN_WIDTH / 2
        self.bgScrllView.addSubview(pieChart!)
        
        //圆圈内的东西
        let contentView = UIView(frame: (pieChart?.bounds)!)
        contentView.height = CGFloat(12 + 12 + 20)
        contentView.centerY = (pieChart?.height)!/2
        pieChart?.addSubview(contentView)
        
        let tiLabel = UILabel(frame: CGRect(x: 0,y: 0,width: contentView.width,height: 12))
        tiLabel.textAlignment = .center
        tiLabel.text = "资产总额(元)"
        tiLabel.textColor = UIColor.hex("999999")
        tiLabel.font = UIFont.customFont(ofSize: 12)
        contentView.addSubview(tiLabel)
        
        let tiMoneyLabel = UILabel(frame: CGRect(x: 0,y: tiLabel.maxY + 11,width: contentView.width,height: 21))
        tiMoneyLabel.textAlignment = .center
        tiMoneyLabel.text = GPWUser.sharedInstance().totalMoney!
        tiMoneyLabel.textColor = UIColor.hex( "333333")
        tiMoneyLabel.font = UIFont.customFont(ofSize: 20)
        contentView.addSubview(tiMoneyLabel)
        
        let bottomImgView = UIImageView(frame: CGRect(x: 16, y: (pieChart?.maxY)! + 28, width: SCREEN_WIDTH - 32, height: 6))
        bottomImgView.image = UIImage(named: "user_zijin_top")
        self.bgScrllView.addSubview(bottomImgView)
        
        let contentArray = [
            ["f16848","账户余额(元)","\(GPWUser.sharedInstance().money!)"],
            ["fcc30c","待收本金(元)","\(GPWUser.sharedInstance().capital!)"],
            ["55a7f2","冻结总额(元)","\(GPWUser.sharedInstance().money_freeze!)"],
            ["a95bee","待收收益(元)","\(GPWUser.sharedInstance().wait_accrual!)"]
        ]
        maxHight = bottomImgView.maxY + 30
        for i in 0 ..< 2 {
            for j in 0 ..< 2 {
                let tempCView = UIView(frame: CGRect(x: CGFloat(j) * SCREEN_WIDTH / 2 + pixw(p: 35) ,y: maxHight,  width: 8 , height: 8))
                tempCView.layer.masksToBounds = true
                tempCView.layer.cornerRadius = 4
                tempCView.backgroundColor = UIColor.hex(contentArray[i * 2 + j][0])
                self.bgScrllView.addSubview(tempCView)
                
                let tempLable = UILabel(frame: CGRect(x: tempCView.maxX + 10 , y: 0, width: 150,height: 16))
                tempLable.text = contentArray[i * 2 + j][1]
                tempLable.font = UIFont.customFont(ofSize: 14)
                tempLable.textColor = UIColor.hex("999999")
                tempLable.centerY = tempCView.centerY
                self.bgScrllView.addSubview(tempLable)
                
                let tempMoneyLabel = UILabel(frame: CGRect(x:  tempLable.x,y: tempLable.maxY + 10,width: 200,height: 19))
                tempMoneyLabel.text = contentArray[i * 2 + j][2]
                tempMoneyLabel.font = UIFont.customFont(ofSize: 17)
                tempMoneyLabel.textColor = UIColor.hex("333333")
                self.bgScrllView.addSubview(tempMoneyLabel)
            }
            maxHight = maxHight + 86
              let  hengImgView = UIImageView(frame: CGRect(x: 16, y: bottomImgView.maxY + 87, width: SCREEN_WIDTH - 32, height: 2))
            hengImgView.image = UIImage(named: "user_zijin_heng")
            bgScrllView.addSubview(hengImgView)
            
            let  shuImgView = UIImageView(frame: CGRect(x: 16, y: bottomImgView.maxY + 30, width: 1, height: 86 + 43))
            shuImgView.centerX = SCREEN_WIDTH / 2
            shuImgView.image = UIImage(named: "user_zijin_shu")
            bgScrllView.addSubview(shuImgView)
        }
        bgV.height = maxHight - 10
    }
    
    fileprivate func initbottomView(){
        let  bottomblockView = UIView(frame: CGRect(x: 0, y: maxHight, width: SCREEN_WIDTH, height: 8))
        bottomblockView.backgroundColor = bgColor
        self.bgScrllView.addSubview(bottomblockView)
        
        let bottomTitleLabel = UILabel(frame: CGRect(x: 0, y: bottomblockView.maxY + 34, width: SCREEN_WIDTH, height: 15))
        bottomTitleLabel.text = "累计收益(元)"
        bottomTitleLabel.textAlignment = .center
        bottomTitleLabel.font = UIFont.customFont(ofSize: 14)
        bottomTitleLabel.textColor = UIColor.hex("999999")
        self.bgScrllView.addSubview(bottomTitleLabel)
        
        //累计收益
        let alljiangTitleLabel = UILabel(frame: CGRect(x: 0, y: bottomTitleLabel.maxY + 8, width: SCREEN_WIDTH, height: 24))
        alljiangTitleLabel.text = "\(GPWUser.sharedInstance().accrual!)"
        alljiangTitleLabel.textAlignment = .center
        alljiangTitleLabel.font = UIFont.customFont(ofSize: 24)
        alljiangTitleLabel.textColor = UIColor.hex("333333")
        self.bgScrllView.addSubview(alljiangTitleLabel)
        
        maxHight = alljiangTitleLabel.maxY + 20
        
        let contentArray = [
            ["fcc30c","已收利息(元)","\(GPWUser.sharedInstance().alreadyRefundAccrual!)"],
            ["fcc30c","红包收益(元)","\(GPWUser.sharedInstance().award!)"],
            ["fcc30c","待收利息(元)","\(GPWUser.sharedInstance().waitRefundAccrual!)"],
            ["fcc30c","加息收益(元)","\(GPWUser.sharedInstance().ticket!)"],
            ["fcc30c","活动奖励(元)","\(GPWUser.sharedInstance().activity_money!)"],
            ["fcc30c","体验金收益(元)","\(GPWUser.sharedInstance().tiyanItemMoney!)"]
        ]
        for i in 0 ..< 3 {
            for j in 0 ..< 2 {
                let cView = UIView(frame: CGRect(x: CGFloat(j) * SCREEN_WIDTH / 2 + pixw(p: 35) ,y: maxHight + 16,  width: 8 , height: 8))
                cView.layer.masksToBounds = true
                cView.layer.cornerRadius = 1
                cView.backgroundColor = UIColor.hex(contentArray[i * 2 + j][0])
                self.bgScrllView.addSubview(cView)
                
                let lable = UILabel(frame: CGRect(x: cView.maxX  + 8, y: 0, width: 200,height: 16))
                lable.text = contentArray[i * 2 + j][1]
                lable.font = UIFont.customFont(ofSize: 14)
                lable.textColor = UIColor.hex("999999")
                lable.centerY = cView.centerY
                self.bgScrllView.addSubview(lable)
                
                let moneyLabel = UILabel(frame: CGRect(x:  lable.x,y: lable.maxY + 10,width: 200,height: 19))
                moneyLabel.text = contentArray[i * 2 + j][2]
                moneyLabel.font = UIFont.customFont(ofSize: 17)
                moneyLabel.textColor = UIColor.hex("333333")
                self.bgScrllView.addSubview(moneyLabel)
            }
            maxHight = maxHight + 74
            if i != 2 {
                let  hengImgView = UIImageView(frame: CGRect(x: 16, y: maxHight, width: SCREEN_WIDTH - 32, height: 2))
                hengImgView.image = UIImage(named: "user_zijin_heng")
                bgScrllView.addSubview(hengImgView)
            }
        }
        
        let  shuImgView = UIImageView(frame: CGRect(x: 16, y: maxHight - 74 * 3, width: 1, height: 74 * 3))
        shuImgView.centerX = SCREEN_WIDTH / 2
        shuImgView.image = UIImage(named: "user_zijin_shu")
        bgScrllView.addSubview(shuImgView)
        
        bgScrllView.contentSize = CGSize(width: SCREEN_WIDTH, height: maxHight + 25)
    }
    
    func stringToFloat(str:String) -> CGFloat{
        let string = str.replacingOccurrences(of: ",", with: "")
        var cgFloat: CGFloat = 0
        
        if let doubleValue = Double(string)
        {
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
