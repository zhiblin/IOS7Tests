//
//  MixTestViewController.m
//  AllDemo
//
//  Created by lzb on 15/9/15.
//  Copyright © 2015年 loaer. All rights reserved.
//

#import "MixTestViewController.h"
#import <Mixpanel.h>
#import "FiveStarViewController.h"

#define MIXPANEL_TOKEN @"5d02ecac989e9eff8a9280ba58590b41"

@interface MixTestViewController ()

@end

@implementation MixTestViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *doButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doButton setFrame:CGRectMake(130, 154, 120, 42)];
    [doButton setBackgroundColor:[UIColor colorWithRed:172.0/255.0 green:172.0/255.0 blue:172.0/255.0 alpha:1.]];
    [doButton setTitle:@"给五星好评" forState:UIControlStateNormal];
    [doButton addTarget:self action:@selector(first) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doButton];
    
//    [self first];
//    UIImageView *t = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"girl-makeup_599"]];
//    [t setFrame:self.view.bounds];
//    [t setContentMode:UIViewContentModeScaleAspectFit];
//    [self.view addSubview:t];
//    [self circleAnimate:t];
}

-(void)first{
    
    FiveStarViewController *star = [[FiveStarViewController alloc] initWithTitle:@"如果BeautyPlus给您带来美丽，请给我们五星好评吧~您的鼓励与支持是我们最大的动力" ok:@"去好评" cancel:@"下一次"];
    star.didstar = ^(BOOL did){
        if (did) {
            NSLog(@"eeeeeeeee");
            NSString *strComment = [NSString stringWithFormat:
                                    @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",
                                    @"622434129"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strComment]];
        }
        else
            NSLog(@"sssssss");
    };
    __weak  UIViewController *weakVC = self;
    [star showStarComment:weakVC];
//    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
//    [[Mixpanel sharedInstance] identify:[Mixpanel sharedInstance].distinctId];
//    NSString *distinctId = [Mixpanel sharedInstance].distinctId;
//    [[Mixpanel sharedInstance].people set:@{ @"name" : distinctId }];
//    [[Mixpanel sharedInstance] track:@"top" properties:[NSDictionary dictionaryWithObjectsAndKeys:@"11",@"2",@"31",@"4", nil]];
    
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
