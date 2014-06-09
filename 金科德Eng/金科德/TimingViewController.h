//
//  TimingViewController.h
//  金科德
//
//  Created by Yangliu on 13-9-9.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "TimingTableView.h"

@interface TimingViewController : BaseViewController<UITextFieldDelegate>
{
    UIButton *setMin5;
    UIButton *setMin30;
    UIButton *setMin90;
    UIButton *setMin200;
    UITextField *minEdit;
    UIButton *digitalTimer;
    UIButton *vercationTimer;
    UIButton *countDownTimer;
    
    UITextField *verOnEdit;
    UITextField *verOffEdit;
    UITextField *digGroup;
    
    UIButton *digWeekBtn1;
    UIButton *digWeekBtn2;
    UIButton *digWeekBtn3;
    UIButton *digWeekBtn4;
    UIButton *digWeekBtn5;
    UIButton *digWeekBtn6;
    UIButton *digWeekBtn7;
    
    UITextField *digOnEdit;
    UITextField *digOffEdit;
}

@property(nonatomic,retain)NSString *mac;
@property(nonatomic,assign)IBOutlet TimingTableView *tableView;
@property(nonatomic,retain)NSString *deviceInfo;

@property(nonatomic,retain)IBOutlet UIButton *setMin5;
@property(nonatomic,retain)IBOutlet UIButton *setMin30;
@property(nonatomic,retain)IBOutlet UIButton *setMin90;
@property(nonatomic,retain)IBOutlet UIButton *setMin200;
@property(nonatomic,retain)IBOutlet UIButton *countDownOnOff;
@property(nonatomic,retain)IBOutlet UITextField *minEdit;

@property(nonatomic,retain)IBOutlet UIButton *digitalTimer;
@property(nonatomic,retain)IBOutlet UIButton *vercationTimer;
@property(nonatomic,retain)IBOutlet UIButton *countDownTimer;

@property(nonatomic,retain)IBOutlet UITextField *verOnEdit;
@property(nonatomic,retain)IBOutlet UITextField *verOffEdit;

@property(nonatomic,retain)IBOutlet UITextField *digGroup;
- (void)setDevID:(Byte)ID;

@property(nonatomic,retain)IBOutlet UIButton *digWeekBtn1;
@property(nonatomic,retain)IBOutlet UIButton *digWeekBtn2;
@property(nonatomic,retain)IBOutlet UIButton *digWeekBtn3;
@property(nonatomic,retain)IBOutlet UIButton *digWeekBtn4;
@property(nonatomic,retain)IBOutlet UIButton *digWeekBtn5;
@property(nonatomic,retain)IBOutlet UIButton *digWeekBtn6;
@property(nonatomic,retain)IBOutlet UIButton *digWeekBtn7;

@property(nonatomic,retain)IBOutlet UITextField *digOnEdit;
@property(nonatomic,retain)IBOutlet UITextField *digOffEdit;

@end
