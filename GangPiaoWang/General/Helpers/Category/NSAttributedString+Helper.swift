//
//  NSAttributeString+Helper.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/22.
//  Copyright © 2016年 GC. All rights reserved.
//

import Foundation

extension NSAttributedString {
    class func attributedString(_ main: String, mainColor: UIColor = titleColor, mainFont: CGFloat = 18, mainFontWeight: UIFont.Weight = .regular, second: String, secondColor: UIColor = titleColor, secondFont: CGFloat = 12, secondFontWeight: UIFont.Weight = .regular) -> NSAttributedString {
        let attr = NSMutableAttributedString()
        let mainAttr = NSAttributedString(string: main, attributes: [NSAttributedStringKey.foregroundColor: mainColor, NSAttributedStringKey.font: UIFont.systemFont(ofSize: mainFont, weight: mainFontWeight)])
        attr.append(mainAttr)
        let secondAttr = NSAttributedString(string: second, attributes: [NSAttributedStringKey.foregroundColor: secondColor, NSAttributedStringKey.font: UIFont.systemFont(ofSize: secondFont, weight: secondFontWeight)])
        attr.append(secondAttr)
        return attr.copy() as! NSAttributedString
    }
    
    class func attributedBoldString(_ main: String, mainColor: UIColor = titleColor, mainFont: CGFloat = 18, second: String, secondColor: UIColor = titleColor, secondFont: CGFloat = 12) -> NSAttributedString {
        let attr = NSMutableAttributedString()
        let mainAttr = NSAttributedString(string: main, attributes: [NSAttributedStringKey.foregroundColor: mainColor, NSAttributedStringKey.font: UIFont.customFont(ofSize: mainFont)])
        attr.append(mainAttr)
        let secondAttr = NSAttributedString(string: second, attributes: [NSAttributedStringKey.foregroundColor: secondColor, NSAttributedStringKey.font: UIFont.customFont(ofSize: secondFont)])
        attr.append(secondAttr)
        return attr.copy() as! NSAttributedString
    }

}
