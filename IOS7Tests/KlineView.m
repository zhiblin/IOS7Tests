//
//  KlineView.m
//  AllDemo
//
//  Created by xiaopi on 16/3/22.
//  Copyright © 2016年 loaer. All rights reserved.
//

#import "KlineView.h"

@implementation KlineView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)init{
    if ((self = [super init])) {
        linesArr = [[NSMutableArray alloc] init];
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
        lable.textColor = [UIColor blueColor];
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
    CGFloat baseWidth = (CHARTWIDTH - _xAxisLbArr.count +1)/(_xAxisLbArr.count - 1);
    CGFloat baseHeight = (CHARTHEIGHT-EMPTYHEIGHT*2)/(numberOfYAxisLb -1);
//    if (self.kMapViewDataSource != nil) {
//        if ([self.kMapViewDataSource respondsToSelector:@selector(offsetOfGridForKMapView:)]) {
//            
//            CGFloat baseDrawWidth = (CHARTWIDTH - _xAxisLbArr.count +1)/ [self.kMapViewDataSource summationOfkPointForKMapView:self];
//            
//            offset = baseDrawWidth/2 + baseDrawWidth*[self.kMapViewDataSource offsetOfGridForKMapView:self];
//            if (offset != baseDrawWidth/2) {
//                baseWidth = (CHARTWIDTH - _xAxisLbArr.count +1 )/numberOfXAxisLb;
//            }
//        }
//    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //    for (int i = 0; i<numberOfXAxisLb; i ++) {
    //        [path moveToPoint:CGPointMake(offset + LBWIDTH + i*baseWidth +1, 0)];
    //        [path addLineToPoint:CGPointMake(offset + LBWIDTH + i*baseWidth +1, CHARTHEIGHT)];
    //    }
    
    for (int i = 0; i<numberOfYAxisLb; i ++) {
        [path moveToPoint:CGPointMake(LBWIDTH , EMPTYHEIGHT + i*baseHeight)];
        [path addLineToPoint:CGPointMake(CHARTWIDTH + LBWIDTH , EMPTYHEIGHT + i*baseHeight)];
    }
    grid.path = path.CGPath;
    
}
- (void)reload{
    for(CAShapeLayer *layer in linesArr){
        [layer removeFromSuperlayer];
    }
    [linesArr removeAllObjects];
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
    /*
     if (self.showLastValue) {
     if(yValuesArr.count>0){
     NSInteger i = yValuesArr.count -1;
     UIBezierPath *path = [UIBezierPath bezierPath];
     [path moveToPoint:CGPointMake(LBWIDTH, [self yPositionWithyValue:yValuesArr[i]])];
     [path addLineToPoint:CGPointMake(LBWIDTH + CHARTWIDTH, [self yPositionWithyValue:yValuesArr[i]])];
     lastValueLine.path = path.CGPath;
     lastValueLeftLb.text = [NSString stringWithFormat:@"%.2f",[yValuesArr[i] floatValue]];
     lastValueLeftLb.hidden = NO;
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
     KMapPointView *view = kMapPointArr[i];
     if ([view isIncrease]) {
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
     
     
     if ([self.kMapViewDataSource respondsToSelector:@selector(numberOfLinesForKMapView:)]) {
     
     for (int i = 0; i< [self.kMapViewDataSource numberOfLinesForKMapView:self]; i++) {
     CAShapeLayer *layer = [CAShapeLayer layer];
     layer.fillColor = [UIColor clearColor].CGColor;
     layer.lineWidth = 1;
     layer.strokeColor = [self.kMapViewDataSource kMapView:self colorsForLinesAtIndex:i].CGColor;
     
     [self.layer addSublayer:layer];
     [linesArr addObject:layer];
     UIBezierPath *path = [UIBezierPath bezierPath];
     CGFloat summation  = [self.kMapViewDataSource kMapView:self summationOfkPointForlinesAtIndex:i];
     CGFloat baseDrawWidth = (CHARTWIDTH - _xAxisLbArr.count +1)/(summation );
     NSInteger numberOfPointNeedsToDraw = [self.kMapViewDataSource kMapView:self numberOfkPointToDrawForlinesAtIndex:i];
     int j = 0;
     NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
     if (numberOfPointNeedsToDraw>0) {
     [path moveToPoint:CGPointMake(j*baseDrawWidth + LBWIDTH + baseDrawWidth/2, [self yPositionWithyValue:[NSNumber numberWithFloat:[self.kMapViewDataSource kMapView:self valueForLinesAtIndexPath:indexPath]]])];
     for ( j = 1; j< numberOfPointNeedsToDraw ; j++) {
     indexPath = [NSIndexPath indexPathForRow:j inSection:i];
     [path addLineToPoint:CGPointMake(j*baseDrawWidth + LBWIDTH+ baseDrawWidth/2, [self yPositionWithyValue:[NSNumber numberWithFloat:[self.kMapViewDataSource kMapView:self valueForLinesAtIndexPath:indexPath]]])];
     
     }
     }
     
     layer.path = path.CGPath;
     }
     }
     
     */
    
}

@end
