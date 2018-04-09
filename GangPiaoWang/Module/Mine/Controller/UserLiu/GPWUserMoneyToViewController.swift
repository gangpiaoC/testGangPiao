//
//  GPWUserMoneyToViewController.swift
//  GangPiaoWang
//  资金流水
//  Created by gangpiaowang on 2016/12/21.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

class GPWUserMoneyToViewController:GPWSecBaseViewController,LazyScrollViewDelegate {
    
    var _startIndex = 0
    let contentArray = [
        ["title":"转入","type":"switch"],
        ["title":"支出","type":"turnout"]
        ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "资金流水"
        
        let lazyScrollView = LazyScrollView(frame: self.bgView.bounds, delegate: self, dataArray: contentArray)
        lazyScrollView?.setTopOffSetWith(Int32(_startIndex))
        self.bgView.addSubview(lazyScrollView!)
    }
    
    func lazyView(at index: Int32) -> LazyScrollSubView! {
        let view = GPWUserMoneyToSubView(frame: self.bgView.bounds)
        view.inCtl = self
        return view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


