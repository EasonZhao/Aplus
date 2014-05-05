//
//  HomeViewController.m
//  金科德
//
//  Created by Yangliu on 13-9-2.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableView.h"
#import "DataSource.h"
#import "AAdapter.h"
#import "HomeTableCell.h"

@interface HomeViewController ()<HomeViewDelegate>
{
    IBOutlet HomeTableView *tableView;
}

@end

@implementation HomeViewController

- (void)dealloc
{
    [tableView release];
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
    // Do any additional setup after loading the view from its nib.
//    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"首页" image:nil tag:0];
//    [item setFinishedSelectedImage:[UIImage imageNamed:@"homeBarS"] withFinishedUnselectedImage:[UIImage imageNamed:@"homeBar"]];
//    self.tabBarItem = item;
//    [item release];
//    self.navigationItem.leftBarButtonItem = [AppWindow getBarItemTitle:@"" Target:self Action:nil ImageName:@"Wi-Fi"];
    self.navigationItem.rightBarButtonItem = [AppWindow getBarItemTitle:@"" Target:self Action:@selector(refresh) ImageName:@"刷新"];
    [tableView setDelDelegate:self];
    //[[NetKit instance] checkSearchCode:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    tableView.aryData = nil;
    [[NetKit instance] checkSearchCode:self];
    [self refresh];
}

-(void)refresh
{
    //[deviceAry removeAllObjects];
//    UdpSocket *udp = [[UdpSocket alloc]initWithDelegate:self];
//    [udp checkStatus:nil];
}

- (void)checkSearchCodeHandler:(BOOL)success Devs:(NSMutableArray*)devs
{
    if (success) {
        tableView.aryData = devs;
        [tableView reloadData];
    } else {
        
    }
}

- (void)delDev:(Byte)DevID
{
    [[NetKit instance] delDevice:DevID delegate:self];
}

- (void)delDeviceHandler:(BOOL)success devID:(Byte)devID
{
    if (!success) {
        return;
    }
    tableView.aryData = nil;
    [tableView reloadData];
    [[NetKit instance] checkSearchCode:self];
}

@end
