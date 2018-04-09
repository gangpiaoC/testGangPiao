//
//  GPWUserBCSecondCell.swift
//  GangPiaoWang
//
//  Created by gangpiaowang on 2017/11/22.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit

class GPWUserBCSecondCell: UITableViewCell {
    var calendarView:GPWCalendarView!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        calendarView = Bundle.main.loadNibNamed("SFCalendarView", owner: nil, options: nil)?.first as! GPWCalendarView
        calendarView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 38 * 8)
        contentView.addSubview(calendarView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

