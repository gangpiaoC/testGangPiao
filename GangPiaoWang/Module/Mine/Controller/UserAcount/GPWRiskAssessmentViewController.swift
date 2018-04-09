//
//  GPWRiskAssessmentViewController.swift
//  GangPiaoWang
//  风险测评
//  Created by gangpiaowang on 2017/6/6.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
fileprivate let SELECTATAG = 10000
fileprivate let SELECTBTAG = 10001
fileprivate let SELECTCTAG = 10002
fileprivate let SELECTDTAG = 10003
fileprivate let BACKBTNTAG = 1000

class GPWRiskAssessmentViewController: GPWSecBaseViewController {
    
    fileprivate var progressView:UIProgressView!
    
    fileprivate var titleLabel:RTLabel!
    
    //标题下面的线
    fileprivate var topLine:UIView!
    
    //四个按钮下面的线
    fileprivate var  bottomLine:UIView!
    
    //数据
    fileprivate var dataArray:[Any]!
    
    //按钮数组
    fileprivate var selectBtnArray = [UIButton]()
    
    //返回按钮
    fileprivate var backBtn:UIButton!
    
    
    //选择题目
    fileprivate var selectNum = 0
    
    //分值
    fileprivate var selectedScoreArray = [Int]()
    
    //结果界面
    fileprivate var resultView:UIView!
    
    //用户类型
    fileprivate var typeLabel:UILabel!
    
    //类型描述
    fileprivate var typeDetailLabel:RTLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "风险测评"
        self.bgView.backgroundColor = UIColor.white
        
