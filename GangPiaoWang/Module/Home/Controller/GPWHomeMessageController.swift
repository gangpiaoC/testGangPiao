//
//  GPWHomeMessageController.swift
//  GangPiaoWang
//  平台公告
//  Created by gangpiaowang on 2017/3/24.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWHomeMessageController: GPWSecBaseViewController,LazyScrollViewDelegate{
    var _startIndex = 0
    let contentArray = [
        ["title":"平台公告","type":News],
        ["title":"回款公告","type":Payment]
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "公告"
        let lazyScrollView = LazyScrollView(frame: self.bgView.bounds, delegate: self, dataArray: contentArray)
        self.bgView.addSubview(lazyScrollView!)
    }

    func lazyView(at index: Int32) -> LazyScrollSubView! {
        let view = GPWHMessageView(frame: self.bgView.bounds)
        view.inCtl = self
        return view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

