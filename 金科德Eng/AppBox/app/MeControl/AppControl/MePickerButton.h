//
//  MeButtonPicker.h
//  MeAppOA
//
//  Created by absir on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeAccessoryPicker.h"

@interface MePickerButton : UIButton<UIPickerViewDelegate>
{
    BOOL isResponder;
    UIView *accessroyView;
}
@property(nonatomic, retain)IBOutlet UIControl<MeAccessoryPickerDelegate> *mePicker;

//软键盘工具条类型
- (int)accessoryViewType;

@end

@interface MeDatePickerButton : MePickerButton
{

}
@end

@interface NextPickerButton : MePickerButton<UIPickerViewDelegate>
{
    
}

@end

@interface NextDatePickerButton : NextPickerButton
{
    
}
@end

@interface NextSegmented : UISegmentedControl
{

}

@end
