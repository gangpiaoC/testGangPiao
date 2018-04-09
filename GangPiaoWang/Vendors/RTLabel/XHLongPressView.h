//
//  XHLongPressView.h
//  XiangHa_3
//
//  Created by xia on 14/11/12.
//  Copyright (c) 2014年 xiangha. All rights reserved.
//

@protocol XHViewLongPressDelegate;
#import <UIKit/UIKit.h>
@interface XHLongPressView : UIView
@property (nonatomic, strong) UIColor *longPressColor;
@property(nonatomic,copy) NSString *enableCopyText;
@property(nonatomic,strong) UIColor *lastBackgroundColor;
@property(nonatomic,assign) id<XHViewLongPressDelegate> longPressDelegate;
-(void)addLongPressActionInCopyWithArray:(NSArray *)titleArray;

@end

@protocol XHViewLongPressDelegate <NSObject>
-(void)menuItemActionLongPressView:(XHLongPressView *)view index:(int)index;
@end
