//
//  MeAccessoryView.m
//  MeAppOA
//
//  Created by absir on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MeAccessoryView.h"

#import "AppWindow.h"

//取消 确定|清除导航条
@implementation MeAccessoryToolBar
@synthesize leftItem;
@synthesize rightItem;

//取消
- (IBAction)leftItemClick:(id)sender
{
    [_responder resignFirstResponder];
}

//确定|清除
- (IBAction)rightItemClick:(id)sender
{
    if([(UIBarItem *)sender tag]){
        [_responder sendActionsForControlEvents:UIControlEventTouchUpInside];
    } else {
        if([_responder isKindOfClass:[UITextField class]] || [_responder isKindOfClass:[UITextView class]]){
            [(UITextField *)_responder setText:@""];
        }
    }
}

//设置方法
- (void)setAccessoryResponder:(UIControl *)responder
{
    if(_responder == responder) return;
    
    if(leftItem.target != self){
        leftItem.title = @"取消";
        leftItem.target = self;
        rightItem.target = self;
        leftItem.action = @selector(leftItemClick:);
        rightItem.action = @selector(rightItemClick:);
    }
    
    _responder = responder;
    if([_responder isKindOfClass:[UITextField class]]){
    
        NSSet *targets = [responder allTargets];
        rightItem.tag = FALSE;
        for(id target in targets){
            
            NSArray *ary = [responder actionsForTarget:target forControlEvent:UIControlEventTouchUpInside];
            if([ary count]){
                rightItem.tag = TRUE;
                break;
            }
        }
        
    } else {
        
        rightItem.tag = FALSE;
    }
    
    rightItem.title = rightItem.tag?@"确定":@"清除";
}

@end


//上一个->下一个 导航条
@implementation NextAccessoryToolBar

//上一个
- (IBAction)leftItemClick:(id)sender
{
    [preResponder becomeFirstResponder];
}
//下一个
- (IBAction)secendItemClick:(id)sender
{
    [nextResPonder becomeFirstResponder];
}
//确定、取消
- (IBAction)rightItemClick:(id)sender
{
    if([(UIBarItem *)sender tag]){
        [_responder sendActionsForControlEvents:UIControlEventTouchUpInside];
    } else {
        [_responder resignFirstResponder];
    }
}
- (void)setAccessoryResponder:(UIControl *)responder
{
    [super setAccessoryResponder:responder];
    rightItem.title = rightItem.tag?@"确定":@"取消";
    
    AppWindow *appWindow = [AppWindow shared];
    NSArray *children = [appWindow getHashChildren:[responder superview]];
    
    int len = [children count];
    int idx = [children indexOfObject:responder];
    preResponder = idx > 0 ? [children objectAtIndex:idx-1]:NULL;
    [leftItem setEnabled:preResponder != NULL];
    
    nextResPonder = ++idx < len?[children objectAtIndex:idx]: NULL;
    [secendItem setEnabled:nextResPonder != NULL];
}

@end

