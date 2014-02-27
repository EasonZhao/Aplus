//
//  AddDeviceViewController.m
//  金科德
//
//  Created by Yangliu on 13-9-9.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "AddDeviceViewController.h"

#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
//#import "wwanconnect.h//frome apple
#import <SystemConfiguration/SystemConfiguration.h>
#import "TextFieldWithComboBox.h"
#import "MBProgressHUD.h"

@interface AddDeviceViewController ()
{
    BOOL hasCommond;
    NSMutableArray *ssidAry;
    IBOutlet TextFieldWithComboBox *comboBox;
    IBOutlet UITextField *password;
    int staRepeatCount;
    int resetRepeatCount;
    NSTimer *timer1;
    NSTimer *timer2;
}
@property(nonatomic,retain)NSString *deviceIP;

@end

@implementation AddDeviceViewController
@synthesize udpSocket;
@synthesize deviceIP;

- (void)dealloc
{
    udpSocket.delegate = nil;
    [password release];
    [comboBox release];
    [ssidAry release];
    [deviceIP release];
    [udpSocket release];
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
//    self.navigationItem.leftBarButtonItem = [AppWindow getBarItemTitle:@"" Target:self Action:nil ImageName:@"Wi-Fi"];
//    self.navigationItem.leftBarButtonItem = [AppWindow getBarItemTitle:@"" Target:self Action:@selector(back:) ImageName:@"back"];
    
    //[self smartlink:nil];
    
    ssidAry = [[NSMutableArray alloc]init];
}

- (IBAction)smartlink:(UIButton *)sender {
    //初始化udp
    NSError *error = nil;
    self.udpSocket = [[[AsyncUdpSocket alloc] initWithDelegate: self] autorelease];
    [udpSocket bindToPort: 48899 error: &error];
    [udpSocket enableBroadcast:YES error:nil]; //发送广播
    NSString *searchCode = @"HF-A11ASSISTHREAD";
    [udpSocket receiveWithTimeout: -1 tag: 99];
    //开始发送
	BOOL res = [udpSocket sendData: [searchCode dataUsingEncoding:NSUTF8StringEncoding]
                             toHost: @"255.255.255.255"
                               port: 48899
                        withTimeout: -1
                                tag: 99];
    if (!res)
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提示"
														message: @"发送失败"
													   delegate: self
											  cancelButtonTitle: @"取消"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}

- (IBAction)command:(UIButton *)sender {
    if (!self.deviceIP) {
        [AppWindow alertMessage:@"未搜索到设备"];
        return;
    }
    //初始化udp
    NSError *error = nil;
    self.udpSocket = [[[AsyncUdpSocket alloc] initWithDelegate: self] autorelease];
    [udpSocket bindToPort: 48899 error: &error];
    [udpSocket enableBroadcast:YES error:nil]; //发送广播
    [udpSocket receiveWithTimeout: -1 tag: 98];
    NSString *searchCode = @"+ok";
    //开始发送
	BOOL res = [udpSocket sendData: [searchCode dataUsingEncoding:NSUTF8StringEncoding]
                             toHost: self.deviceIP
                               port: 48899
                        withTimeout: -1
                                tag: 98];
    if (!res)
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提示"
														message: @"发送失败"
													   delegate: self
											  cancelButtonTitle: @"取消"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}

- (IBAction)scan:(UIButton *)sender {
    if (!self.deviceIP) {
        [AppWindow alertMessage:@"未搜索到设备"];
        return;
    }
    //初始化udp
    NSError *error = nil;
    self.udpSocket = [[[AsyncUdpSocket alloc] initWithDelegate: self] autorelease];
    [udpSocket bindToPort: 48899 error: &error];
    [udpSocket enableBroadcast:YES error:nil]; //发送广播
    [udpSocket receiveWithTimeout: -1 tag: 97];
    NSString *searchCode = @"AT+WSCAN";
    //开始发送
	BOOL res = [udpSocket sendData: [searchCode dataUsingEncoding:NSUTF8StringEncoding]
                             toHost: self.deviceIP
                               port: 48899
                        withTimeout: -1
                                tag: 97];
    if (!res)
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提示"
														message: @"发送失败"
													   delegate: self
											  cancelButtonTitle: @"取消"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}

