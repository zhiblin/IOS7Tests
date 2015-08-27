//
//  MTGroupsViewController.h
//  CollectDemo
//
//  Created by mtt0156 on 14-4-1.
//  Copyright (c) 2014年 lin zhibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "GroupTitleCell.h"
#import "UIImage+ImageTool.h"

@protocol  MTPictureViewControllerDelegate;

#define kThumbnailLength    155.0f

@interface MTGroupsViewController : UIViewController

@property(nonatomic, strong) UIButton *rightbutton;
@property(nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITableView *groupsTable;

@property (nonatomic, strong) NSMutableArray *groups;

@property (nonatomic, weak) id <MTPictureViewControllerDelegate> delegate;

//是否从相机界面进入 YES ：是  NO ：不是
@property (assign) BOOL FromCamera;

-(void)loadGroups;

-(NSMutableArray *)loadImageFromSavePhoto;

@end

@protocol MTPictureViewControllerDelegate <NSObject>


@optional

- (void)imagePickerViewController:(MTGroupsViewController *)imagePickerViewController didFinishPickerALAssetWith:(NSDictionary *)photoInfo coverImage:(UIImage *)coverImage;
//保存到相册是否成功的回调
//- (void)didFinishPickingMediaWithInfo:(NSDictionary *)photoinfo pickImage:(UIImage *)coverImage;

@end

