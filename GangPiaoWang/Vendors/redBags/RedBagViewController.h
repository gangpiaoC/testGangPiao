//
//  ViewController.h
//  Snow
//
//  Created by 周 俊杰 on 13-9-16.
//  Copyright (c) 2013年 周 俊杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedBagViewController : UIViewController{
    NSMutableArray *_imagesArray;
}
@property (nonatomic, copy) void (^ButtonBlock)();
@end
