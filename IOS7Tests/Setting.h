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

typedef void (^DoSettingBlock)();
@property (nonatomic, copy) DoSettingBlock doSettingBlock;

typedef void (^DoDelayBlock)(NSString *telphone);
@property (nonatomic, copy) DoDelayBlock doDelayBlock;

typedef void (^DoMainBlock)();
@property (nonatomic, copy) DoMainBlock doMainBlock;

typedef void (^DoCameraswitchBlock)(NSString *telphone);
@property (nonatomic, copy) DoCameraswitchBlock doCameraswitchBlock;

typedef void (^DoExposureBlock)();
@property (nonatomic, copy) DoExposureBlock doExposureBlock;

typedef void (^DoGridBlock)(NSString *telphone);
@property (nonatomic, copy) DoGridBlock doGridBlock;


@end
