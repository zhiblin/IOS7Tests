

//
//  ImageScrollView.h
//  PictureShow
//
//  Created by lzb on 14-5-30.
//  Copyright (c) 2014年 Xiamen CommSource Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScrollView : UIScrollView

@property (nonatomic) NSUInteger index;

+ (NSUInteger)imageCount;

@end
