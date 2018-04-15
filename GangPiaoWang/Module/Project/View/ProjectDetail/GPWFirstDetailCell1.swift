//
//  GPWFirstDetailCell1.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/20.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SnapKit
import SwiftyJSON

class GPWFirstDetailCell1: UITableViewCell {
    private let staticIncomeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hex("fdc3a7")
        label.text = "历史年化利率"
        label.font = UIFont.customFont(ofSize: 12)
        return label
    }()
    private let incomeLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let staticDateLabel: UILabel = {
        let label = UILabel()
        label.text = "产品期限"
        label.textColor = UIColor.hex("fdc3a7")
        label.font = UIFont.customFont(ofSize: 12.0)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let staticStartInvestLabel: UILabel = {
        let label = UILabel()
        label.text = "起投金额"
        label.textColor = UIColor.hex("fdc3a7")
        label.font = UIFont.customFont(ofSize: 12.0)
        return label
    }()
    private let startInvestLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let progressView: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .bar)
        progress.backgroundColor = UIColor.hex("e9561f")
        progress.progressImage = #imageLiteral(resourceName: "project_detail_progress")
        progress.layer.masksToBounds = true
        progress.layer.cornerRadius = 4
        return progress
    }()
    
    let progressImgView = UIImageView(image: #imageLiteral(resourceName: "project_detail_progressThumb"))
    var progressImgConstraint: Constraint!
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.hex("fdc3a7")
        label.text = "已完成65%"
        label.font = UIFont.customFont(ofSize: 12.0)
        return label
    }()
    
    let bottomLeftDotImgView = UIImageView(image: #imageLiteral(resourceName: "project_detail_circel"))
    let bottomMiddleDotImgView = UIImageView(image: #imageLiteral(resourceName: "project_detail_circel"))
    let bottomRightDotImgView = UIImageView(image: #imageLiteral(resourceName: "project_detail_circel"))
    
    let bottomLeftLineView = UIView(bgColor: redColor)
    let bottomRightLineView = UIView(bgColor: redColor)
    
    let bottomLeftTitleLabel = UILabel(title: "今日出借", color: titleColor, fontSize: 14)
    let bottomMiddleTitleLabel = UILabel(title: "今日计息", color: titleColor, fontSize: 14)
    let bottomRightTitleLabel = UILabel(title: "到期还本息", color: titleColor, fontSize: 14)
    
    let bottomLeftSubtitleLabel = UILabel(title: "2018.04.06", color: UIColor.hex("b7b7b7"), fontSize: 12)
    let bottomMiddleSubtitleLabel = UILabel(title: "2018.04.06", color: UIColor.hex("b7b7b7"), fontSize: 12)
    let bottomRightSubtitleLabel = UILabel(title: "2018.04.06", color: UIColor.hex("b7b7b7"), fontSize: 12)
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        let topBgView = UIView(bgColor: redColor)
        topBgView.addSubview(staticIncomeLabel)
        topBgView.addSubview(incomeLabel)
        topBgView.addSubview(staticDateLabel)
        topBgView.addSubview(dateLabel)
        topBgView.addSubview(staticStartInvestLabel)
        topBgView.addSubview(startInvestLabel)
        topBgView.addSubview(progressView)
        topBgView.addSubview(progressLabel)
        contentView.addSubview(topBgView)
        
        let bottomGuide = UILayoutGuide()
        contentView.addLayoutGuide(bottomGuide)
        contentView.addSubview(bottomLeftDotImgView)
        contentView.addSubview(bottomLeftLineView)
        contentView.addSubview(bottomMiddleDotImgView)
        contentView.addSubview(bottomRightLineView)
        contentView.addSubview(bottomRightDotImgView)
        contentView.addSubview(bottomLeftTitleLabel)
        contentView.addSubview(bottomMiddleTitleLabel)
        contentView.addSubview(bottomRightTitleLabel)
        contentView.addSubview(bottomLeftSubtitleLabel)
        contentView.addSubview(bottomMiddleSubtitleLabel)
        contentView.addSubview(bottomRightSubtitleLabel)
        contentView.addSubview(progressImgView)
        
        
        topBgView.snp.makeConstraints { (maker) in
            maker.top.left.right.equalTo(contentView)
        }
        
        incomeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(topBgView).offset(35)
            maker.left.equalTo(topBgView).offset(42)
            maker.height.equalTo(36)
        }
        
        staticIncomeLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(incomeLabel.snp.bottom).offset(8)
            maker.left.equalTo(incomeLabel)
        }
        
        staticDateLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(incomeLabel)
            maker.width.equalTo(50)
        }
        
        dateLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(staticDateLabel)
            maker.left.equalTo(staticDateLabel.snp.right).offset(4)
            maker.right.equalTo(topBgView).offset(-21)
            maker.width.equalTo(55)
        }
        
        
        staticStartInvestLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(staticDateLabel)
            maker.centerY.equalTo(staticIncomeLabel)
            maker.width.equalTo(staticDateLabel)
        }
        
        startInvestLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(staticStartInvestLabel)
            maker.left.right.equalTo(dateLabel)
        }
        
        progressView.snp.makeConstraints { (maker) in
            maker.top.equalTo(staticIncomeLabel.snp.bottom).offset(37)
            maker.left.right.equalTo(topBgView).inset(16)
            maker.height.equalTo(3)
        }
        
        progressImgView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(progressView)
            progressImgConstraint = maker.centerX.equalTo(progressView.snp.left).constraint
        }
        
        progressLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(progressView.snp.bottom).offset(6)
            maker.right.equalTo(progressView)
            maker.bottom.equalTo(topBgView).offset(-20)
        }
        
        bottomGuide.snp.makeConstraints { (maker) in
            maker.top.equalTo(topBgView.snp.bottom)
            maker.left.right.bottom.equalTo(contentView)
            maker.height.equalTo(100)
        }
        
        bottomLeftDotImgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(bottomGuide).offset(23)
            maker.centerX.equalTo(bottomLeftTitleLabel)
            maker.width.height.equalTo(11)
        }
        bottomLeftLineView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(bottomLeftDotImgView)
            maker.left.equalTo(bottomLeftDotImgView.snp.right).offset(5)
            maker.height.equalTo(1)
        }
        bottomMiddleDotImgView.snp.makeConstraints { (maker) in
            maker.centerY.width.height.equalTo(bottomLeftDotImgView)
            maker.centerX.equalTo(bottomGuide)
            maker.left.equalTo(bottomLeftLineView.snp.right).offset(5)
        }
        bottomRightLineView.snp.makeConstraints { (maker) in
            maker.centerY.height.equalTo(bottomLeftLineView)
            maker.left.equalTo(bottomMiddleDotImgView.snp.right).offset(5)
        }
        bottomRightDotImgView.snp.makeConstraints { (maker) in
            maker.centerY.width.height.equalTo(bottomLeftDotImgView)
            maker.centerX.equalTo(bottomRightTitleLabel)
            maker.left.equalTo(bottomRightLineView.snp.right).offset(5)
        }
        bottomLeftTitleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(bottomLeftDotImgView.snp.bottom).offset(11)
            maker.left.equalTo(bottomGuide).offset(19)
        }
        bottomLeftSubtitleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(bottomLeftTitleLabel.snp.bottom).offset(7)
            maker.centerX.equalTo(bottomLeftTitleLabel)
            maker.bottom.equalTo(bottomGuide).offset(-20)
        }
        bottomMiddleTitleLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(bottomGuide)
            maker.centerY.equalTo(bottomLeftTitleLabel)
        }
        bottomMiddleSubtitleLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(bottomGuide)
            maker.centerY.equalTo(bottomLeftSubtitleLabel)
        }
        bottomRightTitleLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(bottomGuide).offset(-16)
            maker.centerY.equalTo(bottomLeftTitleLabel)
        }
        bottomRightSubtitleLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(bottomRightTitleLabel)
            maker.centerY.equalTo(bottomLeftSubtitleLabel)
        }
    }

    func setupCell(_ dict: JSON) {
        incomeLabel.attributedText = NSAttributedString.attributedString(dict["rate_loaner"].stringValue, mainColor: UIColor.white, mainFont: 40, mainFontWeight: .medium, second: "%", secondColor: UIColor.white, secondFont: 18, secondFontWeight: .medium)
        //是否为新手标
        let isNewbie: Bool = dict["is_index"].intValue == 1 ? true : false
        if isNewbie {
            if GPWUser.sharedInstance().staue == 0 {
                if dict["rate_loaner"].doubleValue > 0 {
                    let attrText = NSMutableAttributedString()
                    attrText.append(NSAttributedString.attributedString(dict["rate_loaner"].stringValue, mainColor: UIColor.white, mainFont: 40, mainFontWeight: .medium, second: "+\(dict["rate_new"].stringValue)", secondColor: UIColor.white, secondFont: 26, secondFontWeight: .medium))
                    attrText.append(NSAttributedString(string: "%", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18, weight: .medium)]))
                    incomeLabel.attributedText = attrText
                }
            }
        }
        dateLabel.attributedText = NSAttributedString.attributedString(dict["deadline"].stringValue, mainColor: UIColor.white, mainFont: 18, mainFontWeight: .medium, second: "天", secondColor: UIColor.hex("fdc3a7"), secondFont: 12)
        startInvestLabel.attributedText = NSAttributedString.attributedString(dict["begin_amount"].stringValue, mainColor: UIColor.white, mainFont: 18, mainFontWeight: .medium,  second: "元", secondColor: UIColor.hex("fdc3a7"), secondFont: 12)
        progressLabel.text =  "已完成\(dict["jindu"].floatValue)%"
        progressView.progress = dict["jindu"].floatValue / 100
        progressImgConstraint.update(offset: CGFloat(progressView.progress) * progressView.width)
        
        bottomLeftSubtitleLabel.text = dict["daytime"].stringValue
        bottomMiddleSubtitleLabel.text = dict["daytime"].stringValue
        bottomRightSubtitleLabel.text = dict["daytimeout"].stringValue
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
