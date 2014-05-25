//
//  TimingViewController.h
//  金科德
//
//  Created by Yangliu on 13-9-9.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "TimingTableView.h"

@interface TimingViewController : BaseViewController

@property(nonatomic,retain)NSString *mac;
@property(nonatomic,assign)IBOutlet TimingTableView *tableView;
@property(nonatomic,retain)NSString *deviceInfo;

- (void)setDevID:(Byte)ID;

@end
