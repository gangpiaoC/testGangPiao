//
//  GPWButton.swift
//  GangPiaoWang
//
//  Created by GC on 16/11/24.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

//文字按钮
class GPWButton: UIButton {
    //创建文字navigation bar按钮
    open class func barButton(title: String) -> GPWButton {
        let font = UIFont.customFont(ofSize: 17.0)
        let buttonSize = (title as NSString).size(attributes: [NSFontAttributeName: font])
        let frame = CGRect(x: 0, y: 0, width: buttonSize.width, height: 44)
        let button = self.button(frame: frame, title: title, fontSize: 17.0, backgroundColor: nil, cornerRadius: nil)
        button.tintColor = UIColor.white
        return button
    }
    
    open class func button(frame: CGRect, title: String) -> GPWButton {
        return self.button(frame: frame, title: title, fontSize: nil, backgroundColor: nil, cornerRadius: nil)
    }
    
    open class func button(frame: CGRect, title: String, fontSize: CGFloat?,backgroundColor: UIColor?, cornerRadius: CGFloat?) -> GPWButton {
        var font: UIFont = UIFont.customFont(ofSize: 14.0)
        if let fontS = fontSize {
            font = UIFont.customFont(ofSize: fontS)
        }
        let button = GPWButton(type: .custom)
        button.frame = frame
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = font
        if let bgColor = backgroundColor {
            button.backgroundColor = bgColor
        }
        if let radius = cornerRadius {
            button.layer.masksToBounds = true
            button.layer.cornerRadius = radius
        }
        return button
    }
}

//创建图片按钮
extension GPWButton {
    //创建图片navigation bar按钮
    open class func backButton(image: UIImage?) -> GPWButton {
        let frame = CGRect(x: 0, y: 20, width: 60, height: 44)
        let scaleImage = image?.imageWithContentSize(size: frame.size, drawInRect: CGRect(x: 16, y: 14, width: 8, height: 16))
        let button = self.button(frame: frame, normalImage: scaleImage, selectedImage: scaleImage)
        return button
    }
    
    open class func button(frame: CGRect, normalImage: UIImage?, selectedImage: UIImage?) -> GPWButton {
        let button = GPWButton(type: .custom)
        button.frame = frame
        button.setBackgroundImage(normalImage, for: .normal)
        button.setBackgroundImage(selectedImage, for: .selected)
        button.adjustsImageWhenHighlighted = false
        return button
    }
}
