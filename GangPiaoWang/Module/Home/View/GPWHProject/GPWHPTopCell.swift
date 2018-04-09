//
//  GPWHPTopCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/11/13.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON
class GPWHPTopCell: UITableViewCell {
    fileprivate var rightLabelWith: Constraint!
    fileprivate var rateLabelY: Constraint!
    fileprivate var bottomLabelY: Constraint!
    fileprivate var LeftImgX: Constraint!
    fileprivate let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius =  6
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.12
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        return view
    }()

    fileprivate let topImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named:"home_project_top")
        return imgView
    }()

    //新手标   体验标  钢融宝-第几期等
    fileprivate let topTitleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "钢票盈-第13期"
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.customFont(ofSize: 15.0)
        return titleLabel
    }()

    fileprivate let leftImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named:"home_project_top_mianfei")
        return imgView
    }()

    fileprivate let rightTtileLabel: UILabel = {
        let companyLabel = UILabel()
        companyLabel.text = "中建二局"
        companyLabel.textColor = redTitleColor
        companyLabel.textAlignment = .center
        companyLabel.layer.masksToBounds = true
        companyLabel.layer.cornerRadius = 10
        companyLabel.layer.borderColor = UIColor.hex("ef785b").cgColor
        companyLabel.layer.borderWidth = 0.5
        companyLabel.font = UIFont.customFont(ofSize: 14.0)
        return companyLabel
    }()

    //利率
    private let rateLabel: RTLabel = {
        let label = RTLabel()
        label.text = "<font size=50 color='#f6390c'>7.0</font><font size=22 color='#f6390c'>%</font><font size=32 color='#f6390c'> + </font><font size=28 color='#f6390c'>3.0</font><font size=24 color='#f6390c'>%</font>"
        label.textAlignment = RTTextAlignmentCenter
        printLog(message: label.optimumSize.height)
        return label
    }()

    //剩余金额+ 项目期限
    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.text = "剩余 260,000元        项目期限30天"
        label.textColor = UIColor.hex("666666")
        label.textAlignment = .center
        return label
    }()

    //抢购
    fileprivate let bottomImgBtn: UIButton = {
        let tempBtn = UIButton()
        tempBtn.setImage(UIImage(named:"home_project_pay"), for: .normal)
        tempBtn.isUserInteractionEnabled = false
        return tempBtn
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        commonInitialize()
    }

    private func commonInitialize() {

        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(contentView).offset(16)
            maker.top.equalTo(contentView).offset(6)
            maker.bottom.equalTo(contentView).offset(-6)
            maker.right.equalTo(contentView).offset(-16)
        }

        contentView.addSubview(topImgView)
        topImgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(1)
            maker.centerX.equalTo(contentView)
        }
        contentView.addSubview(topTitleLabel)
        topTitleLabel.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalTo(topImgView)
        }

        contentView.addSubview(leftImgView)
        leftImgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(bgView).offset(44)
            LeftImgX = maker.left.equalTo(bgView).offset(82).constraint
        }

        contentView.addSubview(rightTtileLabel)
        rightTtileLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(bgView).offset(44)
            rightLabelWith = maker.width.equalTo(84).constraint
            maker.height.equalTo(20)
            maker.left.equalTo(leftImgView.snp.right).offset(8)
        }
        contentView.addSubview(rateLabel)
        rateLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(bgView)
            rateLabelY = maker.top.equalTo(rightTtileLabel.snp.bottom).offset(20).constraint
            maker.height.equalTo(61)
        }

        contentView.addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(bgView)
            bottomLabelY =  maker.top.equalTo(rateLabel.snp.bottom).offset(13).constraint
            maker.height.equalTo(16)
        }

        contentView.addSubview(bottomImgBtn)
        bottomImgBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(bgView).offset(44)
            maker.right.equalTo(bgView).offset(-44)
            maker.height.equalTo(40)
            maker.bottom.equalTo(bgView).offset(-25)
        }
    }
    func setupCell(dict: JSON,index:NSInteger) {

        //得到图片宽度
        var tempLeftImgWith:CGFloat = 0
        if dict["is_index"].intValue == 2 {
            tempLeftImgWith = 80
            leftImgView.image = UIImage(named:"home_project_top_mianfei")
            rateLabel.text = "<font size=24 color='#f6390c'>￥</font><font size=36 color='#f6390c'>\(dict["exper_amount"].intValue)</font>"
            rateLabelY.update(offset: 35)
            bottomLabel.text = "体验金"
            bottomLabelY.update(offset: -15)
        }else {
            if dict["is_index"].intValue == 1 && GPWUser.sharedInstance().staue == 0{
                tempLeftImgWith = 70
                 leftImgView.image = UIImage(named:"home_project_top_xinshou")
            }else{
                tempLeftImgWith = 84
                leftImgView.image = UIImage(named:"home_project_top_hot")
            }
              rateLabel.text = "<font size=50 color='#f6390c'>\(dict["rate_loaner"])</font><font size=22 color='#f6390c'>%</font>"
            if GPWUser.sharedInstance().staue == 0 && dict["rate_loaner"].doubleValue > 0  {
                rateLabel.text = "<font size=50 color='#f6390c'>\(dict["rate_loaner"])</font><font size=22 color='#f6390c'>%</font><font size=32 color='#f6390c'> + </font><font size=28 color='#f6390c'>\(dict["rate_new"])</font><font size=24 color='#f6390c'>%</font>"
            }
            rateLabelY.update(offset: 20)
            bottomLabel.text =  "剩余 \(dict["balance_amount"])元        借款期限\(dict["deadline"])天"
            bottomLabelY.update(offset: 18)
            bottomLabel.font = UIFont.customFont(ofSize: 14)
        }
        topTitleLabel.text = dict["title"].stringValue
        rightTtileLabel.text = dict["acceptance_enterprise"].stringValue
        let  rightLabelW = getWith(str: rightTtileLabel.text!, font: rightTtileLabel.font)
        rightLabelWith.update(offset: rightLabelW + 10)

        //顶部左侧图片距离左侧距离
        let  leftImgX = ( SCREEN_WIDTH - 32 - ( tempLeftImgWith + rightLabelW + 8 + 10 )) / 2
        LeftImgX.update(offset: leftImgX)

        let state1 = dict["status"].stringValue
        switch state1 {
        case "FULLSCALE":
            bottomImgBtn.setImage(UIImage(named: "home_project_top_qiangguang"), for: .normal)
            break
        case "REPAYING":
            bottomImgBtn.setImage(UIImage(named: "home_project_top_huikuanzhong"), for: .normal)
            break
        case "FINISH":
            bottomImgBtn.setImage(UIImage(named: "home_project_top_yihuikuan"), for: .normal)
            break
        case "COLLECTING":
            bottomImgBtn.setImage(UIImage(named: "home_project_top_pay"), for: .normal)
            break
        case "RELEASE":
            bottomImgBtn.setImage(UIImage(named: "home_project_top_rightnow"), for: .normal)
            break
        default:
            bottomImgBtn.setImage(UIImage(named: "home_project_top_qiangguang"), for: .normal)
            break
        }
        if GPWUser.sharedInstance().isLogin == false {
            bottomImgBtn.setImage(UIImage(named: "home_project_top_pay"), for: .normal)
        }
    }
    func getWith(str:String,font:UIFont) -> CGFloat{
        let options:NSStringDrawingOptions = .usesLineFragmentOrigin
        let boundingRect = str.boundingRect(with:  CGSize(width: 300, height: 22), options: options, attributes:[NSAttributedStringKey.font:font], context: nil)
        return boundingRect.width
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
