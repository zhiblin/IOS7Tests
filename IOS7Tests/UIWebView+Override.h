//
//  UIWebView+Override.h
//  AllDemo
//
//  Created by xiaopi on 16/3/25.
//  Copyright © 2016年 loaer. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^JSAlertCallback)(UIWebView *webView, NSString *message, id webFrame);

@interface UIWebView (Override)
@property(nonatomic) JSAlertCallback jsAlertCallback;

@end
