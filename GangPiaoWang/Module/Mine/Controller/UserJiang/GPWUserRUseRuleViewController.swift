//
//  GPWUserRUseRuleViewController.swift
//  GangPiaoWang
//   使用规则
//  Created by gangpiaowang on 2017/3/22.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
class GPWUserRUseRuleViewController: GPWSecBaseViewController {

    private let array = [
        [ "img":"user_reuser_fangshi","title":"获取方式","content":"1、用户通过注册可获得\(GPWGlobal.sharedInstance().app_exper_amount)元体验金，实名认证后得\(GPWGlobal.sharedInstance().app_accountsred)元红包，首次投资后得1%加息券；\n\n2、钢票网会不定期举行各种活动回馈用户，活动中会有红包和加息券奖励。"],
   ["img":"user_reuser_role","title":"使用规则","content":"1、红包不抵入出借金额中，项目回款时同本息一起发放至出借人账户；\n\n2、红包、加息券均不可叠加使用，每次各只能用一张；\n\n3、用户使用红包时，系统会根据出借金额，默认选择最优红包使用，也可以选择使用其他红包；\n\n4、出借过程中，加息券可以选择使用；\n\n5、红包和加息券只能在指定项目中使用；\n\n6、红包或加息券不可拆分使用，也不可转赠他人；\n\n7、已使用红包、加息券的产品，出现流标情况，红包、加息券将退回到账户中，可继续使用；\n\n8、红包和加息券存在有效期，过期将失效，请及时使用；\n\n9、如有疑问请致电钢票网热线：400-900-9017。"]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "使用规则"
        
        let scrollview = UIScrollView(frame: self.bgView.bounds)
        scrollview.backgroundColor = UIColor.white
        self.bgView.addSubview(scrollview)
        
        var maxHeight:CGFloat = 0
        for i in 0 ..< array.count {
            let topView = UIView(frame: CGRect(x: 0, y: maxHeight, width: SCREEN_WIDTH, height: 8))
            topView.backgroundColor = bgColor
            scrollview.addSubview(topView)
           
            let imgView = UIImageView(frame: CGRect(x: 16, y: topView.maxY + 16, width: 20, height: 20))
            imgView.image = UIImage(named: array[i]["img"]!)
            scrollview.addSubview(imgView)
          
            let titleLabel = UILabel(frame: CGRect(x: imgView.maxX + 10, y: imgView.y, width: 300, height: 20))
            titleLabel.textColor = UIColor.hex("333333")
            titleLabel.font = UIFont.systemFont(ofSize: 16)
            titleLabel.text = array[i]["title"]!
            scrollview.addSubview(titleLabel)
            
            let line = UIView(frame: CGRect(x: imgView.x, y: titleLabel.maxY + 16, width: SCREEN_WIDTH - imgView.x * 2, height: 0.5))
            line.backgroundColor = lineColor
            scrollview.addSubview(line)
            
            let  content1Label = RTLabel(frame: CGRect(x: line.x, y: line.maxY + 16, width: line.width, height: 0))
            content1Label.text = "<font size=14 color='#555555'>\(array[i]["content"]!)</font>"
            content1Label.height = content1Label.optimumSize.height
           scrollview.addSubview(content1Label)
            
            maxHeight = content1Label.maxY + 24
            scrollview.contentSize = CGSize(width: SCREEN_WIDTH, height: maxHeight)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
