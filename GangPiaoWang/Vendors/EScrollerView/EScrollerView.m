//
//  EScrollerView.m
//  icoiniPad
//
//  Created by Ethan on 12-11-24.
//
//

#import "EScrollerView.h"
#import "UIView+XH.h"
#import "XHColor.h"
static CGFloat const changeTime = 3;

@interface EScrollerView()<UIScrollViewDelegate>
{
    /**
     *  当前第几个
     */
    int currentPageIndex;
    
    /**
     *  数量
     */
    NSUInteger sumPageCnt;
    
    /**
     *  定时器
     */
    NSTimer * _moveTime;
    
    /**
     *  用于确定滚动式由人导致的还是计时器到了,系统帮我们滚动的,YES,则为系统滚动,NO则为客户滚动(ps.在客户端中客户滚动一个广告后,这个广告的计时器要归0并重新计时)
     */
    BOOL _isTimeUp;
    
    /**
     *  滑动视图
     */
    UIScrollView *_scrollView;

}
@end

@implementation EScrollerView

-(id)initWithFrame:(CGRect)frame pageCount:(NSInteger)pageCount delegate:(id)delegate {
    self=[super initWithFrame:frame];
    if (self) {
        self.flag = YES;
        self.delegate=delegate;
        sumPageCnt=pageCount+2;
        self.userInteractionEnabled=YES;
        _scrollView=[[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(frame.size.width * sumPageCnt, frame.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
        for (NSInteger i=0; i<sumPageCnt; i++) {
            NSInteger index=0;
            if (i==0) {
                index=pageCount-1;
            }
            else if (i==sumPageCnt-1){
                index=0;
            }
            else{
                index=i-1;
            }
            UIView *imgView=[self.delegate EScrollerInitViewForIndex:index];
            
            [imgView setFrame:CGRectMake(frame.size.width*i, 0,frame.size.width, frame.size.height)];
            imgView.backgroundColor = [UIColor clearColor];
            imgView.tag=index;
            UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
            [Tap setNumberOfTapsRequired:1];
            [Tap setNumberOfTouchesRequired:1];
            imgView.userInteractionEnabled = YES;
//            if (pageCount <= 1) {
//                _scrollView.userInteractionEnabled = NO;
//            }
            [imgView addGestureRecognizer:Tap];
            [_scrollView addSubview:imgView];
        }
        
        [self addSubview:_scrollView];
        [_scrollView setContentOffset:CGPointMake(frame.size.width, 0)];
        
        UIView *noteView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-33,self.bounds.size.width,33)];
        [noteView setBackgroundColor:[UIColor clearColor]];
        
        float _pageControlWidth = (sumPageCnt - 2) * 10.0f + 40.f;
        float _pageControlHeight = 20.0f;
        
        _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-_pageControlWidth),12, _pageControlWidth, _pageControlHeight)];
        _pageControl.currentPage=0;
        _pageControl.pageIndicatorTintColor= [XHColor colorWithHexString:@"#e8e8e8" alpha:0.7] ;
        _pageControl.currentPageIndicatorTintColor = [XHColor colorWithHexString:@"cfcfcf"];
       
        if(sumPageCnt-2<=1){
            _pageControl.hidden=YES;
        }else{
            _pageControl.hidden=NO;
        }
       
        _pageControl.centerX = self.frame.size.width / 2;
        _pageControl.numberOfPages=(sumPageCnt-2);
        [noteView addSubview:_pageControl];
        _pageControl.userInteractionEnabled=NO;
        [self addSubview:noteView];
        _isTimeUp = NO;
        if (pageCount <= 1) {
            _pageControl.hidden = YES;
        }else{
            
            [_moveTime invalidate];
            _moveTime = [NSTimer scheduledTimerWithTimeInterval:changeTime target:self selector:@selector(animalMoveImage) userInfo:nil repeats:YES];
            _pageControl.hidden = NO;
        }
    }
    return self;
}

-(void)setFlag:(BOOL)flag{
    if (flag) {
    }else{
       [_moveTime invalidate]; 
    }
}
- (void)animalMoveImage
{

     [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width*(_pageControl.currentPage+2), 0) animated:YES];
    _isTimeUp = YES;

    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating) userInfo:nil repeats:NO];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;
    _pageControl.currentPage=(page-1);
    
    int indexNum = page;
    if (page>sumPageCnt-2) {
        indexNum = 1;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating];
}
-(void)scrollViewDidEndDecelerating{
    if (currentPageIndex==0) {
        [_scrollView setContentOffset:CGPointMake((sumPageCnt-2)*_scrollView.frame.size.width, 0)];
    }
    if (currentPageIndex==(sumPageCnt-1)) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    }
    //手动控制图片滚动应该取消那个三秒的计时器
    if (!_isTimeUp) {
        [_moveTime setFireDate:[NSDate dateWithTimeIntervalSinceNow:changeTime]];
    }
    _isTimeUp = NO;
}
- (void)imagePressed:(UITapGestureRecognizer *)sender
{
    if ([self.delegate respondsToSelector:@selector(EScrollerViewDidClicked:)]) {
        [self.delegate EScrollerViewDidClicked:sender.view.tag];
    }
}
-(void)removeFromSuperview{
    [super removeFromSuperview];
    [_moveTime invalidate];
}
@end





