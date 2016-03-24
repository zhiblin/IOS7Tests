//
//  TouchLineView.h
//  AllDemo
//
//  Created by xiaopi on 16/3/22.
//  Copyright © 2016年 loaer. All rights reserved.
//

#import "BaseLineView.h"

@protocol TSLinesViewDataSource;
@protocol TSLinesViewDelegate;

@interface TouchLineView : BaseLineView{
    CAShapeLayer *chartLine;
    UILabel *touchValueLeftLb;
    UILabel *touchxAxisLb;
    
    
}
@property (nonatomic, assign)BOOL showLastValue;

@property (nonatomic, weak) id<TSLinesViewDataSource>dataSource;
@property (nonatomic, weak) id<TSLinesViewDelegate>delegate;

@end
@protocol TSLinesViewDelegate <NSObject>

- (NSString*)linesView:(TouchLineView*)linesView touchLableAtIndex:(NSInteger)index;

@end

@protocol TSLinesViewDataSource <NSObject>
@required
////左轴、右轴lable
//- (NSInteger)numberOfyAxisLBForlinesView:(TSLinesView*)tSLinesView;
//- (NSString*)linesView:(TSLinesView*)linesView leftAxisLbAtIndex:(NSInteger)index;
//- (NSString*)linesView:(TSLinesView*)linesView rightAxisLbAtIndex:(NSInteger)index;
////横轴lable
//- (NSInteger)numberOfxAxisLBForlinesView:(TSLinesView*)tSLinesView;
//- (NSString*)linesView:(TSLinesView*)linesView xAxisLbAtIndex:(NSInteger)index;

//点的总数
- (NSInteger)summationOfkeyPointForlinesView:(TouchLineView*)tSLinesView;
//需要绘制的点的数量
- (NSInteger)numberOfkeyPointToDrawForlinesView:(TouchLineView*)tSLinesView;
//点的纵坐标
- (CGFloat)linesView:(TouchLineView*)linesView yValueAtIndex:(NSInteger)index;

@optional

@end
