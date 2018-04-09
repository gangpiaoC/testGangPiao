//
//  LazyScrollView.h
//  DMLazyScrollViewExample
//
//  Created by xia on 14/11/23.
//  Copyright (c) 2014年 daniele. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LazyScrollSubView.h"
#import "XHItemsScrollView.h"
@protocol LazyScrollViewDelegate;
@interface LazyScrollView : UIView
@property(nonatomic,assign) float btnSpace;
@property(nonatomic,assign)  int currentIndex;
@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,weak) LazyScrollSubView *currentView;
@property(nonatomic,assign) id<LazyScrollViewDelegate> lazyDelegate;
@property(nonatomic,strong) NSMutableArray *viewsArray;
//是否可滑动

//@property(nonatomic,strong) UIScrollView *topScrollView;
@property(nonatomic,strong) XHItemsScrollView *topScrollView;
@property(nonatomic,strong) NSArray *dataArray;

-(id)initWithFrame:(CGRect)frame delegate:(id)delegate dataArray:(NSArray *)dataArray;
-(id)initNoTopWithFrame:(CGRect)frame delegate:(id)delegate dataArray:(NSArray *)dataArray;
-(void)setTopOffSetWithIndex:(int)index;
-(void)clearAllRequestDelegate;
@end

@protocol LazyScrollViewDelegate <NSObject>
@optional
-(void)lazyViewdidSelectTabAtIndex:(int)index subView:(LazyScrollSubView *)subView;
-(void)lazyScrollViewDidScrollView:(UIScrollView *)scrollView;
@required
-(LazyScrollSubView *)lazyViewAtIndex:(int)index;

@end
