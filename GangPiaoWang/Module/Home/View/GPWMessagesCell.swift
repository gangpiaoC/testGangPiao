//
//  GPWNewsCell.swift
//  GangPiaoWang
//  公告
//  Created by gangpiaowang on 2017/3/20.
//  Copyright © 2017年 GC. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWMessagesCell: UITableViewCell {
    weak var superController:UIViewController?
    var viertScrollView:VierticalScrollView?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        viertScrollView = VierticalScrollView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 40), array: nil)
        self.contentView.addSubview(viertScrollView!)
        let line = UIView(frame: CGRect(x: 0, y: 40 - 0.5, width: SCREEN_WIDTH, height: 0.5))
        line.backgroundColor = lineColor
        self.contentView.addSubview(line)
    }
    func updata(array:JSON)  {
        viertScrollView?.superController = self.superController
        viertScrollView?.update(array: array)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
