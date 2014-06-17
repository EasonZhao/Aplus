//
//  TimingViewController.m
//  金科德
//
//  Created by Yangliu on 13-9-9.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "TimingViewController.h"
#import "TimeEditViewController.h"
#import "SVProgressHUD.h"
#import "NetKit.h"

@interface TimingViewController ()<NetKitDelegate>
{
    Byte devID_;
    NSTimer *timer_;
    
    Byte weekDays1_;
    Byte weekDays2_;
    Byte weekDays3_;
    BOOL digEnable1_;
    BOOL digEnable2_;
}

@end

@implementation TimingViewController
@synthesize tableView;
@synthesize mac;
@synthesize deviceInfo;

@synthesize setMin5;
@synthesize setMin30;
@synthesize setMin90;
@synthesize setMin200;
@synthesize minEdit;
@synthesize digitalTimer;
@synthesize vercationTimer;
@synthesize countDownTimer;
@synthesize countDownOnOff;

@synthesize verOnEdit;
@synthesize verOffEdit;

@synthesize digGroup;

@synthesize digWeekBtn1;
@synthesize digWeekBtn2;
@synthesize digWeekBtn3;
@synthesize digWeekBtn4;
@synthesize digWeekBtn5;
@synthesize digWeekBtn6;
@synthesize digWeekBtn7;

@synthesize digOnEdit;
@synthesize digOffEdit;

