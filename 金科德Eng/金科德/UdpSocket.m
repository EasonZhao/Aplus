//
//  UdpSocket.m
//  金科德
//
//  Created by Yangliu on 13-10-18.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "UdpSocket.h"
#import "AppBox.h"

#define SERVER_IP    @"255.255.255.255"
#define SERVER_PORT  18890
@implementation UdpSocket
@synthesize udpSocket;

static id _shared_ = NULL;

- (void)dealloc
{
    [udpSocket release];
    [super dealloc];
}

//静态返回
+ (id)shared
{
	@synchronized(self)
	{
		if (!_shared_)
			_shared_ = [[self alloc] init];
		return _shared_;
	}
}

- (id)init
{
    self = [super init];
    if (self) {
        //初始化udp
        self.udpSocket = [[[AsyncUdpSocket alloc] initWithDelegate:self] autorelease];
        
        NSError *error = nil;
        
        [self.udpSocket bindToPort: SERVER_PORT error: &error];
        [self.udpSocket enableBroadcast:YES error:nil]; //发送广播
        [udpSocket receiveWithTimeout: -1 tag: 0];
    }
    return self;
}

-(id)initWithDelegate:(id)delegate_
{
    self = [super init];
    if (self) {
        //初始化udp
        self.udpSocket = [[[AsyncUdpSocket alloc] initWithDelegate: delegate_?delegate_:self] autorelease];
        
        NSError *error = nil;
        
        [self.udpSocket bindToPort: SERVER_PORT error: &error];
        [self.udpSocket enableBroadcast:YES error:nil]; //发送广播
        [udpSocket receiveWithTimeout: -1 tag: 0];
    }
    return self;
}

-(void)link:(NSString *)mac
{
    Byte byte[18] = {0x00};
    byte[0] = 0x41;
    byte[1] = 0x54;
    byte[2] = 0x10;
    byte[15] = 0xa1;
    byte[16] = 0x01;
    byte[17] = 0xfe;
	[self sendData:[NSData dataWithBytes:byte length:18]];
}

//状态查询
-(void)checkStatus:(NSString *)mac
{
    Byte byte[18] = {0x00};
    byte[0] = 0x41;
    byte[1] = 0x54;
    byte[2] = 0x10;
    byte[15] = 0xa2;
    byte[16] = 0x01;
    byte[17] = 0xfe;
	[self sendData:[NSData dataWithBytes:byte length:18]];
}

- (void)switchDevice:(NSString *)mac status:(BOOL)isOn
{
    Byte byte[18] = {0x00};
    byte[0] = 0x41;
    byte[1] = 0x54;
    byte[2] = 0x10;
    if (mac&&mac.length>=12) {
        byte[3] = [[mac substringWithRange:NSMakeRange(0, 2)] intValue];
        byte[4] = [[mac substringWithRange:NSMakeRange(2, 2)] intValue];
        byte[5] = [[mac substringWithRange:NSMakeRange(4, 2)] intValue];
        byte[6] = [[mac substringWithRange:NSMakeRange(6, 2)] intValue];
        byte[7] = [[mac substringWithRange:NSMakeRange(8, 2)] intValue];
        byte[8] = [[mac substringWithRange:NSMakeRange(10, 2)] intValue];
    }
    byte[15] = 0x01;
    byte[17] = 0xfe;
    
    if (isOn) {
        byte[16] = 0x00;
        [self sendData:[NSData dataWithBytes:byte length:18]];
    }else
    {
        byte[16] = 0x01;
        [self sendData:[NSData dataWithBytes:byte length:18]];
    }
}

//定时
-(void)timingDevice:(NSString *)mac enable:(BOOL)enable weekON:(Byte)weekON hourON:(Byte)hourON hourRand:(BOOL)rand minON:(Byte)minON weekOFF:(Byte)weekOFF hourOFF:(Byte)hourOFF minOFF:(Byte)minOFF
{
    if (hourON>24||hourOFF>24) {
        NSLog(@"定时小时数大于24");
        return;
    }
    if (minON>60||minOFF>60) {
        NSLog(@"定时分钟数大于60");
        return;
    }
    Byte byte[77] = {0};
    byte[0] = 0x41;
    byte[1] = 0x54;
    if (mac&&mac.length>=12) {
        byte[3] = [[mac substringWithRange:NSMakeRange(0, 2)] intValue];
        byte[4] = [[mac substringWithRange:NSMakeRange(2, 2)] intValue];
        byte[5] = [[mac substringWithRange:NSMakeRange(4, 2)] intValue];
        byte[6] = [[mac substringWithRange:NSMakeRange(6, 2)] intValue];
        byte[7] = [[mac substringWithRange:NSMakeRange(8, 2)] intValue];
        byte[8] = [[mac substringWithRange:NSMakeRange(10, 2)] intValue];
    }
    
    byte[15] = 0x02;
    //    NSData* bytes = [[self ToHex:22] dataUsingEncoding:NSUTF8StringEncoding];
    //    Byte * myByte = (Byte *)[bytes bytes];
    if (enable) {
        weekON |= 0x80;
    }
    byte[16] = weekON;
    byte[17] = hourON;
    byte[18] = minON;
    byte[19] = weekOFF;
    byte[20] = hourOFF;
    byte[21] = minOFF;
    [self sendData:[NSData dataWithBytes:byte length:77]];
}

