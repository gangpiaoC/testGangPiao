//
//  LazyScrollView.m
//  DMLazyScrollViewExample
//
//  Created by xia on 14/11/23.
//  Copyright (c) 2014年 daniele. All rights reserved.
//

#import "LazyScrollView.h"
#import "UIView+XH.h"
@interface LazyScrollView()<UIScrollViewDelegate,XHItemsScrollViewDelegate>
@property(nonatomic,strong)  NSMutableArray *lineViewsArray;
@property(nonatomic,strong)  NSMutableArray *topBtnArray;
@property(nonatomic,assign) float btnWith;
//视图选择数组，最多存3个，超过3个把最早的移除
@property(nonatomic,strong) NSMutableArray *viewSelectArray;
@property(nonatomic,strong) UIView *maskView;
@end
@implementation LazyScrollView

-(id)initWithFrame:(CGRect)frame delegate:(id)delegate dataArray:(NSArray *)dataArray{
    self=[super initWithFrame:frame];
    if (self) {
        _btnWith= self.width / dataArray.count;
        _topBtnArray=[[NSMutableArray alloc]initWithCapacity:0];
        _btnSpace=22.5;
        _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width,self.height)];
        [self addSubview:_scrollView];
        
        _dataArray=dataArray;
        _lazyDelegate=delegate;
        _scrollView.delegate=self;
        _viewsArray=[[NSMutableArray alloc]initWithCapacity:0];
        _viewSelectArray=[[NSMutableArray alloc]initWithCapacity:0];
        _scrollView.pagingEnabled=YES;
        _scrollView.showsHorizontalScrollIndicator=NO;
        for(int i=0;i<dataArray.count;i++){
            [_viewsArray addObject:[NSNull null]];
        }
        [self createTopScrollView];
        _scrollView.frame=CGRectMake(0,CGRectGetMaxY(_topScrollView.frame) , self.width,self.height-CGRectGetMaxY(_topScrollView.frame));
        _scrollView.contentSize=CGSizeMake(self.frame.size.width*dataArray.count, _scrollView.height);
        [self setTopOffSetWithIndex:0];
    }
    return self;
}

-(void)setHeight:(CGFloat)height{
    [super setHeight:height];
    _scrollView.height=height;
}

-(id)initNoTopWithFrame:(CGRect)frame delegate:(id)delegate dataArray:(NSArray *)dataArray{
    self=[super initWithFrame:frame];
    if (self) {
        _topBtnArray=[[NSMutableArray alloc]initWithCapacity:0];
        _btnSpace=22.5;
        _scrollView=[[UIScrollView alloc]initWithFrame:self.bounds];
        [self addSubview:_scrollView];
        
        _dataArray=dataArray;
        _lazyDelegate=delegate;
        _scrollView.delegate=self;
        _viewsArray=[[NSMutableArray alloc]initWithCapacity:0];
        _scrollView.pagingEnabled=YES;
        _scrollView.contentSize=CGSizeMake(self.frame.size.width*dataArray.count, _scrollView.height);
        for(int i=0;i<dataArray.count;i++){
            [_viewsArray addObject:[NSNull null]];
        }
//        [self setTopIndex:0];
        [self loadViewAtIndex:0];
    }
    return self;
}
-(void)createTopScrollView{
    _topScrollView=[XHItemsScrollView createItemsScrollViewWithdelegate:self];
    [_topScrollView setItemsWithDataArray:_dataArray];
    [self addSubview:_topScrollView];
}
-(void)XHItemsScrollViewClickWithIndex:(int)index{
    [self setTopOffSetWithIndex:index];
}
-(void)setTopOffSetWithIndex:(int)index{
    [_topScrollView setItemsToIndex:index];
    _currentIndex= index;
    [self loadViewAtIndex:_currentIndex];
    [_scrollView setContentOffset:CGPointMake(_scrollView.width*_currentIndex,0) animated:NO];
    if ([self.lazyDelegate respondsToSelector:@selector(lazyViewdidSelectTabAtIndex:subView:)]) {
        [self.lazyDelegate lazyViewdidSelectTabAtIndex:_currentIndex subView:[_viewsArray objectAtIndex:_currentIndex]];
    }
    
}

/**
 *  点击之后更换View
 *
 */
-(LazyScrollSubView *)loadViewAtIndex:(int)index{
    id view=[_viewsArray objectAtIndex:index];
    _currentIndex=index;
    if (view==[NSNull null]) {
        [self addViewForIndex:index];
    }
    LazyScrollSubView *subView=[_viewsArray objectAtIndex:index];
    if (!subView.tempDataArray||subView.tempDataArray.count==0) {
        [subView reloadDataWithDict:[_dataArray objectAtIndex:index]];
    }
    _currentView=[_viewsArray objectAtIndex:index];

    for( LazyScrollSubView *view in _viewSelectArray){
        if ([view isEqual:subView]) {
            //把原来的位置删除掉，在最后的位置添加新的
            [_viewSelectArray removeObject:view];
            break;
        }
    }

    //最多3个，超过三个就把最早的移除掉

    [_viewSelectArray addObject:subView];
    if (_viewSelectArray.count>3) {
        LazyScrollSubView *view=_viewSelectArray[0];
        [_viewSelectArray removeObjectAtIndex:0];

        [_viewsArray replaceObjectAtIndex:[_viewsArray indexOfObject:view] withObject:[NSNull null]];
        [view removeFromSuperview];
        view=nil;
    }

    return _currentView;
}
-(void)clearAllRequestDelegate{
    for(id view in _viewsArray){
        if (view!=[NSNull null]) {
            LazyScrollSubView *indexView=(LazyScrollSubView *)view;
            [indexView clearRequestDelegate];
        }
    }
}
-(void)addViewForIndex:(int)index{
    if ([self.lazyDelegate respondsToSelector:@selector(lazyViewAtIndex:)]) {
        LazyScrollSubView *indexView=[self.lazyDelegate lazyViewAtIndex:index];
        indexView.frame=CGRectMake(self.frame.size.width*index, 0, self.frame.size.width, _scrollView.frame.size.height - 50);
        NSLog(@"qqqqqq2===%f",indexView.height);
        [_scrollView addSubview:indexView];
        [_viewsArray replaceObjectAtIndex:index withObject:indexView];
    }
    
}
-(void)addPreView{
    int preIndex=_currentIndex-1;
    
    if (preIndex>=0) {
        id preView=[_viewsArray objectAtIndex:preIndex];
        if (preView==[NSNull null]) {
            [self addViewForIndex:preIndex];
        }
    }
    
}

-(void)addNextView{
    int nextIndex=_currentIndex+1;
    if (nextIndex<=_viewsArray.count-1) {
        id nextView=[_viewsArray objectAtIndex:nextIndex];
        if (nextView==[NSNull null]) {
            [self addViewForIndex:nextIndex];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float offX=scrollView.contentOffset.x;
    if (offX>0&&offX<_viewsArray.count*self.frame.size.width) {
        float currentOffSet=_currentIndex*self.frame.size.width;
        if (offX>currentOffSet) {
            [self addNextView];
        }
        else if(offX<currentOffSet){
            [self addPreView];
        }
    }
    if ([self.lazyDelegate respondsToSelector:@selector(lazyScrollViewDidScrollView:)]) {
        [self.lazyDelegate lazyScrollViewDidScrollView:scrollView];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float offX=scrollView.contentOffset.x;
    int index=offX/self.frame.size.width;
    [self setTopOffSetWithIndex:index];

}
@end
