//
//  EScrollerView.h
//  icoiniPad
//
//  Created by Ethan on 12-11-24.
//
//

#import <UIKit/UIKit.h>
@protocol EScrollerViewDelegate <NSObject>
@optional

/**
 *  点击事件
 *
 *  @param index 点击第几个
 */
-(void)EScrollerViewDidClicked:(NSUInteger)index;

/**
 *  滑动
 *
 *  @param index 滑动到第几个
 *
 *  @return 返回视图
 */
-(UIView *)EScrollerInitViewForIndex:(NSUInteger)index;
@end

@interface EScrollerView : UIView

/**
 *  是否滑动
 */
@property(nonatomic,assign)BOOL flag;
/**
 *  页码控制
 */
@property(nonatomic,retain) UIPageControl *pageControl;


/**
 *  代理
 */
@property(nonatomic,assign)id<EScrollerViewDelegate> delegate;

/**
 *  初始化视图
 *
 *  @param frame     视图大小
 *  @param pageCount 滑动视图的数量
 *  @param delegate  代理
 *
 *  @return 自己
 */
-(id)initWithFrame:(CGRect)frame pageCount:(NSInteger)pageCount delegate:(id)delegate;
@end
