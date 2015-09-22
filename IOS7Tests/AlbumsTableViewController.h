//
//  AlbumsTableViewController.h
//  IOS7Tests
//
//  Created by lzb on 15/8/27.
//  Copyright (c) 2015年 loaer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedImage)(UIImage *currentImage);

@interface AlbumsTableViewController : UIViewController

@property (nonatomic, strong) UITableView *groupsTable;
@property (nonatomic, strong) SelectedImage selectImage;

- (id)initWithToCameraRoll:(BOOL)isto;

@end
