//
//  UILabel+YXYNumberAnimationLabel.m
//  YXYNumberAnimationLabelDemo
//
//  Created by 杨萧玉 on 14-5-25.
//  Copyright (c) 2014年 杨萧玉. All rights reserved.
//
//#define AnimationSpeed 100
#import "UILabel+YXYNumberAnimationLabel.h"
#import <objc/runtime.h>
#define TIMEINTERVAL 0.01
@implementation UILabel (YXYNumberAnimationLabel)
-(void)autochangeFontsize:(double) number{
//    if (number<100000) {
//        [self setFont:[UIFont fontWithName:self.font.fontName size:28]];
//    }
//    else if (number<1000000){
//        [self setFont:[UIFont fontWithName:self.font.fontName size:26]];
//    }
//    else if (number<10000000){
//        [self setFont:[UIFont fontWithName:self.font.fontName size:24]];
//    }
//    else if (number<100000000){
//        [self setFont:[UIFont fontWithName:self.font.fontName size:22]];
//    }
}
-(void)changNumToNumber:(double)number withDurTime:(double)time withStrnumber:(NSString *)str{
    double timeNum = time / TIMEINTERVAL;
    [self setAnimationSpeed:number / timeNum];
    self.toNumber = number;
    self.strNumber = str;
    [self changeFromNumber:0 toNumber:number withAnimationTime:TIMEINTERVAL];
}

-(void)changeFromNumber:(double) originalnumber toNumber:(double) newnumber withAnimationTime:(NSTimeInterval)timeSpan{
    [UIView animateWithDuration:timeSpan delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        NSString *currencyStr = [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithDouble: originalnumber]  numberStyle:NSNumberFormatterCurrencyStyle];
        currencyStr = [currencyStr substringWithRange:NSMakeRange(1, currencyStr.length-2)];
        if ([[currencyStr substringFromIndex:currencyStr.length-1] isEqualToString:@"0"]) {
            currencyStr =[currencyStr substringToIndex:currencyStr.length-2];
        }
        [self autochangeFontsize:originalnumber];
        self.text = currencyStr;
        
    } completion:^(BOOL finished) {
        if(originalnumber < newnumber){
            [self changeFromNumber:originalnumber + self.animationSpeed toNumber:newnumber withAnimationTime:timeSpan];
        }else{
            self.text = self.strNumber;
        }
    }];
}



-(double)animationSpeed{
    double speed = ((NSNumber *)objc_getAssociatedObject(self, @selector(animationSpeed))).doubleValue;
    if (!speed) {
        speed = 100;
    }
    return speed;
}

-(void)setAnimationSpeed:(double)speed{
    objc_setAssociatedObject(self, @selector(animationSpeed), [NSNumber numberWithDouble:speed], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void)setToNumber:(CGFloat)toNumber{
    objc_setAssociatedObject(self, @selector(toNumber), [NSNumber numberWithDouble:toNumber], OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(CGFloat)toNumber{
    double number = ((NSNumber *)objc_getAssociatedObject(self, @selector(toNumber))).doubleValue;
    return number;
}
-(void)setStrNumber:(NSString *)strNumber{
    objc_setAssociatedObject(self, @selector(strNumber), strNumber, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)strNumber{
    NSString *str =  ((NSString *)objc_getAssociatedObject(self, @selector(strNumber)));
    return str;
}

@end
