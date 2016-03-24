//
//  KlineView.m
//  AllDemo
//
//  Created by xiaopi on 16/3/22.
//  Copyright © 2016年 loaer. All rights reserved.
//

#import "KlineView.h"

@implementation KlineView



- (instancetype)init{
    if ((self = [super init])) {
        kMapPointArr = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void) initParams{
    [super initParams];
    EMPTYHEIGHT = CHARTHEIGHT/(2*numberOfYAxisLb +2);
}
- (void)layoutLb{
    
    CGFloat baseWidth = CHARTWIDTH /(_xAxisLbArr.count - 1);
    
    if (self.kMapViewDataSource != nil) {
        if ([self.kMapViewDataSource respondsToSelector:@selector(offsetOfGridForKMapView:)]) {
            
            CGFloat baseDrawWidth = (CHARTWIDTH - _xAxisLbArr.count +1)/ [self.kMapViewDataSource summationOfkPointForKMapView:self];
            
            offset = baseDrawWidth/2 + baseDrawWidth*[self.kMapViewDataSource offsetOfGridForKMapView:self];
            if (offset != baseDrawWidth/2) {
                baseWidth = (CHARTWIDTH - _xAxisLbArr.count +1 )/numberOfXAxisLb;
            }
        }
    }
    
    for(int i = 0;i< _xAxisLbArr.count; i++){
        UILabel *lable = _xAxisLbArr[i];
        lable.frame = CGRectMake(offset + LBWIDTH + i*baseWidth - baseWidth/2, self.frame.size.height - LBHEIGHT ,baseWidth,LBHEIGHT);
    }
    
    CGFloat baseHeight = (CHARTHEIGHT-EMPTYHEIGHT*2)/(numberOfYAxisLb -1);
    for(int i = 0;i< numberOfYAxisLb; i++){
        UILabel *lable = _yAxisLbArr[i];
        lable.textColor = [UIColor orangeColor];
        lable.frame = CGRectMake(0, EMPTYHEIGHT + i*baseHeight - LBHEIGHT/2,LBWIDTH -5 ,LBHEIGHT);
    }
    
    
}

- (void)initGrid{
    offset = 0.0f;
    CGFloat baseHeight = (CHARTHEIGHT-EMPTYHEIGHT*2)/(numberOfYAxisLb -1);

    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for (int i = 0; i<numberOfYAxisLb; i ++) {
        [path moveToPoint:CGPointMake(LBWIDTH , EMPTYHEIGHT + i*baseHeight)];
        [path addLineToPoint:CGPointMake(CHARTWIDTH + LBWIDTH , EMPTYHEIGHT + i*baseHeight)];
    }
    grid.path = path.CGPath;
    
}
- (void)reload{
    for(KlineItem *kMapPointView in kMapPointArr){
        [kMapPointView removeFromSuperview];
    }
    [kMapPointArr removeAllObjects];
    
    if (self.kMapViewDataSource == nil) {
        return;
    }
    
    yValuesArr = [[NSMutableArray alloc] init];
    summationOfkeyPoint = [self.kMapViewDataSource summationOfkPointForKMapView:self];
    CGFloat baseWidth = (CHARTWIDTH - _xAxisLbArr.count +1)/summationOfkeyPoint;
    isXDirectrixInCenter = YES;
    CGFloat baseHeight = (CHARTHEIGHT- EMPTYHEIGHT*2)/(maxValue - minValue);
    for (int i = 0; i<[self.kMapViewDataSource numberOfkPointToDrawForKMapView:self]; i++) {
        KlineItem *kMapPointView = [self.kMapViewDataSource kMapView:self kMapPointViewAtIndex:i];
        [kMapPointArr addObject:kMapPointView];
        [self addSubview:kMapPointView];
        [kMapPointView setBaseWidth:baseWidth/2 baseHeight:baseHeight];
        kMapPointView.center = CGPointMake(LBWIDTH + i*baseWidth + baseWidth/2, [self yPositionWithyValue:[NSNumber numberWithFloat:kMapPointView.getValue]]);
        [yValuesArr addObject:[NSNumber numberWithFloat:kMapPointView.getValue]];
    }
    
}

@end
