//
//  ComboboxPicker.h
//  POTEK
//
//  Created by Eason Zhao on 14-6-8.
//  Copyright (c) 2014年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "MeTextField.h"

@interface ComboboxPicker : MeNextField<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *picker;
    UIToolbar *toolbar;
}


@end
