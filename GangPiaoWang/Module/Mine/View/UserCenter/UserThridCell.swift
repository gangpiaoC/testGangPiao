//
//  UserThridCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/6/8.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class UserThridCell: UITableViewCell {
    weak fileprivate var superControl:UserController?
    fileprivate var dicArray:[[String:String]]?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        //竖线
        let verLine = UIView(frame: CGRect(x: SCREEN_WIDTH / 2, y: 24, width: 1, height: 290 - 24 * 2))
        verLine.backgroundColor = lineColor
        contentView.addSubview(verLine)
        
        //横线
        let hor1Line = UIView(frame: CGRect(x: 16, y: 290  / 3, width: SCREEN_WIDTH - 16 * 2, height: 1))
        hor1Line.backgroundColor = lineColor
        contentView.addSubview(hor1Line)

        //横线1
        let hor1Line1 = UIView(frame: CGRect(x: 16, y: 290 * 2 / 3, width: SCREEN_WIDTH - 16 * 2, height: 1))
        hor1Line1.backgroundColor = lineColor
        contentView.addSubview(hor1Line1)

    }
    
    func updata(_ dicArray:[[String:String]],superControl:UserController) {
        self.superControl = superControl
        for subview in contentView.subviews {
            if subview.tag >= 100000 {
                subview.removeFromSuperview()
            }
        }
        
        for i in 0 ..< 3 {
            for j in 0 ..< 2 {
                let  btn = UIButton(type: .custom)
                btn.frame = CGRect(x: SCREEN_WIDTH / 2 * CGFloat(j), y: 189 / 2 * CGFloat(i), width: SCREEN_WIDTH / 2, height: 189 / 2)
                btn.tag = 100000 + i * 2 + j
                btn.setTitle(dicArray[i * 2 + j]["title"]!, for: .normal)
                btn.setTitleColor(UIColor.clear, for: .normal)
                btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
                btn.backgroundColor = UIColor.clear
                contentView.addSubview(btn)
                
                let  tiImgView = UIImageView(frame: CGRect(x: 16, y: 24, width: 28, height: 30))
                tiImgView.image = UIImage(named: dicArray[i * 2 + j]["img"]!)
                btn.addSubview(tiImgView)
                
                let titleLabel = UILabel(frame: CGRect(x: tiImgView.maxX + 10, y: tiImgView.y + 3, width: btn.width - 16 - tiImgView.maxX - 10, height: 17))
                titleLabel.text = dicArray[i * 2 + j]["title"]!
                titleLabel.font = UIFont.systemFont(ofSize: 16)
                titleLabel.textColor = UIColor.hex("4f4f4f")
                btn.addSubview(titleLabel)
                
                let detailLabel = UILabel(frame: CGRect(x: titleLabel.x, y: titleLabel.maxY + 11, width: titleLabel.width , height: 15))
                detailLabel.text = dicArray[i * 2 + j]["detail"]!
                detailLabel.font = UIFont.systemFont(ofSize: 14)
                detailLabel.textColor = UIColor.hex("b7b7b7")
                btn.addSubview(detailLabel)

                if btn.tag == 100003 {
                    detailLabel.textColor = UIColor.hex("fa713d")
                    if GPWUser.sharedInstance().data_award != "" {
                        detailLabel.text = "\(GPWUser.sharedInstance().data_award)元红包可用"
                    }else if GPWUser.sharedInstance().data_ticket != "" {
                        detailLabel.text = "\(GPWUser.sharedInstance().data_ticket)张加息券可用"
                    }else{
                        detailLabel.textColor = UIColor.hex("b7b7b7")
                        detailLabel.text = "真金白银免费送"
                    }
                }
                if btn.tag == 100000 {
                    let temp = UserDefaults.standard.value(forKey: "eyeFlag") as? String ?? "0"
                    if temp == "1" {
                        self.changLabelNum(detailLabel, detailLabel.text!)
                    }else{
                        detailLabel.text = "待收:****"
                    }
                }
            }
        }
    }
    func changLabelNum( _ label:UILabel,_ num :String ) {
        let  array = num.components(separatedBy: ":")
        let  tempformat = NumberFormatter()
        tempformat.numberStyle = .decimal
        let doubleNum = tempformat.number(from: array[1])
        label.changNum(toNumber: doubleNum as! Double, withDurTime: 1, withStrnumber: num)
    }

    @objc func btnClick(_ sender:UIButton) {
        switch sender.tag {
        case 100000:
            //出借记录
            MobClick.event("mine", label: "出借记录")
            self.superControl?.navigationController?.pushViewController(GPWOutRcordController(), animated: true)
             break
        case 100001:
            //回款日历
            MobClick.event("mine", label: "回款日历")
            self.superControl?.navigationController?.pushViewController(GPWUserBCalendarController(), animated: true)
            break
        case 100002:
            //资金流水
            MobClick.event("mine", label: "资金流水")
            self.superControl?.navigationController?.pushViewController(GPWUserMoneyToViewController(), animated: true)
            break
        case 100003:
            //优惠券
            MobClick.event("mine", label: "优惠券")
            let  tempControl = UserRewardViewController()
            tempControl._startIndex = 0
            self.superControl?.navigationController?.pushViewController(tempControl, animated: true)
            break
        case 100004:
            //邀请奖励
            MobClick.event("mine", label: "邀请奖励")
            if GPWGlobal.sharedInstance().app_invite_link.count > 0 {
                self.superControl?.navigationController?.pushViewController(GPWWebViewController(subtitle: "", url: GPWGlobal.sharedInstance().app_invite_link), animated: true)
            }else{
                self.superControl?.navigationController?.pushViewController(GPWGetFriendRcordController(), animated: true)
            }
            break
             case 100005:
                //信息披露
                self.superControl?.navigationController?.pushViewController(GPWFHelpViewController(), animated: true)
            break
        default:
            printLog(message: "不知道是啥")
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
