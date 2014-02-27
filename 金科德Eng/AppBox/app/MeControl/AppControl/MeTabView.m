//
//  MeTabView.m
//  MeAppVideo
//
//  Created by absir on 12-3-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MeTabView.h"

@implementation MeTabView
@synthesize tabContentView;
@synthesize selectIndex;

//释放对象
- (void)dealloc
{
    [tabViews release];
    [tabContentView release];
    [super dealloc];
}

//点击切换
- (void)clickSegBtn:(UIButton *)btn
{
    if(btn.tag >= [tabViews count]) return;
    
    [selectBtn setEnabled:TRUE];
    contentView.hidden = YES;
    //[contentView removeFromSuperview];
    
    selectBtn = btn;
    contentView = [tabViews objectAtIndex:btn.tag];
    contentView.hidden = NO;
    //[tabContentView addSubview:contentView];
    [selectBtn setEnabled:FALSE];
}

//设置切换内容页
- (void)setTabContentView:(UIView *)tabConView
{
    [tabConView retain];
    [tabContentView release];
    tabContentView = tabConView;
    
    if(tabViews) [tabViews release];
    tabViews = [[NSArray alloc] initWithArray:[tabContentView subviews]];
    
    int idx = 0;
    int len = [tabViews count];
    
    UIButton *defaultBtn = NULL;
    NSArray *views = [self subviews];
    for(UIButton *btn in views){
        if([btn isKindOfClass:[UIButton class]]){
            btn.enabled = TRUE;
            [btn removeTarget:self action:@selector(clickSegBtn:) forControlEvents:UIControlEventTouchUpInside];
            if(idx < len){
                [[tabViews objectAtIndex:idx] setHidden:YES];
                //[[tabViews objectAtIndex:idx] removeFromSuperview];
                
                btn.tag = idx;
                [btn addTarget:self action:@selector(clickSegBtn:) forControlEvents:UIControlEventTouchUpInside];
                
                if(btn == selectBtn) [self clickSegBtn:btn];
                else if(idx==0) defaultBtn = btn;
            }
            idx++;
        }
    }
    if(!selectBtn && defaultBtn) [self clickSegBtn:defaultBtn];
}

- (int)selectIndex
{
    return selectBtn.tag;
}

@end
