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
{
    UIButton *setMin5;
    UIButton *setMin30;
    UIButton *setMin90;
    UIButton *setMin200;
    UITextField *minEdit;
    UIButton *digitalTimer;
    UIButton *vercationTimer;
    UIButton *countDownTimer;
}

@property(nonatomic,retain)NSString *mac;
@property(nonatomic,assign)IBOutlet TimingTableView *tableView;
@property(nonatomic,retain)NSString *deviceInfo;

@property(nonatomic,retain)IBOutlet UIButton *setMin5;
@property(nonatomic,retain)IBOutlet UIButton *setMin30;
@property(nonatomic,retain)IBOutlet UIButton *setMin90;
@property(nonatomic,retain)IBOutlet UIButton *setMin200;
@property(nonatomic,retain)IBOutlet UITextField *minEdit;

@property(nonatomic,retain)IBOutlet UIButton *digitalTimer;
@property(nonatomic,retain)IBOutlet UIButton *vercationTimer;
@property(nonatomic,retain)IBOutlet UIButton *countDownTimer;


- (void)setDevID:(Byte)ID;


@end
