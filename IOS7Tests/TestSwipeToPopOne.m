//
//  TestSwipeToPopOne.m
//  IOS7Tests
//
//  Created by by on 13-11-22.
//  Copyright (c) 2013年 pipaw. All rights reserved.
//

#import "TestSwipeToPopOne.h"
#import "TestSwipeToPopTwo.h"

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
    UIButton *push = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    push.frame  = CGRectMake(100, 200, 100, 80);
    [push setTitle:[NSString stringWithFormat:@"push"] forState:UIControlStateNormal];
    
    [push addTarget:self action:@selector(pushtonextview) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:push];
    
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
