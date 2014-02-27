//
//  MeTableView.h
//  MeAppBox
//
//  Created by absir on 12-5-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppBox.h"

@interface MeTableView : UITableView<UITableViewDataSource, UITableViewDelegate>
{
    BOOL readyReload;
    UIView *loadingView;
    
    NSMutableArray *aryData;
}

@property(nonatomic, retain)NSArray *aryData;

//载入界面
- (void)loadingView;
//移出载入界面
- (void)unloadingView;
//更新界面
- (void)updateView;
//载入完成后回调
- (void)completeResponse:(NSString *)response;
//滚动倒最后一条
- (void)scrollTableToFoot:(BOOL)animated;

@end
