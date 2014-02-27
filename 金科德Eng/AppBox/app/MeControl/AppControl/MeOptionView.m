//
//  MeOptionView.m
//  MeAppBox
//
//  Created by absir on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MeOptionView.h"

@implementation MeOptionView
@synthesize selectIndex;

- (void)dealloc
{
    [optionBtns release];
    optionBtns = NULL;
    [super dealloc];
}

- (void)selectBtn:(UIButton *)btn
{
    if(selectBtn) [selectBtn setEnabled:TRUE];
    [btn setEnabled:FALSE];
    selectIndex=[optionBtns indexOfObject:btn];
    if(selectIndex<0){
        selectBtn=NULL;
    }else {
        selectBtn=btn;
    }
}

- (void)didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    if(!optionBtns){
        selectIndex = -1;
        optionBtns = [[NSMutableArray alloc] init];
    }
    if([subview isKindOfClass:[UIButton class]]){
        UIButton *btn=(UIButton *)subview;
        [optionBtns addObject:btn];
        [btn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        if(![btn isEnabled]) [self selectBtn:btn];
    }
}
-(void)selectIndex:(int)selectIndex_
{
    selectIndex = selectIndex_;
    if(selectIndex_<optionBtns.count&&selectIndex_>=0)
        [self selectBtn:[optionBtns objectAtIndex:selectIndex_]];
}
- (void)willRemoveSubview:(UIView *)subview
{
    [super willRemoveSubview:subview];
    if(!optionBtns) return;
    if([subview isKindOfClass:[UIButton class]]){
        UIButton *btn=(UIButton *)subview;
        if(selectBtn==btn){
            selectBtn=NULL;
            selectIndex=-1;
        }else if(selectBtn){
            selectIndex=[optionBtns indexOfObject:selectBtn];
        }
        [btn removeTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [optionBtns removeObject:btn];
    }
}

@end


@implementation RequireOptionView
@synthesize requireControl;

- (void)dealloc
{
    [requireControl release];
    [super dealloc];
}

- (void)selectBtn:(UIButton *)btn
{
    [super selectBtn:btn];
    [requireControl setEnabled:selectIndex>=0];
}

@end



