//
//  GPWOutRcordController.swift
//  GangPiaoWang
//  出借记录
//  Created by gangpiaowang on 2016/12/23.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
class GPWOutRcordController: GPWSecBaseViewController,LazyScrollViewDelegate{
    var _startIndex = 0
    let contentArray = [
        //已出借
        ["title":"已出借","type":"loaned"],
        //收益中
        ["title":"收益中","type":"revenue"],
        //已完成
        ["title":"已完成","type":"finish"]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "出借记录"
        
        //设置顶部信息
        self.initTopView()
        let  lazyScrollView = LazyScrollView(frame: CGRect(x: 0, y: 110, width: SCREEN_WIDTH, height: self.bgView.height - 110), delegate: self, dataArray: contentArray)
        self.bgView.addSubview(lazyScrollView!)
    }
    //顶部视图
    func initTopView()  {
       let  imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 110))
        imgView.image = UIImage(named:"user_record_topView")
        self.bgView.addSubview(imgView)

        let  array = [
            ["title":"待收本金(元)","money": GPWUser.sharedInstance().capital ?? ""],
            ["title":"待收利息(元)","money": GPWUser.sharedInstance().wait_accrual ?? ""]
        ]
        for i in  0 ..< array.count {
            let titleLabel = UILabel(frame: CGRect(x:  SCREEN_WIDTH / 2  *  CGFloat(i), y: 38, width: SCREEN_WIDTH / 2, height: 22))
            titleLabel.text = array[i]["title"] ?? ""
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.customFont(ofSize: 16)
            titleLabel.textColor = UIColor.white
            imgView.addSubview(titleLabel)

            let moneyLabel = UILabel(frame: CGRect(x:  titleLabel.x, y: titleLabel.maxY + 1, width: SCREEN_WIDTH / 2, height: 22))
            moneyLabel.text = array[i]["money"] ?? ""
            moneyLabel.textAlignment = .center
            moneyLabel.font = UIFont.customFont(ofSize: 20)
            moneyLabel.textColor = UIColor.white
            imgView.addSubview(moneyLabel)
            if i == 0 {
                let line = UIView(frame: CGRect(x: SCREEN_WIDTH / 2 - 0.5, y: 48, width: 1, height: 25))
                line.backgroundColor = UIColor.white
                imgView.addSubview(line)
            }
        }
    }
    func lazyView(at index: Int32) -> LazyScrollSubView! {
        let view = GPWOutRcordView(frame: self.bgView.bounds)
        view.inCtl = self
        view.superControl = self
        return view
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
}
