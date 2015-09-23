//
//  SelectView.h
//  AllDemo
//
//  Created by lzb on 15/9/22.
//  Copyright © 2015年 loaer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidBtn)(NSInteger i);

@interface SelectView : UIView


@property (nonatomic, strong) DidBtn didbtn;
@property (nonatomic, strong) UIButton *oneButton;
@property (nonatomic, strong) UIButton *twoButton;
@property (nonatomic, strong) UIButton *threeButton;
@property (nonatomic, strong) UIButton *fourButton;
@property (nonatomic, strong) UIButton *fiveButton;
@property (nonatomic, strong) UIButton *sixButton;
@property (nonatomic, strong) UIButton *sevenButton;

@end
