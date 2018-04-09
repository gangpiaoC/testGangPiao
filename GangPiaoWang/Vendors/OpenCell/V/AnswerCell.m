//
//  AnswerCell.m
//  KCB
//
//  Created by haozp on 16/1/6.
//  Copyright © 2016年 haozp. All rights reserved.
//

#import "AnswerCell.h"
#import "XHColor.h"
#define SCREEN_WIDTH                 ([[UIScreen mainScreen] bounds].size.width)
@implementation AnswerCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
         self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.tempTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 16, SCREEN_WIDTH - 32, 300)];
        self.tempTitleLabel.font = [UIFont systemFontOfSize:14];
        self.tempTitleLabel.numberOfLines = 0;
        self.tempTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.tempTitleLabel.textColor = [XHColor colorWithHexString:@"666666"];
        self.tempTitleLabel.textColor = [XHColor colorWithHexString:@"666666"];
        self.tempTitleLabel.backgroundColor = [XHColor colorWithHexString:@"f2f2f2"];
        [self.contentView addSubview:self.tempTitleLabel];
        self.backgroundColor = [XHColor colorWithHexString:@"f2f2f2"];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
