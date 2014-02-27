//
//  MeTextField.m
//  MeAppBox
//
//  Created by absir on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MeTextField.h"

#import "AppWindow.h"

//自定义 文本输入框
@implementation MeTextField

//初始化对象
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        self.delegate = [AppWindow shared];
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame]))
    {
        self.delegate = [AppWindow shared];
        
    }
    return self;
}

//软键盘工具条类型
- (int)accessoryViewType
{
    return assryTyp_normal;
}

//自动滚动
- (int)autoScrollType
{
    return self.tag%2;
}

- (BOOL)becomeFirstResponder
{
    if([self autoScrollType]){
        [[AppWindow shared] becomeActive:self];
    }
    
    if([self isFirstResponder]){
        [self.delegate textFieldShouldBeginEditing:self];
    }
    
    return [super becomeFirstResponder];
}
- (BOOL)resignFirstResponder
{
    if([self autoScrollType]){
        [[AppWindow shared] resignActive:self];
    }
    return [super resignFirstResponder];
}

@end

//上一个->下一个 文本输入框
@implementation MeNextField

//自动滚动
- (int)autoScrollType
{
    return 1;
}

//软键盘工具条类型
- (int)accessoryViewType
{
    return assryTyp_next;
}

//设置上一个,下一个数组
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    UIView *superview = self.superview;
    AppWindow *appWindow = [AppWindow shared];
    
    if(superview)
    {
        [appWindow removeHashParent:superview :self];
    }
    
    if(newSuperview)
    {
        [appWindow addHashParent:newSuperview :self];
    }
}

@end

//最大字符限制输入框
@implementation MeLengthField
@synthesize lengthLabel;

- (void)dealloc
{
    [lengthLabel release];
    [super dealloc];
}

- (void)textFieldDidChange
{
    NSString *txt = [self text];
    NSUInteger len = txt.length;
    if(len>lengthLabel.tag){
        len = lengthLabel.tag;
        self.text = [txt substringToIndex:len];
    }else{
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    [lengthLabel setText:[NSString stringWithFormat:MAX_INPUT_DETAILS,lengthLabel.tag-len]];
}

- (void)setLengthLabel:(UILabel *)label
{
    [label retain];
    [lengthLabel release];
    if(![self actionsForTarget:self forControlEvent:UIControlEventEditingChanged]){
        [self addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    }
    lengthLabel = label;
    
    [label setText:[NSString stringWithFormat:MAX_INPUT_DETAILS,label.tag-[self text].length]];
}

@end

//自定义 输入区域
@implementation MeTextView

//初始化对象
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder]))
    {
        self.delegate = [AppWindow shared];
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame]))
    {
        self.delegate = [AppWindow shared];
        
    }
    return self;
}

//软键盘工具条类型
- (int)accessoryViewType
{
    return assryTyp_normal;
}

//自动滚动
- (int)autoScrollType
{
    return self.tag%2;
}

@end


//最大字符限制输入框
@implementation MeLengthView
@synthesize lengthLabel;

- (void)dealloc
{
    if(registerNotice){
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    [lengthLabel release];
    [super dealloc];
}

- (void)setLengthLabel:(UILabel *)label
{
    [label retain];
    [lengthLabel release];
    
    if(!registerNotice){
        
        registerNotice = TRUE;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:self];
    }
    lengthLabel = label;
    
    [label setText:[NSString stringWithFormat:MAX_INPUT_DETAILS,label.tag-[self text].length]];
}

- (void)textViewTextDidChangeNotification:(NSNotification *)aNotification
{
    if(aNotification.object == self){
        
        NSString *txt = [self text];
        NSUInteger len = txt.length;
        if(len>lengthLabel.tag){
            len = lengthLabel.tag;
            self.text = [txt substringToIndex:len];
        }
        
        [lengthLabel setText:[NSString stringWithFormat:MAX_INPUT_DETAILS,lengthLabel.tag-len]];
    }
}

@end


