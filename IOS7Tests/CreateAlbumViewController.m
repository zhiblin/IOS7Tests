//
//  CreateAlbumViewController.m
//  AllDemo
//
//  Created by lzb on 15/10/14.
//  Copyright © 2015年 loaer. All rights reserved.
//

#import "CreateAlbumViewController.h"

@import Photos;

@interface CreateAlbumViewController ()

@end

@implementation CreateAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *aBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [aBtn setBackgroundColor:[UIColor lightGrayColor]];
    [aBtn setFrame:CGRectMake(0, 0, 200, 200)];
    [aBtn setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [aBtn setTitle:@"Create" forState:UIControlStateNormal];
    [aBtn addTarget:self action:@selector(createAblum) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:aBtn];
}


-(void)createAblum{
    
    PHFetchResult *fetchResult = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    for (NSInteger i = 0; i < fetchResult.count; i++) {
        // 获取一个相册（PHAssetCollection）
        PHCollection *collection = fetchResult[i];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            if ([assetCollection.localizedTitle isEqualToString:@"Rd"]) {
                
                NSLog(@"localizedTitle %@",assetCollection.localizedTitle);
                return;
            }
            // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
//            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOptions];
//            else {
//                NSAssert(NO, @"Fetch collection not PHCollection: %@", collection);
            }
        }
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"Rd"];
     } completionHandler:^(BOOL success, NSError *error){
    if (!success) {
        NSLog(@"Error creating album: %@", error);
    }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
