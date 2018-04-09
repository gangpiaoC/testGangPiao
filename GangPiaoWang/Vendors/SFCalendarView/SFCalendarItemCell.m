//
//  SFCalendarItemCell.m
//  SFProjectTemplate
//
//  Created by sessionCh on 2016/12/29.
//  Copyright © 2016年 www.sunfobank.com. All rights reserved.
//

#import "SFCalendarItemCell.h"
#import "SFCalendarManager.h"

@interface SFCalendarItemCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIView *dianImgView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

- (IBAction)btnClick:(UIButton *)sender;

@end

@implementation SFCalendarItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.hidden = YES;
    self.bgImgView.image = [UIImage imageNamed:@"user_bc_selectM"];
    [self.contentView insertSubview:self.bgImgView atIndex:0];
}

- (void)setModel:(SFCalendarItemModel *)model
{
    if (model) {
        _model = model;
        self.lab.text = [NSString stringWithFormat:@"%ld", model.date.day];
        self.lab.font = [UIFont systemFontOfSize:14.0f];
        self.bgImgView.image = [UIImage imageNamed:@""];
        self.lab.textColor = [self stringTOColor:@"#333333"];
        self.bgView.hidden = YES;
        self.dianImgView.hidden = YES;
        switch (model.type) {
            case SFCalendarTypeUp:
            case SFCalendarTypeDown:
            {
                self.lab.textColor = [self stringTOColor:@"#a6a6a6"];
                break;
            }

            case SFCalendarTypeCurrent:
            {

                BOOL  bgHiddenFlag = YES;
                if (model.isNowDay) {
                    bgHiddenFlag = NO;
                    self.lab.textColor = [self stringTOColor:@"#333333"];
                    self.bgView.backgroundColor = [self stringTOColor:@"#ffffff"];
                    self.bgView.layer.borderColor = [self stringTOColor:@"#f6390c"].CGColor;
                    self.bgView.layer.borderWidth = 0.5;
                }
                if (model.isNormalSelected) {
                    self.bgView.backgroundColor = [self stringTOColor:@"#fcc30c"];
                    self.bgView.layer.borderColor = [self stringTOColor:@"#ffffff"].CGColor;
                    self.dianImgView.hidden = NO;
                }

                if (model.isSelected){
                     self.lab.textColor = [self stringTOColor:@"#ffffff"];
                    self.bgView.backgroundColor = [self stringTOColor:@"#f6390d"];
                    self.bgView.layer.borderColor = [self stringTOColor:@"#ffffff"].CGColor;
                    // 添加简易动画
                    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                    animation.duration = 0.15;
                    animation.repeatCount = 1;
                    animation.autoreverses = YES;
                    animation.fromValue = [NSNumber numberWithFloat:1.0];
                    animation.toValue = [NSNumber numberWithFloat:1.1];
                    [self.bgView.layer addAnimation:animation forKey:@"scale-layer"];
                    bgHiddenFlag = NO;
                }
                self.bgView.hidden = bgHiddenFlag;
                break;
            }
                
            case SFCalendarTypeWeek:
            {
                self.lab.text = model.weekday;
                self.lab.textColor = [self stringTOColor:@"#a6a6a6"];
                break;
            }
                
            case SFCalendarTypeMonth:
            {
                self.lab.text = [NSString stringWithFormat:@"%@月",model.month];
                if (model.isSelected) {
                    self.bgImgView.image = [UIImage imageNamed:@"user_bc_selectM"];
                    self.lab.textColor = [self stringTOColor:@"#f6390c"];
                } else {
                    self.bgImgView.image = [UIImage imageNamed:@""];
                    self.lab.textColor = [self stringTOColor:@"#ff957a"];
                }
                break;
            }
                
            default:
                
                self.lab.textColor = [UIColor redColor];
                break;
        }
    }
}

- (IBAction)btnClick:(UIButton *)sender {
    [[SFCalendarManager shareInstance] updateSelectedItemModel:self.model];
}

- (UIColor *)stringTOColor:(NSString *)str
{
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}

@end
