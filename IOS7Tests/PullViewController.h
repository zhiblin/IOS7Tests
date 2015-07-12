//
//  PullViewController.h
//  IOS7Tests
//
//  Created by lzb on 15/7/1.
//  Copyright (c) 2015年 loaer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, retain) UIImageView *imgProfile;
@property (nonatomic, retain) UIImageView *cameraBottomImage;
@property (nonatomic, retain) UIImageView *cameraMiddleImage;
@property (nonatomic, retain) UIImageView *cameraTopLeftImage;
@property (nonatomic, retain) UIImageView *cameraTopRightImage;
@property (nonatomic, retain) UIScrollView *scrollView;

@end
