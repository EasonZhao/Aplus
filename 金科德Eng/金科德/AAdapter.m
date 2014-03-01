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
}

@synthesize name = _name;

@synthesize ico = _ico;

- (void)setId:(int)id
{
    _id = id;
}

- (void)deleteThisAdapter
{
    [[DBInterface instance] deleteAdapter:_id];
}
@end
