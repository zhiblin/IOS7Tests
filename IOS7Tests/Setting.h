//
//  Setting.h
//  IOS7Tests
//
//  Created by lzb on 15/2/9.
//  Copyright (c) 2015年 pipaw. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Setting : UIView

@property (nonatomic, strong) UIButton *main;
@property (nonatomic, strong) UIButton *setting;
@property (nonatomic, strong) UIButton *grid;
@property (nonatomic, strong) UIButton *cameraswitch;
@property (nonatomic, strong) UIButton *exposure;
@property (nonatomic, strong) UIButton *delay;

@property (nonatomic, strong) MASConstraint *gridConstraint;
@property (nonatomic, strong) MASConstraint *cameraswitchConstraint;


@end
