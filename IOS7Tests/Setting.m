//
//  Setting.m
//  IOS7Tests
//
//  Created by lzb on 15/2/9.
//  Copyright (c) 2015年 pipaw. All rights reserved.
//

#import "Setting.h"
#import "MSSPopMasonry.h"

@import MobileCoreServices;

@implementation Setting

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Setup the view defaults
        [self setupViewDefaults];
    }
    return self;
    
}

-(void)setupViewDefaults{
    
    self.main = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.main addTarget:self action:@selector(toPicture) forControlEvents:UIControlEventTouchUpInside];
    [self.main setBackgroundColor:[UIColor blueColor]];
    [self addSubview:self.main];
    
    self.setting = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.setting addTarget:self action:@selector(dosetting) forControlEvents:UIControlEventTouchUpInside];
    [self.setting setBackgroundColor:[UIColor blueColor]];
    [self addSubview:self.setting];
    
    self.grid = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.grid addTarget:self action:@selector(dogrid) forControlEvents:UIControlEventTouchUpInside];
    [self.grid setBackgroundColor:[UIColor redColor]];
    [self addSubview:self.grid];
    
    self.cameraswitch = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cameraswitch addTarget:self action:@selector(docameraswitch) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraswitch setBackgroundColor:[UIColor blueColor]];
    [self addSubview:self.cameraswitch];
    
    self.delay = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.delay addTarget:self action:@selector(dodelay) forControlEvents:UIControlEventTouchUpInside];
    [self.delay setBackgroundColor:[UIColor redColor]];
    [self addSubview:self.delay];
    self.exposure = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.exposure addTarget:self action:@selector(dosetting) forControlEvents:UIControlEventTouchUpInside];
    [self.exposure setBackgroundColor:[UIColor blueColor]];
    [self addSubview:self.exposure];
    
    [self.main mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0.0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.mas_equalTo(10.0);
    }];
    [self.setting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0.0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.right.mas_equalTo(-10.0);
        
//        make.left.equalTo(self.mas_left).with.offset(padding.left);
//        make.bottom.equalTo(superview.mas_bottom).with.offset(-padding.bottom);
//        make.right.equalTo(superview.mas_right).with.offset(-padding.right);
    }];
    
    [self.grid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0.0);
        make.size.mas_equalTo(CGSizeMake(40.0, 40.0));
        make.right.mas_equalTo(self.setting.mas_left).with.offset(-23.0);
    }];
    
    [self.delay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0.0);
        make.size.mas_equalTo(CGSizeMake(40.0, 40.0));
        make.right.mas_equalTo(self.grid.mas_left).with.offset(-23.0);
    }];
    
    [self.cameraswitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0.0);
        make.size.mas_equalTo(CGSizeMake(40.0, 40.0));
        self.cameraswitchConstraint = make.right.mas_equalTo(self.setting.mas_left).with.offset(-23.0);
    }];
    
    [self.exposure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0.0);
        make.size.mas_equalTo(CGSizeMake(40.0, 40.0));
        make.right.mas_equalTo(self.cameraswitch.mas_left).with.offset(-23.0);
    }];
   
}




-(void)dosetting{
    
    if (self.doSettingBlock) {
        self.doSettingBlock();
    }
//    [self.cameraswitch mas_updateConstraints:^(MASConstraintMaker *make) {
//        
//        make.right.mas_equalTo(self.setting.mas_left).with.offset(230.0);
//        
//    }];
    
    
    POPSpringAnimation *leftSideAnimation = [POPSpringAnimation new];
    leftSideAnimation.toValue = @(-150);
    leftSideAnimation.property = [POPAnimatableProperty mas_offsetProperty];
    leftSideAnimation.springBounciness = 16;
    leftSideAnimation.springSpeed = 6;
    
    [self.cameraswitchConstraint pop_addAnimation:leftSideAnimation forKey:@"offset"];
    
//    [UIView animateWithDuration:1 animations:^{
//        [self layoutIfNeeded];
//    } completion:^(BOOL finished) {
        //repeat!
//        [self animateWithInvertedInsets:!invertedInsets];
//    }];
//    [self.cameraswitch updateConstraintsIfNeeded];
//    [self.cameraswitch updateConstraints];
    
    POPAnimatableProperty *constantProperty = [POPAnimatableProperty propertyWithName:@"constant" initializer:^(POPMutableAnimatableProperty *prop){
        prop.readBlock = ^(NSLayoutConstraint *layoutConstraint, CGFloat values[]) {
            values[0] = [layoutConstraint constant];
        };
        prop.writeBlock = ^(NSLayoutConstraint *layoutConstraint, const CGFloat values[]) {
            [layoutConstraint setConstant:values[0]];
        };
    }];
    
    POPSpringAnimation *constantAnimation = [POPSpringAnimation animation];
    constantAnimation.property = [POPAnimatableProperty mas_offsetProperty];
//    constantAnimation.fromValue = @(_layoutConstraint.constant);
    constantAnimation.toValue = @(200);
    [self.cameraswitchConstraint pop_addAnimation:constantAnimation forKey:@"constantAnimation"];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
