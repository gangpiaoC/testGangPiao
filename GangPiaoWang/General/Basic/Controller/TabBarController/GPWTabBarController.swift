//
//  GPWTabBarController.swift
//  GangPiaoWang
//
//  Created by GC on 16/11/23.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //配置
        config()
        //初始化
        commonInitialization()
    }
    
    fileprivate func config() {
        //设置背景不透明
         self.tabBar.isTranslucent = false
    }
    
    fileprivate func commonInitialization() {
        let homeVC = GPWHomeViewController()
        let projectVC = GPWProjectTypeController()
        let foundVC = GPWFoundViewController()
        let myVC = UserController()

        let controllers = [homeVC, projectVC,foundVC, myVC]
        let titles = ["首页", "产品",  "发现","我的"]
        var navControllers = [GPWNavigationController]()
        
        var index = 0
        for vc in controllers {
            vc.title = titles[index]
            vc.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.hex("fa713d")], for: .selected)
            vc.tabBarItem.image = UIImage(named: "tabBar_\(index)")
            vc.tabBarItem.imageInsets = UIEdgeInsets(top: -3, left: 0, bottom: 3, right: 0)
            vc.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
            vc.tabBarItem.selectedImage = UIImage(named: "tabBar_selected_\(index)")?.withRenderingMode(.alwaysOriginal)
            let navC = GPWNavigationController(rootViewController: controllers[index])
            navControllers.append(navC)
            index += 1
        }
        self.viewControllers = navControllers
    }
}
