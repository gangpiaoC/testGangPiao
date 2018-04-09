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
        
        //横线
        let verLine = UIView(frame: CGRect(x: SCREEN_WIDTH / 2, y: 17, width: 0.5, height: 283 - 17 * 2))
        verLine.backgroundColor = lineColor
        contentView.addSubview(verLine)
        
        //竖线1
        let hor1Line = UIView(frame: CGRect(x: 16, y: 189 / 2, width: SCREEN_WIDTH - 16 * 2, height: 0.5))
        hor1Line.backgroundColor = lineColor
        contentView.addSubview(hor1Line)

        //竖线2
        let hor2Line = UIView(frame: CGRect(x: 16, y: 189, width: SCREEN_WIDTH - 16 * 2, height: 0.5))
        hor2Line.backgroundColor = lineColor
        contentView.addSubview(hor2Line)
    }
    
    func updata(_ dicArray:[[String:String]],superControl:UserController) {
        self.superControl = superControl
        for subview in contentView.subviews {
            if subview.tag >= 10000 {
                subview.removeFromSuperview()
            }
        }
        
        for i in 0 ..< 3 {
            for j in 0 ..< 2 {
                let  btn = UIButton(type: .custom)
                btn.frame = CGRect(x: SCREEN_WIDTH / 2 * CGFloat(j), y: 189 / 2 * CGFloat(i), width: SCREEN_WIDTH / 2, height: 189 / 2)
                btn.tag = 10000 + i * 2 + j
                btn.setTitle(dicArray[i * 2 + j]["title"]!, for: .normal)
                btn.setTitleColor(UIColor.clear, for: .normal)
                btn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
                btn.backgroundColor = UIColor.clear
                contentView.addSubview(btn)
                
                let  tiImgView = UIImageView(frame: CGRect(x: 16, y: 24, width: 26, height: 26))
                tiImgView.image = UIImage(named: dicArray[i * 2 + j]["img"]!)
                btn.addSubview(tiImgView)
                
                let titleLabel = UILabel(frame: CGRect(x: tiImgView.maxX + 10, y: tiImgView.y + 3, width: btn.width - 16 - tiImgView.maxX - 10, height: 17))
                titleLabel.text = dicArray[i * 2 + j]["title"]!
                titleLabel.font = UIFont.systemFont(ofSize: 16)
                titleLabel.textColor = UIColor.hex("333333")
                btn.addSubview(titleLabel)
                
                let detailLabel = UILabel(frame: CGRect(x: titleLabel.x, y: titleLabel.maxY + 11, width: titleLabel.width , height: 15))
                detailLabel.text = dicArray[i * 2 + j]["detail"]!
                detailLabel.font = UIFont.systemFont(ofSize: 14)
                detailLabel.textColor = UIColor.hex("999999")
                btn.addSubview(detailLabel)

                if btn.tag == 10000 {
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
    func btnClick(_ sender:UIButton) {
        switch sender.tag {
        case 10000:
            //出借记录
            MobClick.event("mine", label: "出借记录")
            self.superControl?.navigationController?.pushViewController(GPWOutRcordController(), animated: true)
             break
        case 10001:
            //回款日历
            MobClick.event("mine", label: "回款日历")
            self.superControl?.navigationController?.pushViewController(GPWUserBCalendarController(), animated: true)
            break
        case 10002:
            //资金流水
            MobClick.event("mine", label: "资金流水")
            self.superControl?.navigationController?.pushViewController(GPWUserMoneyToViewController(), animated: true)
            break
        case 10003:
            
            if sender.title(for: .normal) == "风险测评" {
                //风险测评
                MobClick.event("mine", label: "风险测评")
                self.superControl?.navigationController?.pushViewController(GPWRiskAssessmentViewController(), animated: true)
            }else{
                //邀请奖励
                MobClick.event("mine", label: "邀请奖励")
                self.superControl?.navigationController?.pushViewController(GPWGetFriendRcordController(), animated: true)
            }
            break
             case 10004:
                //网贷课堂
                self.superControl?.navigationController?.pushViewController(GPWWDKTViewController(), animated: true)
            break
             case 10005:
                //信息披露
                self.superControl?.navigationController?.pushViewController(GPWXXPLViewController(), animated: true)
            break
        default:
            printLog(message: "不知道是啥")
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
