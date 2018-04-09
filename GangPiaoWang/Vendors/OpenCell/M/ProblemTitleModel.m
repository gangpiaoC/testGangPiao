//
//  ProblemTitleModel.m
//  KCB
//
//  Created by haozp on 16/1/6.
//  Copyright © 2016年 haozp. All rights reserved.
//

#import "ProblemTitleModel.h"
#import "AnswerModel.h"

@implementation ProblemTitleModel

+ (instancetype)friendGroupWithDict:(NSDictionary *)dict withIndex:(NSInteger)index{
    return [[self alloc] initWithDict:dict withIndex:(NSInteger)index];
}
- (instancetype)initWithDict:(NSDictionary *)dict withIndex:(NSInteger)index{
    if (self = [super init]) {
        self.title = dict[@"title"];
        _index = index;
        NSMutableArray *tempArray = [NSMutableArray array];
        AnswerModel *answer = [AnswerModel answerWithDict:dict];
        [tempArray addObject:answer];
        _infor = tempArray;
    }
    return self;
}
@end
