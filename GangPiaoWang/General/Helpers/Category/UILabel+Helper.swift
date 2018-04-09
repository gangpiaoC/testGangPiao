//
//  UILabel+Helper.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/21.
//  Copyright © 2016年 GC. All rights reserved.
//

import Foundation

extension UILabel {
    convenience init(title: String, color: UIColor, fontSize: CGFloat, weight: CGFloat = UIFontWeightRegular, textAlign: NSTextAlignment = .left, numberOfLines: Int = 1) {
        self.init()
        self.text = title
        self.textColor = color
        self.font = UIFont.customFont(ofSize: fontSize)
        self.textAlignment = textAlign
        self.numberOfLines = numberOfLines
    }
}
