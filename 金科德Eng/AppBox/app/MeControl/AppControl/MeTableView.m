//
//  MeTableView.m
//  MeAppBox
//
//  Created by absir on 12-5-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MeTableView.h"

@implementation MeTableView
@synthesize aryData;

//初始化对象
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if((self = [super initWithCoder:aDecoder])){
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//释放对象
- (void)dealloc
{
    [aryData release];
    [super dealloc];
}

//选项卡载入准备
- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if(self.superview){
        if(readyReload){
            [self updateView];
        }
    } else {
        readyReload = TRUE;
    }
}

//载入界面
- (void)loadingView
{
    loadingView = [AppWindow loadingView:self Type:0 Data:NULL];
    [[self superview] addSubview:loadingView];
}
//移出载入界面
- (void)unloadingView
{
    [loadingView removeFromSuperview];
    loadingView = NULL;
}
//更新界面
- (void)updateView
{
    [self reloadData];
}
//载入完成后回调
- (void)completeResponse:(NSString *)response
{
    [self unloadingView];
}

//滚动倒最后一条
- (void)scrollTableToFoot:(BOOL)animated
{  
    NSInteger sectionEnd = [self numberOfSections];
    if (--sectionEnd < 0) return;  
    NSInteger rowEnd = [self numberOfRowsInSection:sectionEnd];  
    if (--rowEnd < 0) return;  
    
    NSIndexPath *indexPathEnd = [NSIndexPath indexPathForRow:rowEnd inSection:sectionEnd];  
    
    [self scrollToRowAtIndexPath:indexPathEnd atScrollPosition:UITableViewScrollPositionBottom animated:animated];
} 

#pragma UITableView DataResource Delegate
//自身数据和委托
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int number = [aryData count];
    return number?number:1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NULL] autorelease];
}


@end
