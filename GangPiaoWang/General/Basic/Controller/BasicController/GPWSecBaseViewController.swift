//
//  GPWSecBaseViewController.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/2.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWSecBaseViewController: GPWBaseViewController {
    var leftButton: GPWButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgView.frame = CGRect(x: 0.0, y: self.navigationBar.maxY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.navigationBar.maxY)
        self.noDataImgView?.centerX = self.bgView.width / 2
        self.noDataImgView?.centerY = self.bgView.height / 2
        setupLeftButton()
    }
    
    fileprivate func setupLeftButton() {
        self.leftButton = GPWButton.backButton(image: UIImage(named: "nav_left")!)
        self.leftButton!.addTarget(self, action: #selector(back(sender:)), for: .touchUpInside)
        self.navigationBar.addSubview(self.leftButton)
    }
    
    @objc open func back(sender: GPWButton) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
}
