//
//  QRViewController.m
//  AllDemo
//
//  Created by lzb on 15/11/26.
//  Copyright © 2015年 loaer. All rights reserved.
//

#import "QRViewController.h"

@interface QRViewController ()

@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Input
    NSError *error = nil;
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (error) {
        NSLog(@"初始化输入设备失败");
    }
    // Output
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // Session
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    // 添加输入输出
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    // 条码类型 AVMetadataObjectTypeQRCode 即二维码，如果需要扫描条形码，就要在这个数组里添加枚举，command点二维码枚举进去，就会看见其他的需要的条码类型，例如UPC，code39，code128等，酌情使用
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _previewLayer =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    // 开始扫码
    [_session startRunning];
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate methods
// 扫到码之后，会通过这个代理方法告知扫码结果
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    NSString *stringValue = nil;
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    // 扫码成功，停止扫码会话层活动
    [_session stopRunning];
    
    NSLog(@"%@",stringValue);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
