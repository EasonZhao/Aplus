//
//  TimeEditViewController.h
//  金科德
//
//  Created by Yangliu on 13-9-9.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "TimingTableView.h"

@interface TimeEditViewController : BaseViewController

@property(nonatomic,retain)NSString *mac;
@property(nonatomic,retain)NSMutableDictionary *data;
@property(nonatomic,assign)TimingTableView *timingTableView;
@property(nonatomic)BOOL isAdd;

@end
