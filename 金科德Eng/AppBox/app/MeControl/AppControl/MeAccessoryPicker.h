//
//  MeAccessoryPicker.h
//  MeAppBox
//
//  Created by absir on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MeAccessoryPickerDelegate <NSObject>

@property(nonatomic, assign)UIButton *accesoryButton;

+ (id)currentPicker;

- (void)clickItemOK;

@end

@interface MeDatePicker : UIDatePicker<MeAccessoryPickerDelegate>
{
    NSDateFormatter *dateFormatter;
}

@end