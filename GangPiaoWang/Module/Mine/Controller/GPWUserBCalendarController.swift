//
//  GPWUserBCalendarController.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/11/22.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWUserBCalendarController: GPWSecBaseViewController {

    fileprivate  var maxY:CGFloat = 0
    fileprivate var scrollView:UIScrollView!
    fileprivate var  calendarView:GPWCalendarView!
    fileprivate var   topView:UIView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .black
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barStyle = .default
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
         super.viewDidLoad()
        self.title = "回款日历"
        self.navigationBar.isHidden = true
        self.bgView.y = 0
        self.bgView.height += 64
        scrollView = UIScrollView(frame: self.bgView.bounds)
        self.bgView.addSubview(scrollView)
        self.firstView()

        calendarView = Bundle.main.loadNibNamed("SFCalendarView", owner: nil, options: nil)?.first as! GPWCalendarView
        calendarView.frame = CGRect(x: 0, y: 149 + 20, width: SCREEN_WIDTH, height: 320)
        calendarView.callBack = {   [weak self] (array,wait,returnA) in
            guard let strongSelf = self else { return }
            strongSelf.showHuikuan(array)
            if wait != "1" {
                let  waitLabel = strongSelf.topView.viewWithTag(10001) as! UILabel
                waitLabel.text = wait
                let  returnLabel = strongSelf.topView.viewWithTag(10000) as! UILabel
                returnLabel.text = returnA
            }
        }
        scrollView.addSubview(calendarView)
        self.threeView()

    }

    func firstView() {
        topView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 149 + 20))
        scrollView.addSubview(topView)

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 149 + 20)

        //设置渐变的主颜色
        gradientLayer.colors = [UIColor.hex("fa481a").cgColor, UIColor.hex("f76b1c").cgColor]
        //将gradientLayer作为子layer添加到主layer上
        topView.layer.addSublayer(gradientLayer)
        topView.layer.insertSublayer(gradientLayer, at: 0)

        //设置顶部
        let  titleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: SCREEN_WIDTH, height: 44))
        titleLabel.textColor = UIColor.white
        titleLabel.text = "回款日历"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.customFont(ofSize: 18)
        topView.addSubview(titleLabel)

        setupLeftButton()
        let array = [
            ["img":"user_bc_huikuan","title":"当月已回款(元)","money":"20,186.72"],
            ["img":"user_bc_daishou","title":"当月待回款(元)","money":"80,186.25"]
        ]

        for i in 0 ..< array.count {
            let tempImgView = UIImageView(frame: CGRect(x: pixw(p: 32) + CGFloat(i) * SCREEN_WIDTH / 2, y: 79 + 20, width: 20, height: 20))
            tempImgView.image = UIImage(named:array[i]["img"]!)
            topView.addSubview(tempImgView)

            let  tempTLabel = UILabel(frame: CGRect(x: tempImgView.maxX + 7, y: 0, width: 100, height: 15))
            tempTLabel.textColor = UIColor.hex("ffa189")
            tempTLabel.centerY = tempImgView.centerY
            tempTLabel.font = UIFont.customFont(ofSize: 14)
            tempTLabel.text = array[i]["title"]
            topView.addSubview(tempTLabel)

            let  tempMoneyLabel = UILabel(frame: CGRect(x: tempTLabel.x, y:tempTLabel.maxY + 10, width: 100, height: 19))
            tempMoneyLabel.textColor = UIColor.white
            tempMoneyLabel.font = UIFont.customFont(ofSize: 18)
            tempMoneyLabel.text = array[i]["money"]
            tempMoneyLabel.tag = 10000 + i
            topView.addSubview(tempMoneyLabel)
        }
    }
    fileprivate func setupLeftButton() {
        self.leftButton = GPWButton.backButton(image: UIImage(named: "nav_left_wite")!)
        self.leftButton!.addTarget(self, action: #selector(back(sender:)), for: .touchUpInside)
        topView.addSubview(self.leftButton)
    }


    func threeView() {
        let  tempView = UIView(frame: CGRect(x: 0, y: calendarView.maxY, width:SCREEN_WIDTH , height: 35 + 16 + 16))
        tempView.backgroundColor = UIColor.white
        scrollView.addSubview(tempView)

        let  tempLabel = UILabel(frame: CGRect(x: SCREEN_WIDTH - 50 - 16 , y: tempView.height - 16 - 16, width: 50, height: 16))
        tempLabel.font = UIFont.customFont(ofSize: 14)
        tempLabel.text = "回款日"
        tempLabel.textColor = UIColor.hex("666666")
        tempView.addSubview(tempLabel)

        let dianView = UIView(frame: CGRect(x: tempLabel.x - 7 - 6, y: 0, width: 7, height: 7))
        dianView.backgroundColor = UIColor.hex("fcc30c")
        dianView.layer.cornerRadius = 3.5
        dianView.centerY = tempLabel.centerY
        tempView.addSubview(dianView)
         maxY = tempView.maxY + 10
        printLog(message: maxY)
    }

    func showHuikuan( _ array:[JSON]) {
        maxY = 566
        for subView in scrollView.subviews {
            if subView.tag == 10000 {
                subView.removeFromSuperview()
            }
        }
        for  json in array {
            let tempView = UIView(frame: CGRect(x: 0, y: maxY, width: SCREEN_WIDTH, height: 46))
            tempView.backgroundColor = UIColor.white
            tempView.tag = 10000
            scrollView.addSubview(tempView)

            let dianView = UIView(frame: CGRect(x: 16, y: 29, width: 5, height: 5))
            dianView.backgroundColor = UIColor.hex("fcc30c")
            dianView.layer.cornerRadius = 2.5
            tempView.addSubview(dianView)

            let  titleLabel = UILabel(frame: CGRect(x: dianView.maxX + 9, y: 0, width: 150, height: 46))
            titleLabel.textColor = UIColor.hex("333333")
            titleLabel.font = UIFont.customFont(ofSize: 14)
            titleLabel.text = json["title"].stringValue
            tempView.addSubview(titleLabel)
            dianView.centerY = titleLabel.centerY

            let  moneyLabel = RTLabel(frame: CGRect(x: SCREEN_WIDTH / 2 - 10, y: 0, width: SCREEN_WIDTH / 2 - 16 + 10, height: 46))
            moneyLabel.text = "<font size=14 color='#999999'>待回款金额   </font><font size=14 color='#333333'>\(json["amount"])元</font>"
            moneyLabel.height = moneyLabel.optimumSize.height
            moneyLabel.centerY = titleLabel.centerY
            tempView.addSubview(moneyLabel)

            let  line = UIView(frame: CGRect(x: 16, y: tempView.height - 0.5, width: SCREEN_WIDTH - 16, height: 0.5))
            line.backgroundColor = bgColor
            tempView.addSubview(line)

            maxY = tempView.maxY
        }
        scrollView.contentSize = CGSize(width: SCREEN_WIDTH, height: maxY + 20)
    }
}
