//
//  GPWOutRcordDetailController.swift
//  GangPiaoWang
// 出借详情
//  Created by gangpiaowang on 2017/3/8.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWOutRcordDetailController: GPWSecBaseViewController {
    var  rcordID :String?
    var auto_id:String?
    var pTitle:String?
    private var dicJson:JSON?
    private var scrollView:UIScrollView!
    private var maxY:CGFloat!
    override func viewDidLoad() {
        self.title = "出借详情"
        super.viewDidLoad()
        maxY = 24.00
        scrollView = UIScrollView(frame: self.bgView.bounds)
        scrollView.backgroundColor = UIColor.white
        self.bgView.addSubview(scrollView)
      self.getNetData()
    }
    override func getNetData() {
        GPWNetwork.requetWithPost(url: Invest_record_content, parameters:  ["auto_id":rcordID ?? "0"], responseJSON: {
            [weak self] (json, msg) in
            guard let strongSelf = self else { return }
            printLog(message: json)
            strongSelf.dicJson = json
            strongSelf.topView()
            strongSelf.sceView()
        }) { (error) in

        }
    }
    func btnClick() {
        let  control = DownHTongController()
        control.urlStr = self.dicJson!["contract"].stringValue
        print(control.urlStr)
        control.navTitle = "出借合同"
        control.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(control, animated: false)
    }
    
    //第一梯队
    func topView()  {
        let is_pact = self.dicJson?["is_pact"].stringValue ?? "0"
        if is_pact == "1" {
            //合同
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: SCREEN_WIDTH - 75 - 16, y: 33, width: 73, height: 21)
            btn.setTitle("出借合同", for: .normal)
            btn.setTitleColor(redColor, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            btn.addTarget(self, action: #selector(self.btnClick), for: .touchUpInside)
            self.navigationBar.addSubview(btn)
        }

        let array = [
        ["img":"user_record_accol","title":"出借金额(元)","money":(self.dicJson?["amount"].stringValue)! as String],
         ["img":"user_record_wait","title":"预计收益(元)","money":(self.dicJson?["expect_earnings"].stringValue)! as String]
        ]
        for i in 0 ..< array.count {
            let  imgView = UIImageView(frame: CGRect(x: 16, y: maxY, width: 9, height: 9))
            imgView.image = UIImage(named: array[i]["img"]!)
            scrollView.addSubview(imgView)
            let  titleLabel = UILabel(frame: CGRect(x: imgView.maxX + 10, y: 0, width: 82, height: 20))
            titleLabel.text = array[i]["title"]
            titleLabel.centerY = imgView.centerY
            titleLabel.font = UIFont.customFont(ofSize: 14)
            titleLabel.textColor = UIColor.hex("999999")
            scrollView.addSubview(titleLabel)
            
            let  moneyLabel = UILabel(frame: CGRect(x: titleLabel.maxX + 15, y: 0, width: 200, height: 20))
            moneyLabel.text = array[i]["money"]
            moneyLabel.centerY = imgView.centerY
            moneyLabel.font = UIFont.customFont(ofSize: 18)
            moneyLabel.textColor = UIColor.hex("f6390d")
            scrollView.addSubview(moneyLabel)
             maxY = moneyLabel.maxY
            if i == 0 {
                let line = UIView(frame: CGRect(x: 0, y: moneyLabel.maxY + 19, width: SCREEN_WIDTH, height: 8))
                line.backgroundColor =  bgColor
                scrollView.addSubview(line)
                maxY = line.maxY + 19
            }
        }
        
        var  profitArray = [Dictionary<String,String>]()
        
        //新手专享
        let  new_user_amount = self.dicJson?["new_user_amount"].doubleValue ?? 0.00
        if new_user_amount > 0{
            profitArray.append(["title":"新手专享加息","money": self.dicJson?["new_user_amount"].stringValue ?? "0.00"])
        }
        
        //出借利息
         let  amount_ticket = self.dicJson?["amount_ticket"].doubleValue ?? 0.00
        if  amount_ticket > 0{
            profitArray.append(["title":"出借利息","money":(self.dicJson?["amount_ticket"].stringValue)!])
        }
        
        //站岗利息
        let  amount_subsidy = self.dicJson?["amount_subsidy"] .doubleValue ?? 0.00
        if amount_subsidy > 0{
            profitArray.append(["title":"站岗利息","money":(self.dicJson?["amount_subsidy"].stringValue)!])
        }
        
        //红包
        let  money = self.dicJson?["award"] .intValue ?? 0
        if money > 0{
            profitArray.append(["title":"红包","money":(self.dicJson?["award"].stringValue)!])
        }
        //加息券
         let  amount_accrual = self.dicJson?["amount_accrual"] .doubleValue ?? 0.00
        if amount_accrual > 0{
            profitArray.append(["title":"加息券","money":(self.dicJson?["amount_accrual"].stringValue)!])
        }
        
        if profitArray.count == 1 {
            profitArray.removeLast()
        }
        
        //利息  红包  站岗利息等
        maxY = maxY + 12
        for i in 0 ..< profitArray.count {
            maxY = maxY + 14
            let  dic = profitArray[i]
            let  titleLabel = UILabel(frame: CGRect(x: 16, y: maxY, width: 86, height: 20))
            titleLabel.text = dic["title"]
            titleLabel.font = UIFont.customFont(ofSize: 14)
            titleLabel.textColor = UIColor.hex("999999")
            scrollView.addSubview(titleLabel)
            
            let  moneyLabel = UILabel(frame: CGRect(x: titleLabel.maxX + 17, y: maxY, width: 200, height: 20))
            moneyLabel.text =  dic["money"]! + "元"
            moneyLabel.font = UIFont.customFont(ofSize: 14)
            moneyLabel.textColor = UIColor.hex("333333")
            scrollView.addSubview(moneyLabel)
            maxY = titleLabel.maxY +  13

            let line = UIView(frame: CGRect(x: titleLabel.x, y: maxY, width: SCREEN_WIDTH - titleLabel.x, height: 0.5))
            line.backgroundColor = lineColor
            scrollView.addSubview(line)
            maxY = line.maxY
        }
    
        let block = UIView(frame: CGRect(x: 0, y: maxY, width: SCREEN_WIDTH, height: 8))
        block.backgroundColor = bgColor
        scrollView.addSubview(block)
        maxY = block.maxY
    }
    
    //第二梯队
    func sceView()  {
        let imgView = UIImageView(frame: CGRect(x: 16, y: maxY + 20, width: 3, height: 14))
        imgView.image = UIImage(named: "user_record_shu")
        scrollView.addSubview(imgView)
        
        let titleLabel = RTLabel(frame: CGRect(x: imgView.maxX + 6, y: 0, width: 270, height: 20))
        titleLabel.text = "<font size=14 color='#333333'>项目详情</font>"
        titleLabel.height = titleLabel.optimumSize.height
        titleLabel.centerY = imgView.centerY
        scrollView.addSubview(titleLabel)
        maxY = titleLabel.maxY + 29
       var tempRate = self.dicJson?["rate_loaner"].stringValue ?? "0.0"
        if self.dicJson?["is_new"].intValue == 1 {
            tempRate = tempRate + "% + \(String(describing: self.dicJson?["rate_new"] ?? "0.0"))"
        }
        
        let array = [
            ["title":"年化利率","money":tempRate + "%"],
            ["title":"借款期限","money":(self.dicJson?["deadline"].stringValue)! as String + "天"],
            ["title":"还款方式","money":(self.dicJson?["refund_type"].stringValue)! as String],
            ["title":"起息方式","money":(self.dicJson?["repaying_type"].stringValue)! as String],
            ["title":"出借日期","money": GPWHelper.strFromDate((dicJson?["add_time"].doubleValue)!, format: "yyyy-MM-dd")],
            ["title":"还款日期","money":(self.dicJson?["repaying_times"].stringValue)! as String],
        ]
        
        for i in 0 ..< array.count {
            let  tempLabel = UILabel(frame: CGRect(x:  imgView.maxX, y: maxY, width: 70, height: 20))
            tempLabel.text = array[i]["title"]
            tempLabel.font = UIFont.customFont(ofSize: 16)
            tempLabel.textColor = UIColor.hex("999999")
            scrollView.addSubview(tempLabel)
            
            let  temp1Label = UILabel(frame: CGRect(x: tempLabel.maxX + 17, y: 0, width: 130, height: 20))
            temp1Label.text = array[i]["money"]
            temp1Label.centerY = tempLabel.centerY
            temp1Label.font = UIFont.customFont(ofSize: 16)
            temp1Label.textColor = UIColor.hex("333333")
            scrollView.addSubview(temp1Label)
            maxY = tempLabel.maxY
            let line = UIView(frame: CGRect(x: imgView.x, y: temp1Label.maxY + 13, width: SCREEN_WIDTH - imgView.x, height: 0.5))
            line.backgroundColor =  lineColor
            scrollView.addSubview(line)
            maxY = line.maxY + 13
        }

        let bottomView = UIView(frame: CGRect(x: 0, y: maxY - 13, width: SCREEN_WIDTH, height: 200))
        bottomView.backgroundColor = bgColor
        scrollView.addSubview(bottomView)

        //项目详情
        let  proDetailBtn = UIButton(type: .custom)
        proDetailBtn.frame = CGRect(x: 0, y: 22, width: 100, height: 30)
        proDetailBtn.setTitle("项目详情", for: .normal)
        proDetailBtn.centerX = SCREEN_WIDTH / 2
        proDetailBtn.layer.cornerRadius = proDetailBtn.height / 2
        proDetailBtn.layer.borderColor = UIColor.hex("f6390d").cgColor
        proDetailBtn.layer.borderWidth = 0.5
        proDetailBtn.setTitleColor(UIColor.hex("f6390d"), for: .normal)
        proDetailBtn.addTarget(self, action: #selector(gotoPDetailControl), for: .touchUpInside)
        proDetailBtn.titleLabel?.font = UIFont.customFont(ofSize: 16)
        bottomView.addSubview(proDetailBtn)
        maxY = SCREEN_HEIGHT + 30
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: maxY + 30)
    }

    func gotoPDetailControl() {
        let vc = GPWProjectDetailViewController(projectID: auto_id ?? "0")
        vc.title = self.pTitle
        self.navigationController?.show(vc, sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
