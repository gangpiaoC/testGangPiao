//
//  GPWMarkAlertView.swift
//  GangPiaoWang
//
//  Created by GC on 17/1/16.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWMarkAlertView: UIView {

    static let shared = GPWMarkAlertView()
    private var coverView: UIView!
    
    func show() {
        let window = UIApplication.shared.keyWindow
        coverView = UIView(frame: kMainScreenBounds)
        coverView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        window?.addSubview(coverView)
        window?.bringSubview(toFront: coverView)
        
        let alertView = UIImageView(image: UIImage(named: "project_markAlert"))
        alertView.center = coverView.center
        alertView.bounds = CGRect(x: 0, y: 0, width: ceil(306 * SCREEN_WIDTH / 375), height: ceil(205 * SCREEN_WIDTH / 375))
        alertView.layer.masksToBounds = true
        alertView.layer.cornerRadius = 3.0
        alertView.isUserInteractionEnabled = true
        coverView.addSubview(alertView)
        
        let cancelButton = UIButton(type: .custom)
        cancelButton.frame = CGRect(x: alertView.bounds.width - 26, y: 0, width: 26, height: 26)
        cancelButton.setImage(UIImage(named: "home_tiyan_close"), for: .normal)
        cancelButton.setImage(UIImage(named: "home_tiyan_close"), for: .selected)
        cancelButton.adjustsImageWhenHighlighted = false
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        alertView.addSubview(cancelButton)
    }
    
    @objc private func cancelAction() {
        coverView.removeFromSuperview()
    }
}
