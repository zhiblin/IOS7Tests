//
//  BaseLineView.m
//  AllDemo
//
//  Created by xiaopi on 16/3/22.
//  Copyright © 2016年 loaer. All rights reserved.
//

#import "BaseLineView.h"

@implementation BaseLineView
@synthesize needToDrawRightAxisLb;


- (id)init{
    if ((self = [super init])) {
        //       绘制虚线
        grid = [CAShapeLayer layer];
        grid.lineWidth = 1;
        grid.strokeColor = [UIColor colorWithRed:242.0/255. green:242.0/255. blue:242.0/255. alpha:1].CGColor;
        grid.fillColor = [UIColor clearColor].CGColor;
        grid.lineDashPattern = @[@5,@3];
        [self.layer addSublayer:grid];

        _xAxisLbArr = [[NSMutableArray alloc] init];
        _yAxisLbArr = [[NSMutableArray alloc] init];
        
        self.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1];
       
    }
    return self;
}
- (void)layoutSubviews{
    //增减subView不重绘边框
    if (numberOfSubViews != self.subviews.count) {
        numberOfSubViews = self.subviews.count;
    }
    else{
        [self initParams];
        [self initGrid];
        [self layoutLb];
        [self reload];
        
    }
}
- (void)initParams{
    LBWIDTH = self.frame.size.width/10 ;
    LBHEIGHT = 20;
    if (self.needToDrawRightAxisLb) {
        CHARTWIDTH = self.frame.size.width - LBWIDTH*2;
    }
    else{
        CHARTWIDTH = self.frame.size.width - LBWIDTH*1.5;
    }
    
    CHARTHEIGHT = self.frame.size.height - LBHEIGHT;
    
    
}

- (void)initGrid{
    
}
- (void)reload{
    
}
- (void)layoutLb{
    
}

- (void)setYAxisLbArr:(NSArray *)yAxisLbArr{
    if (numberOfYAxisLb != yAxisLbArr.count) {
        
        numberOfYAxisLb = yAxisLbArr.count;
    }
    
    for(UILabel *lable in _yAxisLbArr){
        [lable removeFromSuperview];
    }
    [_yAxisLbArr removeAllObjects];
    
//    Y轴绘制
    for(int i = 0; i< yAxisLbArr.count;i++){
        NSString *str = yAxisLbArr[i];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectZero];
        lable.text = str;
        lable.textColor = [UIColor greenColor];
        lable.textAlignment = 2;
        lable.font = [UIFont systemFontOfSize:12];
        [self addSubview:lable];
        [_yAxisLbArr addObject:lable];
        if (yAxisLbArr.count == i*2+1) {
            startValue = [str floatValue];
            lable.textColor = [UIColor whiteColor];
        }
    }

    maxValue = [[yAxisLbArr firstObject] floatValue];
    minValue = [[yAxisLbArr lastObject] floatValue];
}
- (void)setXAxisLbArr:(NSArray *)xAxisLbArr{
    if(numberOfXAxisLb != xAxisLbArr.count){
        numberOfXAxisLb = xAxisLbArr.count;
    }
    for(UILabel *lable in _xAxisLbArr){
        [lable removeFromSuperview];
    }
    [_xAxisLbArr removeAllObjects];
    
    for(int i = 0;i < xAxisLbArr.count ; i++){
        NSString *str = xAxisLbArr[i];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectZero];
        lable.text = str;
        lable.textColor = [UIColor orangeColor];
        lable.backgroundColor = [UIColor redColor];
        lable.textAlignment = 1;
        lable.font = [UIFont systemFontOfSize:12];
//        [self addSubview:lable];
        [_xAxisLbArr addObject:lable];
    }
}

- (void)setNeedToDrawRightAxisLb:(BOOL)newValue{
    needToDrawRightAxisLb = newValue;
    [self layoutIfNeeded];
}

- (CGFloat)yPositionWithyValue:(NSNumber*)yValue{
    
    return 0;
}

@end
