//
//  TYWaterWaveView.m
//  TYWaveProgressDemo
//
//  Created by tanyang on 15/4/14.
//  Copyright (c) 2015 tanyang. All rights reserved.
//
#import "TYWaterWaveView.h"

@interface TYWaterWaveView ()

@property (nonatomic, strong) CADisplayLink *waveDisplaylink;

@property (nonatomic, strong) CAShapeLayer  *firstWaveLayer;
@property (nonatomic, strong) CAShapeLayer  *secondWaveLayer;

@end

@implementation TYWaterWaveView{

    
    float variable;     //可变参数 更加真实 模拟波纹
    BOOL increase;      // 增减变化
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds  = YES;
        [self setUp];
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds  = YES;
        [self setUp];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _waterWaveHeight = self.frame.size.height/2;
    _waterWaveWidth  = [UIScreen mainScreen].bounds.size.width;
    if (_waterWaveWidth > 0) {
        _waveCycle =  1.29 * M_PI / _waterWaveWidth;
    }
    
    if (_currentWavePointY <= 0) {
        _currentWavePointY = self.frame.size.height;
    }
}

- (void)setUp
{
    _waterWaveHeight = self.frame.size.height/2;
    _waterWaveWidth  = self.frame.size.width;
    _firstWaveColor = [UIColor colorWithRed:223/255.0 green:83/255.0 blue:64/255.0 alpha:1];
    _secondWaveColor = [UIColor colorWithRed:236/255.0f green:90/255.0f blue:66/255.0f alpha:1];
    
    _waveGrowth = 0.85;
    _waveSpeed = 0.4/M_PI;
    
    [self resetProperty];
}

- (void)resetProperty
{
    _currentWavePointY = self.frame.size.height;
    
    variable = 1.6;
    increase = NO;
    
    _offsetX = 0;

}

- (void)setFirstWaveColor:(UIColor *)firstWaveColor
{
    _firstWaveColor = firstWaveColor;
    _firstWaveLayer.fillColor = firstWaveColor.CGColor;
}

- (void)setSecondWaveColor:(UIColor *)secondWaveColor
{
    _secondWaveColor = secondWaveColor;
    _secondWaveLayer.fillColor = secondWaveColor.CGColor;
}

- (void)setPercent:(CGFloat)percent
{
    _percent = percent;
    [self resetProperty];
}

-(void)startWave{
    
    [self resetProperty];
    
    if (_firstWaveLayer == nil) {
        // 创建第一个波浪Layer
        _firstWaveLayer = [CAShapeLayer layer];
        _firstWaveLayer.fillColor = _firstWaveColor.CGColor;
        [self.layer addSublayer:_firstWaveLayer];
    }
    
    if (_secondWaveLayer == nil) {
        // 创建第二个波浪Layer
        _secondWaveLayer = [CAShapeLayer layer];
        _secondWaveLayer.fillColor = _secondWaveColor.CGColor;
        [self.layer addSublayer:_secondWaveLayer];
    }
    
    if (_waveDisplaylink) {
        [self stopWave];
    }
    
    // 启动定时调用
    _waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    [_waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
}

- (void)reset
{
    [self stopWave];
    [self resetProperty];
    
    [_firstWaveLayer removeFromSuperlayer];
    _firstWaveLayer = nil;
    [_secondWaveLayer removeFromSuperlayer];
    _secondWaveLayer = nil;
}

-(void)animateWave
{
    if (increase) {
        variable += 0.01;
    }else{
        variable -= 0.01;
    }
    
    
    if (variable<=1) {
        increase = YES;
    }
    
    if (variable>=1.6) {
        increase = NO;
    }
    
    _waveAmplitude = variable*5;
}

-(void)getCurrentWave:(CADisplayLink *)displayLink{
    
    [self animateWave];
    
    if (_currentWavePointY > 2 * _waterWaveHeight *(1-_percent)) {
        // 波浪高度未到指定高度 继续上涨
        _currentWavePointY -= _waveGrowth;
    }
    
    // 波浪位移
    _offsetX -= _waveSpeed;
    
    [self setCurrentFirstWaveLayerPath];

    [self setCurrentSecondWaveLayerPath];
}

-(void)setCurrentFirstWaveLayerPath{

    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _currentWavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <=  _waterWaveWidth ; x++) {
        // 正弦波浪公式
        y = _waveAmplitude * sin(_waveCycle * x + _offsetX) + _currentWavePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, _waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    _firstWaveLayer.path = path;
    CGPathRelease(path);
}

-(void)setCurrentSecondWaveLayerPath{

    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = _currentWavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <=  _waterWaveWidth ; x++) {
        // 余弦波浪公式
        y = _waveAmplitude * cos(_waveCycle * x + _offsetX) + _currentWavePointY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, _waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    _secondWaveLayer.path = path;
    CGPathRelease(path);
}

-(void) stopWave{
    [_waveDisplaylink invalidate];
    _waveDisplaylink = nil;
}

- (void)dealloc{
    [self reset];
}

@end
