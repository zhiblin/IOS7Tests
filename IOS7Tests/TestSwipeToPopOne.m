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

@interface TestSwipeToPopOne ()

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
    [self.view addSubview:set];
    UIButton *push = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    push.frame  = CGRectMake(100, 200, 100, 80);
    [push setTitle:[NSString stringWithFormat:@"push"] forState:UIControlStateNormal];
    
    [push addTarget:self action:@selector(pushtonextview) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:push];
    
    
    
    
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
