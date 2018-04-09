//
//  GPWHTSecCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2016/12/20.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
import SnapKit

class GPWHTSecCell: UITableViewCell {
    weak fileprivate var superControl:GPWHomeTiyanViewController?
    fileprivate var noLoginView:UIView!
    fileprivate var marBtnConstraint: Constraint!
    fileprivate var dic:JSON?
    fileprivate var magImgView:UIImageView!

    fileprivate let left1Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.customFont(ofSize: 14)
        label.textColor = timeColor
        label.text = "还款方式"
        return label
    }()
    
    private let right1Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 14)
        label.textColor = titleColor
        label.text = "一次性还本付息"
        return label
    }()
    private let left2Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.customFont(ofSize: 14)
        label.textColor = timeColor
        label.text = "体验金额"
        return label
    }()
    
    private let right2Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 14)
        label.textColor = titleColor
        label.text = "6666元"
        return label
    }()
    private let left3Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.customFont(ofSize: 14)
        label.textColor = timeColor
        label.text = "产品描述"
        return label
    }()
    
    private let right3Label: UILabel = {
        let label = UILabel()
        label.font = UIFont.customFont(ofSize: 14)
        label.textColor = titleColor
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "体验标是平台设立的一个提供给用户进行体验的产品，体验金额使用后即可产生收益。"
        return label
    }()
    
    let markButton: UIButton = {
        let markButton = UIButton(type: .custom)
        markButton.setTitle("立即体验", for: .normal)
        markButton.layer.masksToBounds = true
        markButton.layer.cornerRadius = 3
        return markButton
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        contentView.addSubview(left1Label)
        contentView.addSubview(right1Label)
        contentView.addSubview(left2Label)
        contentView.addSubview(right2Label)
        contentView.addSubview(left3Label)
        contentView.addSubview(right3Label)
        contentView.addSubview(markButton)
        markButton.addTarget(self, action: #selector(handelMark), for: .touchUpInside)
        
        left1Label.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(22)
            maker.left.equalTo(contentView).offset(16)
            maker.width.equalTo(60)
        }
        right1Label.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(left1Label)
            maker.left.equalTo(left1Label.snp.right).offset(19)
        }
        
        left2Label.snp.makeConstraints { (maker) in
            maker.top.equalTo(left1Label.snp.bottom).offset(22)
            maker.left.width.equalTo(left1Label)
            //maker.width.equalTo(60)
        }
        right2Label.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(left2Label)
            maker.left.equalTo(right1Label)
        }
        
        left3Label.snp.makeConstraints { (maker) in
            maker.top.equalTo(left2Label.snp.bottom).offset(22)
            maker.left.width.equalTo(left2Label)
        }
        right3Label.snp.makeConstraints { (maker) in
            maker.top.equalTo(left3Label)
            maker.left.equalTo(right2Label)
            maker.right.equalTo(contentView).offset(-16)
        }
        
        markButton.snp.makeConstraints { (maker) in
            maker.top.equalTo(right3Label.snp.bottom).offset(40)
            marBtnConstraint = maker.height.equalTo(48).constraint
            maker.left.equalTo(contentView).offset(16)
            maker.right.equalTo(contentView).offset(-16)
            maker.bottom.equalTo(contentView).offset(-21)
        }
    }
    
    
    func updata(dic:JSON,superControl:GPWHomeTiyanViewController) {
        self.superControl = superControl
        self.dic = dic
        right1Label.text = dic["retpay_type"].stringValue

        right2Label.text = "\(dic["exper_amount"].intValue / 100)" + "元"
        right3Label.text = dic["product_descion"].stringValue
        let tempExperAmount = dic["exper_amount"].floatValue
       
        //当前时间的时间戳
        let timeInterval:TimeInterval = Date().timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        let hour = GPWHelper.strFromDate(Double(timeStamp), format: "HH")
        if Int(hour)! < 10 {
            marBtnConstraint.update(offset: 64)
            markButton.setImage(UIImage(named:"home_tiyan_cometime"), for: .normal)
            markButton.isUserInteractionEnabled = false
        }else{
            if tempExperAmount <= 0 {
                markButton.backgroundColor = UIColor.hex("c3c3c3")
                markButton.isUserInteractionEnabled = false
            }else{
                markButton.backgroundColor = UIColor.hex("fb4a0c")
            }
        }
    }

    
    //立即体验
    @objc private func handelMark() {
        if  GPWUser.sharedInstance().isLogin {
            if GPWUser.sharedInstance().is_idcard == 1 {
                if GPWUser.sharedInstance().is_valid == "1" {
                    MobClick.event("index_experience_biao", label: "exper_button")
                    let wid = UIApplication.shared.delegate!.window!
                    noLoginView = UIView(frame:CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
                    noLoginView.backgroundColor = UIColor.hex("000000", alpha: 0.3)
                    noLoginView.tag = 10000
                    wid!.addSubview(noLoginView)
                    
                    let showView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 228))
                    showView.centerX = noLoginView.width / 2
                    showView.backgroundColor = UIColor.white
                    showView.layer.masksToBounds = true
                    showView.layer.cornerRadius = 4
                    showView.isUserInteractionEnabled = true
                    showView.centerY = noLoginView.height / 2
                    noLoginView.addSubview(showView)
                    
                    let btn = UIButton(type: .custom)
                    btn.frame = CGRect(x: 10, y: showView.height - 20 - 56 , width: 216, height: 56)
                    btn.setBackgroundImage(UIImage(named: "home_tiyan_sure"), for: .normal)
                    btn.titleLabel?.font = UIFont.customFont(ofSize: 14)
                    btn.centerX = showView.width / 2
                    btn.addTarget(self, action: #selector(self.Click(sender:)), for: .touchUpInside)
                    btn.tag = 100
                    showView.addSubview(btn)
                    let shouyi = ((self.dic?["exper_amount"].floatValue)! / 100) * (self.dic?["deadline"].floatValue)! * (self.dic?["expect_rate"].floatValue)! / 365 / 100
                    let tempAmount = String(format: "%.2f", shouyi)
                    //标题
                    let  titleArray = ["出借金额","借款期限","预计收益"]
                    let  contentArray = ["\((self.dic?["exper_amount"].intValue)! / 100)元","\(self.dic?["deadline"] ?? "1")天",tempAmount]
                    
                    for i in 0 ..< titleArray.count {
                        let  titleLabel = UILabel(frame: CGRect(x: 49, y: 38 + i * 33, width: 58, height: 20))
                        titleLabel.text = titleArray[i]
                        titleLabel.font = UIFont.customFont(ofSize: 14)
                        titleLabel.textColor = UIColor.hex("666666")
                        showView.addSubview(titleLabel)
                        
                        if  i != titleArray.count - 1 {
                            let  contentLabel = UILabel(frame: CGRect(x: Int(titleLabel.maxX + 20.0), y: 0, width: 120, height: 20))
                            contentLabel.text = contentArray[i]
                            contentLabel.centerY = titleLabel.centerY
                            contentLabel.font = UIFont.customFont(ofSize: 14)
                            contentLabel.textColor = UIColor.hex("666666")
                            showView.addSubview(contentLabel)
                        }else{
                            let  contentLabel = UILabel(frame: CGRect(x: Int(titleLabel.maxX + 20.0), y:0, width: 120, height: 20))
                            contentLabel.centerY = titleLabel.centerY
                            contentLabel.attributedText = NSAttributedString.attributedString( contentArray[i], mainColor: redTitleColor, mainFont: 24, second: "元", secondColor: redTitleColor, secondFont: 12)
                            showView.addSubview(contentLabel)
                        }
                    }
                    
                    let cancelBtn = UIButton(type: .custom)
                    cancelBtn.frame = CGRect(x: showView.width - 26, y: 0 , width: 26, height: 26)
                    cancelBtn.setImage( UIImage(named: "home_tiyan_close"), for: .normal)
                    cancelBtn.addTarget(self, action: #selector(self.Click(sender:)), for: .touchUpInside)
                    showView.addSubview(cancelBtn)
                }else{
                    //未绑定银行卡
                    self.superControl?.navigationController?.pushViewController(UserReadInfoViewController(), animated: true)
                }
            }else{
                //未实名
                self.superControl?.navigationController?.pushViewController(UserReadInfoViewController(), animated: true)
            }
        }else{
            self.superControl?.navigationController?.pushViewController(GPWLoginViewController(), animated: true)
        }
    }
    
    @objc func Click(sender:UIButton) {
        if sender.tag == 100 {
            let  dic =  ["exper_id":"\(self.dic!["auto_id"])" ,"exper_amount":"\(self.dic!["exper_amount"])"]
            GPWNetwork.requetWithPost(url: Exper_bid, parameters:dic, responseJSON: { [weak self] (json, msg) in
                guard let strongSelf = self else { return }
                printLog(message: json)
                strongSelf.noLoginView.removeFromSuperview()
                let vc = GPWExperienceSuccessViewController()
                _ = strongSelf.superControl?.navigationController?.show(vc, sender: nil)
                }, failure: { error in
                    
            })
        }else{
            printLog(message: "取消")
            noLoginView.removeFromSuperview()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
