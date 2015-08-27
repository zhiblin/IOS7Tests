//
//  MTPictureCell.h
//  Pomelo
//
//  Created by mtt0156 on 14-4-15.
//  Copyright (c) 2014年 Xiamen CommSource Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MTPictureCell : UITableViewCell

@property (nonatomic, strong) UIImageView *titleImage;
@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UILabel *titleLabel;


-(void)setUpCell:(ALAssetsGroup *)group index:(NSIndexPath *)index;
-(void)setUpCell:(NSString *)titleSTR titieImage:(UIImage *)tImage index:(NSIndexPath *)index;

@end
