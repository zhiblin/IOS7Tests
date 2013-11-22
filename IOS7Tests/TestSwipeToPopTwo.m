//
//  TestSwipeToPopTwo.m
//  IOS7Tests
//
//  Created by by on 13-11-22.
//  Copyright (c) 2013年 pipaw. All rights reserved.
//

#import "TestSwipeToPopTwo.h"

@interface TestSwipeToPopTwo ()<UIGestureRecognizerDelegate>

@end

@implementation TestSwipeToPopTwo

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
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
	// Do any additional setup after loading the view.
    UIScreenEdgePanGestureRecognizer *left2rightSwipe = [[UIScreenEdgePanGestureRecognizer alloc]
                                                          initWithTarget:self
                                                          action:@selector(handleSwipeGesture:)]
                                                         ;
    [left2rightSwipe setDelegate:self];
    [left2rightSwipe setEdges:UIRectEdgeLeft];
    [self.view addGestureRecognizer:left2rightSwipe];

}

- (void)handleSwipeGesture:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
