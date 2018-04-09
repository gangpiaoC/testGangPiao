//
//  LazyScrollSubView.h
//  XiangHa_3
//
//  Created by xia on 14/11/23.
//  Copyright (c) 2014年 xiangha. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LazyScrollSubView : UIView
@property(nonatomic,copy) NSString *name;
@property(nonatomic,strong) NSMutableArray *tempDataArray;
@property(nonatomic,weak) UIViewController *inCtl;

/**
 *  刷新数据
 *
 *  @param dict <#dict description#>
 */
-(void)reloadDataWithDict:(NSDictionary *)dict;
-(void)clearRequestDelegate;
@end
