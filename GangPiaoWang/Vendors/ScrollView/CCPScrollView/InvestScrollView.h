//
//  InvestScrollView.h
//  AMT
//
//  Created by aimutou on 17/3/10.
//  Copyright © 2017年 aimutou. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^clickLabelBlock)(NSInteger index,NSString *titleString);

@interface InvestScrollView : UIView
/**
 *  文字数组
 */
@property (nonatomic,strong) NSArray *investArray;

/**
 *  是否可以拖拽
 */
@property (nonatomic,assign) BOOL isCanScroll;
/**
 *  block回调
 */
@property (nonatomic,copy)void(^clickLabelBlock)(NSInteger index,NSString *titleString);

/**
 *  关闭定时器
 */
- (void)removeTimer;

/**
 *  添加定时器
 */
- (void)addTimer;

/**
 *  label的点击事件
 */

- (void) clickTitleLabel:(clickLabelBlock) clickLabelBlock;

/**
 *  传递数组并把视图宽度传过来
 */

- (void)pushArray:(NSArray *)array withW:(CGFloat)width;

/**
 * 注销界面
 */

-(void)viewDealloc;

@end
