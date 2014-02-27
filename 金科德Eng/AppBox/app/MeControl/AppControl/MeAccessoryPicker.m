//
//  MeAccessoryPicker.m
//  MeAppBox
//
//  Created by absir on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MeAccessoryPicker.h"

@implementation MeDatePicker
@synthesize accesoryButton;
static id _meDataPicker_ = NULL;

+ (id)currentPicker
{
    if(!_meDataPicker_){
        _meDataPicker_ = [[[self alloc] initWithFrame:CGRectNull] autorelease];
    }
    return _meDataPicker_;
}

- (void)setAccesoryButton:(UIButton *)button
{
    if(accesoryButton == button) return;
    
    accesoryButton = button;
    switch (button.tag) {
        case UIDatePickerModeDate:
            
            break;
        case UIDatePickerModeDateAndTime:
            
            break;
        case UIDatePickerModeCountDownTimer:
            
            break;
        default:
            
            break;
    }
}

- (void)clickItemOK
{
    
}

- (void)dealloc
{
    if(self == _meDataPicker_){
        _meDataPicker_ = NULL;
    }
    [super dealloc];
}

@end


