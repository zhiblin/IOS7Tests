//
//  MTCameraImageScrollView.h
//  MTXX
//
//  Created by JoyChiang on 14-3-27.
//  Copyright (c) 2014年 Meitu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTImageScrollView : UIScrollView

@property (nonatomic, strong, readonly) UIImageView *originalImageView;
@property (nonatomic, strong, readonly) UIImageView *processImageView;

@property (nonatomic, strong) UIImage *originalImage;   /**< 原始图片 */
@property (nonatomic, strong) UIImage *processImage;    /**< 已处理的图片 */

@end