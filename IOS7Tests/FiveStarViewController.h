//
//  FiveStarViewController.h
//  AllDemo
//
//  Created by lzb on 15/9/21.
//  Copyright © 2015年 loaer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidStar)(BOOL done);

@interface FiveStarViewController : UIViewController

@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, strong) DidStar didstar;

- (instancetype)initWithTitle:(NSString *)titleString ok:(NSString *)okString cancel:(NSString *)cancelString;

-(void)showStarComment:(UIViewController *)VC;

@end
