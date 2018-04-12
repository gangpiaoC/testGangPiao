//
//  VierticalScrollView.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/3/20.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class VierticalScrollView: UIView {
    var dicArray:JSON?
    var index:Int?
    var timer:Timer?
    var superController:UIViewController?
    init(frame: CGRect,array:JSON?) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.dicArray = array
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.nextButton), userInfo: nil, repeats: true)
        self.index = 100
        
        //图标
        let  imgView = UIImageView(frame: CGRect(x: 16, y: 0, width: 17, height: 15))
        imgView.centerY = self.height / 2
        imgView.image = UIImage(named: "home_indexs_gonggao")
        self.addSubview(imgView)
        
        //列表
        let  listBtn = UIButton(type: .custom)
        listBtn.frame = CGRect(x: SCREEN_WIDTH - 16 - 24, y: 0, width: 24, height: 40)
        listBtn.imageView?.contentMode = .scaleAspectFill
        listBtn.setImage(UIImage(named: "home_indexs_dian"), for: .normal)
        listBtn.addTarget(self, action: #selector(btnListClick), for: .touchUpInside)
        self.addSubview(listBtn)
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: imgView.maxX + 10, y: 0, width: listBtn.x - 16 - imgView.maxX - 10, height: self.height)
        btn.addTarget(self, action: #selector(self.btnCilck(sender:)), for: .touchUpInside)
        btn.tag = self.index!
        self.addSubview(btn)
        
        //标题
        let  titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: btn.width, height: btn.height))
        titleLabel.font = UIFont.customFont(ofSize: 14)
        titleLabel.isUserInteractionEnabled = false
        titleLabel.tag = 1000
        titleLabel.textColor = titleColor
        btn.addSubview(titleLabel)
    }
    
    func update(array:JSON) {
        self.dicArray = array
         let  firstBtn = self.viewWithTag(self.index!) as! UIButton
        let titleLabel = firstBtn.viewWithTag(1000) as! UILabel
        let tempDic = self.dicArray?[self.index! - 100]
        titleLabel.text = tempDic?["title"].string
        if (self.dicArray?.count)! <= 1 {
            timer?.invalidate()
        }else{
            if timer?.isValid == false {
                timer?.fire()  
            }
        }
    }
    
    @objc func btnCilck(sender:UIButton) {
        let tempDic = self.dicArray?[self.index! - 100]
        let autoid = tempDic!["auto_id"].intValue
        MobClick.event("home", label: "平台公告-第\(self.index! - 100)个")
        let  vc = GPWWebViewController(subtitle: "", url: "https://www.gangpiaowang.com/Web/account_newshows.html?auto_id=\(autoid)")
        vc.messageFlag = "1"
        self.superController?.navigationController?.pushViewController( vc, animated: true)
    }
    
    @objc func btnListClick() {
        printLog(message: "去往列表")
        MobClick.event("home", label: "平台公告-列表")
        superController?.navigationController?.pushViewController(GPWHomeMessageController(), animated: true)
    }
    
    @objc func nextButton() {
        let  firstBtn = self.viewWithTag(self.index!) as! UIButton
        let modelBtn = UIButton(type: .custom)
        modelBtn.frame = CGRect(x: firstBtn.x, y: firstBtn.height, width: firstBtn.width, height: firstBtn.height)
        self.index = self.index! + 1
        modelBtn.tag = self.index!
        if modelBtn.tag - 100 == self.dicArray?.count {
            self.index = 100
            modelBtn.tag = self.index!
        }
        modelBtn.addTarget(self, action: #selector(self.btnCilck(sender:)), for: .touchUpInside)
        self.addSubview(modelBtn)
     
        //标题
        let  titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width:modelBtn.width, height: modelBtn.height))
        titleLabel.font = UIFont.customFont(ofSize: 14)
        let tempDic = self.dicArray?[self.index! - 100]
        titleLabel.isUserInteractionEnabled = false
        titleLabel.text = tempDic?["title"].string
        titleLabel.tag = 1000
        titleLabel.textColor = UIColor.hex("666666")
        modelBtn.addSubview(titleLabel)
        
        UIView.animate(withDuration: 0.25, animations: {
            firstBtn.y = -firstBtn.height
            modelBtn.y = 0
        }) { (isFinished) in
             firstBtn.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
