//
//  AlbumTableViewCell.m
//  IOS7Tests
//
//  Created by lzb on 15/8/27.
//  Copyright (c) 2015年 loaer. All rights reserved.
//

#import "AlbumTableViewCell.h"

@interface AlbumTableViewCell ()

@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation AlbumTableViewCell

@synthesize posterImageView,titleLabel,countLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initView];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)initView{
    
    posterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 70, 70)];
    
    [self addSubview:posterImageView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 18, 200, 25)];
    
    [self addSubview:titleLabel];
    
    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(86, 53, 200, 15)];
    
    [self addSubview:countLabel];
    
}
-(void)setCellImageView:(UIImage *)posterImage title:(NSString *)titleString count:(NSString *)countString{
    posterImageView.image = posterImage;
    titleLabel.text = titleString;
    countLabel.text = countString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
