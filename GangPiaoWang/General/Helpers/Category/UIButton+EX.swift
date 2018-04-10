
//
//  UIButton+EX.swift
//  mutouwang
//
//  Created by GC on 2017/11/2.
//  Copyright © 2017年 mutouw. All rights reserved.
//

import Foundation

enum ButtonImageTitleStyle: Int {
    case imagePositionLeft = 0                  //左图右字
    case imagePositionRight                     //右图左字
    case imagePositionTop                        //上图下字
    case imagePositionBottom                  //下图上字
}

extension UIButton {
    //设置图片文字排列位置
    func setButtonImageTitleStyle(_ style: ButtonImageTitleStyle, padding: CGFloat) {
        if (self.imageView?.image != nil) && (self.titleLabel?.text != nil) {
            self.titleEdgeInsets = .zero
            self.imageEdgeInsets = .zero
            let labelWidth = self.titleLabel!.intrinsicContentSize.width
            let labelHeight = self.titleLabel!.intrinsicContentSize.height
            let imageWidth = self.imageView!.intrinsicContentSize.width
            let imageHeight = self.imageView!.intrinsicContentSize.height
            let imageOffsetX = labelWidth / 2
            let imageOffsetY = imageHeight / 2 + padding / 2
            let labelOffsetX = imageWidth / 2
            let labelOffsetY = labelHeight / 2 + padding / 2
            switch (style) {
            case .imagePositionLeft:
                self.imageEdgeInsets = UIEdgeInsetsMake(0, -padding / 2, 0, padding / 2)
                self.titleEdgeInsets = UIEdgeInsetsMake(0, padding / 2, 0, -padding / 2)
                self.contentEdgeInsets = UIEdgeInsetsMake(0, padding / 2, 0, padding / 2)
            case .imagePositionRight:
                self.imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + padding / 2, 0, -(labelWidth + padding / 2))
                self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageWidth - padding / 2, 0, imageWidth + padding / 2)
                self.contentEdgeInsets = UIEdgeInsetsMake(0, padding / 2, 0, padding / 2)
            case .imagePositionTop:
                let maxWidth = max(imageWidth, labelWidth)
                let maxHeight = max(imageHeight, labelHeight)
                let changeWidth = imageWidth + labelWidth - maxWidth
                let changeHeight = imageHeight + labelHeight + padding - maxHeight
                self.imageEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, imageOffsetX, labelOffsetY, -imageOffsetX)
                self.titleEdgeInsets = UIEdgeInsetsMake(imageOffsetY, -labelOffsetX, -imageOffsetY, labelOffsetX)
                self.contentEdgeInsets = UIEdgeInsetsMake(changeHeight - labelOffsetY, -changeWidth / 2, labelOffsetY, -changeWidth / 2)
            case .imagePositionBottom:
                let maxWidth = max(imageWidth, labelWidth)
                let maxHeight = max(imageHeight, labelHeight)
                let changeWidth = imageWidth + labelWidth - maxWidth
                let changeHeight = imageHeight + labelHeight + padding - maxHeight
                self.imageEdgeInsets = UIEdgeInsetsMake(labelOffsetY, imageOffsetX, -labelOffsetY, -imageOffsetX)
                self.titleEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, -labelOffsetX, imageOffsetY, labelOffsetX)
                self.contentEdgeInsets = UIEdgeInsetsMake(changeHeight - labelOffsetY, -changeWidth / 2, labelOffsetY, -changeWidth / 2)
            }
        }
    }
}
