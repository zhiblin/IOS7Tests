//
//  MTPictureViewController.h
//  CollectDemo
//
//  Created by mtt0156 on 14-3-25.
//  Copyright (c) 2014年 lin zhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define kThumbnailLength    78.0f

@protocol  MTPictureViewControllerDelegate;


@interface MTPictureViewController : UIViewController<UIScrollViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

{
    UIScrollView *_scrollView;
    
    UIImageView *_prevPageView;
    UIImageView *_currentPageView;
    UIImageView *_nextPageView;
    
    NSInteger _currentPageIndex;
    
    NSMutableArray *_photoPages;
    
    NSTimer *_delayTimer;
    
    NSInteger viewStatus;
    
}


@property (nonatomic, strong) UICollectionView *grouppersons;

@property (nonatomic, weak) id <MTPictureViewControllerDelegate> delegate;

@property (assign) NSInteger _currentPageIndex;

@property (nonatomic, strong) NSMutableArray *_photoPages;

//是否从相机界面进入 YES ：是  NO ：不是
@property (assign) BOOL FromCamera;
//是否从编辑中心按钮进入 YES ：是  NO ：不是
@property (assign) BOOL FromBeautyCenter;
//是否相册权限 YES ：有权限  NO ：没权限
@property (assign) BOOL NoPermission;

@end

@protocol MTPictureViewControllerDelegate <NSObject>


@optional

- (void)imagePickerViewController:(MTPictureViewController *)imagePickerViewController didFinishPickerALAssetWith:(NSDictionary *)photoInfo coverImage:(UIImage *)coverImage;
//保存到相册是否成功的回调
//- (void)didFinishPickingMediaWithInfo:(NSDictionary *)photoinfo pickImage:(UIImage *)coverImage;

@end


