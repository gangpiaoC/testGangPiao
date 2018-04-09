//
//  GPWNavigationController.swift
//  gggg
//
//  Created by GC on 16/12/22.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

fileprivate let kDefaultAlpha: CGFloat = 0.6
fileprivate let kTargetTranslateScale: CGFloat = 0.75

class GPWNavigationController: UINavigationController {
    fileprivate let screenshotImgView = UIImageView()
    fileprivate let coverView = UIView()
    fileprivate var screenshotImgs = [UIImage]()
    var panGestureRecognizer: UIPanGestureRecognizer!
    fileprivate var currentViewController: UIViewController?
    var canDrag: Bool = true {
        willSet {
            self.panGestureRecognizer.isEnabled = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.isEnabled = false
        navigationBar.isHidden = true
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRec(sender:)))
        panGestureRecognizer.delaysTouchesBegan = true
        view.addGestureRecognizer(panGestureRecognizer)
        
        screenshotImgView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        coverView.frame = screenshotImgView.frame
        coverView.backgroundColor = UIColor.black
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension GPWNavigationController: UIGestureRecognizerDelegate {
    @objc fileprivate func panGestureRec(sender: UIPanGestureRecognizer) {
        if visibleViewController == viewControllers[0] {
            return
        }
        switch sender.state {
        case .began:
            sender.view?.endEditing(true)
            dragBegin()
        case .ended:
            dragEnd()
        default:
            dragging(sender: sender)
        }
    }
    
    private func dragBegin() {
        view.window?.insertSubview(screenshotImgView, at: 0)
        view.window?.insertSubview(coverView, aboveSubview: screenshotImgView)
        
        screenshotImgView.image = screenshotImgs.last
    }
    
    private func dragEnd() {
        let translateX = view.transform.tx
        let width = view.frame.width
        if translateX < 40 {
            UIView.animate(withDuration: 0.3, animations: { 
                self.view.transform = CGAffineTransform.identity
                self.screenshotImgView.transform = CGAffineTransform(translationX: -SCREEN_WIDTH, y: 0)
                self.coverView.alpha = kDefaultAlpha
            }, completion: { (finished) in
                self.screenshotImgView.removeFromSuperview()
                self.coverView.removeFromSuperview()
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.transform = CGAffineTransform(translationX: width, y: 0)
                self.screenshotImgView.transform = CGAffineTransform(translationX: 0, y: 0)
                self.coverView.alpha = 0
            }, completion: { (finished) in
                self.view.transform = CGAffineTransform.identity
                self.screenshotImgView.removeFromSuperview()
                self.coverView.removeFromSuperview()
                _ = self.popViewController(animated: false)
            })
        }
    }
    
    private func dragging(sender: UIPanGestureRecognizer) {
       let offsetX = sender.translation(in: view).x
        if offsetX > 0 {
            view.transform = CGAffineTransform(translationX: offsetX, y: 0)
        }
        let  currentTranslateScaleX = offsetX / view.frame.width
        if offsetX < SCREEN_WIDTH {
            screenshotImgView.transform = CGAffineTransform(translationX: (offsetX - SCREEN_WIDTH) * 0.6, y: 0)
        }
        let alpha = kDefaultAlpha - (currentTranslateScaleX / kTargetTranslateScale) * kDefaultAlpha
        coverView.alpha = alpha
    }
}

extension GPWNavigationController {
    fileprivate func screenshot() {
        guard let beyondVC = view.window?.rootViewController else {
            return
        }
        let size = beyondVC.view.frame.size
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        let rect = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        beyondVC.view.drawHierarchy(in: rect, afterScreenUpdates: false)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        if let snapshot = snapshot {
            screenshotImgs.append(snapshot)
        }
        UIGraphicsEndImageContext()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count >= 1 {
            screenshot()
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        if screenshotImgs.count > 0 {
            screenshotImgs.removeLast()
        }
        if viewControllers.count == 1 {
            viewControllers.first?.hidesBottomBarWhenPushed = false
        }
        return super.popViewController(animated: animated)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        if screenshotImgs.count > 0 {
            screenshotImgs.removeAll()
        }
        viewControllers.first?.hidesBottomBarWhenPushed = false
        return super.popToRootViewController(animated: animated)
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        for vc in viewControllers.reversed() {
            if viewController == vc {
                break
            }
            screenshotImgs.removeLast()
        }
        viewControllers.first?.hidesBottomBarWhenPushed = false
        return super.popToViewController(viewController, animated: animated)
    }
}
