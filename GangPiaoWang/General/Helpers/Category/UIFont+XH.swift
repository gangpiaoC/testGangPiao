//
//  UIfOOO.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/1/5.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

extension UIFont {
    @objc static func customFont(ofSize fontSize: CGFloat) -> UIFont {
        return self.systemFont(ofSize: fontSize)
        //return self.boldSystemFont(ofSize:fontSize)
        //return self.systemFont(ofSize: fontSize, weight: UIFont.Weight.light)
    }
}
