//
//  AAdapter.m
//  POTEK
//
//  Created by Eason Zhao on 14-3-1.
//  Copyright (c) 2014年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "AAdapter.h"
#import "DBInterface.h"

//插座数据结构
@implementation AAdapter
{
    int _id;
    enum DevState stat_;
}

@synthesize name = _name;

@synthesize ico = _ico;

- (id)initWithData:(NSData *)data
{
    if (self = [super init]) {
        Byte *pData = (Byte*)[data bytes];
        _id = pData[0];
        if (pData[2]==0x01) {
            stat_ = ADA_ON;
        } else if (pData[2]==0x00) {
            stat_ = ADA_OFF;
        }
    }
    return self;
}

- (void)setId:(int)id
{
    _id = id;
}

- (void)deleteThisAdapter
{
    [[DBInterface instance] deleteAdapter:_id];
}

- (int)getState
{
    return stat_;
}

@end
