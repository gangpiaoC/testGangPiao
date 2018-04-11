//
//  GPWRedEnvelop.swift
//  GangPiaoWang
//
//  Created by GC on 16/12/29.
//  Copyright © 2016年 GC. All rights reserved.
//

import Foundation
import SwiftyJSON

struct RedEnvelop {
    var restrict_amount: Int
    var amount: Int     //红包金额
    var auto_id: String
    var status: String
    var expire: Double
    var limit: String
    var limitse:String
    var active_time: Double
    
    init(_ redEnvelop: JSON) {
        restrict_amount = redEnvelop["restrict_amount"].intValue
        amount = redEnvelop["amount"].intValue
        auto_id = redEnvelop["auto_id"].stringValue
        status = redEnvelop["status"].stringValue
        expire = redEnvelop["due_time"].doubleValue
        limit = redEnvelop["limit"].stringValue
        limitse =  redEnvelop["limitse"].stringValue
        active_time = redEnvelop["active_time"].doubleValue
    }
}
    
