//
//  HeadView.m
//  KCB
//
//  Created by haozp on 16/1/6.
//  Copyright © 2016年 haozp. All rights reserved.
//
#define SCREEN_WIDTH                 ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)

#import "HeadView.h"
#import "ProblemTitleModel.h"
#import "XHColor.h"
@interface HeadView()
{
    UIButton *_bgButton;
    UILabel *_numLabel;
}
@end

@implementation HeadView

+ (instancetype)headViewWithTableView:(UITableView *)tableView
{
    static NSString *headIdentifier = @"header";
    
    HeadView *headView;
    if (headView == nil) {
        headView = [[HeadView alloc] initWithReuseIdentifier:headIdentifier];
    }
    
    return headView;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UIButton *bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [bgButton setImage:[UIImage imageNamed:@"found_help_jiantou"] forState:UIControlStateNormal];
        [bgButton setTitleColor:[XHColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        bgButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [bgButton setBackgroundColor:[UIColor whiteColor]];
        bgButton.imageView.contentMode = UIViewContentModeCenter;
        bgButton.imageView.clipsToBounds = NO;
        bgButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        bgButton.contentEdgeInsets = UIEdgeInsetsMake(30, SCREEN_WIDTH-30, 30, 0);
        bgButton.titleEdgeInsets = UIEdgeInsetsMake(0, -SCREEN_WIDTH + 30, 0, 50);
        [bgButton addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgButton];
        _bgButton = bgButton;
    }
    return self;
}

- (void)headBtnClick{
    if ([_delegate respondsToSelector:@selector(clickWidthIndex:)]) {
        [_delegate clickWidthIndex:_titleGroup.index];
    }
}
- (void)setTitleGroup:(ProblemTitleModel *)titleGroup{
    _titleGroup = titleGroup;
    [_bgButton setTitle:titleGroup.title forState:UIControlStateNormal];
}


- (void)didMoveToSuperview{
    [UIView animateWithDuration:0.1 animations:^{
            _bgButton.imageView.transform = _titleGroup.isOpened ? CGAffineTransformMakeRotation(M_PI_2*2) : CGAffineTransformMakeRotation(0);
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _bgButton.frame = self.bounds;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(16, self.frame.size.height-1, self.frame.size.width - 16, 1)];
    line.backgroundColor = [XHColor colorWithHexString:@"f2f2f2"];
    [self addSubview:line];
}

@end
