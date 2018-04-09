//
//  GPWIntroduceViewController.swift
//  GangPiaoWang
//  引导界面
//  Created by GC on 16/12/5.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWIntroduceViewController: UIViewController, UIScrollViewDelegate {
    fileprivate let pageCount = 4
    fileprivate var isRemoved = false
    fileprivate var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
    
    private func commonInit() {
        scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: CGFloat(pageCount) * SCREEN_WIDTH, height: self.view.bounds.height)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        
        for index in 0..<pageCount {
            let imageView = UIImageView(frame: CGRect(x: CGFloat(index) * self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
            printLog(message: SCREEN_HEIGHT)
            if SCREEN_HEIGHT < 568 {
                imageView.image = UIImage(named: "introduce\(index)")
            }else{
                imageView.image = UIImage(named: "introduce\(index)_\(index)")
            }
            
            scrollView.addSubview(imageView)
            imageView.backgroundColor = UIColor.gray
            
            if index == pageCount - 1 {
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: 0, y: self.view.bounds.height / 10 * 8.5, width: 216, height: 56)
                button.center.x = self.view.bounds.width / 2
                button.setBackgroundImage(UIImage(named: "induct_btn"), for: .normal)
                button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                imageView.isUserInteractionEnabled = true
                imageView.addSubview(button)
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        if offsetX > (SCREEN_WIDTH * CGFloat(pageCount - 1) + 100) {
            if !isRemoved {
                remove()
            }
        }
    }
    
    @objc func buttonAction() {
        UserDefaults.standard.set(true, forKey: "isInstalled")
        remove()
    }
    
    func remove() {
        isRemoved = true
        if let dic = GPWGlobal.sharedInstance().initJson{
            printLog(message: "1111111")
            if dic["app_info"]["advert_picture"].stringValue.count > 5  && dic["app_info"]["is_vaild"].intValue == 1 {
                 printLog(message: "222222")
                let adController = GPWADViewController(imgStr: dic["app_info"]["advert_picture"].stringValue, toUrl: dic["app_info"]["advert_url"].stringValue)
                let wid = UIApplication.shared.delegate?.window
                wid??.rootViewController = adController
            }else{
                let wid = UIApplication.shared.delegate?.window
                if  GPWGlobal.sharedInstance().gpwbarController == nil {
                    GPWGlobal.sharedInstance().gpwbarController = GPWTabBarController()
                }
                wid??.rootViewController = GPWGlobal.sharedInstance().gpwbarController
            }
        }else{
             printLog(message: "33333333")
            UIView.animate(withDuration: 0.25, animations: {
                self.view.alpha = 0.0
            }) { (isFinished) in
                 printLog(message: "444444")
                let wid = UIApplication.shared.delegate?.window
                if  GPWGlobal.sharedInstance().gpwbarController == nil {
                    GPWGlobal.sharedInstance().gpwbarController = GPWTabBarController()
                }
                wid??.rootViewController = GPWGlobal.sharedInstance().gpwbarController
            }
        }
    }
}
