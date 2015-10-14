//
//  AppDelegate.m
//  IOS7Tests
//
//  Created by by on 13-11-22.
//  Copyright (c) 2013年 pipaw. All rights reserved.
//

#import "AppDelegate.h"
#import "TestSwipeToPopOne.h"
#import "LoaerCollectionViewController.h"
#import "PullViewController.h"
#import "NetDataViewController.h"
#import "AdViewController.h"
#import "MixTestViewController.h"
#import "SelectViewController.h"
#import "TimeViewController.h"
#import "CreateAlbumViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
//    TestSwipeToPopOne *tstp = [[TestSwipeToPopOne alloc] init];
//    LoaerCollectionViewController *tstp = [[LoaerCollectionViewController alloc] init];
    
//    PullViewController *pull = [[PullViewController alloc] init];
//    NetDataViewController *netdata = [[NetDataViewController alloc] init];
//    AdViewController *ad = [[AdViewController alloc] init];
//    MixTestViewController *test = [[MixTestViewController alloc] init];
//    SelectViewController *s = [[SelectViewController alloc] init];
//    TimeViewController *s = [[TimeViewController alloc] init];
    CreateAlbumViewController *a = [[CreateAlbumViewController alloc] init];
    UINavigationController *main = [[UINavigationController alloc] initWithRootViewController:a];
    main.navigationBarHidden = YES;
    self.window.rootViewController = main;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
