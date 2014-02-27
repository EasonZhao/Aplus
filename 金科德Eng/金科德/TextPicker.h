//
//  TextPicker.h
//  Cycon
//
//  Created by Yangliu on 13-3-26.
//  Copyright (c) 2013年 Yangliu. All rights reserved.
//

#import "MeTextField.h"

@interface TextPicker : MeNextField<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *picker;
    UIToolbar *toolbar;
}

@property(nonatomic,retain)NSArray *dataAry;
@property(nonatomic,retain)NSString *selectedText;


@end
