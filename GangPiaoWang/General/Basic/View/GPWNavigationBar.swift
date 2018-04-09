//
//  GPWNavigationBar.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/2.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWNavigationBar: UIView {
    var titleLabel: UILabel!
    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    var isLineHidden: Bool = false {
        didSet {
            self.line?.isHidden = isLineHidden
        }
    }
    fileprivate var line: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func commonInitialize() {
        self.backgroundColor = baseColor
        addTitleLabel()
        addLine()
    }
    
    fileprivate func addTitleLabel() {
        titleLabel = UILabel(frame: CGRect(x: 0, y: self.height - 44, width: SCREEN_WIDTH / 2.0, height: 44))
        titleLabel.textColor = titleColor
        titleLabel.centerX = self.width / 2
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.customFont(ofSize: 18)
        self.addSubview(titleLabel)
    }
    
    fileprivate func addLine() {
        line = UIView(frame: CGRect(x: 0, y: self.frame.height - 0.5, width: self.frame.width, height: 0.5))
        line!.backgroundColor = lineColor
        self.addSubview(line!)
    }
}
