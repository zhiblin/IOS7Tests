//
//  UIWebView+Override.m
//  AllDemo
//
//  Created by xiaopi on 16/3/25.
//  Copyright © 2016年 loaer. All rights reserved.
//

#import <objc/runtime.h>
#import "UIWebView+Override.h"

#define REPLACE_THAT_METHOD_AT_RUNTIME

@implementation UIWebView (Override)

#ifndef REPLACE_THAT_METHOD_AT_RUNTIME

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

- (__unused void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    if (self.jsAlertCallback) self.jsAlertCallback(sender, message, frame);
}

#pragma GCC diagnostic pop

#else

- (void)_:(UIWebView *)sender :(NSString *)message :(id)frame {
    if (self.jsAlertCallback) self.jsAlertCallback(sender, message, frame);
}

#endif

#pragma mark - Getters & Setters

- (void)setJsAlertCallback:(JSAlertCallback)callback {
    objc_setAssociatedObject(self, @selector(jsAlertCallback), callback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
#ifdef REPLACE_THAT_METHOD_AT_RUNTIME
    typedef const char *TYPES;
    Class cls = [UIWebView class];
    Method m = class_getInstanceMethod(cls, @selector(_:::));
    SEL name = NSSelectorFromString(@"webView:runJavaScriptAlertPanelWithMessage:initiatedByFrame:");
    IMP imp = method_getImplementation(m);
    TYPES types = method_getTypeEncoding(m);
    class_replaceMethod(cls, name, imp, types);
#endif
}

- (JSAlertCallback)jsAlertCallback {
    return objc_getAssociatedObject(self, @selector(jsAlertCallback));
}


@end