//定时
-(void)timingDevice:(NSString *)mac timing:(NSArray*)ary
{
    if (ary.count>10) {
        NSLog(@"定时组数大于10");
        return;
    }
    Byte byte[77] = {0};
    byte[0] = 0x41;
    byte[1] = 0x54;
    if (mac&&mac.length>=12) {
        byte[3] = [[mac substringWithRange:NSMakeRange(0, 2)] intValue];
        byte[4] = [[mac substringWithRange:NSMakeRange(2, 2)] intValue];
        byte[5] = [[mac substringWithRange:NSMakeRange(4, 2)] intValue];
        byte[6] = [[mac substringWithRange:NSMakeRange(6, 2)] intValue];
        byte[7] = [[mac substringWithRange:NSMakeRange(8, 2)] intValue];
        byte[8] = [[mac substringWithRange:NSMakeRange(10, 2)] intValue];
    }
    byte[15] = 0x02;
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dic = [ary objectAtIndex:i];
        BOOL enable = [[dic objectForKey:@"enable"] boolValue];
        Byte week = [[dic objectForKey:@"week"] intValue];
        Byte weekON = week;
        Byte weekOFF = week;
        Byte hourON = [[dic objectForKey:@"hourON"] intValue];
        Byte minON = [[dic objectForKey:@"minON"] intValue];
        Byte hourOFF = [[dic objectForKey:@"hourOFF"] intValue];
        Byte minOFF = [[dic objectForKey:@"minOFF"] intValue];
        if (enable) {
            weekON |= 0x80;
        }
        byte[16+i*6] = weekON;
        byte[17+i*6] = hourON;
        byte[18+i*6] = minON;
        byte[19+i*6] = weekOFF;
        byte[20+i*6] = hourOFF;
        byte[21+i*6] = minOFF;
    }
    
    [self sendData:[NSData dataWithBytes:byte length:77]];
}

//倒计时
-(void)countDownDevice:(NSString*)mac enable:(BOOL)enable hour:(Byte)hour min:(Byte)min sec:(Byte)sec
{
    if (hour>99) {
        NSLog(@"倒计时小时数%d > 99",hour);
        return;
    }
    if (min>60) {
        NSLog(@"倒计时分钟数%d > 60",hour);
        return;
    }
    if (sec>60) {
        NSLog(@"倒计时秒数%d > 60",hour);
        return;
    }
    Byte byte[20] = {0};
    byte[0] = 0x41;
    byte[1] = 0x54;
    byte[2] = 0x12;
    if (mac&&mac.length>=12) {
        byte[3] = [[mac substringWithRange:NSMakeRange(0, 2)] intValue];
        byte[4] = [[mac substringWithRange:NSMakeRange(2, 2)] intValue];
        byte[5] = [[mac substringWithRange:NSMakeRange(4, 2)] intValue];
        byte[6] = [[mac substringWithRange:NSMakeRange(6, 2)] intValue];
        byte[7] = [[mac substringWithRange:NSMakeRange(8, 2)] intValue];
        byte[8] = [[mac substringWithRange:NSMakeRange(10, 2)] intValue];
    }
    byte[15] = 0x03;
    byte[19] = 0xfe;
    if (enable) {
        hour|=0x80;
    }else
    {
        hour&=0x7f;
    }
    byte[16] = hour;
    byte[17] = min;
    byte[18] = sec;
    [self sendData:[NSData dataWithBytes:byte length:20]];
}

//查询搜索码
- (IBAction)checkSearchCode:(UIButton *)sender {
    NSString *checkSearchCode = @"AT+ASWD";
    [self sendData:[checkSearchCode dataUsingEncoding:NSUTF8StringEncoding]];
}

- (IBAction)smartlink:(UIButton *)sender {
    NSString *searchCode = @"HF-A11ASSISTHREAD";
    [self sendData:[searchCode dataUsingEncoding:NSUTF8StringEncoding]];
}

//发送短消息
-(void)sendData:(NSData*)data
{
    //开始发送
	BOOL res = [self.udpSocket sendData: data
								 toHost: SERVER_IP
								   port: SERVER_PORT
							withTimeout: -1
									tag: 1];
    
	if (!res)
    {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"UDP"
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
//    Byte *byte = (Byte*)[data bytes];
//    for (int i=0; i < [data length]; i++) {
//        NSLog(@"testByte = %d\n",byte[i]);
//    }
//    NSLog(@"localHost %@",[self.udpSocket localHost]);
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
@end
