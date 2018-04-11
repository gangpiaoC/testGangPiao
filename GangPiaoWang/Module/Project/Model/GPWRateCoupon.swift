//
//  GPWRateCoupon.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/29.
//  Copyright © 2016年 GC. All rights reserved.
//

import Foundation
import SwiftyJSON

struct RateCoupon {
    var status: String   //未使用AVAILABLE；加息中IN_USE；已使用HAS_USED；已失效PAST_DUE
    var add_time: Double
    var rate: String      //利率（需除以100）
    var road: String
    var trade_num: String
    var restrict_item: String   //加息劵限定项目
    var expire: Double   //加息劵到期时间
    var restrict_time: String
    var auto_id: String
    var active_time: Double
    
    init(_ rateCoupon: JSON) {
        add_time = rateCoupon["add_time"].doubleValue
        rate =  rateCoupon["rate"].stringValue
        road = rateCoupon["road"].stringValue
        trade_num = rateCoupon["trade_num"].stringValue
        restrict_item = rateCoupon["restrict_item"].stringValue
        auto_id = rateCoupon["auto_id"].stringValue
        status = rateCoupon["status"].stringValue
        expire = rateCoupon["due_time"].doubleValue
        active_time = rateCoupon["active_time"].doubleValue
        restrict_time = rateCoupon["restrict_time"].stringValue
    }
}
    
