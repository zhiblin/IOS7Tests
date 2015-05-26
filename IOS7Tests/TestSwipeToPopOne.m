//
//  TestSwipeToPopOne.m
//  IOS7Tests
//
//  Created by by on 13-11-22.
//  Copyright (c) 2013年 pipaw. All rights reserved.
//

#import "TestSwipeToPopOne.h"
#import "TestSwipeToPopTwo.h"
#import "Setting.h"

@interface TestSwipeToPopOne ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation TestSwipeToPopOne

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    Setting *set = [[Setting alloc] initWithFrame:self.view.bounds];
    set.doSettingBlock = ^(){
        
        NSLog(@"setting");
        _countdownView = [[CameraCountdownView alloc] initWithFrame:self.view.bounds andSeconds:3.0f];
        _countdownView.userInteractionEnabled = NO;
        [_countdownView setDelegate:self];
        [self.view addSubview:_countdownView];
        _countdownView.userInteractionEnabled = YES;
        [_countdownView startCountdownTimer];
        
    };
//    [self.view addSubview:set];
    UIButton *push = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    push.frame  = CGRectMake(100, 200, 100, 80);
    [push setTitle:[NSString stringWithFormat:@"push"] forState:UIControlStateNormal];
    
    [push addTarget:self action:@selector(toPicture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:push];
    
    
    
    
}

-(void)toPicture{
    
    [UIImagePickerController isSourceTypeAvailable:
     UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    mediaUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.videoQuality = UIImagePickerControllerQualityTypeHigh;
    mediaUI.delegate = self;
    
    [self presentViewController:mediaUI animated:YES completion:nil];
    
}

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController:(UIImagePickerController *) picker
 didFinishPickingMediaWithInfo:(NSDictionary *) info
{
    // 设置Audio Session类别
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    //    [self dismissViewControllerAnimated:NO completion:nil];
    
    // Handle a movie capture
    CFStringRef newMediaType = (__bridge_retained CFStringRef)mediaType;
    if (CFStringCompare(newMediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSURL *moviePath = [info objectForKey: UIImagePickerControllerMediaURL];
        
        NSDictionary *inputOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                                                 forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVAsset *asset = [[AVURLAsset alloc] initWithURL:moviePath options:inputOptions];
        
        if (!asset || CMTimeGetSeconds([asset duration]) < 3.0) {
            if (!asset) {
//                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"MovieImportError", nil)];
            }
            else {
//                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"ImportTooShort", nil)];
            }
            [picker popToRootViewControllerAnimated:YES];
        }
        else {
            
        }
    }
    CFRelease(newMediaType);
}

- (void)cameraCountdownViewDidCompleted{
 
    if (_countdownView) {
        [_countdownView removeFromSuperview];
        _countdownView = nil;
    }
    
}

-(void)pushtonextview{
    
    
    TestSwipeToPopTwo *tstpt = [[TestSwipeToPopTwo alloc] init];
    [self.navigationController pushViewController:tstpt animated:YES];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
