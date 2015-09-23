//
//  SelectViewController.m
//  AllDemo
//
//  Created by lzb on 15/9/22.
//  Copyright © 2015年 loaer. All rights reserved.
//

#import "SelectViewController.h"
#import "SelectView.h"

@interface SelectViewController ()

@property (nonatomic, strong) SelectView *sView;

@end

@implementation SelectViewController

@synthesize sView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    sView = [[SelectView alloc] initWithFrame:CGRectMake(0, 100, [[UIScreen mainScreen] bounds].size.width, 36)];
    sView.userInteractionEnabled = YES;
    [self.view addSubview:sView];
    
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
