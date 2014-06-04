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

typedef struct
{
    int weekday;
    int onHour;
    int onMin;
    int offHour;
    int offMin;
}WeekDaySet;

@protocol NetKitDelegate <NSObject>

- (void)checkSearchCodeHandler:(BOOL)success Devs:(NSMutableArray*)devs;

- (void)switchDeviceHandler:(BOOL)success devID:(Byte)devID;

- (void)addDeviceHandler:(BOOL)success;

- (void)delDeviceHandler:(BOOL)success devID:(Byte)devID;

- (void)allOnOffHandler;

- (void)countdownHandler:(BOOL)success devID:(Byte)devID;

- (void)setTimerHandler:(BOOL)success devID:(Byte)devID;

@end

//网关通信使用
@interface NetKit : NSObject

- (id)init;

- (void)checkSearchCode:(id)delegate;

//开关量命令
- (void)switchDevice:(BOOL)isOn devID:(Byte)devID delegate:(id)delegate;

- (void)countDown:(Byte)devID isOn:(BOOL)isOn hours:(int)hours
              min:(int)min sec:(int)sec enable:(BOOL)enable delegate:(id)delegate;

- (void)setTimer:(Byte)devID weekdays:(NSMutableArray*)weekdays delegate:(id)delegate;

- (void)addDevice:(id)delegate;

- (void)delDevice:(Byte)devID delegate:(id)delegate;

- (void)allOn;

- (void)allOff;

+ (NetKit*)instance;

@property(nonatomic, retain)id onOffDelegate;

@end
