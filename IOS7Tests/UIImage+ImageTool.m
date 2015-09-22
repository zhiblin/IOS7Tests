//
//  UIImage+ImageTool.m
//  PictureShow
//
//  Created by lzb on 14-5-27.
//  Copyright (c) 2014年 hard-working. All rights reserved.
//

#import "UIImage+ImageTool.h"

@implementation UIImage (ImageTool)


- (UIImage *)thumbnailWithSize:(CGSize)size{
    
    CGFloat screenScale = [UIScreen mainScreen].scale;
    if (self.scale < screenScale)
    {
        size = CGSizeMake(size.width * screenScale,
                          size.height * screenScale);
    }
    
    return [self imageCroppedToFill:size];

    
}

- (UIImage *)imageCroppedToFill:(CGSize)size
{
    CGFloat factor = MAX(size.width / self.size.width,
                         size.height / self.size.height);
    
    UIGraphicsBeginImageContextWithOptions(size,
                                           YES,                     // Opaque
                                           self.scale);             // Use image scale
    
    CGRect rect = CGRectMake((size.width - nearbyintf(self.size.width * factor)) / 2.0,
                             (size.height - nearbyintf(self.size.height * factor)) / 2.0,
                             nearbyintf(self.size.width * factor),
                             nearbyintf(self.size.height * factor));
    [self drawInRect:rect];
    UIImage * croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
//    NSLog(@"Image %@ %@ cropped to %@ %@", self,NSStringFromCGSize(self.size),croppedImage,NSStringFromCGSize(croppedImage.size));
    
    return croppedImage;
}

@end
