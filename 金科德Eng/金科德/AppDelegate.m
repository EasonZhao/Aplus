//
//  AppDelegate.m
//  金科德
//
//  Created by Yangliu on 13-9-2.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "AAdapter.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>


@implementation AppDelegate
{
    NSTimer *timer_;
    NSString *netIP_;
    NSData *macAddr_;
    UdpSocket *socket_;
    int serachTimes_;
}

#pragma mark MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
- (NSData *) macaddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSData *data = [[NSData alloc] initWithBytes:ptr length:6];
    free(buf);
    return data;
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //获取mac地址
    macAddr_ = [self macaddress];
    serachTimes_ = 0;
    //发送0xa1
    socket_ = [[UdpSocket alloc] initWithDelegate:self];
    /*[self searchDev];
    timer_ = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(searchDev) userInfo:nil repeats:YES];
     */
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

- (void)searchDev
{
    serachTimes_ += 1;
    if (serachTimes_<=1) {
        [SVProgressHUD showWithStatus:@"网络连接中" maskType:SVProgressHUDMaskTypeGradient];
    } else {
        [SVProgressHUD dismiss];
        NSString *str = [[NSString alloc] initWithFormat:@"连接失败，正在尝试重新连接:%d",serachTimes_];
        [SVProgressHUD showWithStatus:str maskType:SVProgressHUDMaskTypeGradient];
    }
    
    if (netIP_) {
        [timer_ invalidate];
    } else {
        [socket_ checkSearchCode];
    }
}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    if (!data) {
        return FALSE;
    }
    Byte *pData = (Byte*)[data bytes];
    if (pData[0]!=0x41 || pData[1]!=0x54) {
        return FALSE;
    }
    [SVProgressHUD dismiss];
    netIP_ = [[NSString alloc] initWithString:host];
    Byte *pos = pData+24;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    while (*pos!=0xfe) {
        NSData *tmp = [[NSData alloc] initWithBytes:pos length:3];
        AAdapter *ada = [[AAdapter alloc] initWithData: tmp];
        [arr addObject:ada];
        pos += 3;
    }
    return YES;
}

/*
- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    return NO;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}
*/
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
