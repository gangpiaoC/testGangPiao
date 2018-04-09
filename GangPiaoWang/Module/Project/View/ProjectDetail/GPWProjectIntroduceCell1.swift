//
//  GPWProjectIntroduceCell1.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/20.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit
import SnapKit

class GPWProjectIntroduceCell1: UITableViewCell {
    var imgTap: (() -> Void)?
    private var imgView: UIImageView!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        let indictorView = GPWIndicatorView.indicatorView()
        contentView.addSubview(indictorView)
        
        let headerLabel = UILabel()
        headerLabel.font = UIFont.customFont(ofSize: 14)
        headerLabel.textColor = titleColor
        headerLabel.text = "质押票据"
        contentView.addSubview(headerLabel)
        
        imgView = UIImageView()
        imgView.image = UIImage(named: "placeholderImage")
        imgView.isUserInteractionEnabled = true
        contentView.addSubview(imgView)
        let sigleTap = UITapGestureRecognizer(target: self, action: #selector(handleSigleTap(ges:)))
        imgView.addGestureRecognizer(sigleTap)
        
        let lineView = UIView()
        lineView.backgroundColor = lineColor
        contentView.addSubview(lineView)
        
        indictorView.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView).offset(17)
            maker.left.equalTo(contentView).offset(16)
            maker.height.equalTo(14)
            maker.width.equalTo(3)
        }
        
        headerLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(indictorView)
            maker.left.equalTo(indictorView.snp.right).offset(7)
            maker.right.equalTo(contentView)
        }
        
        imgView.snp.makeConstraints { (maker) in
            maker.top.equalTo(indictorView.snp.bottom).offset(10)
            maker.left.equalTo(contentView).offset(16)
            maker.right.equalTo(contentView).offset(-16)
            maker.height.equalTo(ceil((SCREEN_WIDTH - 32) * 0.6))
        }
        
        lineView.snp.makeConstraints { (maker) in
            maker.top.equalTo(imgView.snp.bottom).offset(18)
            maker.left.equalTo(contentView).offset(16)
            maker.right.equalTo(contentView).offset(-16)
            maker.height.equalTo(0.5)
            maker.bottom.equalTo(contentView)
        }
    }
    
    func setupCell(_ dict: String) {
        imgView.downLoadImg(imgUrl: dict)
    }
    
    @objc private func handleSigleTap(ges: UITapGestureRecognizer) {
        if let imgTap = self.imgTap {
              imgTap()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
