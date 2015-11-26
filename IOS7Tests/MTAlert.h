//
//  MTAlert.h
//  BeautyPlus
//
//  Created by lzb on 15/11/5.
//  Copyright © 2015年 美图网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTAlert : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIButton *cancelButton;

-(id)initWithFrame:(CGRect)frame title:(NSString *)titleStr message:(NSString *)messageStr ok:(NSString *) okStr;


@end
