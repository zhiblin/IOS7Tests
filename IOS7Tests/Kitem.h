//
//  Kitem.h
//  AllDemo
//
//  Created by xiaopi on 16/3/23.
//  Copyright © 2016年 loaer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Kitem : NSObject


@property (nonatomic, assign) CGFloat maxValue;//最高价
@property (nonatomic, assign) CGFloat minValue;//最低价
@property (nonatomic, assign) CGFloat startValue;//开盘价
@property (nonatomic, assign) CGFloat endValue;//收盘价

@end
