//
//  UdpSocket.h
//  金科德
//
//  Created by Yangliu on 13-10-18.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncUdpSocket.h"

@interface UdpSocket : NSObject
@property (nonatomic, retain) AsyncUdpSocket *udpSocket;
@property (nonatomic, retain) NSData *netMac;

//设置网关的ip地址，从广播模式切换到udp端对端
-(BOOL)setNetIp:(NSString*)ip;

//静态返回
//+ (id)shared;
-(id)initWithDelegate:(id)delegate_;
-(void)link;

//状态查询
-(void)checkStatus;

//开关量命令
- (void)switchDevice:(BOOL)isOn devID:(Byte)devID;

/*
//定时
-(void)timingDevice:(NSString *)mac enable:(BOOL)enable weekON:(Byte)weekON hourON:(Byte)hourON hourRand:(BOOL)rand minON:(Byte)minON weekOFF:(Byte)weekOFF hourOFF:(Byte)hourOFF minOFF:(Byte)minOFF;
//定时组
-(void)timingDevice:(NSString *)mac timing:(NSArray*)ary;

//倒计时
-(void)countDownDevice:(NSString*)mac enable:(BOOL)enable hour:(Byte)hour min:(Byte)min sec:(Byte)sec;
*/
-(void)checkSearchCode;

-(void)addDevice;
@end
