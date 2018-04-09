//
//  TYWaterWaveView.h
//  TYWaveProgressDemo
//
//  Created by tanyang on 15/4/14.
//  Copyright (c) 2015 tanyang. All rights reserved.
//  核心波浪view

#import <UIKit/UIKit.h>

@interface TYWaterWaveView : UIView
@property (nonatomic, assign)CGFloat waveAmplitude;  // 波纹振幅
@property (nonatomic, assign)CGFloat waveCycle;      // 波纹周期
@property (nonatomic, assign)CGFloat waveSpeed;      // 波纹速度
@property (nonatomic, assign)CGFloat waveGrowth;     // 波纹上升速度

@property (nonatomic, assign)CGFloat waterWaveHeight;
@property (nonatomic, assign)CGFloat waterWaveWidth;
@property (nonatomic, assign)CGFloat offsetX;           // 波浪x位移
@property (nonatomic, assign)CGFloat currentWavePointY; // 当前波浪上市高度Y（高度从大到小 坐标系向下增长）

@property (nonatomic, strong)   UIColor *firstWaveColor;    // 第一个波浪颜色
@property (nonatomic, strong)   UIColor *secondWaveColor;   // 第二个波浪颜色

@property (nonatomic, assign)   CGFloat percent;            // 百分比

-(void) startWave;
-(void) stopWave;
-(void) reset;

@end
