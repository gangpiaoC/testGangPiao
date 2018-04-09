//
//  GPWUserMDetailViewController.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/30.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWUserMDetailViewController: GPWSecBaseViewController {

    var dicData:JSON?
    init(dic:JSON){
        super.init(nibName: nil, bundle: nil)
        self.dicData = dic
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "消息详情"
        
        printLog(message: "\(self.dicData!["auto_id"])")
        self.getNetData()
        self.bgView.backgroundColor = UIColor.white
        let titleLabel = UILabel(frame: CGRect(x: pixw(p:16), y:pixw(p: 30), width: SCREEN_WIDTH - pixw(p:32), height: pixw(p:18)))
        titleLabel.text = self.dicData?["title"].stringValue
        titleLabel.font = UIFont.customFont(ofSize: pixw(p:18))
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.hex("333333")
        self.bgView.addSubview(titleLabel)
        
        let timeLabel = UILabel(frame: CGRect(x: pixw(p:16), y: titleLabel.maxY + pixw(p:11), width: titleLabel.width, height: pixw(p:12)))
        timeLabel.text =  GPWHelper.strFromDate(self.dicData!["add_time"].doubleValue, format: "yyyy-MM-dd  HH:mm")
        timeLabel.textAlignment = .center
        timeLabel.textColor = UIColor.hex("999999")
        timeLabel.font = UIFont.customFont(ofSize: pixw(p:12))
        self.bgView.addSubview(timeLabel)
        
        let line = UIView(frame: CGRect(x: 0, y: timeLabel.maxY + pixw(p:12), width: SCREEN_WIDTH, height: 0.5))
        line.backgroundColor = lineColor
        self.bgView.addSubview(line)
        
        let contentLabel = RTLabel(frame: CGRect(x: pixw(p:16), y: line.maxY + pixw(p:20), width: titleLabel.width, height:pixw(p: 50)))
        contentLabel.text = "<font size=\(pixw(p: 16)) color='#555555'>\(self.dicData!["content"])</font>"
        contentLabel.height = contentLabel.optimumSize.height
        self.bgView.addSubview(contentLabel)
        
    }

    override func getNetData() {
        GPWNetwork.requetWithPost(url: Update_messages, parameters: ["auto_id":"\(self.dicData!["auto_id"])"], responseJSON:  { (json, msg) in
            printLog(message: json)
        }, failure: { error in

        })
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
