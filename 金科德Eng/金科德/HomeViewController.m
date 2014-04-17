//
//  HomeViewController.m
//  金科德
//
//  Created by Yangliu on 13-9-2.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableView.h"
#import "UdpSocket.h"
#import "DataSource.h"
#import "DBInterface.h"
#include "IPAddress.h"
#import "AAdapter.h"
#import "HomeTableCell.h"

@interface HomeViewController ()
{
    IBOutlet HomeTableView *tableView;
    DBInterface *_db;
    UdpSocket *socket_;
    NSString *netIP_;           //中心节点ip
    NSTimer *timer_;
    NSMutableArray *ipAddressArr_;
}

@end

@implementation HomeViewController

- (void)dealloc
{
    [tableView release];
    [_db release];
    [socket_ release];
    [super dealloc];
}

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
    socket_ = [[UdpSocket alloc] initWithDelegate:self];
    // Do any additional setup after loading the view from its nib.
//    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"首页" image:nil tag:0];
//    [item setFinishedSelectedImage:[UIImage imageNamed:@"homeBarS"] withFinishedUnselectedImage:[UIImage imageNamed:@"homeBar"]];
//    self.tabBarItem = item;
//    [item release];
//    self.navigationItem.leftBarButtonItem = [AppWindow getBarItemTitle:@"" Target:self Action:nil ImageName:@"Wi-Fi"];
    self.navigationItem.rightBarButtonItem = [AppWindow getBarItemTitle:@"" Target:self Action:@selector(refresh) ImageName:@"刷新"];
    
    [self connectNetPort];
}

- (void)timeoutHandle
{
    if (netIP_) {
        NSLog(@"connect net failure");
    } else {
        NSLog(@"connect net success");
    }
}

- (void)connectNetPort
{
    //发送0xa1
    [socket_ checkSearchCode];
    //启动定时器
    if (!timer_) {
        [timer_ invalidate];
    }
    timer_ = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(timeoutHandle) userInfo:nil repeats:NO];
}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    if (!netIP_) {
        //如果是本机ip，不做处理
        if (!ipAddressArr_) {
            ipAddressArr_ = [[NSMutableArray alloc] init];
            InitAddresses();
            GetIPAddresses();
            GetHWAddresses();
            for (int i=0; i<MAXADDRS; i++) {
                if (ip_addrs[i]==0) {
                    break;
                }
                NSString *str = [[NSString alloc] initWithUTF8String:ip_names[i]];
                [ipAddressArr_ addObject:str];
            }
        }
        for (NSString *str in ipAddressArr_) {
            NSRange fundObj = [host rangeOfString:str options:NSCaseInsensitiveSearch];
            if (fundObj.length>0) {
                return NO;
            }
            
            if (!data) {
                return FALSE;
            }
            Byte *pData = (Byte*)[data bytes];
            if (pData[0]!=0x41 || pData[1]!=0x54) {
                return FALSE;
            }
        }
        
        [timer_ invalidate];
        socket_.netMac = data;
        socket_.netMac = [socket_.netMac subdataWithRange:NSMakeRange(3, 6)];
        //[SVProgressHUD dismiss];
        netIP_ = [[NSString alloc] initWithString:host];
        Byte *pData = (Byte*)[data bytes];
        Byte *pos = pData+24;
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        while (*pos!=0xfe) {
            NSData *tmp = [[NSData alloc] initWithBytes:pos length:3];
            AAdapter *ada = [[AAdapter alloc] initWithData: tmp];
            ada.socket = socket_;
            [arr addObject:ada];
            pos += 3;
        }
        tableView.aryData = arr;
        [tableView reloadData];
        
        //切换udp传输类型
        BOOL ret = [socket_ setNetIp:host];
        assert(ret);
    } else {
        
    }
        return YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

-(void)refresh
{
    //[deviceAry removeAllObjects];
//    UdpSocket *udp = [[UdpSocket alloc]initWithDelegate:self];
//    [udp checkStatus:nil];
}

#pragma mark -

/**
 * Called when the datagram with the given tag has been sent.
 **/
- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
 **/
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

/**
 * Called if an error occurs while trying to receive a requested datagram.
 * This is generally due to a timeout, but could potentially be something else if some kind of OS error occurred.
 **/
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

/**
 * Called when the socket is closed.
 * A socket is only closed if you explicitly call one of the close methods.
 **/
- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock
{
    NSLog(@"%s %d", __FUNCTION__, __LINE__);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
