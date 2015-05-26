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
        self.backgroundColor = [UIColor blueColor];
        self.titleImageView = [[UIImageView alloc] initWithFrame:self.frame];
        self.titleImageView.image = [UIImage imageNamed:@"倒计时1"];
//        [self addSubview:self.titleImageView];
    }
    return self;
}

@end
