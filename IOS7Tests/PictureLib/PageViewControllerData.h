
//
//  PageViewControllerData.h
//  CollectDemo
//
//  Created by mtt0156 on 14-6-3.
//  Copyright (c) 2014年 lin zhibin. All rights reserved.
//
 

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PageViewControllerData : NSObject

+ (PageViewControllerData *)sharedInstance;

@property (nonatomic, strong) NSArray *photoAssets; // array of ALAsset objects


- (NSUInteger)photoCount;
- (UIImage *)photoAtIndex:(NSUInteger)index;
- (NSDictionary *)dictionaryAtIndex:(NSUInteger)index pictureSize:(int)sizeint;



@end