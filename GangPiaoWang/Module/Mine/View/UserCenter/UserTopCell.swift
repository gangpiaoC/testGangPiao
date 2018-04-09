//
//  UserCell.swift
//  test
//
//  Created by gangpiaowang on 2016/12/16.
//  Copyright © 2016年 mutouwang. All rights reserved.
//

import UIKit
typealias userTopcallback = (_ flag:Bool)->Void
class UserTopCell: UITableViewCell {

    var callBack:userTopcallback?

    weak var superController:UIViewController?

    fileprivate var prightImgView:UIImageView!

    //查看按钮
    fileprivate var eyeBtn:UIButton!
    
    //用户手机号
    var phoneLabel:RTLabel!
    
    //收益
    fileprivate var everyAddMoneyLabel:UILabel!
    fileprivate var everyAddMoneyStr:String!

    //资金总额
    fileprivate var acountMoneyLabel:UILabel!
    fileprivate var acountMoneyStr:String!

    //可用余额
    fileprivate var partLabel:UILabel!
    fileprivate var partStr:String!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.selectionStyle = .none

        let userImgView = UIImageView(frame: CGRect(x: 16, y: 35, width: 31, height: 31))
        userImgView.image = UIImage(named: "user_center_toplogo")
        contentView.addSubview(userImgView)
        
        phoneLabel = RTLabel(frame: CGRect(x: userImgView.maxX + 8,y:  0,width: 200,height: 16))
        phoneLabel.text = "<font size=16 color='#ffffff'>***********</font>"
        phoneLabel.size = phoneLabel.optimumSize
        phoneLabel.centerY = userImgView.centerY
        self.contentView.addSubview(phoneLabel)

        prightImgView = UIImageView(frame: CGRect(x: phoneLabel.maxX + 10, y: 0, width: 7, height: 13))
        prightImgView.image = UIImage(named: "user_center_topright")
        prightImgView.centerY = userImgView.centerY + 3
        contentView.addSubview(prightImgView)

