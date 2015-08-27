//
//  MyPageViewController.h
//  CollectDemo
//
//  Created by mtt0156 on 14-6-3.
//  Copyright (c) 2014年 lin zhibin. All rights reserved.
//



#define RGBCOLOR(r,g,b) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.f]

#define RGBACOLOR(r,g,b,a) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]

#import "MyPageViewController.h"
#import "PhotoViewController.h"
#import "PageViewControllerData.h"
#import "PSAppDelegate.h"
#import "MTGroupsViewController.h"

@implementation MyPageViewController

@synthesize leftbutton,rightbutton,titleLabel,customNavView;


-(void)showNav{
    
    customNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [customNavView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:customNavView];
    
    leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftbutton setTitle:NSLocalizedString(@"GUI_TEXT_ASSETS_PHOTOS", @"GUI_TEXT_ASSETS_PHOTOS") forState:UIControlStateNormal];
    
    [leftbutton setTitle:NSLocalizedString(@"GUI_TEXT_ASSETS_CAMERAROLL", @"GUI_TEXT_ASSETS_CAMERAROLL") forState:UIControlStateNormal];
    
    
    
    [leftbutton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [leftbutton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [leftbutton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [leftbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [leftbutton setImage:[UIImage imageNamed:@"topbar_btn_back"] forState:UIControlStateNormal];
    [leftbutton.titleLabel setFont:[UIFont fontWithName:Custom_Font_Family_2 size:18]];
    [leftbutton setFrame:CGRectMake(5, 7, 120, 30)];
    [leftbutton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [customNavView addSubview:leftbutton];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 7, 160, 30)];
    [titleLabel setText:NSLocalizedString(@"GUI_TEXT_ASSETS_CAMERAROLL", @"GUI_TEXT_ASSETS_CAMERAROLL")];
    [titleLabel setFont:[UIFont fontWithName:Custom_Font_Family_1 size:20]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    
    [customNavView addSubview:titleLabel];
    
    rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbutton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [rightbutton setImage:[UIImage imageNamed:@"相册_btn_关闭"] forState:UIControlStateNormal];
    
    [rightbutton setFrame:CGRectMake(276, 0, 40, 40)];
    [customNavView addSubview:rightbutton];
    
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self showNav];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeAll;
    }
    
    PhotoViewController *startingPage = [PhotoViewController photoViewControllerForPageIndex:self.startingIndex];
    
    if (startingPage != nil)
    {
        self.dataSource = self;
        
        [self setViewControllers:@[startingPage] direction:UIPageViewControllerNavigationDirectionForward animated:NO  completion:NULL];
    }
    
    UIButton* doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [doneBtn setAlpha:1.0f];
    [doneBtn setUserInteractionEnabled:YES];

    [doneBtn setTitle:[NSString stringWithFormat:@"USE"] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(usePicture) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setFrame:CGRectMake(0, self.view.frame.size.height-44, 320, 44)];
    [doneBtn setImage:[UIImage imageNamed:@"相册_使用"] forState:UIControlStateNormal];
    [doneBtn setImage:[UIImage imageNamed:@"相册_使用"] forState:UIControlStateHighlighted];
    
    [doneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [doneBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5.0, 0.0, 0.0)];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-LightItalic" size:18]];
    [doneBtn setBackgroundImage:[self rectImageWithColor:RGBACOLOR(251.0, 76.0, 105.0, 1.0) size:doneBtn.frame.size] forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:[self rectImageWithColor:RGBCOLOR(182.0, 65.0, 86.0) size:doneBtn.frame.size] forState:UIControlStateSelected];
    [doneBtn setBackgroundImage:[self rectImageWithColor:RGBCOLOR(182.0, 65.0, 86.0) size:doneBtn.frame.size] forState:UIControlStateHighlighted];
    [doneBtn setAdjustsImageWhenHighlighted:YES];
    [self.view addSubview:doneBtn];
    
}

-(void)usePicture{
    
    MTGroupsViewController *target = nil;
    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
        if ([controller isKindOfClass:[MTGroupsViewController class]]) { //这里判断是否为你想要跳转的页面
            target = (MTGroupsViewController *)controller;
        }
    }
    if (target) {
        
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *coverImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSDictionary *photoinfo = [[PageViewControllerData sharedInstance] dictionaryAtIndex:self.startingIndex pictureSize:0];
        
        [target.delegate imagePickerViewController:target didFinishPickerALAssetWith:photoinfo coverImage:coverImage];
        
        
    }
    
}

-(UIImage *)rectImageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}

#pragma mark - UIPageViewControllerDelegate

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(PhotoViewController *)vc
{
    NSUInteger index = vc.pageIndex;
    self.startingIndex = vc.pageIndex;
    return [PhotoViewController photoViewControllerForPageIndex:(index - 1)];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(PhotoViewController *)vc
{
    NSUInteger index = vc.pageIndex;
    self.startingIndex = vc.pageIndex;
    return [PhotoViewController photoViewControllerForPageIndex:(index + 1)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGSize titleSize = [_backtitlestr sizeWithFont:[UIFont systemFontOfSize:24]];
    if (titleSize.width > leftbutton.frame.size.width) {
        [leftbutton setTitle:@"back" forState:UIControlStateNormal];
    }
    else{
        [leftbutton setTitle:_backtitlestr forState:UIControlStateNormal];
    }
    
}

@end
