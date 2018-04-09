//
//  ProblemTitleModel.h
//  KCB
//
//  Created by haozp on 16/1/6.
//  Copyright © 2016年 haozp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProblemTitleModel : NSObject
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray *infor;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign, getter = isOpened) BOOL opened;

+ (instancetype)friendGroupWithDict:(NSDictionary *)dict withIndex:(NSInteger)index;
- (instancetype)initWithDict:(NSDictionary *)dict withIndex:(NSInteger)index;

@end
