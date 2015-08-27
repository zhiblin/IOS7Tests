//
//  MyPageViewController.h
//  CollectDemo
//
//  Created by mtt0156 on 14-6-3.
//  Copyright (c) 2014年 lin zhibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPageViewController : UIPageViewController <UIPageViewControllerDataSource>

@property NSInteger startingIndex;

@property (nonatomic, strong) NSMutableArray *images;

@property(nonatomic, strong) UIButton *leftbutton;

@property(nonatomic, strong) UIButton *rightbutton;

@property(nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *customNavView;

@property (nonatomic,copy) NSString *backtitlestr;

@end
