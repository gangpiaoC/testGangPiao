//
//  GPWTableView.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/2.
//  Copyright © 2016年 GC. All rights reserved.
//

import UIKit

protocol GPWTableViewDelegate: UITableViewDelegate, UITableViewDataSource {}

class GPWTableView: UITableView {
    
    //MARK: /*************生命周期***************
    convenience init(delegate: GPWTableViewDelegate) {
        let frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64 - 49)
        self.init(frame:frame,style:.grouped, delegate:delegate)
    }
    
    convenience init(frame: CGRect, delegate: GPWTableViewDelegate) {
        self.init(frame:frame,style:.grouped, delegate:delegate)
    }
    
    init(frame:CGRect,style:UITableViewStyle, delegate:GPWTableViewDelegate) {
        super.init(frame: frame, style: style)
        self.dataSource = delegate
        self.delegate = delegate
        self.sectionFooterHeight = 0.001
        self.sectionHeaderHeight = 0.0001
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 80.0
        self.separatorStyle = .none
        self.backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
