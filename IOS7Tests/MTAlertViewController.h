//
//  MTAlertViewController.h
//  BeautyPlus
//
//  Created by lzb on 15/11/5.
//  Copyright © 2015年 美图网. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    OneButton,
    TwoButton
} AlertViewType;



typedef void(^DidAction)(BOOL done);

@interface MTAlertViewController : UIViewController


@property (nonatomic, strong) DidAction didAction;

- (id)initWithTitle:(NSString *)titleStr  message:(NSString *)messageStr ok:(NSString *) okStr cancel:(NSString *) cancelStr alertType:(AlertViewType)alertViewType;

-(void)showCustomAlertView:(UIViewController *)VC;

@end