- (void)dealloc
{
    [deviceInfo release];
    [mac release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        minEdit.delegate = self;
        weekDays1_ = 0x7f;
        weekDays2_ = 0x7f;
        weekDays3_ = 0x7f;
        digEnable1_ = NO;
        digEnable2_ = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    minEdit.delegate = self;
    minEdit.returnKeyType = UIReturnKeyNext;
    minEdit.textAlignment = UITextAlignmentRight;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    //UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"commit" style:UIBarButtonItemStyleBordered target:self action:@selector(commit:)];
    self.navigationItem.rightBarButtonItem = [AppWindow getBarItemTitle:@"" Target:self Action:@selector(commit:) ImageName:@"上传"];
    
    [[NetKit instance] reqStat:0x01];
    
    // Do any additional setup after loading the view from its nib.
//    self.navigationItem.leftBarButtonItem = [AppWindow getBarItemTitle:@"" Target:self Action:nil ImageName:@"Wi-Fi"];
//    self.navigationItem.rightBarButtonItem = [AppWindow getBarItemTitle:@"" Target:self Action:@selector(back:) ImageName:@"back"];
    NSLog(@"TimingViewController deviceInfo %@",deviceInfo);
}

- (void)commit:(UIButton *)sender
{
    BOOL sended = NO;
    //发送定时命令
    if (digEnable1_ || digEnable2_) {
        if ([digOnEdit.text length]==0 ||
            [digOffEdit.text length]==0) {
            return;
        }
        NSArray *arr = [digOnEdit.text componentsSeparatedByString:@":"];
        int onHour = [[arr objectAtIndex:0] intValue];
        int onMin = [[arr objectAtIndex:1] intValue];
        arr = [digOffEdit.text componentsSeparatedByString:@":"];
        int offHour = [[arr objectAtIndex:0] intValue];
        int offMin = [[arr objectAtIndex:1] intValue];
        //提示
        if ((onHour*60+onMin)>=(offHour*60+offMin)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @""
                                                            message: @"Invalid parameter"
                                                           delegate: self
                                                  cancelButtonTitle: @"取消"
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
            return;
        }
        NSMutableArray *weeks = [NSMutableArray array];
        if (digEnable1_) {
            WeekDaySet set = {0};
            set.weekday = weekDays1_;
            set.onHour = onHour;
            set.onMin = onMin;
            set.offHour = offHour;
            set.offMin = offMin;
            set.isON = true;
            NSValue *value = nil;
            value = [NSValue valueWithBytes:&set objCType:@encode(WeekDaySet)];
            [weeks addObject:value];
        } else {
            WeekDaySet set = {0};
            NSValue *value = nil;
            value = [NSValue valueWithBytes:&set objCType:@encode(WeekDaySet)];
            [weeks addObject:value];
        }
        
        if (digEnable2_) {
            WeekDaySet set = {0};
            set.weekday = weekDays2_;
            set.onHour = onHour;
            set.onMin = onMin;
            set.offHour = offHour;
            set.offMin = offMin;
            set.isON = true;
            NSValue *value = nil;
            value = [NSValue valueWithBytes:&set objCType:@encode(WeekDaySet)];
            [weeks addObject:value];
        } else {
            WeekDaySet set = {0};
            NSValue *value = nil;
            value = [NSValue valueWithBytes:&set objCType:@encode(WeekDaySet)];
            [weeks addObject:value];
        }
        WeekDaySet set = {0};
        NSValue *value = nil;
        value = [NSValue valueWithBytes:&set objCType:@encode(WeekDaySet)];
        [weeks addObject:value];
        [[NetKit instance] setTimer:devID_ weekdays:weeks delegate:self];
        sended = YES;
    } else if (vercationTimer.selected) {
        if ([verOnEdit.text length]==0 ||
            [verOffEdit.text length]==0) {
            return;
        }
        NSArray *arr = [verOnEdit.text componentsSeparatedByString:@":"];
        int onHour = [[arr objectAtIndex:0] intValue];
        int onMin = [[arr objectAtIndex:1] intValue];
        arr = [verOffEdit.text componentsSeparatedByString:@":"];
        int offHour = [[arr objectAtIndex:0] intValue];
        int offMin = [[arr objectAtIndex:1] intValue];
        //提示
        if ((onHour*60+onMin)>=(offHour*60+offMin)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @""
                                                            message: @"Invalid parameter"
                                                           delegate: self
                                                  cancelButtonTitle: @"取消"
                                                  otherButtonTitles: nil];
            [alert show];
            [alert release];
            return;
        }
        NSMutableArray *weeks = [NSMutableArray array];
        for (int i=0; i<2; i++) {
            WeekDaySet set = {0};
            NSValue *value = nil;
            value = [NSValue valueWithBytes:&set objCType:@encode(WeekDaySet)];
            [weeks addObject:value];
        }
        WeekDaySet set = {0};
        set.weekday = weekDays3_;
        set.onHour = onHour;
        set.onMin = onMin;
        set.offHour = offHour;
        set.offMin = offMin;
        set.isON = true;
        NSValue *value = nil;
        value = [NSValue valueWithBytes:&set objCType:@encode(WeekDaySet)];
        [weeks addObject:value];
        [[NetKit instance] setTimer:devID_ weekdays:weeks delegate:self];
        sended = YES;
    } else if (countDownTimer.selected) {
        int min = [minEdit.text integerValue];
        int hour = min / 60;
        min = min % 60;
        [[NetKit instance] countDown:devID_
                                isOn:countDownOnOff.selected
                               hours:hour
                                 min:min
                                 sec:0
                              enable:YES
                            delegate:self];
        sended = YES;
    }
    if (sended) {
        timer_ = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timeoutHandle) userInfo:nil repeats:NO];
        [SVProgressHUD showWithStatus:@"请稍后" maskType:SVProgressHUDMaskTypeClear];
    }
}

- (void)timeoutHandle
{
    [SVProgressHUD showErrorWithStatus:@"指令失败"];
}

