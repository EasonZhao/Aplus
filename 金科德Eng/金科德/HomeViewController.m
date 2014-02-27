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

@interface HomeViewController ()
{
    IBOutlet HomeTableView *tableView;
}

@property(nonatomic,retain)NSMutableArray *deviceAry;

@end

@implementation HomeViewController
@synthesize deviceAry;

- (void)dealloc
{
    [deviceAry release];
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
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

-(void)refresh
{
    [deviceAry removeAllObjects];
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
 * Called when the socket has received the requested datagram.
 *
 * Due to the nature of UDP, you may occasionally receive undesired packets.
 * These may be rogue UDP packets from unknown hosts,
 * or they may be delayed packets arriving after retransmissions have already occurred.
 * It's important these packets are properly ignored, while not interfering with the flow of your implementation.
 * As an aid, this delegate method has a boolean return value.
 * If you ever need to ignore a received packet, simply return NO,
 * and AsyncUdpSocket will continue as if the packet never arrived.
 * That is, the original receive request will still be queued, and will still timeout as usual if a timeout was set.
 * For example, say you requested to receive data, and you set a timeout of 500 milliseconds, using a tag of 15.
 * If rogue data arrives after 250 milliseconds, this delegate method would be invoked, and you could simply return NO.
 * If the expected data then arrives within the next 250 milliseconds,
 * this delegate method will be invoked, with a tag of 15, just as if the rogue data never appeared.
 *
 * Under normal circumstances, you simply return YES from this method.
 **/
- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    //Byte *byte = (Byte*)[data bytes];
    NSString *localIP = [AppWindow localWiFiIPAddress];
    NSString *response = [NSString stringWithFormat:@"%@",data];
    NSString *s = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease];
    NSLog(@"HomeVC\nreceive => tag %ld\nresponse => %@ \nresponseStr => %@ \nhost => %@",tag,response,s,host);
    response = [response substringWithRange:NSMakeRange(1, response.length-2)];
    response = [response stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (localIP&&localIP.length) {
        NSRange range = [host rangeOfString:localIP];
        if(range.location==NSNotFound)
        {
            NSString *responseHead = [response substringWithRange:NSMakeRange(0, 4)];
            responseHead = [AppWindow stringFromHexString:responseHead];
            NSString *responseMac = [response substringWithRange:NSMakeRange(6, 12)];
            NSLog(@"responseMac %@",responseMac);
            NSString *responseSecretKey = [response substringWithRange:NSMakeRange(18, 12)];
            NSLog(@"responseSecretKey %@",responseSecretKey);
            NSString *status = [response substringWithRange:NSMakeRange(30, 2)];
            NSLog(@"status %@",status);
            //response = [AppWindow stringFromHexString:response];
            NSLog(@"responseHead %@",responseHead);
            if (!deviceAry) {
                deviceAry = [[NSMutableArray alloc]init];
            }
            [deviceAry addObject:response];
            tableView.aryData = deviceAry;
            [tableView reloadData];
//        DataSource *dataSource = [DataSource sharedDataSource];
//        NSMutableArray *savedDeveiceAry = [dataSource deviceDatas];
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"where mac == '%@'",responseMac];
//        NSArray *filteredAry = [savedDeveiceAry filteredArrayUsingPredicate:predicate];
//        if (!filteredAry.count) {
//            [dataSource newDeviceData:responseMac];
//        }
        }
    }
    
    
    /*
    NSString *response = [NSString stringWithFormat:@"%@",data];
    NSLog(@"response %@",response);
    response = [response stringByReplacingOccurrencesOfString:@" " withString:@""];
    response = [response substringWithRange:NSMakeRange(1, response.length-2)];
    NSString *responseHead = [response substringWithRange:NSMakeRange(0, 4)];
    responseHead = [AppWindow stringFromHexString:responseHead];
    NSString *responseMac = [response substringWithRange:NSMakeRange(6, 12)];
    NSLog(@"responseMac %@",responseMac);
    NSString *responseSecretKey = [response substringWithRange:NSMakeRange(18, 12)];
    NSLog(@"responseSecretKey %@",responseSecretKey);
    NSString *status = [response substringWithRange:NSMakeRange(19, 2)];
    NSLog(@"status %@",status);
    response = [AppWindow stringFromHexString:response];
    NSLog(@"responseHead %@",responseHead);
    NSString *s = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease];
    NSLog(@"didReceiveData, host = %@, tag = %ld dataString = %@", host, tag,s);
    */
    return NO;
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
