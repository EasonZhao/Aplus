//
//  MeTextField.h
//  MeAppBox
//
//  Created by absir on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//自定义 文本输入框
@interface MeTextField : UITextField
{
    
}

//Picker工具条类型
- (int)accessoryViewType;

//自动滚动 0 不动 1滚动 －1自动遮罩
- (int)autoScrollType;

@end


//上一个->下一个 文本输入框
@interface MeNextField : MeTextField
{
    
}
@end


//最大字符限制输入框
#define MAX_INPUT_DETAILS   @"还可以输入%d个字符"
@interface MeLengthField : MeTextField
{
    
}
@property(nonatomic, retain)IBOutlet UILabel *lengthLabel;

@end

//自定义 输入区域
@interface MeTextView : UITextView
{
    
}

//Picker工具条类型
- (int)accessoryViewType;

//自动滚动 0 不动 1滚动 －1自动遮罩
- (int)autoScrollType;

@end


@interface MeLengthView : MeTextView
{
    bool registerNotice;
}
@property(nonatomic, retain)IBOutlet UILabel *lengthLabel;

@end


