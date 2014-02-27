//
//  MeProccessView.m
//  MeAppBox
//
//  Created by absir on 12-5-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MeProccessView.h"

#import "AppWindow.h"

@implementation MeProccessView
@synthesize proccess;

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])) {
        completeWidth = self.frame.size.width;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder])){
        completeWidth = self.frame.size.width;
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    [AppWindow setStretchable:self];
}

- (void)setProccess:(float)pos
{
    if(pos<0 || pos>1) return;
    
    CGRect frame = self.frame;
    frame.size.width = completeWidth*(proccess = pos);
    [self setFrame:frame];
}

@end
