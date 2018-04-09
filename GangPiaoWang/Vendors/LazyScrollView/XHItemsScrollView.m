//
//  XHItemsScrollView.m
//  XiangHa_3
//
//  Created by xia on 15/3/30.
//  Copyright (c) 2015年 xiangha. All rights reserved.
//

#import "XHItemsScrollView.h"
#import "XHColor.h"
#import "UIView+XH.h"
#define normalColor @"333333"
#define selectedColor @"f6390d"
#define lineBackClor [XHColor colorWithHexString:@"f2f2f2"]
#define selfHeight 50
@interface XHItemsScrollView()
{
    float _btnSpace;
    UIView *_maskView;
    int _currentIndex;
    NSArray *_dataArray;
    float _startX;
}
@end

@implementation XHItemsScrollView
+(XHItemsScrollView *)createItemsScrollViewWithdelegate:(id)clickDelegate{
    XHItemsScrollView *itemsScrollView=[[XHItemsScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, selfHeight)];
    itemsScrollView.clickDelegate=clickDelegate;
    return itemsScrollView;
}

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _enableAlignCenter=YES;
        _enableLeftMargin=YES;
        _startX=0;
        self.backgroundColor=[UIColor whiteColor];
        self.tag=1000;
        self.showsHorizontalScrollIndicator=NO;
        self.showsVerticalScrollIndicator=NO;
        _topBtnArray=[[NSMutableArray alloc]initWithCapacity:0];
        _btnSpace=22.5;
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 1, [UIScreen mainScreen].bounds.size.width, 1)];
        line.backgroundColor =lineBackClor;
        [self addSubview:line];
    }
    return self;
}
-(void)setItemsWithDataArray:(NSArray *)dataArray{
    if (!_enableLeftMargin) {
        _startX=0;
    }

    _dataArray=dataArray;
    _lineViewsArray=[[NSMutableArray alloc]initWithCapacity:0];
    UIButton *lastBtn=nil;
    float sumWidth=0;

    for(int i=0;i<dataArray.count;i++){
        NSDictionary *dict=[dataArray objectAtIndex:i];
        NSString *name=[dict objectForKey:@"title"];
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor=[UIColor whiteColor];
        [btn setTitle:name forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:16];
        btn.tag=1000+i;
        [btn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        CGSize size=[name sizeWithFont:btn.titleLabel.font];
        sumWidth+=size.width;
        if (lastBtn) {
            btn.frame=CGRectMake(CGRectGetMaxX(lastBtn.frame)+_btnSpace, 0, size.width, self.height - 10);
        }else{
            btn.frame=CGRectMake(_startX, 0, size.width, self.height - 10);
        }
        [_topBtnArray addObject:btn];
        [btn setTitleColor:[XHColor colorWithHexString:normalColor] forState:UIControlStateNormal];

        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, btn.height - 2, btn.width, 2)];
        view.tag=2000;
        view.centerX = btn.width / 2;
        [btn addSubview:view];
        view.backgroundColor=[XHColor colorWithHexString:selectedColor];
        lastBtn=btn;
    }

    UIView *block = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 10, self.width, 10)];
    block.backgroundColor = [XHColor colorWithHexString:@"f2f2f2" ];
    [self addSubview:block];
    
    if (!_enableAlignCenter) {
        [self setContentSize:CGSizeMake(CGRectGetMaxX(lastBtn.frame)+_startX, self.height)];
        return;
    }


    if (dataArray.count<6) {
        _btnSpace=(self.width-sumWidth)/(dataArray.count+1);

        for(int i=0;i<_topBtnArray.count;i++) {
            UIButton *btn=_topBtnArray[i];
            if (i==0) {
                btn.frame=CGRectMake(_btnSpace, 0, btn.width, self.height);
            }
            else{
                btn.frame=CGRectMake(CGRectGetMaxX(lastBtn.frame)+_btnSpace, 0, btn.width, self.height);

            }
            lastBtn=btn;
        }
        return;
    }

    float firstBtnX=_startX;
    if (CGRectGetMaxX(lastBtn.frame)<self.width-_startX*2) {
        firstBtnX=(self.width-(CGRectGetMaxX(lastBtn.frame)-_startX))/2;
    }
    else{
        [self setContentSize:CGSizeMake(CGRectGetMaxX(lastBtn.frame)+15, self.height)];

    }
    for(int i=0;i<_topBtnArray.count;i++) {
        UIButton *btn=_topBtnArray[i];
        if (i==0) {
            btn.frame=CGRectMake(firstBtnX, 0, btn.width, self.height );
        }
        else{
            btn.frame=CGRectMake(CGRectGetMaxX(lastBtn.frame)+_btnSpace, 0, btn.width, self.height );

        }
        UIView *subView=[btn viewWithTag:2000];
        subView.x = -_btnSpace/2;
        lastBtn=btn;
    }


}
-(void)topBtnClick:(UIButton *)btn{
    int index=(int)btn.tag-1000;
    if ([self.clickDelegate respondsToSelector:@selector(XHItemsScrollViewClickWithIndex:)]) {
        [self.clickDelegate XHItemsScrollViewClickWithIndex:index];
    }
}
-(void)setItemsToIndex:(int)index{
    __block float fx = 0;
    int preIndex=_currentIndex;
    _currentIndex = index;
    if (_topBtnArray.count>0) {
        UIButton *button = [_topBtnArray objectAtIndex:index];
        int dirction = index > preIndex ? 1 : -1;

        fx  = button.center.x - self.contentOffset.x - self.width / 2;

        [UIView animateWithDuration:0.15 animations:^{
            if (dirction == 1 && button.center.x - self.contentOffset.x > self.self.width / 2 ) {
                fx = MIN(self.contentOffset.x + fx, self.contentSize.width - self.width);
                if (fx < 0) {
                    fx = 0;
                }
                [self setContentOffset:CGPointMake(fx,0)];


            } else if (dirction == -1 && button.center.x - self.contentOffset.x < self.width / 2){
                fx = MAX(self.contentOffset.x + fx, 0);
                [self setContentOffset:CGPointMake(fx,0)];
            }

        }];
        for (int i = 0; i < _topBtnArray.count; i++) {
            UIButton *button =_topBtnArray[i];
            UIView *subView=[button viewWithTag:2000];
            if (i == index) {
                subView.hidden = NO;
                [button setTitleColor:[XHColor colorWithHexString:selectedColor] forState:UIControlStateNormal];
                subView.backgroundColor = [XHColor colorWithHexString:selectedColor] ;

            } else {
                subView.backgroundColor = lineBackClor;
                subView.hidden = YES;
                [button setTitleColor:[XHColor colorWithHexString:normalColor] forState:UIControlStateNormal];
            }
        }
    }
}

@end
