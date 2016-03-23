//
//  BaseLineView.h
//  AllDemo
//
//  Created by xiaopi on 16/3/22.
//  Copyright © 2016年 loaer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseLineView : UIView{
    
    BOOL isXDirectrixInCenter;
    
    CAShapeLayer *grid;
    
    float maxValue;
    float minValue;
    float startValue;
    
    NSInteger numberOfSubViews;
    NSInteger summationOfkeyPoint;
    
    NSMutableArray *_xAxisLbArr;
    NSMutableArray *_yAxisLbArr;
    NSMutableArray *yValuesArr;
    
    NSInteger numberOfYAxisLb;
    NSInteger numberOfXAxisLb;
    
    CGFloat LBWIDTH;
    CGFloat LBHEIGHT;
    CGFloat EMPTYHEIGHT;
    CGFloat CHARTWIDTH;
    CGFloat CHARTHEIGHT;
    
    
}



- (instancetype)init;
- (void)initParams;
- (CGFloat)yPositionWithyValue:(NSNumber*)yValue;

- (void)reload;

@property(nonatomic ,copy) NSArray *yAxisLbArr;   //从大到小排序
@property(nonatomic ,copy) NSArray *xAxisLbArr;
@property(nonatomic ,assign) BOOL needToDrawRightAxisLb;

@end
