//
//  MeButtonPicker.m
//  MeAppOA
//
//  Created by absir on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MePickerButton.h"

#import "AppWindow.h"
#import "MeAccessoryPicker.h"

@implementation MePickerButton
@synthesize mePicker;

//初始化对象
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder])){
        [self removeTarget:self action:@selector(pickerBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(pickerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])){
        [self removeTarget:self action:@selector(pickerBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(pickerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

//释放对象
- (void)dealloc
{
    [mePicker release];
    [super dealloc];
}

//选择方法
- (void)pickerBtnClick
{
    if(!mePicker) return;
    
    AppWindow *appWindow = [AppWindow shared];
    
    //获取是否有类似输入框
    accessroyView = NULL;
    if(appWindow.accessoryView){
        if(appWindow.accessoryView == mePicker){
            
            accessroyView = appWindow.accessoryView;
        } else {
            NSArray *views = [appWindow.accessoryView subviews];
            if([views count] == 2){
                
                if([views objectAtIndex:1] == mePicker){
                    
                    MeAccessoryToolBar *accessoryToolBar = [views objectAtIndex:0];
                    if([accessoryToolBar isKindOfClass:[MeAccessoryToolBar class]]){
                        [accessoryToolBar setAccessoryResponder:self];
                    }
                    
                    accessroyView = appWindow.accessoryView;
                }
            }
        }
    }
    
    //如果发现同类输入框
    if(accessroyView){
        if(mePicker.accesoryButton == self){
            if(!isResponder){
                [self resignFirstResponder];
            }
        } else {
            mePicker.accesoryButton = self;
        }
    }
    //如果没有同类输入框
    else{
        
        MeAccessoryToolBar *accessoryToolBar = [[AppWindow shared] accessoryToolBarAtType:[self accessoryViewType]];
        if(accessoryToolBar){
            [accessoryToolBar setAccessoryResponder:self];
            
            CGRect frame = accessoryToolBar.bounds;
            frame.size.height += mePicker.bounds.size.height;
            accessroyView = [[[UIView alloc] initWithFrame:frame] autorelease];
            
            accessoryToolBar.frame = accessoryToolBar.bounds;
            [accessroyView addSubview:accessoryToolBar];
            
            CGRect rect = mePicker.bounds;
            rect.origin.x = (frame.size.width - rect.size.width) * 0.5f;
            rect.origin.y += accessoryToolBar.bounds.size.height;
            mePicker.frame = rect;
            [accessroyView addSubview:mePicker];
            
        } else {
            
            accessroyView = mePicker;
        }
    
        [mePicker setAccesoryButton:self];
        [appWindow accessoryAnimationInView:accessroyView Responder:self];
    }
}

//Picker工具条类型
- (int)accessoryViewType
{
    return assryTyp_normal;
}

//激活按钮
- (BOOL)becomeFirstResponder
{
    isResponder = TRUE;
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    isResponder = FALSE;
    return [super becomeFirstResponder];
}

//激活按钮
- (BOOL)resignFirstResponder
{
    [AppWindow accessoryAnimationOutView:accessroyView];
    accessroyView = NULL;
    return [super resignFirstResponder];
}

@end

@implementation MeDatePickerButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder])){
        self.mePicker = [MeDatePicker currentPicker];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])){
        self.mePicker = [MeDatePicker currentPicker];
    }
    return self;
}

@end

@implementation NextPickerButton

//选择方法
- (void)pickerBtnClick
{
    [[AppWindow shared] becomeActive:self];
    [super pickerBtnClick];
}

- (BOOL)resignFirstResponder
{
    [[AppWindow shared] resignActiveResponder];
    return [super resignFirstResponder];
}

//Picker工具条类型
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

@implementation NextDatePickerButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder])){
        self.mePicker = [MeDatePicker currentPicker];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])){
        self.mePicker = [MeDatePicker currentPicker];
    }
    return self;
}

@end


@implementation NextSegmented

//激活
- (BOOL)becomeFirstResponder
{
    [[AppWindow shared] becomeActive:self];
    
    AppWindow *appWindow = [AppWindow shared];
    if(appWindow.accessoryView){
        NSArray *ary = [appWindow.accessoryView subviews];
        if([ary count]){
            MeAccessoryToolBar *toolBar = [ary objectAtIndex:0];
            if([toolBar isKindOfClass:[MeAccessoryToolBar class]]){
                [toolBar setAccessoryResponder:self];
            }
        }
    } else if(appWindow.inputToolBar){
        [appWindow.inputToolBar setAccessoryResponder:self];
    }
    
    return [super becomeFirstResponder];
}

//失去焦点
- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents
{
    if(controlEvents & UIControlEventTouchUpInside){
        [[AppWindow shared] resignActiveResponder];
    }
    
    [super sendActionsForControlEvents:controlEvents];
}

- (BOOL)resignFirstResponder
{
    [[AppWindow shared] resignActive:self];
    return [super resignFirstResponder];
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

