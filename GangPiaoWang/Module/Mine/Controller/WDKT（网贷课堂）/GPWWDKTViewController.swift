//
//  GPWWDKTViewController.swift
//  GangPiaoWang
//  网贷课堂
//  Created by gangpiaowang on 2018/3/6.
//  Copyright © 2018年 GC. All rights reserved.
//

import UIKit

class GPWWDKTViewController: GPWSecBaseViewController,LazyScrollViewDelegate{

    var _startIndex = 0
    let contentArray = [
        ["title":"网贷知识","type":"1"],
        ["title":"风险提示","type":"0"]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "网贷课堂"

        let lazyScrollView = LazyScrollView(frame: self.bgView.bounds, delegate: self, dataArray: contentArray)
        lazyScrollView?.setTopOffSetWith(Int32(_startIndex))
        self.bgView.addSubview(lazyScrollView!)
    }

    func lazyView(at index: Int32) -> LazyScrollSubView! {
        let view = GPWWDKTSubview(frame: self.bgView.bounds)
        view.inCtl = self
        return view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
