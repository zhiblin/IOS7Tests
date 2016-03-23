//
//  TouchLineView.m
//  AllDemo
//
//  Created by xiaopi on 16/3/22.
//  Copyright © 2016年 loaer. All rights reserved.
//

#import "TouchLineView.h"

@implementation TouchLineView
- (instancetype)init{
    if ((self = [super init])) {
        self.layer.masksToBounds = YES;
        chartLine = [CAShapeLayer layer];
        [self.layer addSublayer:chartLine];
        chartLine.fillColor = [UIColor clearColor].CGColor;
        chartLine.strokeColor = [UIColor colorWithRed:66/255.0f green:88/255.0f blue:145/255.0f alpha:1].CGColor;
        chartLine.lineWidth = 1;
        
        lastValueLeftLb = [[UILabel alloc] initWithFrame:CGRectZero];
        lastValueLeftLb.textAlignment = 1;
        lastValueLeftLb.textColor = [UIColor orangeColor];
        lastValueLeftLb.backgroundColor = [UIColor greenColor];
        lastValueLeftLb.font = [UIFont systemFontOfSize:12.0f];
//        [self addSubview:lastValueLeftLb];
        lastValueRightLb = [[UILabel alloc] initWithFrame:CGRectZero];
        lastValueRightLb.textAlignment = 1;
        lastValueRightLb.textColor = [UIColor orangeColor];
        lastValueRightLb.backgroundColor = [UIColor greenColor];
        lastValueRightLb.font = [UIFont systemFontOfSize:12.0f];
//        [self addSubview:lastValueRightLb];
        
        
        lastValueLine = [CAShapeLayer layer];
        lastValueLine.lineWidth = 1;
        lastValueLine.fillColor = [UIColor clearColor].CGColor;
        lastValueLine.strokeColor = [UIColor greenColor].CGColor;
//        [self.layer addSublayer:lastValueLine];
        
        touchValueLeftLb = [[UILabel alloc] initWithFrame:CGRectZero];
        touchValueLeftLb.textColor = [UIColor orangeColor];
        touchValueLeftLb.textAlignment = 1;
        touchValueLeftLb.backgroundColor = self.backgroundColor;
        touchValueLeftLb.font = [UIFont systemFontOfSize:12.0f];
//        touchValueLeftLb.layer.cornerRadius = 10;
//        touchValueLeftLb.layer.borderColor = [UIColor colorWithRed:66/255.0f green:88/255.0f blue:145/255.0f alpha:1].CGColor;
//        touchValueLeftLb.layer.borderWidth = .5f;
//        touchValueLeftLb.layer.masksToBounds = YES;
        touchValueLeftLb.hidden = YES;
        [self addSubview:touchValueLeftLb];
        
        touchValueRightLb = [[UILabel alloc] initWithFrame:CGRectZero];
        touchValueRightLb.textColor = [UIColor orangeColor];
        touchValueRightLb.textAlignment = 1;
        touchValueRightLb.backgroundColor = self.backgroundColor;
        touchValueRightLb.font = [UIFont systemFontOfSize:12.0f];
        touchValueRightLb.layer.cornerRadius = 10;
        touchValueRightLb.layer.borderColor = [UIColor colorWithRed:66/255.0f green:88/255.0f blue:145/255.0f alpha:1].CGColor;
        touchValueRightLb.layer.borderWidth = .5f;
        touchValueRightLb.layer.masksToBounds = YES;
        touchValueRightLb.hidden = YES;
//        [self addSubview:touchValueRightLb];
        
        
        touchxAxisLb = [[UILabel alloc] initWithFrame:CGRectZero];
        touchxAxisLb.textColor = [UIColor orangeColor];
        touchxAxisLb.textAlignment = 1;
        touchxAxisLb.backgroundColor = self.backgroundColor;
        touchxAxisLb.font = [UIFont systemFontOfSize:12.0f];
        
        touchxAxisLb.hidden = YES;
        [self addSubview:touchxAxisLb];
        
        
        
    }
    return self;
}
- (void)initParams{
    [super initParams];
    EMPTYHEIGHT = CHARTHEIGHT/9;
}

- (void)layoutLb{
    CGFloat baseWidth = (CHARTWIDTH - _xAxisLbArr.count +1) /(_xAxisLbArr.count - 1);
    for(int i = 0;i< _xAxisLbArr.count; i++){
        UILabel *lable = _xAxisLbArr[i];
        lable.frame = CGRectMake(LBWIDTH + i*baseWidth - baseWidth/2, self.frame.size.height - LBHEIGHT ,baseWidth,LBHEIGHT);
    }
    CGFloat baseHeight = (CHARTHEIGHT-EMPTYHEIGHT*2)/(numberOfYAxisLb -1);
    for(int i = 0;i< numberOfYAxisLb; i++){
        UILabel *lable = _yAxisLbArr[i];
        lable.frame = CGRectMake(0, EMPTYHEIGHT + i*baseHeight - LBHEIGHT/2,LBWIDTH -5 ,LBHEIGHT);
    }
    
    
}

