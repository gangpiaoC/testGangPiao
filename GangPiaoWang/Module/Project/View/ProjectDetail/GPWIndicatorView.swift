//
//  GPWIndicatorView.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/20.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWIndicatorView: UIView {
    class func indicatorView() -> GPWIndicatorView {
        let indictorView = GPWIndicatorView()
        indictorView.backgroundColor = redTitleColor
        indictorView.layer.masksToBounds = true
        indictorView.layer.cornerRadius = 2
        return indictorView
    }
}
