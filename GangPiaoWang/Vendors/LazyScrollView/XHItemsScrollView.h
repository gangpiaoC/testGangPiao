//
//  XHItemsScrollView.h
//  XiangHa_3
//
//  Created by xia on 15/3/30.
//  Copyright (c) 2015年 xiangha. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol XHItemsScrollViewDelegate;
@interface XHItemsScrollView : UIScrollView
@property(nonatomic,assign) BOOL enableAlignCenter;
@property(nonatomic,assign) BOOL enableLeftMargin;
@property(nonatomic,strong)  NSMutableArray *lineViewsArray;
 @property(nonatomic,strong) NSMutableArray *topBtnArray;

@property(nonatomic,assign) id<XHItemsScrollViewDelegate> clickDelegate;
+(XHItemsScrollView *)createItemsScrollViewWithdelegate:(id)clickDelegate;

-(void)setItemsWithDataArray:(NSArray *)dataArray;
-(void)setItemsToIndex:(int)index;
@end

@protocol XHItemsScrollViewDelegate <NSObject>
-(void)XHItemsScrollViewClickWithIndex:(int)index;
@end