- (void)initGrid{
    CGFloat baseWidth = (CHARTWIDTH - _xAxisLbArr.count +1)/(_xAxisLbArr.count - 1);
    CGFloat baseHeight = (CHARTHEIGHT-EMPTYHEIGHT*2)/(numberOfYAxisLb -1);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (int i = 0; i<numberOfXAxisLb; i ++) {
        [path moveToPoint:CGPointMake(LBWIDTH + i*baseWidth +1, self.frame.size.height - LBHEIGHT)];
        [path addLineToPoint:CGPointMake(LBWIDTH + i*baseWidth +1, 0)];
    }
    for (int i = 0; i<numberOfYAxisLb; i ++) {
        [path moveToPoint:CGPointMake(LBWIDTH , EMPTYHEIGHT + i*baseHeight)];
        [path addLineToPoint:CGPointMake(CHARTWIDTH + LBWIDTH , EMPTYHEIGHT + i*baseHeight)];
    }
    grid.path = path.CGPath;
    
}
- (void)reload{
    if (self.dataSource == nil) {
        return;
    }
    summationOfkeyPoint = [self.dataSource summationOfkeyPointForlinesView:self];
    NSInteger numberOfPoints = [self.dataSource numberOfkeyPointToDrawForlinesView:self];
    yValuesArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<numberOfPoints; i++) {
        [yValuesArr addObject:[NSNumber numberWithFloat:[self.dataSource linesView:self yValueAtIndex:i]]];
    }
    
    chartLine.path = nil;
    lastValueLine.path = nil;
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat baseDrawWidth = (CHARTWIDTH - _xAxisLbArr.count +1)/(summationOfkeyPoint-1);
    isXDirectrixInCenter = NO;
    if (yValuesArr.count == 0) {
        return;
    }
    [path moveToPoint:CGPointMake(LBWIDTH, [self yPositionWithyValue:yValuesArr[0]])];
    
    int i = 1;
    for (; i < yValuesArr.count ; i ++) {
        [path addLineToPoint:CGPointMake(LBWIDTH + i*baseDrawWidth, [self yPositionWithyValue:yValuesArr[i]])];
    }
    i --;
    chartLine.path = path.CGPath;
    chartLine.shadowColor = [UIColor colorWithRed:66/255.0f green:88/255.0f blue:145/255.0f alpha:1].CGColor;
    chartLine.shadowOpacity = 0.5;
    chartLine.shadowOffset =CGSizeMake(0, 0);
    [path addLineToPoint:CGPointMake(LBWIDTH + i*baseDrawWidth, CHARTHEIGHT)];
    [path addLineToPoint:CGPointMake(LBWIDTH, CHARTHEIGHT)];
    [path closePath];
    chartLine.shadowPath = path.CGPath;
    
    if (self.showLastValue) {
        [path removeAllPoints];
        [path moveToPoint:CGPointMake(LBWIDTH, [self yPositionWithyValue:yValuesArr[i]])];
        [path addLineToPoint:CGPointMake(LBWIDTH + CHARTWIDTH, [self yPositionWithyValue:yValuesArr[i]])];
        lastValueLine.path = path.CGPath;
        lastValueLeftLb.text = [NSString stringWithFormat:@"%.2f",[yValuesArr[i] floatValue]];
        
        lastValueLeftLb.frame = CGRectMake(0, [self yPositionWithyValue:yValuesArr[i]] - 10, LBWIDTH , 20);
        [self bringSubviewToFront:lastValueLeftLb];
        if (self.needToDrawRightAxisLb) {
            lastValueRightLb.hidden = NO;
            [self bringSubviewToFront:lastValueRightLb];
            lastValueRightLb.text = [NSString stringWithFormat:@"%.2f%%",([yValuesArr[i] floatValue] - startValue)/startValue];
            lastValueRightLb.frame = CGRectMake(LBWIDTH + CHARTWIDTH, [self yPositionWithyValue:yValuesArr[i]] - 10, LBWIDTH, 20);
        }
        else{
            lastValueRightLb.hidden = YES;
        }
        if ([yValuesArr[i] floatValue] > startValue) {
            lastValueLeftLb.backgroundColor = [UIColor redColor];
            lastValueRightLb.backgroundColor = [UIColor redColor];
            lastValueLine.strokeColor = [UIColor redColor].CGColor;
        }
        else{
            lastValueLeftLb.backgroundColor = [UIColor greenColor];
            lastValueRightLb.backgroundColor = [UIColor greenColor];
            lastValueLine.strokeColor = [UIColor greenColor].CGColor;
        }
    }
    else{
        lastValueLeftLb.hidden = YES;
        lastValueRightLb.hidden = YES;
    }
}
- (CGFloat)yPositionWithyValue:(NSNumber*)yValue{
    CGFloat y = [yValue floatValue];
    CGFloat baseHeight = (CHARTHEIGHT- EMPTYHEIGHT*2)/(maxValue - minValue);
    return CHARTHEIGHT - EMPTYHEIGHT -(y - minValue)*baseHeight;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGFloat baseDrawWidth = (CHARTWIDTH - _xAxisLbArr.count +1)/(summationOfkeyPoint-1);
    if (isXDirectrixInCenter) {
        baseDrawWidth = (CHARTWIDTH - _xAxisLbArr.count +1)/summationOfkeyPoint;
    }
    UITouch *touch = touches.anyObject;
    CGPoint touchPoint = [touch locationInView:self];
    NSInteger i = (touchPoint.x - LBWIDTH)/baseDrawWidth;
    if (i>yValuesArr.count -1||i<0||yValuesArr.count == 0) {
        return;
    }
    CGFloat touchValue = [yValuesArr[i] floatValue];
    if (isXDirectrixInCenter) {
    }
    
    
    touchValueLeftLb.text = [NSString stringWithFormat:@"%.2f",touchValue];
    touchValueLeftLb.frame = CGRectMake(0, [self yPositionWithyValue:yValuesArr[i]] - 10, LBWIDTH, 20);
    if (self.needToDrawRightAxisLb) {
        touchValueRightLb.text = [NSString stringWithFormat:@"%.2f%%",touchValue*100/startValue - 100];
        touchValueRightLb.frame = CGRectMake(self.frame.size.width - LBWIDTH, [self yPositionWithyValue:yValuesArr[i]] - 10, LBWIDTH, 20) ;
        touchValueRightLb.hidden = NO;
    }
    else{
        touchValueRightLb.hidden = YES;
    }
    
    
    if ([_delegate respondsToSelector:@selector(linesView:touchLableAtIndex:)]) {
        touchxAxisLb.text = [_delegate linesView:self touchLableAtIndex:i];
        touchxAxisLb.frame = CGRectMake(LBWIDTH + i*baseDrawWidth - LBWIDTH/2, self.frame.size.height - LBHEIGHT, LBWIDTH, LBHEIGHT);
        touchxAxisLb.hidden = NO;
    }
    else{
        touchxAxisLb.hidden = YES;
    }
    touchValueLeftLb.hidden = NO;
    
    [self bringSubviewToFront:touchxAxisLb];
    [self bringSubviewToFront:touchValueLeftLb];
    [self bringSubviewToFront:touchValueRightLb];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGFloat baseDrawWidth = (CHARTWIDTH - _xAxisLbArr.count +1)/(summationOfkeyPoint-1);
    if (isXDirectrixInCenter) {
        baseDrawWidth = (CHARTWIDTH - _xAxisLbArr.count +1)/summationOfkeyPoint;
    }
    UITouch *touch = touches.anyObject;
    CGPoint touchPoint = [touch locationInView:self];
    NSInteger i = (touchPoint.x - LBWIDTH)/baseDrawWidth;
    if (i>yValuesArr.count -1||i<0||yValuesArr.count == 0) {
        return;
    }
    CGFloat touchValue = [yValuesArr[i] floatValue];
    if (isXDirectrixInCenter) {
    }
    
    touchValueLeftLb.text = [NSString stringWithFormat:@"%.2f",touchValue];
    touchValueLeftLb.frame = CGRectMake(-10, [self yPositionWithyValue:yValuesArr[i]] - 10, LBWIDTH+10, 20);
    if (self.needToDrawRightAxisLb) {
        touchValueRightLb.text = [NSString stringWithFormat:@"%.2f%%",touchValue*100/startValue - 100];
        touchValueRightLb.frame = CGRectMake(self.frame.size.width - LBWIDTH, [self yPositionWithyValue:yValuesArr[i]] - 10, LBWIDTH+10, 20) ;
        touchValueRightLb.hidden = NO;
    }
    else{
        touchValueRightLb.hidden = YES;
    }
    
    
    if ([_delegate respondsToSelector:@selector(linesView:touchLableAtIndex:)]) {
        touchxAxisLb.text = [_delegate linesView:self touchLableAtIndex:i];
        touchxAxisLb.frame = CGRectMake(LBWIDTH + i*baseDrawWidth - LBWIDTH/2, self.frame.size.height - LBHEIGHT, LBWIDTH, LBHEIGHT);
        touchxAxisLb.hidden = NO;
    }
    else{
        touchxAxisLb.hidden = YES;
    }
    touchValueLeftLb.hidden = NO;
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    touchValueLeftLb.hidden = YES;
    touchValueRightLb.hidden = YES;
    touchxAxisLb.hidden = YES;
}

@end
