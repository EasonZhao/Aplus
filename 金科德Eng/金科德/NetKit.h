//
//  NetKit.h
//  POTEK
//
//  Created by Eason Zhao on 14-4-18.
//  Copyright (c) 2014年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AAdapter.h"
#import "AsyncUdpSocket.h"

@protocol NetKitDelegate <NSObject>

- (void)checkSearchCodeHandler:(BOOL)success Devs:(NSMutableArray*)devs;

- (void)switchDeviceHandler:(BOOL)success devID:(Byte)devID stat:(enum DevState)stat;

@end

//网关通信使用
@interface NetKit : NSObject

- (id)init;

- (void)checkSearchCode:(id)delegate;

//开关量命令
- (void)switchDevice:(BOOL)isOn devID:(Byte)devID delegate:(id)delegate;

+ (NetKit*)instance;

@end
