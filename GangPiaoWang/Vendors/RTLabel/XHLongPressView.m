//
//  XHLongPressView.m
//  XiangHa_3
//
//  Created by xia on 14/11/12.
//  Copyright (c) 2014年 xiangha. All rights reserved.
//

#import "XHLongPressView.h"
#import "XHColor.h"
@interface XHLongPressView()
{
    UILongPressGestureRecognizer *_longPressGes;
    NSArray *_titleArray;
}
@end
@implementation XHLongPressView
-(void)addLongPressActionInCopyWithArray:(NSArray *)titleArray{
    self.longPressColor=[XHColor colorWithHexString:@"e3e3e3"];
    if (!_longPressGes) {
        _longPressGes= [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTimeClickedAction:)];
        _longPressGes.minimumPressDuration = 0.5;
        [self addGestureRecognizer:_longPressGes];
        _longPressGes.allowableMovement = NO;
        [self setMultipleTouchEnabled:NO];
    }
    _titleArray=titleArray;
    _lastBackgroundColor=self.backgroundColor;

}
-(void)setMenuWithTitleArray{
    NSMutableArray *tempArray=[[NSMutableArray alloc]initWithCapacity:0];

    UIMenuItem *textItem = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(rtMenuItemAction0:)];
    [tempArray addObject:textItem];

    if (_titleArray) {
        if (_titleArray.count>=1) {
            UIMenuItem *textItem1 = [[UIMenuItem alloc] initWithTitle:[_titleArray objectAtIndex:0] action:@selector(rtMenuItemAction1:)];
            [tempArray addObject:textItem1];
        }

        if (_titleArray.count>=2) {
            UIMenuItem *textItem2 = [[UIMenuItem alloc] initWithTitle:[_titleArray objectAtIndex:1] action:@selector(rtMenuItemAction2:)];
            [tempArray addObject:textItem2];
        }
    }
    [UIMenuController sharedMenuController].menuItems=tempArray;
    [[UIMenuController sharedMenuController] update];
}
- (BOOL)canPerformAction:(SEL)action
              withSender:(id)sender
{
    if (action == @selector(rtMenuItemAction0:)||action == @selector(rtMenuItemAction1:)||action == @selector(rtMenuItemAction2:))
        return YES;

    return [super canPerformAction:action withSender:sender];
}

- (void) longTimeClickedAction:(UILongPressGestureRecognizer *)gestureRecognizer {

    if (gestureRecognizer.state==UIGestureRecognizerStateBegan) {

        [self setMenuWithTitleArray];
        self.backgroundColor=self.longPressColor;

        [self becomeFirstResponder];
        //[XHGlobal share].firstResponder=self;
        [[UIMenuController sharedMenuController] setTargetRect:[self frame] inView:self.superview];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    }
}
- (void)rtMenuItemAction0:(id)sender
{
    //复制动作
//    if ([self.longPressDelegate respondsToSelector:@selector(menuItemActionLongPressView:index:)])
//    {
//        [self.longPressDelegate menuItemActionLongPressView:self index:0];
//    }
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:self.enableCopyText];
}
- (void)rtMenuItemAction1:(id)sender
{
    if ([self.longPressDelegate respondsToSelector:@selector(menuItemActionLongPressView:index:)])
    {
        [self.longPressDelegate menuItemActionLongPressView:self index:1];
    }
}
- (void)rtMenuItemAction2:(id)sender
{
    if ([self.longPressDelegate respondsToSelector:@selector(menuItemActionLongPressView:index:)])
    {
        [self.longPressDelegate menuItemActionLongPressView:self index:2];
    }
}


@end
