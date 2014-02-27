//
//  MeScrollView.m
//  MeAppVideo
//
//  Created by absir on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MeScrollView.h"

@implementation MeScrollView
@synthesize conView = conView_;

//释放对象
- (void)dealloc
{
    [conView_ release];
    [super dealloc];
}

//设置Scroll内容视图
- (void)setConView:(UIView *)conView
{
    [conView retain];
    [conView_ release];
    conView_ = conView;
    
    [self addSubview:conView];
    self.contentSize = conView.bounds.size;
}

@end
