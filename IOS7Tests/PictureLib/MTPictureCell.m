//
//  MTPictureCell.m
//  Pomelo
//
//  Created by mtt0156 on 14-4-15.
//  Copyright (c) 2014年 Xiamen CommSource Technology Co., Ltd. All rights reserved.
//

#import "MTPictureCell.h"




@implementation MTPictureCell

@synthesize titleImage,titleLabel,logoImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        titleImage  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 123+32)];
        titleImage.contentMode = UIViewContentModeScaleAspectFill;
        titleImage.clipsToBounds = YES;
        [self.contentView addSubview:titleImage];
        
        UIImageView* titleBackgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 91+32, 320, 32)];
//        titleBackground.backgroundColor = [UIColor blackColor];
        titleBackgroundImage.alpha = .7;
        
        titleBackgroundImage.image = [self rectImageWithColor:[UIColor blackColor] size:CGSizeMake(320, 32)];
        
        [self.contentView addSubview:titleBackgroundImage];
        
        logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(7, 96+32, 22, 22)];
        
        [self.contentView addSubview:logoImage];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 91+32, 284, 32)];
        titleLabel.font = [UIFont fontWithName:Custom_Font_Family_2 size:16];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:titleLabel];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUpCell:(NSString *)titleSTR titieImage:(UIImage *)tImage index:(NSIndexPath *)index{
    
    if (index.row == 0) {
        logoImage.image = [UIImage imageNamed:@"相册_icon_camera-roll"];
    }
    else{
        logoImage.image = [UIImage imageNamed:@"相册_icon_相册"];
    }
    titleLabel.text = titleSTR;
    
    titleImage.image = tImage;
    
    
    
}

-(void)setUpCell:(ALAssetsGroup *)group index:(NSIndexPath *)index{
    
    if (index.row == 0) {
        logoImage.image = [UIImage imageNamed:@"相册_icon_camera-roll"];
    }
    else{
        logoImage.image = [UIImage imageNamed:@"相册_icon_相册"];
    }
    titleLabel.text = [group valueForProperty:ALAssetsGroupPropertyName];
    
    [self getTitleImage:group];
    
}

-(void)getTitleImage:(ALAssetsGroup *)group{
    
    [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:0] options:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            
            size_t height               = CGImageGetHeight([result aspectRatioThumbnail]);
            size_t width                = CGImageGetWidth([result aspectRatioThumbnail]);
            NSLog(@"%zu %zu",height,width);
            titleImage.image = [UIImage  imageWithCGImage:[result aspectRatioThumbnail] scale:height / 120.0 orientation:UIImageOrientationUp];
        }
        
    }];
    
}

-(UIImage *)rectImageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (void)drawRect:(CGRect)rect {
//    if (self.titleImage.image) {
//        [self.titleImage.image drawInRect:CGRectMake(0, 0, 320, 123+32)];
//        self.titleImage.image = nil;
//    }
    
//    [self.titleLabel.text drawInRect:textRect withFont:font lineBreakMode:UILineBreakModeTailTruncation];
}


@end
