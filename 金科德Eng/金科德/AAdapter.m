//
//  AAdapter.m
//  POTEK
//
//  Created by Eason Zhao on 14-3-1.
//  Copyright (c) 2014年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "AAdapter.h"
#import "DBInterface.h"

NSString *defaultName = @"SOCKET";
NSString *defaultIco = @"插座图标.png";
//插座数据结构
@implementation AAdapter
{
    enum DevState stat_;
    int type_;
}

@synthesize name = _name;

@synthesize ico = _ico;
@synthesize socket = _socket;

@synthesize devID = _devID;

- (id)initWithData:(NSData *)data
{
    if (self = [super init]) {
        
        Byte *pData = (Byte*)[data bytes];
        self.devID = pData[0];
        if (pData[2]==0x01) {
            stat_ = ADA_ON;
        } else if (pData[2]==0x00) {
            stat_ = ADA_OFF;
        }
        if (![[DBInterface instance] AdapterExist:self.devID]) {
            self.name = defaultName;
            self.ico = defaultIco;
            //添加默认信息
            BOOL ret = [[DBInterface instance] insertAdapter:self.devID name:self.name ico:self.ico type:pData[1]];
            assert(ret);
        } else {
            NSString* nameStr = nil;
            NSString* icoStr = nil;
            int tmpType = 0;
            BOOL ret = [[DBInterface instance] getAdapter:self.devID name:&nameStr ico:&icoStr type:&tmpType];
            assert(ret);
            self.name = nameStr;
            self.ico = icoStr;
            type_ = tmpType;
        }
    }
    return self;
}

- (BOOL)insertToDB
{
    
    return YES;
}

- (void)deleteThisAdapter
{
    [[DBInterface instance] deleteAdapter:self.devID];
}

- (int)getState
{
    return stat_;
}

@end