- (IBAction)textFieldChange:(UITextField *)textField
{
    if ([textField.text isEqualToString:@"1"]) {
        digWeekBtn1.selected = weekDays1_ & 0x01 ? YES : NO;
        digWeekBtn2.selected = weekDays1_ & 0x02 ? YES : NO;
        digWeekBtn3.selected = weekDays1_ & 0x04 ? YES : NO;
        digWeekBtn4.selected = weekDays1_ & 0x08 ? YES : NO;
        digWeekBtn5.selected = weekDays1_ & 0x10 ? YES : NO;
        digWeekBtn6.selected = weekDays1_ & 0x20 ? YES : NO;
        digWeekBtn7.selected = weekDays1_ & 0x40 ? YES : NO;
        
        digitalTimer.selected = digEnable1_;
    } else if ([textField.text isEqualToString:@"2"]) {
        BOOL tmp = NO;
        tmp = weekDays2_ & 0x01 ? YES : NO;
        digWeekBtn1.selected = tmp;
        tmp = weekDays2_ & 0x02 ? YES : NO;
        digWeekBtn2.selected = tmp;
        tmp = weekDays2_ & 0x04 ? YES : NO;
        digWeekBtn3.selected = tmp;
        tmp = weekDays2_ & 0x08 ? YES : NO;
        digWeekBtn4.selected = tmp;
        tmp = weekDays2_ & 0x10 ? YES : NO;
        digWeekBtn5.selected = tmp;
        tmp = weekDays2_ & 0x20 ? YES : NO;
        digWeekBtn6.selected = tmp;
        tmp = weekDays2_ & 0x40 ? YES : NO;
        digWeekBtn7.selected = tmp;
        
        digitalTimer.selected = digEnable2_;
    }
}

- (IBAction)toggle:(UIButton *)sender {
    
    sender.selected = !sender.selected;
}

- (IBAction)setDigEnable:(UIButton*)sender
{
    if ([digGroup.text isEqualToString:@"1"]) {
        digEnable1_ = sender.selected;
    } else {
        digEnable2_ = sender.selected;
    }
}

- (IBAction)setVerTimerWeekArg:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if ([[sender.titleLabel text] isEqualToString:@"mon"]) {
        if (sender.selected) {
            weekDays3_ = weekDays3_ | 0x01;
        } else {
            weekDays3_ = weekDays3_ & 0xfe;
        }
    } else if ([[sender.titleLabel text] isEqualToString:@"tue"]) {
        if (sender.selected) {
            weekDays3_ = weekDays3_ | 0x02;
        } else {
            weekDays3_ = weekDays3_ & 0xfd;
        }
    } else if ([[sender.titleLabel text] isEqualToString:@"web"]) {
        if (sender.selected) {
            weekDays3_ = weekDays3_ | 0x04;
        } else {
            weekDays3_ = weekDays3_ & 0xfb;
        }
    } else if ([[sender.titleLabel text] isEqualToString:@"thu"]) {
        if (sender.selected) {
            weekDays3_ = weekDays3_ | 0x08;
        } else {
            weekDays3_ = weekDays3_ & 0xf7;
        }
    } else if ([[sender.titleLabel text] isEqualToString:@"fir"]) {
        if (sender.selected) {
            weekDays3_ = weekDays3_ | 0x10;
        } else {
            weekDays3_ = weekDays3_ & 0xef;
        }
    } else if ([[sender.titleLabel text] isEqualToString:@"sat"]) {
        if (sender.selected) {
            weekDays3_ = weekDays3_ | 0x20;
        } else {
            weekDays3_ = weekDays3_ & 0xdf;
        }
    } else if ([[sender.titleLabel text] isEqualToString:@"sun"]) {
        if (sender.selected) {
            weekDays3_ = weekDays3_ | 0x40;
        } else {
            weekDays3_ = weekDays3_ & 0xbf;
        }
    }
}

