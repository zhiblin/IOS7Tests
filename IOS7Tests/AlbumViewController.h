//
//  AlbumViewController.h
//  IOS7Tests
//
//  Created by lzb on 15/8/27.
//  Copyright (c) 2015年 loaer. All rights reserved.
//

#import <UIKit/UIKit.h>

@import AssetsLibrary;

@interface AlbumViewController : UIViewController

@property (nonatomic, strong) UICollectionView *assetsCollectionView;

-(id)initWithGroup:(ALAssetsGroup *)group;


@end
