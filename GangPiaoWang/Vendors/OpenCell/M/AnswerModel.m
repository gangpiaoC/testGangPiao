//
//  AnswerModel.m
//  KCB
//
//  Created by haozp on 16/1/6.
//  Copyright © 2016年 haozp. All rights reserved.
//

#import "AnswerModel.h"

@implementation AnswerModel

+ (instancetype)answerWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.answer = dict[@"content"];
    }
    return self;
}

@end
