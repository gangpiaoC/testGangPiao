//
//  UIImage+scaleToSize.swift
//  GangPiaoWang
//
//  Created by GC on 16/11/24.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

extension UIImage {
    func imageWithContentSize(size: CGSize, drawInRect rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
}

