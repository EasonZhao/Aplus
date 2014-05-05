//
//  AAdapter.h
//  POTEK
//
//  Created by Eason Zhao on 14-3-1.
//  Copyright (c) 2014年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UdpSocket.h"

enum DevState
{
    ADA_ON = 0,
    ADA_OFF
};

@interface AAdapter : NSObject


@property(nonatomic, retain) NSString *name;

@property(nonatomic, retain) NSString *ico;

@property(nonatomic, retain) UdpSocket *socket;

@property(nonatomic)int devID;


- (id)initWithData:(NSData*)data;

- (void)deleteThisAdapter;

- (int)getState;

@end
