//
//  GPWProjectDetailViewController.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/19.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWProjectDetailViewController: GPWSecBaseViewController, UIScrollViewDelegate {
    
    lazy var scrollView:UIScrollView = {
        var scrollView:UIScrollView = UIScrollView(frame:  CGRect(x: 0,y: 0,width: self.bgView.bounds.size.width,height: self.bgView.bounds.size.height - 49))
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = false
        scrollView.contentSize = CGSize(width: self.bgView.bounds.width, height: self.bgView.bounds.height * 2)
        return scrollView
    }()
    
    lazy var firstSubView:UIScrollView = {
        var scrollView:UIScrollView = UIScrollView(frame:  CGRect(x: 0,y: 0,width: self.bgView.bounds.size.width,height: self.bgView.bounds.size.height - 49))
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.blue
//        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: self.bgView.bounds.width, height: (self.bgView.bounds.height - 49) * 2)
        return scrollView
    }()
    
    lazy var secondSubView: UIView = {
        var view: UIView = UIView(frame: CGRect(x: 0,y: self.bgView.bounds.size.height,width: self.bgView.bounds.size.width,height: self.bgView.bounds.size.height - 49))
        view.backgroundColor = UIColor.red
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "项目详情"
        bgView.addSubview(scrollView)
        bgView.addSubview(firstSubView)
        bgView.addSubview(secondSubView)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentOffsetY = scrollView.contentOffset.y
        if(contentOffsetY > (scrollView.contentSize.height - scrollView.bounds.size.height + 20))
        {
            let contentOffset = CGPoint(x: 0, y: self.bgView.bounds.height - 49)
            self.scrollView.setContentOffset(contentOffset, animated: true)
        }
    }
}
