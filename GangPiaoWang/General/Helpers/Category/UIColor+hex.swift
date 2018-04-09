//
//  UIColor+hex.swift
//  GangPiaoWang
//
//  Created by GC on 16/11/25.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func hex(_ colorStr: String) -> UIColor {
        return self.hex(colorStr, alpha: 1.0)
    }
    
    class func hex(_ colorStr: String, alpha: CGFloat) -> UIColor {
        var colorString = colorStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if colorString.count < 6 {
            return UIColor.clear
        }
        if colorString.hasPrefix("0X") {
            let index = colorString.index(colorString.startIndex, offsetBy: 2)
            colorString = colorString.substring(from: index)
        }
        if colorString.hasPrefix("#") {
            let index = colorString.index(colorString.startIndex, offsetBy: 1)
            colorString = colorString.substring(from: index)
        }
        if colorString.count != 6 {
            return UIColor.clear
        }
        
        let start = colorString.startIndex
        let redEnd = colorString.index(start, offsetBy: 2)
        let greenEnd = colorString.index(redEnd, offsetBy: 2)
        let blueEnd = colorString.index(greenEnd, offsetBy: 2)
        let redRange = start ..< redEnd
        let greenRange = redEnd ..< greenEnd
        let blueRange = greenEnd ..< blueEnd
        let redStr = colorString.substring(with: redRange)
        let greenStr = colorString.substring(with: greenRange)
        let blueStr = colorString.substring(with: blueRange)
        
        var r, g, b: UInt32
        r = 100
        g = 100
        b = 100
        Scanner(string: redStr).scanHexInt32(&r)
        Scanner(string: greenStr).scanHexInt32(&g)
        Scanner(string: blueStr).scanHexInt32(&b)
        return UIColor(red: CGFloat(Double(r) / 255.0), green: CGFloat(Double(g) / 255.0), blue: CGFloat(Double(b) / 255.0), alpha: alpha)
    }
}
