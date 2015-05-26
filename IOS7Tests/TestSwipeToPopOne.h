//
//  TestSwipeToPopOne.h
//  IOS7Tests
//
//  Created by by on 13-11-22.
//  Copyright (c) 2013年 pipaw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraCountdownView.h"

@import MobileCoreServices;
@import AVFoundation;
@import CoreFoundation;

@interface TestSwipeToPopOne : UIViewController<CameraCountdownViewDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) CameraCountdownView *countdownView;

@end
