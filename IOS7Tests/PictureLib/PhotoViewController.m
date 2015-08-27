
//
//  PhotoViewController.h
//  CollectDemo
//
//  Created by mtt0156 on 14-6-3.
//  Copyright (c) 2014年 lin zhibin. All rights reserved.
//
#import "PhotoViewController.h"
#import "ImageScrollView.h"
#import "PageViewControllerData.h"
#import "MyPageViewController.h"
#import "MTImageScrollView.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation PhotoViewController

+ (PhotoViewController *)photoViewControllerForPageIndex:(NSUInteger)pageIndex
{
    if (pageIndex < [[PageViewControllerData sharedInstance] photoCount])
    {
        return [[self alloc] initWithPageIndex:pageIndex];
    }
    return nil;
}

- (id)initWithPageIndex:(NSInteger)pageIndex
{
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil)
    {
        _pageIndex = pageIndex;
    }
    return self;
}

- (void)loadView
{
    // replace our view property with our custom image scroll view
    ImageScrollView *scrollView = [[ImageScrollView alloc] init];
    scrollView.index = _pageIndex;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    MTImageScrollView *scrollView = [[MTImageScrollView alloc] init];
//    scrollView.index = _pageIndex;
    
    self.view = scrollView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // set the navigation bar's title to indicate which photo index we are viewing,
    // note that our parent is MyPageViewController
    //

    MyPageViewController *page = (MyPageViewController *)self.parentViewController;
//    self.parentViewController.navigationItem.title =
         page.titleLabel.text =  [NSString stringWithFormat:@"%@ of %@", [@(self.pageIndex+1) stringValue], [@([[PageViewControllerData sharedInstance] photoCount]) stringValue]];
}

@end
