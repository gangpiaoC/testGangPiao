//
//  SectionModel.swift
//  FoldTableView
//
//  Created by ShaoFeng on 16/7/29.
//  Copyright © 2016年 Cocav. All rights reserved.
//

import UIKit
import SwiftyJSON
class GPWFriendSectionModel: NSObject {
    //邀请方式
    var yaotypeStr : String?
    //名称
    var nameStr:String?
    //手机号
    var phoneStr:String?
    //时间
    var timeStr:String?
    //金额
    var moneyStr:String?
    var isExpanded: Bool? = false
    var cellModels: [GPWFriendCellModel] = []
    
    class func loadData( dicArray:[JSON],finish: ([GPWFriendSectionModel]) -> ()) {
        var array = [GPWFriendSectionModel]()
        for i in 0 ..< dicArray.count{
            let sectionModel = GPWFriendSectionModel()
             let  oneDic = dicArray[i]
            sectionModel.isExpanded = false
            sectionModel.yaotypeStr = oneDic["type"].stringValue
            sectionModel.nameStr = oneDic["name"].stringValue
            sectionModel.phoneStr = oneDic["telephone"].stringValue
            sectionModel.timeStr =  GPWHelper.strFromDate(oneDic["add_time"].doubleValue, format: "yyyy.MM.dd")
            sectionModel.moneyStr =  "\(oneDic["amounts"] )"
            
            var cellModels = [GPWFriendCellModel]()
            let  secArray = oneDic["secnd"]
            for i in 0 ..< secArray.count{
                let dic = secArray[i]
                let cellModel = GPWFriendCellModel()
                cellModel.yaotypeStr = dic["type"].stringValue
                cellModel.nameStr = dic["name"].stringValue
                cellModel.phoneStr = dic["telephone"].stringValue
                cellModel.timeStr =  GPWHelper.strFromDate(dic["add_time"].doubleValue, format: "yyyy.MM.dd")
                cellModel.moneyStr =   "\(dic["amounts"] )"
                cellModels.append(cellModel)
            }
            sectionModel.cellModels = cellModels
            array.append(sectionModel)
        }
        finish(array)
    }
}
