//
//  QRViewController.h
//  AllDemo
//
//  Created by lzb on 15/11/26.
//  Copyright © 2015年 loaer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface QRViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>

@property (strong,nonatomic)AVCaptureDevice *device;
@property (strong,nonatomic)AVCaptureDeviceInput *input;
@property (strong,nonatomic)AVCaptureMetadataOutput *output;
@property (strong,nonatomic)AVCaptureSession *session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

@end
