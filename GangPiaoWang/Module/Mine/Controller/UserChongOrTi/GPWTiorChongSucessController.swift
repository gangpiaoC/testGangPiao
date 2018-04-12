//
//  GPWTiorChongSucessController.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/22.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
enum TiorChongType:Int{
    case CHONGZHI
    case TIXIAN
}
class GPWTiorChongSucessController: GPWBaseViewController {
    
    var type:TiorChongType?
    var money:String =  "0"
    var  shouxu:CGFloat = 0
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (navigationController as! GPWNavigationController).canDrag = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topBgView = UIView(frame: CGRect(x: 0, y: 10, width: SCREEN_WIDTH, height: 330))
        topBgView.backgroundColor = UIColor.white
        
        self.bgView.height += 49
        self.bgView.addSubview(topBgView)
        
        let imgView = UIImageView(frame: CGRect(x: 0, y: 30, width: 70, height: 70))
        imgView.centerX = SCREEN_WIDTH / 2
        imgView.image = UIImage(named: "project_investSucess")
        topBgView.addSubview(imgView)
        
        let  tipLabel = UILabel(frame: CGRect(x: 0, y: imgView.maxY + 37, width: SCREEN_WIDTH, height: 19))
        tipLabel.font = UIFont.customFont(ofSize: 18)
        tipLabel.textColor = redColor
        tipLabel.textAlignment = .center
        topBgView.addSubview(tipLabel)
        
        let moneyLabel = UILabel(frame: CGRect(x: 0, y: tipLabel.maxY + 10, width: SCREEN_WIDTH, height: 26))
        var tempMoney:CGFloat = 0
        moneyLabel.text = "\(self.money)元"
        moneyLabel.textColor = UIColor.hex("666666")
        moneyLabel.textAlignment = .center
        moneyLabel.font = UIFont.customFont(ofSize: 24)
        topBgView.addSubview(moneyLabel)
        
        let blockView = UIView(frame: CGRect(x: 0, y: moneyLabel.maxY + 24, width: SCREEN_WIDTH, height: 10))
        blockView.backgroundColor = bgColor
        topBgView.addSubview(blockView)
        
        var maxHeight = blockView.maxY
        
        //充值金额
        var temp1Str = "\(self.money)元"
        
        //标题：充值金额  提现金额
        var tempName = "充值金额"
        if type == TiorChongType.CHONGZHI {
             self.title = "充值"
            tipLabel.text = "充值成功"
            moneyLabel.isHidden = true
        }else{
             self.title = "提现"
            tempName = "提现金额"
            tipLabel.text = "提现申请已成功"
            moneyLabel.text = "提现金额预计T+1个工作日到账"
            moneyLabel.font = UIFont.customFont(ofSize: 14)
            temp1Str = "\(self.money)元"
            
        }
        
        var bankNum = ((GPWUser.sharedInstance().bank_num! as NSString)).substring(with: NSRange(location: (GPWUser.sharedInstance().bank_num?.count)! - 4,length: 4))
        bankNum = "尾号" + bankNum
        
        var array = [[String:String]]()
        if type == TiorChongType.CHONGZHI {
            array = [
                ["title": GPWUser.sharedInstance().bank_name!,"content": bankNum],
                ["title": tempName ,"content":temp1Str]
            ]
        }else{
            if let doubleValue = Double(self.money )
            {
                tempMoney = CGFloat(doubleValue)
            }
            tempMoney = tempMoney  - self.shouxu
            array = [
                ["title": GPWUser.sharedInstance().bank_name!,"content": bankNum],
                ["title": tempName ,"content":"\(tempMoney)元"]
            ]
            
            if shouxu > 0 {
                array.append(["title": "提现费用" ,"content":"\(shouxu)元"])
            }
        }
        
        for i in 0 ..< array.count {
            
            let tempLabel = UILabel(frame: CGRect(x: 16, y: maxHeight, width: SCREEN_WIDTH / 2, height: 56))
            tempLabel.textColor = UIColor.hex("333333")
            tempLabel.text = array[i]["title"]
            tempLabel.font = UIFont.customFont(ofSize: 16)
            topBgView.addSubview(tempLabel)
            
            let temp2Label = UILabel(frame: CGRect(x: SCREEN_WIDTH / 2, y: tempLabel.y, width: SCREEN_WIDTH / 2 - 16, height: tempLabel.height))
            temp2Label.textColor = UIColor.hex("333333")
            temp2Label.text = array[i]["content"]
            temp2Label.textAlignment = .right
            temp2Label.textColor = UIColor.hex("666666")
            if i == 1{
                if type == TiorChongType.CHONGZHI {
                    temp2Label.textColor = redColor
                }else{
                    temp2Label.textColor = UIColor.hex("3ebe18")
                }
            }
            temp2Label.font = UIFont.customFont(ofSize: 16)
            topBgView.addSubview(temp2Label)
            
            let line = UIView(frame: CGRect(x: 0, y:temp2Label.maxY, width: SCREEN_WIDTH, height: 1))
            line.backgroundColor = bgColor
            topBgView.addSubview(line)
            
            maxHeight = line.maxY
        }
        
        topBgView.height = maxHeight
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 16, y:  maxHeight + 40, width: SCREEN_WIDTH - 16 * 2, height: 48)
        btn.setBackgroundImage(UIImage(named: "btn_bg"), for: .normal)
        btn.setTitle("完成", for: .normal)
        btn.titleLabel?.font = UIFont.customFont(ofSize: 18)
        btn.addTarget(self, action: #selector(self.btnClick), for: .touchUpInside)
        self.bgView.addSubview(btn)
    }
  
    @objc func btnClick()  {
         (navigationController as! GPWNavigationController).canDrag = true
        if type ==  .CHONGZHI {
            for vc in self.navigationController!.viewControllers {
                if vc.isKind(of: GPWInvestViewController.self) {
                    _ = self.navigationController?.popToViewController(vc, animated: true)
                    return
                }
            }
        }
        _ = self.navigationController?.popToRootViewController(animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
