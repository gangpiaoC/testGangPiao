//
//  XHPaggingNavbar.m
//  XHTwitterPagging
//
//  Created by 曾 宪华 on 14-6-20.
//  Copyright (c) 2014年 曾宪华 QQ群: (142557668) QQ:543413507  Gmail:xhzengAIB@gmail.com. All rights reserved.
//

#import "XHPaggingNavbar.h"
#import "GangPiaoWang-Swift.h"

#define pixw(p)  ((SCREEN_WIDTH/320.0)*p)
#define kXHiPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define kXHLabelBaseTag 1000

@interface XHPaggingNavbar ()
@property(nonatomic,strong)    NSMutableArray *pageViewsArray;

/**
 *  title label 集合
 */
@property (nonatomic, strong) NSMutableArray *titleLabels;

@end

@implementation XHPaggingNavbar

#pragma mark - DataSource

- (void)reloadData {
    _pageViewsArray=[[NSMutableArray alloc]initWithCapacity:0];
    if (!self.titles.count) {
        return;
    }
    self.clipsToBounds=YES;
    [self.titleLabels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.hidden = YES;
    }];
    
    [self.titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        CGRect titleLabelFrame = CGRectMake((idx * (kXHiPad ?240 : pixw(130))), pixw(20), CGRectGetWidth(self.bounds), pixw(20));
        UILabel *titleLabel = (UILabel *)[self viewWithTag:kXHLabelBaseTag + idx];
        if (!titleLabel) {
            titleLabel = [[UILabel alloc] init];
            [self addSubview:titleLabel];
            [self.titleLabels addObject:titleLabel];
        }
        titleLabel.hidden = NO;
        titleLabel.backgroundColor=[UIColor clearColor];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        titleLabel.font = [UIFont customFontOfSize:18];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor hex:@"333333"];
        titleLabel.text = title;
        titleLabel.frame = titleLabelFrame;
        if (self.currentPage == idx) {
            titleLabel.alpha = 1.0;
        } else {
            titleLabel.alpha = 0.0;
        }

    }];

    for(int i=0;i<self.titleLabels.count;i++){
        float pageCtlW=pixw(5);
        float pageCtlH=pixw(2);
        float pageCtlSpace=pixw(1);

        float startX=(self.width-self.titleLabels.count*pageCtlW-(self.titleLabels.count-1)*pageCtlSpace)/2;
        UIView *pageView=[[UIView alloc]initWithFrame:CGRectMake(startX+i*(pageCtlW+pageCtlSpace), self.height-5-pageCtlH, pageCtlW, pageCtlH)];
        [self addSubview:pageView];
        [_pageViewsArray addObject:pageView];
    }

    self.currentPage=0;
}

#pragma mark - Propertys

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    UIView *view=[_pageViewsArray objectAtIndex:currentPage];
    view.backgroundColor=[UIColor hex:@"111111"];
    for(int i=0;i<_pageViewsArray.count;i++){
        UIView *tempView=[_pageViewsArray objectAtIndex:i];
        if (![view isEqual:tempView]) {
            tempView.backgroundColor=[UIColor hex:@"111111" alpha:0.6];
        }
    }
}
- (void)setContentOffset:(CGPoint)contentOffset {
    _contentOffset = contentOffset;
    CGFloat xOffset = contentOffset.x;
    
    CGFloat normalWidth = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    self.currentPage=(int)xOffset/normalWidth;
    [self.titleLabels enumerateObjectsUsingBlock:^(UILabel *titleLabel, NSUInteger idx, BOOL *stop) {
        if ([titleLabel isKindOfClass:[UILabel class]]) {
            // frame
            CGRect titleLabelFrame = titleLabel.frame;
            titleLabelFrame.origin.x = (idx * (kXHiPad ?240 :pixw(100))) - xOffset / 3.2;
            titleLabel.frame = titleLabelFrame;
            
            // alpha
            CGFloat alpha;
            if(xOffset < normalWidth * idx) {
                alpha = (xOffset - normalWidth * (idx - 1)) / normalWidth;
            }else{
                alpha = 1 - ((xOffset - normalWidth * idx) / normalWidth);
            }
            titleLabel.alpha = alpha;
        }
    }];
}

- (NSMutableArray *)titleLabels {
    if (!_titleLabels) {
        _titleLabels = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _titleLabels;
}

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
    }
    return self;
}

- (void)dealloc {
    self.titleLabels = nil;
}

@end
