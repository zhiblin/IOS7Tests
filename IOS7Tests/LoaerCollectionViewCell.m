//
//  LoaerCollectionViewCell.m
//  IOS7Tests
//
//  Created by lzb on 15/5/26.
//  Copyright (c) 2015年 pipaw. All rights reserved.
//

#import "LoaerCollectionViewCell.h"

@implementation LoaerCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor redColor];
        self.titleLabel = [[UILabel alloc] initWithFrame:self.frame];
        self.titleLabel.font = [UIFont systemFontOfSize:28.f];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        self.titleImageView = [[UIImageView alloc] initWithFrame:self.frame];
        self.titleImageView.image = [UIImage imageNamed:@"倒计时1"];
//        [self addSubview:self.titleImageView];
    }
    return self;
}

@end
