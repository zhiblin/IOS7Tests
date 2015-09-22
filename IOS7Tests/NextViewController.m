//
//  NextViewController.m
//  IOS7Tests
//
//  Created by lzb on 15/5/26.
//  Copyright (c) 2015年 loaer. All rights reserved.
//

#import "NextViewController.h"

@interface NextViewController ()

@property (nonatomic, strong) UIImage* showsImage;
@end

@implementation NextViewController

-(id)initWithImage:(UIImage *)showImage{
    
        self = [super init];
        if (self)
        {
            _showsImage = showImage;
        }
        return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    UIImageView *backImage = [[UIImageView alloc] initWithImage:_showsImage];
    [backImage setFrame:self.view.bounds];
    [backImage setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:backImage];
    UIButton *butt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [butt setFrame:CGRectMake(60, 100, 120, 100)];
    [butt setTitle:@"back" forState:UIControlStateNormal];
    [butt addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:butt];
}

-(void)back{
//    [self dismissViewControllerAnimated:NO completion:^{
    
        [self.navigationController popViewControllerAnimated:YES];
//    }];
    
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