- (IBAction)addDevice:(UIButton *)sender {
    if (!comboBox.text.length) {
        [AppWindow alertMessage:@"请选择无线网"];
        return;
    }
    if (!password.text.length) {
        [AppWindow alertMessage:@"请输入密码"];
        return;
    }
    if (!self.deviceIP) {
        [AppWindow alertMessage:@"未搜索到设备"];
        return;
    }
    int index = comboBox.selectedIndex;
    NSString *apInfo = [ssidAry objectAtIndex:index];
    NSArray *apInfoAry = [apInfo componentsSeparatedByString:@","];
    NSString *security = [apInfoAry objectAtIndex:3];
    //security = [security stringByReplacingOccurrencesOfString:@"/" withString:@","];
    
    /////////////===============================////////////////
    NSArray *securityAry = [security componentsSeparatedByString:@"/"];
    NSString *authentication = nil;
    NSString *encryption = nil;
    if (securityAry.count) {
        authentication = [securityAry objectAtIndex:0];
        encryption = [securityAry objectAtIndex:1];
    }
    
    
    //初始化udp
    NSError *error = nil;
    self.udpSocket = [[[AsyncUdpSocket alloc] initWithDelegate: self] autorelease];
    [udpSocket bindToPort: 48899 error: &error];
    [udpSocket enableBroadcast:YES error:nil]; //发送广播
    [udpSocket receiveWithTimeout: -1 tag: 96];
    NSString *searchCode = [NSString stringWithFormat:@"AT+WSTRY=%@,%@,%@\r\n",comboBox.text,@"WPAPSK,TKIP",password.text];//AT+WSTRY=SSID,认证方式,加密方式,密码\r\n
    //开始发送
	BOOL res = [udpSocket sendData: [searchCode dataUsingEncoding:NSUTF8StringEncoding]
                             toHost: self.deviceIP
                               port: 48899
                        withTimeout: -1
                                tag: 96];
    if (!res)
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提示"
														message: @"发送失败"
													   delegate: self
											  cancelButtonTitle: @"取消"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

-(void)sta
{
    if (!self.deviceIP) {
        [AppWindow alertMessage:@"未搜索到设备"];
        return;
    }
    if (staRepeatCount>5) {
        if (timer1&&[timer1 isValid]) {
            [timer1 invalidate];
            timer1 = nil;
        }
        return;
    }
    staRepeatCount ++;
    //初始化udp
    NSError *error = nil;
    self.udpSocket = [[[AsyncUdpSocket alloc] initWithDelegate: self] autorelease];
    [udpSocket bindToPort: 48899 error: &error];
    [udpSocket enableBroadcast:YES error:nil]; //发送广播
    [udpSocket receiveWithTimeout: -1 tag: 95];
    NSString *searchCode = @"AT+WMODE=STA\r\n";
    //开始发送
	BOOL res = [udpSocket sendData: [searchCode dataUsingEncoding:NSUTF8StringEncoding]
                            toHost: self.deviceIP
                              port: 48899
                       withTimeout: -1
                               tag: 95];
    if (!res)
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提示"
														message: @"发送失败"
													   delegate: self
											  cancelButtonTitle: @"取消"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}

-(void)reset
{
    if (!self.deviceIP) {
        [AppWindow alertMessage:@"未搜索到设备"];
        return;
    }
    if (resetRepeatCount>5) {
        if (timer2&&[timer2 isValid]) {
            [timer2 invalidate];
            timer2 = nil;
        }
        return;
    }
    resetRepeatCount ++;
    //初始化udp
    NSError *error = nil;
    self.udpSocket = [[[AsyncUdpSocket alloc] initWithDelegate: self] autorelease];
    [udpSocket bindToPort: 48899 error: &error];
    [udpSocket enableBroadcast:YES error:nil]; //发送广播
    [udpSocket receiveWithTimeout: -1 tag: 94];
    NSString *searchCode = @"AT+Z\r\n";
    //开始发送
	BOOL res = [udpSocket sendData: [searchCode dataUsingEncoding:NSUTF8StringEncoding]
                            toHost: self.deviceIP
                              port: 48899
                       withTimeout: -1
                               tag: 94];
    if (!res)
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"提示"
														message: @"发送失败"
													   delegate: self
											  cancelButtonTitle: @"取消"
											  otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
}

#pragma mark -

/**
 * Called when the datagram with the given tag has been sent.
 **/
- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"%s tag %ld", __FUNCTION__, tag);
    switch (tag) {
        case 94:
        {
            if (resetRepeatCount>5) {
                if (timer2&&[timer2 isValid]) {
                    [timer2 invalidate];
                    timer2 = nil;
                }
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
            break;
        case 98:
        {
            [sock closeAfterSending];
        }
            break;
            
        default:
            break;
    }
}

/**
 * Called if an error occurs while trying to send a datagram.
 * This could be due to a timeout, or something more serious such as the data being too large to fit in a sigle packet.
 **/
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"%s tag %ld", __FUNCTION__, tag);
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
    NSString *localIP = [AppWindow localWiFiIPAddress];
    NSString *response = [NSString stringWithFormat:@"%@",data];
    NSString *s = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease];
    NSLog(@"receive => tag %ld\nresponse => %@ \nresponseStr => %@ \nhost => %@",tag,response,s,host);
    if (!localIP) {
        return NO;
    }
    switch (tag) {
        case 99:
        {
            NSRange range = [host rangeOfString:localIP];
            if(range.location==NSNotFound)
            {
                if (!self.deviceIP) {
                    self.deviceIP = host;
                    //[self command:nil];
                    //[self scan:nil];
                    NSLog(@" deviceIP %@",deviceIP);
                    [sock closeAfterReceiving];
                    return YES;
                }
            }
            response = [AppWindow stringFromHexString:response];
            
            
        }
            break;
        case 98:
        {
            //[sock closeAfterReceiving];
            //return YES;
        }
            break;
        case 97:
        {
            if (s&&s.length>1) {
                if (![s hasPrefix:@"+ok"]) {
                    [ssidAry addObject:s];
                }
            }else
            {
                NSMutableArray *ssids = [NSMutableArray array];
                for(NSString *str in ssidAry)
                {
                    NSArray *a = [str componentsSeparatedByString:@","];
                    [ssids addObject:[a objectAtIndex:1]];
                }
                comboBox.comboBoxDatasource = ssids;
                comboBox.canBeActive = YES;
                //comboBox.dele = self;
                comboBox.comboRowHeight = 27;
                comboBox.comboHeight = 162;
                comboBox.placeholder = @"请选择";
            }
            //[sock closeAfterReceiving];
            //return YES;
        }
            break;
        case 96:
        {
            if ([s hasPrefix:@"+ok=TRY OK"]) {
                timer1 = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(sta) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:timer1 forMode:NSRunLoopCommonModes];
                //[self sta];
            }else
            {
                [AppWindow alertMessage:@"连接失败"];
            }
        }
            break;
        case 95:
        {
            if ([s hasPrefix:@"+ok"]) {
                staRepeatCount = 6;
                timer2 = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(reset) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:timer2 forMode:NSRunLoopCommonModes];
                //[self reset];
            }else
            {
                
            }
        }
            break;
        case 94:
        {
            
        }
            break;
        case 0:
        {
            
        }
        default:
            break;
    }
//    if (tag==99) {
//        
//    }else
//    {
//        response = [response stringByReplacingOccurrencesOfString:@" " withString:@""];
//        response = [response substringWithRange:NSMakeRange(1, response.length-2)];
//        NSString *responseHead = [response substringWithRange:NSMakeRange(0, 4)];
//        responseHead = [AppWindow stringFromHexString:responseHead];
//        NSString *responseMac = [response substringWithRange:NSMakeRange(6, 12)];
//        NSLog(@"responseMac %@",responseMac);
//        NSString *responseSecretKey = [response substringWithRange:NSMakeRange(18, 12)];
//        NSLog(@"responseSecretKey %@",responseSecretKey);
//        NSString *status = [response substringWithRange:NSMakeRange(19, 2)];
//        NSLog(@"status %@",status);
//        response = [AppWindow stringFromHexString:response];
//        NSLog(@"responseHead %@",responseHead);
//        NSString *s = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease];
//        NSLog(@"didReceiveData, host = %@, tag = %ld dataString = %@", host, tag,s);
//    }
    
    
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
    if (hasCommond) {
        [self scan:nil];
    }
    if (!hasCommond) {
        [self command:nil];
        hasCommond = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
