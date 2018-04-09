//
//  XHColor.h
//  XiangHa_3
//
//  Created by xia on 14/9/16.
//  Copyright (c) 2014年 xiangha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface XHColor : NSObject
/**
 *  将十六进制字符串转化为颜色值
 *
 *  @param stringToConvert <#stringToConvert description#>
 *
 *  @return <#return value description#>
 */
+(UIColor *) colorWithHexString: (NSString *) stringToConvert;
/**
 *  <#Description#>
 *
 *  @param stringToConvert <#stringToConvert description#>
 *  @param alpha           字体透明度
 *
 *  @return <#return value description#>
 */
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert alpha:(float)alpha;
@end
