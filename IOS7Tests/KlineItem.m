//
//  KlineItem.m
//  AllDemo
//
//  Created by xiaopi on 16/3/22.
//  Copyright © 2016年 loaer. All rights reserved.
//

#import "KlineItem.h"

@implementation KlineItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithMaxValue:(CGFloat)aMaxValue MinValue:(CGFloat)aMinValue StartValue:(CGFloat)aStartValue EndValue:(CGFloat)aEndValue{
    if ((self = [super init])) {
        self.backgroundColor = [UIColor clearColor];
        maxValue = aMaxValue;
        minValue = aMinValue;
        startValue = aStartValue;
        endValue = aEndValue;
        slenderLayer = [CAShapeLayer layer];
        slenderLayer.fillColor = [UIColor clearColor].CGColor;
        thickLayer = [CAShapeLayer layer];
        thickLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:slenderLayer];
        [self.layer addSublayer:thickLayer];
    }
    return self;
}

- (CGFloat)getValue{
    return endValue;
}
- (void)setBaseWidth:(CGFloat)width baseHeight:(CGFloat)height{
    if (width<5) {
        width = 5;
    }
    self.frame = CGRectMake(0, 0, width, height*(maxValue - minValue));
    if (startValue>endValue) {//跌
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(width/2, 0)];
        [path addLineToPoint:CGPointMake(width/2, height*(maxValue - minValue))];
        slenderLayer.lineWidth = 1;
        slenderLayer.strokeColor = [UIColor greenColor].CGColor;
        slenderLayer.path = path.CGPath;
        
        //        path = [UIBezierPath bezierPath];
        NSLog(@"%f %f %f",width/2,(maxValue-startValue)*height,(maxValue - endValue)*height);
        path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, (maxValue-startValue)*height, width, ((maxValue - endValue)*height)-((maxValue-startValue)*height)) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(width/2, width/2)];
        //        [path moveToPoint:CGPointMake(width/2, (maxValue-startValue)*height)];
        //        [path addLineToPoint:CGPointMake(width/2, (maxValue - endValue)*height)];
        thickLayer.lineWidth = width;
        thickLayer.fillColor = [UIColor greenColor].CGColor;
        thickLayer.path = path.CGPath;
    }
    else{   //涨
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(width/2, 0)];
        [path addLineToPoint:CGPointMake(width/2, (maxValue-endValue)*height)];
        [path moveToPoint:CGPointMake(width/2, (maxValue - startValue)*height)];
        [path addLineToPoint:CGPointMake(width/2, height*(maxValue - minValue))];
        slenderLayer.lineWidth = 1;
        slenderLayer.strokeColor = [UIColor redColor].CGColor;
        slenderLayer.path = path.CGPath;
        
        CGRect rect = CGRectMake(1, (maxValue-endValue)*height, width-2, (endValue-startValue)*height);
        path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(width/2, width/2)];//[UIBezierPath bezierPathWithRect:rect];
        thickLayer.lineWidth = 1;
        thickLayer.fillColor = [UIColor redColor].CGColor;
        thickLayer.path = path.CGPath;
        
    }
    CGFloat offset = (maxValue - endValue)/(maxValue - minValue);
    self.layer.anchorPoint = CGPointMake(0.5, offset);
    
}
- (BOOL)isIncrease{
    return startValue<endValue;
}

@end