- (IBAction)setDigTimerWeekArg:(UIButton*)sender
{
    sender.selected = !sender.selected;
    Byte tmp = 0;
    if ([digGroup.text isEqualToString:@"1"]) {
        tmp = weekDays1_;
    } else {
        tmp = weekDays2_;
    }
    if ([[sender.titleLabel text] isEqualToString:@"mon"]) {
        if (sender.selected) {
            tmp = tmp | 0x01;
        } else {
            tmp = tmp & 0xfe;
        }
    } else if ([[sender.titleLabel text] isEqualToString:@"tue"]) {
        if (sender.selected) {
            tmp = tmp | 0x02;
        } else {
            tmp = tmp & 0xfd;
        }
    } else if ([[sender.titleLabel text] isEqualToString:@"web"]) {
        if (sender.selected) {
            tmp = tmp | 0x04;
        } else {
            tmp = tmp & 0xfb;
        }
    } else if ([[sender.titleLabel text] isEqualToString:@"thu"]) {
        if (sender.selected) {
            tmp = tmp | 0x08;
        } else {
            tmp = tmp & 0xf7;
        }
    } else if ([[sender.titleLabel text] isEqualToString:@"fir"]) {
        if (sender.selected) {
            tmp = tmp | 0x10;
        } else {
            tmp = tmp & 0xef;
        }
    } else if ([[sender.titleLabel text] isEqualToString:@"sat"]) {
        if (sender.selected) {
            tmp = tmp | 0x20;
        } else {
            tmp = tmp & 0xdf;
        }
    } else if ([[sender.titleLabel text] isEqualToString:@"sun"]) {
        if (sender.selected) {
            tmp = tmp | 0x40;
        } else {
            tmp = tmp & 0xbf;
        }
    }
    if ([digGroup.text isEqualToString:@"1"]) {
        weekDays1_ = tmp;
    } else {
        weekDays2_ = tmp;
    }
}

- (IBAction)add:(UIButton *)sender {
    if (tableView.aryData.count>=10) {
        [AppWindow alertMessage:@"定时最多10组"];
        return;
    }
    TimeEditViewController *timeEdit = [[TimeEditViewController alloc]initWithNibName:@"TimeEditViewController" bundle:nil];
    timeEdit.isAdd = YES;
    //timeEdit.timingTableView = tableView;
    [[AppWindow getNavigationController] pushViewController:timeEdit animated:YES];
    [timeEdit release];
}

- (IBAction)save:(UIButton *)sender {
    if (!tableView.aryData.count) {
        return;
    }
//    UdpSocket *udp = [[UdpSocket alloc]init];
//    [udp timingDevice:nil timing:tableView.aryData];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)setMinValue:(UIButton *)sender
{
    if (sender==setMin5) {
        minEdit.text = @"5";
    } else if (sender==setMin30) {
        minEdit.text = @"30";
    } else if (sender==setMin90) {
        minEdit.text = @"90";
    } else if (sender==setMin200) {
        minEdit.text = @"200";
    }
}

- (IBAction)changeTimingType:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (!sender.selected) {
        return;
    }
    if (digitalTimer==sender) {
        vercationTimer.selected = NO;
        countDownTimer.selected = NO;
        return;
    } else if (vercationTimer==sender) {
        digitalTimer.selected = NO;
        countDownTimer.selected = NO;
        return;
    } else if (countDownTimer==sender) {
        digitalTimer.selected = NO;
        vercationTimer.selected = NO;
        return;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDevID:(Byte)ID
{
    devID_ = ID;
}

//UITextField的协议方法，当开始编辑时监听
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移30个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-210,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location>=3) {
        return NO;
    } else {
        return YES;
    }
}

//恢复原始视图位置
-(void)resumeView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    float Y = 20.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

-(void)hidenKeyboard
{
    [minEdit resignFirstResponder];
    [self resumeView];
}

//点击键盘上的Return按钮响应的方法
-(IBAction)nextOnKeyboard:(UITextField *)sender
{
    if (sender == self.minEdit) {
        //[self.passwordText becomeFirstResponder];
    }
}

- (void)countdownHandler:(BOOL)success devID:(Byte)devID
{
    if (timer_ && [timer_ isValid]) {
        [timer_ invalidate];
    }
    if (success) {
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [SVProgressHUD showErrorWithStatus:@"指令失败"];
    }
}

- (void)setTimerHandler:(BOOL)success devID:(Byte)devID
{
    if (timer_ && [timer_ isValid]) {
        [timer_ invalidate];
    }
    if (success) {
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [SVProgressHUD showErrorWithStatus:@"指令失败"];
    }
}
@end
