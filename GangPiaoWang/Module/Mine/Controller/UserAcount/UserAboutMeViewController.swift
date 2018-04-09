//
//  UserAboutMeViewController.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/18.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class UserAboutMeViewController: GPWSecBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关于我们"
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 149))
        bgView.backgroundColor = UIColor.white
        self.bgView.addSubview(bgView)
        let imgView = UIImageView(frame: CGRect(x: 0, y: 30, width: 151, height: 49))
        imgView.centerX = bgView.width / 2
        imgView.image = UIImage(named: "user_about_logo")
        bgView.addSubview(imgView)
        
        let label = UILabel(frame: CGRect(x: 0, y: imgView.maxY + 20, width: 56, height: 20))
        label.text = "v1.0.0"
        label.centerX = SCREEN_WIDTH / 2
        label.textColor = UIColor.hex("666666")
        label.textAlignment = .center
        label.font = UIFont.customFont(ofSize: 14)
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor.hex("666666").cgColor
        label.layer.borderWidth = 0.5
        label.layer.cornerRadius = label.height / 2
        bgView.addSubview(label)
        
        let cell = UserOtherCell(style: .default, reuseIdentifier: "aboutme")
        cell.updata(title: "关于钢票", superc: self)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.click(sender:)))
        cell.addGestureRecognizer(tap)
        cell.width = SCREEN_WIDTH
        cell.backgroundColor = UIColor.white
        cell.y = bgView.maxY + 10
        self.bgView.addSubview(cell)
    }
    @objc func click(sender:UITapGestureRecognizer) {
        print("关于钢票")
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