        let path = Bundle.main.path(forResource: "risk_assessment", ofType: "json")
        printLog(message: path)
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
        do{
            let temp1 = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any]
            dataArray = temp1?["data"] as! [Any]
              printLog(message: dataArray)
        }catch{
            printLog(message: error)
        }
      

        let block =  UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10))
        block.backgroundColor = bgColor
        self.bgView.addSubview(block)
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.frame = CGRect(x: 16, y: block.maxY + 42, width: SCREEN_WIDTH - 32, height: 8)
        progressView.setProgress(0.1, animated: true)
        self.bgView.addSubview(progressView)
        
        progressView.progressTintColor = UIColor.hex("fcc30c")
        progressView.trackTintColor = UIColor.hex("ededed")
        
        titleLabel = RTLabel(frame: CGRect(x: 38, y: progressView.maxY + 42, width: SCREEN_WIDTH - 38 * 2, height: 20))
        titleLabel.text = "<font size=16 color='#666666'>1、您的收入状况是：</font>"
        titleLabel.textColor = UIColor.hex("333333")
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        self.bgView.addSubview(titleLabel)
        
        topLine = UIView(frame: CGRect(x: titleLabel.x, y: titleLabel.maxY + 20, width: titleLabel.width, height: 1))
        topLine.backgroundColor = UIColor.hex("ededed")
        self.bgView.addSubview(topLine)
        
        //a
        var maxY = topLine.maxY + 18
        let tempArray = ["A、","B、","C、","D、"]
        for  i in 0 ..< 4 {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: titleLabel.x, y: maxY, width: titleLabel.width, height: 25)
            btn.tag = 10000 + i
            btn.addTarget(self, action: #selector(self.btnClick(sender:)), for: .touchUpInside)
            self.bgView.addSubview(btn)
            selectBtnArray.append(btn)
            
            
            let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
            imgView.image = UIImage(named: "user_risk_select")
            imgView.centerY = btn.height / 2
            imgView.tag = 1000
            btn.addSubview(imgView)
            
            //ABCD
            let  selectLabel = UILabel(frame: CGRect(x: imgView.maxY + 10 , y: 0, width: 30, height: btn.height))
            selectLabel.font = UIFont.customFont(ofSize: 16)
            selectLabel.text = tempArray[i]
            selectLabel.tag = 1001
            selectLabel.textColor = UIColor.hex("666666")
            btn.addSubview(selectLabel)
            
            let tempLabel = RTLabel(frame: CGRect(x: selectLabel.maxX , y:  2, width: btn.width - selectLabel.maxX , height: btn.height))
            tempLabel.text = "<font size=16 color='#666666'>钢票网欢迎您</font>"
            tempLabel.isUserInteractionEnabled = false
            tempLabel.tag = 1002
            btn.addSubview(tempLabel)
            maxY = btn.maxY + 23
        }
        bottomLine = UIView(frame: CGRect(x: titleLabel.x, y: maxY, width: titleLabel.width, height: 1))
        bottomLine.backgroundColor = UIColor.hex("ededed")
        self.bgView.addSubview(bottomLine)
        
        backBtn = UIButton(type: .custom)
        backBtn.frame = CGRect(x: titleLabel.x, y: bottomLine.maxY + 30, width: 100, height: 32)
        backBtn.layer.masksToBounds = true
        backBtn.tag = BACKBTNTAG
        backBtn.layer.borderColor = UIColor.hex("cdcdcd").cgColor
        backBtn.layer.borderWidth = 1
        backBtn.layer.cornerRadius = 3
        backBtn.setTitle("返回上一题", for: .normal)
        backBtn.isHidden = true
        backBtn.addTarget(self, action: #selector(self.btnClick(sender:)), for: .touchUpInside)
        backBtn.setTitleColor(UIColor.hex("999999"), for: .normal)
        backBtn.titleLabel?.font = UIFont.customFont(ofSize: 14)
        self.bgView.addSubview(backBtn)
        
        let tempData = dataArray[0] as? [String:Any]
        self.reloadData(dic: tempData!)
        self.riskScuess()
        if GPWUser.sharedInstance().risk > 0 {
            self.showResultView(GPWUser.sharedInstance().risk)
        }
    }
    
    func btnClick(sender:UIButton)  {
        if sender.tag == BACKBTNTAG {
            selectNum = selectNum - 1
            if selectNum == 0 {
                backBtn.isHidden = true
            }else{
                backBtn.isHidden = false
            }
            let tempData = dataArray[selectNum] as? [String:Any]
            self.reloadData(dic: tempData!)
            if selectedScoreArray.count != 0 {
                selectedScoreArray.removeLast()
            }
        }else{
            backBtn.isHidden = false
            selectNum = selectNum + 1
            if selectNum >= dataArray.count {
                selectNum = selectNum - 1
                backBtn.isHidden = true
                progressView.setProgress(Float(selectNum + 1) / Float(10), animated: true)
                var score = 0
                
                for tempScore in selectedScoreArray {
                    score = score + tempScore
                }
                self.showResultView(score)
                return
            }
            //展示使用
            var tempData = dataArray[selectNum] as? [String:Any]
            self.reloadData(dic: tempData!)
            
            //获取前一个选择的分数
            tempData = dataArray[selectNum - 1] as? [String:Any]
            let tempAny = tempData?["an_list"] as? [Any]
            let temDic = tempAny?[sender.tag - 10000] as? [String:Any]
            printLog(message: temDic!)
            selectedScoreArray.append(temDic?["score"] as! Int)
            printLog(message: selectedScoreArray)
        }
    }
    
    func showResultView(_ score:Int) {
        resultView.isHidden = false
        GPWNetwork.requetWithPost(url: Risk_score, parameters: ["score":"\(score)"], responseJSON: { (json, msg) in
          GPWUser.sharedInstance().getUserInfo()
        }) { (error) in
            
        }
        
        var  type = "保守型"
        var tpeDetail = ""
        if score <= 30 {
            //保守型
            type = "保守型"
            tpeDetail = "您属于保守型出借人。您属于风险承受能力较低、投资很谨慎的出借人。应尽量回避波动性较大的投资产品，保护本金不受损失和保持资产流动性是首要目标。"
        }else if score > 37 && score <= 72 {
            //稳健型
            type = "稳健型"
            tpeDetail = "您属于稳健型出借人。您风险偏好较低，希望在保证本金安全的基础上能有增值收入，止损意识强，是一个比较平稳的出借人。适合投资于能够提供温和升值能力，投资价值有温和波动的产品。"
        }else{
            //进取型
            type = "进取型"
            tpeDetail = "您属于进取型出借人。您倾向于通过承受较高的风险以获取较高的回报的出借人，可以承受一定的投资波动，应根据个人的需求，将资产在高风险和低风险的产品之间进行分配，以取得投资组合的均衡发展。"
        }
        
        typeLabel.text = "\"\(type)\""
        typeDetailLabel.text =  "<font size=14 color='#666666'>\(tpeDetail)</font>"
        typeDetailLabel.height = typeDetailLabel.optimumSize.height
        
    }
    
    func reloadData(dic:[String:Any]) {
         progressView.setProgress(Float(selectNum + 1) / Float(10), animated: true)
        titleLabel.text =  "<font size=18 color='#333333'>\(String(describing: dic["question"] ?? ""))</font>"
        titleLabel.height = titleLabel.optimumSize.height
        let tempAny = dic["an_list"] as? [Any]
        topLine.y = titleLabel.maxY + 20
        
        //获取第一个
        var maxY = topLine.maxY + 18
        for i in 0 ..< tempAny!.count {
            let  btn = selectBtnArray[i]
            btn.y = maxY
            let temImgView = btn.viewWithTag(1000) as! UIImageView
            let tempselectLabel = btn.viewWithTag(1001) as! UILabel
             let tempLabel = btn.viewWithTag(1002) as! RTLabel
            let temDic = tempAny?[i] as? [String:Any]
            
             temImgView.image = UIImage(named: "user_risk_select")
             tempLabel.text = "<font size=16 color='#666666'>\(String(describing: temDic?["an_content"] ?? ""))</font>"
            tempselectLabel.textColor = UIColor.hex("666666")
            //分值数组如果小于当前题数
            if selectedScoreArray.count > selectNum {
                let  score = temDic?["score"] as! Int
                //数组中分数
                let tempScore = selectedScoreArray[selectNum]
                if score == tempScore{
                     temImgView.image = UIImage(named: "user_risk_selected")
                     tempLabel.text = "<font size=16 color='#333333'>\(String(describing: temDic?["an_content"] ?? ""))</font>"
                    tempselectLabel.textColor = UIColor.hex("333333")
                }
            }
           
           
            tempLabel.height = tempLabel.optimumSize.height
            btn.height = tempLabel.height
            maxY = btn.maxY + 23
        }
        bottomLine.y = maxY
        backBtn.y = bottomLine.maxY + 30
    }
    
    func riskScuess() {
        resultView = UIView(frame: self.bgView.bounds)
        resultView.isHidden = true
        resultView.backgroundColor = UIColor.white
        self.bgView.addSubview(resultView)

        //您的风险评级为
        let  titleLabel = UILabel(frame: CGRect(x: 0, y: 44, width: SCREEN_WIDTH, height: 18))
        titleLabel.text = "您的风险评级为"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.customFont(ofSize: 18)
        titleLabel.textColor = UIColor.hex("333333")
        resultView.addSubview(titleLabel)

        //类型
        typeLabel = UILabel(frame: CGRect(x: 0, y: titleLabel.maxY + 24, width: SCREEN_WIDTH, height: 36))
        typeLabel.textColor = redTitleColor
        typeLabel.text = "\"保守型\""
        typeLabel.textAlignment = .center
        typeLabel.font = UIFont.boldSystemFont(ofSize: 36)
        resultView.addSubview(typeLabel)
        
        //类型
        let  typeImgView = UIImageView(frame: CGRect(x: 0, y: typeLabel.maxY + 45, width: 90, height: 82))
        typeImgView.image = UIImage(named: "user_risk_result_jq")
        typeImgView.centerX = SCREEN_WIDTH / 2
        resultView.addSubview(typeImgView)

        
        typeDetailLabel = RTLabel(frame: CGRect(x: 32, y: typeImgView.maxY + 18, width: SCREEN_WIDTH - 32 * 2, height: 10))
        typeDetailLabel.text = "<font size=14 color='#666666'>您属于保守型出借人，属于风险承受能力较低投资很谨慎的出借人。应尽量回避波动性事实较大的投资产品，保护本金不受损失和保持资产流动性是首要目标。</font>"
        typeDetailLabel.height = typeDetailLabel.optimumSize.height
        resultView.addSubview(typeDetailLabel)
        
        let seeBtn = UIButton(type: .custom)
        seeBtn.frame = CGRect(x: 32, y: resultView.height - 126 - 44, width: SCREEN_WIDTH - 64, height: 44)
        seeBtn.setBackgroundImage(UIImage(named:"user_safe_go_sure"), for: .normal)
        seeBtn.setTitle("去出借", for: .normal)
        seeBtn.tag = 10000
        seeBtn.addTarget(self, action: #selector(self.bottomBtnClick(_:)), for: .touchUpInside)
        seeBtn.setTitleColor(UIColor.white, for: .normal)
        seeBtn.titleLabel?.font = UIFont.customFont(ofSize: 18)
        resultView.addSubview(seeBtn)
        
        let resetBtn = UIButton(type: .custom)
        resetBtn.frame = CGRect(x: 32, y: seeBtn.maxY + 29, width: SCREEN_WIDTH - 64, height: 44)
        resetBtn.setBackgroundImage(UIImage(named:"user_safe_go_cancel"), for: .normal)
        resetBtn.tag = 10001
        resetBtn.addTarget(self, action: #selector(self.bottomBtnClick(_:)), for: .touchUpInside)
        resetBtn.setTitle("重新测评", for: .normal)
        resetBtn.setTitleColor(redColor, for: .normal)
        resetBtn.titleLabel?.font = UIFont.customFont(ofSize: 18)
        resultView.addSubview(resetBtn)
    }
    
    func bottomBtnClick( _ sender:UIButton) {
        
        //查看产品
        if sender.tag == 10000 {
            GPWHelper.selectTabBar(index: PROJECTBARTAG)
        }else{
            //重新测评
            selectedScoreArray.removeAll()
            resultView.isHidden = true
            selectNum = 0
            let tempData = dataArray[selectNum] as? [String:Any]
            self.reloadData(dic: tempData!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
