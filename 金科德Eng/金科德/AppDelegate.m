//
//  AppDelegate.m
//  金科德
//
//  Created by Yangliu on 13-9-2.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
//    self.window.backgroundColor = [UIColor whiteColor];
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mian_bg.png"]];
    UITabBarController *tabBarVC = (UITabBarController*)self.window.rootViewController;
    UIViewController *first = [tabBarVC.viewControllers objectAtIndex:0];
    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:@"Home" image:nil tag:0];
    [item1 setFinishedSelectedImage:[UIImage imageNamed:@"home"] withFinishedUnselectedImage:[UIImage imageNamed:@"home"]];
    first.tabBarItem = item1;
    [item1 release];
    UIViewController *second = [tabBarVC.viewControllers objectAtIndex:1];
    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:@"Setting" image:nil tag:0];
    [item2 setFinishedSelectedImage:[UIImage imageNamed:@"set"] withFinishedUnselectedImage:[UIImage imageNamed:@"set"]];
    second.tabBarItem = item2;
    [item2 release];
    UIViewController *third = [tabBarVC.viewControllers objectAtIndex:2];
    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:@"Service" image:nil tag:0];
    [item3 setFinishedSelectedImage:[UIImage imageNamed:@"serv"] withFinishedUnselectedImage:[UIImage imageNamed:@"serv"]];
    third.tabBarItem = item3;
    [item3 release];
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
