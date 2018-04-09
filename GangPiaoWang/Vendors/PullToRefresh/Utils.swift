//
//  RefreshUtil.swift
//  PullToRefreshKit
//
//  Created by huangwenchen on 16/7/12.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
import UIKit

struct PullToRefreshKitConst{
    //KVO
    static let KPathOffSet = "contentOffset"
    static let KPathPanState = "state"
    static let KPathContentSize = "contentSize"
    
    //Default const
    static let defaultHeaderHeight:CGFloat = 70.0
    static let defaultFooterHeight:CGFloat = 44.0
    
    //Tags
    static let headerTag = 100001
    static let footerTag = 100002
}

struct PullToRefreshKitHeaderString{
//    static let pullDownToRefresh = "下拉可以刷新"
//    static let releaseToRefresh =  "松开立即刷新"
//    static let refreshSuccess = "刷新成功"
//    static let refreshFailure = "刷新失败"
//    static let refreshing = "正在刷新数据中..."
    static let pullDownToRefresh = "有温度的金融服务平台"
    static let releaseToRefresh =  "有温度的金融服务平台"
    static let refreshSuccess = "有温度的金融服务平台"
    static let refreshFailure = "有温度的金融服务平台"
    static let refreshing = "有温度的金融服务平台"
}

struct PullToRefreshKitFooterString{
//    static let pullUpToRefresh = "上拉加载更多数据"
    static let pullUpToRefresh = ""
    static let refreshing = "正在刷新数据中..."
    static let noMoreData = "暂无更多数据"
    static let tapToRefresh = "点击加载更多"
    static let scrollAndTapToRefresh = "上拉或点击加载更多"
}

struct PullToRefreshKitBool {
    static var isLoading = false
}
