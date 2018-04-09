//
//  GPWHomeVierticalView.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/4/7.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWHomeVierticalView: UIView {
    var dicArray:[String]?
    var index:Int?
    var timer:Timer?
    var superController:UIViewController?
    init(frame: CGRect,array:[String]?) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.dicArray = array
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.nextButton), userInfo: nil, repeats: true)
        self.index = 100
        if (self.dicArray?.count)! <= 1 {
            timer?.invalidate()
        }else{
            if timer?.isValid == false {
                timer?.fire()
            }
        }
        
        //图标
        let  imgView = UIImageView(frame: CGRect(x: pixw(p: 110), y: 0, width: 11, height: 13))
        imgView.centerY = self.height / 2
        imgView.image = UIImage(named: "home_bottom")
        self.addSubview(imgView)
        
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: imgView.maxX + 5, y: 0, width: SCREEN_WIDTH - 16 - imgView.maxX - 10, height: self.height)
        btn.tag = self.index!
        self.addSubview(btn)
        
        //标题
        let  titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: btn.width, height: btn.height))
        titleLabel.font = UIFont.customFont(ofSize: 12)
        titleLabel.isUserInteractionEnabled = false
        titleLabel.tag = 1000
        titleLabel.text = array?[0]
        titleLabel.textColor = UIColor.hex("999999")
        btn.addSubview(titleLabel)
    }
    
    func update(array:[String]) {
        self.dicArray = array
        let  firstBtn = self.viewWithTag(self.index!) as! UIButton
        let titleLabel = firstBtn.viewWithTag(1000) as! UILabel
        let titleStr = self.dicArray?[self.index! - 100]
        titleLabel.text = titleStr
        if (self.dicArray?.count)! <= 1 {
            timer?.invalidate()
        }else{
            if timer?.isValid == false {
                timer?.fire()
            }
        }
    }
    
    func nextButton() {
        let  firstBtn = self.viewWithTag(self.index!) as! UIButton
        let modelBtn = UIButton(type: .custom)
        modelBtn.frame = CGRect(x: firstBtn.x, y: firstBtn.height, width: firstBtn.width, height: firstBtn.height)
        self.index = self.index! + 1
        modelBtn.tag = self.index!
        if modelBtn.tag - 100 == self.dicArray?.count {
            self.index = 100
            modelBtn.tag = self.index!
        }
        self.addSubview(modelBtn)
        
        //标题
        let  titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width:modelBtn.width, height: modelBtn.height))
        titleLabel.font = UIFont.customFont(ofSize: 12)
        let titleStr = self.dicArray?[self.index! - 100]
        titleLabel.isUserInteractionEnabled = false
        titleLabel.text = titleStr
        titleLabel.tag = 1000
        titleLabel.textColor = UIColor.hex("999999")
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
