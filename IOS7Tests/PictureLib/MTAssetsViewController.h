//
//  MTAssetsViewController.h
//  CollectDemo
//
//  Created by mtt0156 on 14-4-2.
//  Copyright (c) 2014年 lin zhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MTAssetsViewController : UIViewController<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) UICollectionView *groupCollection;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, copy) NSString *titlestr;

//是否需要返回上个视图 YES ：是  NO ：不是
@property (assign) BOOL BackBool;

-(NSMutableArray *)loadImageFromSavePhoto;

@end
