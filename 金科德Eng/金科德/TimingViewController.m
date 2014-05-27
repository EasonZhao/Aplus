//
//  TimingViewController.m
//  金科德
//
//  Created by Yangliu on 13-9-9.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "TimingViewController.h"
#import "TimeEditViewController.h"

@interface TimingViewController ()
{
    Byte devID_;
    
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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    minEdit.textAlignment = UITextAlignmentRight;
    //UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"commit" style:UIBarButtonItemStyleBordered target:self action:@selector(commit:)];
    self.navigationItem.rightBarButtonItem = [AppWindow getBarItemTitle:@"" Target:self Action:@selector(commit:) ImageName:@"上传.png"];
    // Do any additional setup after loading the view from its nib.
//    self.navigationItem.leftBarButtonItem = [AppWindow getBarItemTitle:@"" Target:self Action:nil ImageName:@"Wi-Fi"];
//    self.navigationItem.rightBarButtonItem = [AppWindow getBarItemTitle:@"" Target:self Action:@selector(back:) ImageName:@"back"];
    NSLog(@"TimingViewController deviceInfo %@",deviceInfo);
}

- (void)commit:(id)obj
{
    //发送定时命令
}

- (IBAction)toggle:(UIButton *)sender {
    
    sender.selected = !sender.selected;
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

@end
