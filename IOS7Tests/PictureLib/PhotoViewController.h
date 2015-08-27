
//
//  PhotoViewController.h
//  CollectDemo
//
//  Created by mtt0156 on 14-6-3.
//  Copyright (c) 2014年 lin zhibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController

@property (nonatomic, strong) NSArray *photos;  // array of ALAsset objects

@property NSUInteger pageIndex;

+ (PhotoViewController *)photoViewControllerForPageIndex:(NSUInteger)pageIndex;

@end
