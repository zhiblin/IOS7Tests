//
//  NetDataViewController.m
//  IOS7Tests
//
//  Created by lzb on 15/8/26.
//  Copyright (c) 2015年 loaer. All rights reserved.
//

#import "NetDataViewController.h"
#import "ReactiveCocoa.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import <ASIHTTPRequest.h>

#define kMTServerAddress        @"http://backend.beautyplus.com/beautyplusaddata/getbeautyplusad.json?lang="

@interface NetDataViewController ()

@end

@implementation NetDataViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
/*
-(void)getData:(NSString *)language{
    NSString *str;
//    if (IS_TEST_PACKAGE) {
        str = [NSString stringWithFormat:@"%@%@%@",kMTServerAddress,language,@"&debug_status=1&system=2"];//arc4random()%10000];
//    }
//    else {
//        str = [NSString stringWithFormat:@"%@%@%@",kMTServerAddress,language,@"&debug_status=2&system=2"];
        //str = [NSString stringWithFormat:@"%@?v=%d",kMTServerAddress,arc4random()%10000];
//    }
    NSURL *url = [NSURL URLWithString:str];
    
    [advertRequest clearDelegatesAndCancel];
    [ASIHTTPRequest clearSession];
    [self setAdvertRequest:[ASIHTTPRequest requestWithURL:url]];
    advertRequest.delegate = self;
    [advertRequest setDidFinishSelector:@selector(didRequestAdFinished:)];
    [advertRequest setDidFailSelector:@selector(didRequestAdFailed:)];
    [advertRequest startAsynchronous];
    
}
 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
