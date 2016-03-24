//
//  KlineView.h
//  AllDemo
//
//  Created by xiaopi on 16/3/22.
//  Copyright © 2016年 loaer. All rights reserved.
//

#import "TouchLineView.h"
#import "KlineItem.h"
@protocol KMapViewDataSource;
@interface KlineView : TouchLineView{
    NSMutableArray *kMapPointArr;
    CGFloat offset;
}

@property (nonatomic, weak) id<KMapViewDataSource>kMapViewDataSource;
@end

@protocol KMapViewDataSource <NSObject>
@required
//点的总数
- (NSInteger)summationOfkPointForKMapView:(KlineView*)kMapView;
//需要绘制的点的数量
- (NSInteger)numberOfkPointToDrawForKMapView:(KlineView*)kMapView;
//需要绘制的点
- (KlineItem *)kMapView:(KlineView*)kMapView kMapPointViewAtIndex:(NSInteger)index;

@optional
- (NSInteger)offsetOfGridForKMapView:(KlineView*)kMapView;
- (NSInteger)numberOfLinesForKMapView:(KlineView*)kMapView;
- (UIColor *)kMapView:(KlineView*)kMapView colorsForLinesAtIndex:(NSInteger)index;
- (NSInteger)kMapView:(KlineView*)kMapView summationOfkPointForlinesAtIndex:(NSInteger)index;
- (NSInteger)kMapView:(KlineView*)kMapView numberOfkPointToDrawForlinesAtIndex:(NSInteger)index;

- (CGFloat )kMapView:(KlineView*)kMapView valueForLinesAtIndexPath:(NSIndexPath *)indexPath;


@end
