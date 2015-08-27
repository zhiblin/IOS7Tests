//
//  PageViewControllerData.h
//  CollectDemo
//
//  Created by mtt0156 on 14-6-3.
//  Copyright (c) 2014年 lin zhibin. All rights reserved.
//

#import "PageViewControllerData.h"
#import "UIImage+ImageTool.h"
//#import <MTImageCore/UIImage+ImageData.h>

@implementation PageViewControllerData


+ (PageViewControllerData *)sharedInstance
{
    static dispatch_once_t onceToken;
    static PageViewControllerData *sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[PageViewControllerData alloc] init];
    });
    return sSharedInstance;
}


- (NSUInteger)photoCount
{
    return self.photoAssets.count;
}

- (UIImage *)photoAtIndex:(NSUInteger)index
{
    ALAsset *photoAsset = self.photoAssets[index];
    
    ALAssetRepresentation *assetRepresentation = [photoAsset defaultRepresentation];
    
    UIImage *fullScreenImage = [UIImage imageWithCGImage:[assetRepresentation fullScreenImage]
                                                   scale:[assetRepresentation scale]
                                             orientation:(UIImageOrientation)ALAssetOrientationUp];
    return fullScreenImage;
}

-(NSDictionary *)dictionaryAtIndex:(NSUInteger)index pictureSize:(int)sizeint
{
    ALAsset *photoAsset = self.photoAssets[index];
    UIImage *fullImage = [UIImage imageWithCGImage:photoAsset.defaultRepresentation.fullResolutionImage scale:photoAsset.defaultRepresentation.scale orientation:(UIImageOrientation)photoAsset.defaultRepresentation.orientation];
   // fullImage = [fullImage imageWithMaxLength:sizeint];
    NSDictionary *photoinfo = [[NSDictionary alloc] initWithObjectsAndKeys:fullImage,UIImagePickerControllerOriginalImage,photoAsset.defaultRepresentation.metadata,@"metadata", nil];
    return photoinfo;
}







@end
