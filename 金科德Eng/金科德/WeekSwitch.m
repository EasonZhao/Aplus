//
//  WeekSwitch.m
//  TestUdpClient
//
//  Created by Yangliu on 13-10-17.
//  Copyright (c) 2013年 e-linkway.com. All rights reserved.
//

#import "WeekSwitch.h"

@interface WeekSwitch ()
{
    Byte week;
}
@end

@implementation WeekSwitch

- (id)init
{
    self = [super init];
    if (self) {
        week = 0xff;
    }
    return self;
}

-(void)enable
{
    week|=0x80;
}

-(void)openSu
{
    week|=0x40;
}

-(void)openSa
{
    week|=0x20;
}

-(void)openFr
{
    week|=0x10;
}

-(void)openTh
{
    week|=0x08;
}

-(void)openWe
{
    week|=0x04;
}

-(void)openTu
{
    week|=0x02;
}

-(void)openMo
{
    week|=0x01;
}

-(void)disable
{
    week=(week&(~0x80));
}

-(void)closeSu
{
    week=(week&(~0x40));
}

-(void)closeSa
{
    week=(week&(~0x20));
}

-(void)closeFr
{
    week=(week&(~0x10));
}

-(void)closeTh
{
    week=(week&(~0x08));
}

-(void)closeWe
{
    week=(week&(~0x04));
}

-(void)closeTu
{
    week=(week&(~0x02));
}

-(void)closeMo
{
    week=(week&(~0x01));
}

-(Byte)getWeek
{
    return week;
}

-(void)setWeek:(Byte)week_
{
    week = week_;
}

@end