        //用户信息按钮
        let  userInfoBtn = UIButton(type: .custom)
        userInfoBtn.frame = CGRect(x: userImgView.x, y: userImgView.y, width: prightImgView.maxX - userImgView.x, height: userImgView.height)
        userInfoBtn.tag = 103
        userInfoBtn.addTarget(self, action: #selector(self.setClick(_:)), for: .touchUpInside)
        contentView.addSubview(userInfoBtn)

        //底部空白横条
        let  bottomView = UIView(frame: CGRect(x: 0, y: 180 + 90 + 8 - 83, width: SCREEN_WIDTH, height: 83))
        bottomView.backgroundColor = UIColor.white
        contentView.addSubview(bottomView)

        //展示钱数
        let  moneyBgView = UIView(frame: CGRect(x: 16, y: 90, width: SCREEN_WIDTH - 32, height: 180))
        moneyBgView.layer.cornerRadius = 5
        moneyBgView.backgroundColor = UIColor.white
        moneyBgView.layer.shadowColor = UIColor.black.cgColor
        moneyBgView.layer.shadowOpacity = 0.2
        moneyBgView.layer.shadowRadius = 6
        moneyBgView.layer.shadowOffset = CGSize(width: 2, height: 2)
        contentView.addSubview(moneyBgView)

        let temp1Label = UILabel(frame: CGRect(x: 0,y: 26,width: moneyBgView.width,height:  17))
        temp1Label.text = "资金总额(元)"
        temp1Label.font = UIFont.customFont(ofSize: 16)
        temp1Label.textColor = UIColor.hex("999999")
        temp1Label.textAlignment = .center
        moneyBgView.addSubview(temp1Label)

        eyeBtn = UIButton(type: .custom)
        eyeBtn.frame = CGRect(x: pixw(p: 214), y: 0, width: 9 + 18 + 9, height: 18)
        eyeBtn.addTarget(self, action: #selector(eyeClick), for: .touchUpInside)
        eyeBtn.setImage(UIImage(named:"user_center_eye_open"), for: .normal)
        eyeBtn.centerY = temp1Label.centerY
        moneyBgView.addSubview(eyeBtn)
        
        acountMoneyLabel = UILabel(frame:CGRect(x: 0,y: temp1Label.maxY +  12,width: temp1Label.width,height: 29))
        acountMoneyLabel.text = "0.00"
        acountMoneyLabel.font = UIFont.systemFont(ofSize: 28)
        acountMoneyLabel.textColor = UIColor.hex("f85015")
        acountMoneyLabel.textAlignment = .center
        moneyBgView.addSubview(acountMoneyLabel)
        
        
        let temp2Label = UILabel(frame: CGRect(x: 0,y: acountMoneyLabel.maxY + 31,width: moneyBgView.width / 2,height:  15))
        temp2Label.text = "累计收益(元)"
        temp2Label.font = UIFont.customFont(ofSize:  14)
        temp2Label.textColor = UIColor.hex("999999")
        temp2Label.textAlignment = .center
        moneyBgView.addSubview(temp2Label)
        
        everyAddMoneyLabel = UILabel(frame:CGRect(x: 0,y: temp2Label.maxY + 11,width: temp2Label.width,height:  21))
        everyAddMoneyLabel.text = "0.00"
        everyAddMoneyLabel.font = UIFont.systemFont(ofSize:  20)
        everyAddMoneyLabel.textColor = UIColor.hex("666666")
        everyAddMoneyLabel.textAlignment = .center
        moneyBgView.addSubview(everyAddMoneyLabel)

        let temp3Label = UILabel(frame: CGRect(x: moneyBgView.width / 2,y: acountMoneyLabel.maxY + 31,width: moneyBgView.width / 2,height:  15))
        temp3Label.text = "账户余额(元)"
        temp3Label.textAlignment = .center
        temp3Label.font = UIFont.customFont(ofSize:  14)
        temp3Label.textColor = UIColor.hex("999999")
       moneyBgView.addSubview(temp3Label)

        partLabel =  UILabel(frame:CGRect(x: temp3Label.x,y: everyAddMoneyLabel.y,width: temp3Label.width,height:  21))
        partLabel.text = "0.00"
        partLabel.font = UIFont.systemFont(ofSize:  20)
        partLabel.textAlignment = .center
        partLabel.textColor = UIColor.hex("666666")
        moneyBgView.addSubview(partLabel)


        let acoutMBtn = UIButton(type: .custom)
        acoutMBtn.frame = moneyBgView.bounds
        acoutMBtn.y = eyeBtn.maxY + 30
        acoutMBtn.height = acoutMBtn.height - eyeBtn.maxY - 30
        acoutMBtn.tag = 102
        acoutMBtn.addTarget(self, action: #selector(self.setClick(_:)), for: .touchUpInside)
        moneyBgView.addSubview(acoutMBtn)
        
    }
    
    func updata(_ everyAddMoney:String,acountMoney:String,phone:String,partMoney:String,superC:UIViewController) {
        everyAddMoneyStr = everyAddMoney
        acountMoneyStr = acountMoney
        partStr = partMoney
        let temp = UserDefaults.standard.value(forKey: "eyeFlag")
        if temp == nil {
            UserDefaults.standard.set("1", forKey: "eyeFlag")
            eyeBtn.setImage(UIImage(named:"user_center_eye_open"), for: .normal)
            self.changLabelNum()
        }else{
            if temp as! String == "1"{
                eyeBtn.setImage(UIImage(named:"user_center_eye_open"), for: .normal)
                self.changLabelNum()
            }else{
                eyeBtn.setImage(UIImage(named:"user_center_eye_close"), for: .normal)
                self.everyAddMoneyLabel.text = "****"
                self.acountMoneyLabel.text = "****"
                self.partLabel.text = "****"
            }
        }
        self.phoneLabel.width = 300
        self.phoneLabel.text =  "<font size=16 color='#ffffff'>\(phone)</font>"
        self.phoneLabel.size = self.phoneLabel.optimumSize
        self.prightImgView.x = self.phoneLabel.maxX + 10
        self.prightImgView.centerY = self.phoneLabel.centerY
        self.superController = superC
    }

    func changLabelNum() {
        eyeBtn.isUserInteractionEnabled = false
        let  tempformat = NumberFormatter()
        tempformat.numberStyle = .decimal

        let doubleNum = tempformat.number(from: everyAddMoneyStr)
        self.everyAddMoneyLabel.changNum(toNumber: doubleNum as! Double, withDurTime: 1, withStrnumber: everyAddMoneyStr)

        let acountNum = tempformat.number(from: acountMoneyStr)
        self.acountMoneyLabel.changNum(toNumber:acountNum as! Double , withDurTime: 1, withStrnumber: acountMoneyStr)

        let partNum = tempformat.number(from: partStr)
        self.partLabel.changNum(toNumber:partNum as! Double , withDurTime: 1, withStrnumber: partStr)
        let time: TimeInterval = 1.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.eyeBtn.isUserInteractionEnabled = true
        }
    }
    
    @objc func setClick(_ sender:UIButton) {
        if sender.tag == 102 {
            MobClick.event("mine", label: "资金统计")
            superController?.navigationController?.pushViewController(GPWUserMoneyFundViewController(), animated: true)
        }else if sender.tag == 103 {
             superController?.navigationController?.pushViewController(UserSetViewController(), animated: true)
        }
    }

    @objc func eyeClick( _sender:UIButton) {
        let temp = UserDefaults.standard.value(forKey: "eyeFlag") as? String
            if temp == "0" {
                eyeBtn.setImage(UIImage(named:"user_center_eye_open"), for: .normal)
                UserDefaults.standard.set("1", forKey: "eyeFlag")
                self.changLabelNum()
            }else{
                eyeBtn.setImage(UIImage(named:"user_center_eye_close"), for: .normal)
                UserDefaults.standard.set("0", forKey: "eyeFlag")
                self.everyAddMoneyLabel.text = "****"
                self.acountMoneyLabel.text = "****"
                self.partLabel.text = "****"
            }
        self.callBack!(true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
