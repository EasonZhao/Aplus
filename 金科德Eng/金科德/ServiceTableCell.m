//
//  ServiceTableCell.m
//  金科德
//
//  Created by Yangliu on 13-9-8.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "ServiceTableCell.h"

@implementation ServiceTableCell
@synthesize imgV;
@synthesize nameLbl;

- (void)dealloc
{
    [nameLbl release];
    [imgV release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
