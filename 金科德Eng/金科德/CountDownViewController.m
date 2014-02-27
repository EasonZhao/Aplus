//
//  CountDownViewController.m
//  金科德
//
//  Created by Yangliu on 13-9-9.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "CountDownViewController.h"
#import "MeOptionView.h"
#import "UdpSocket.h"

@interface CountDownViewController ()
{
    IBOutlet UISwitch *switchBtn;
    IBOutlet MeOptionView *optionView;
    IBOutlet UITextField *hourTxtFld;
    IBOutlet UITextField *minTxtFld;
    IBOutlet UITextField *secTxtFld;
}

@end

@implementation CountDownViewController
@synthesize mac;

- (void)dealloc
{
    [mac release];
    [hourTxtFld release];
    [minTxtFld release];
    [secTxtFld release];
    [switchBtn release];
    [optionView release];
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
    // Do any additional setup after loading the view from its nib.
//    self.navigationItem.leftBarButtonItem = [AppWindow getBarItemTitle:@"" Target:self Action:nil ImageName:@"Wi-Fi"];
//    self.navigationItem.rightBarButtonItem = [AppWindow getBarItemTitle:@"" Target:self Action:@selector(back:) ImageName:@"back"];
    
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([hourTxtFld isFirstResponder]) {
        [hourTxtFld resignFirstResponder];
    }
    if ([minTxtFld isFirstResponder]) {
        [minTxtFld resignFirstResponder];
    }
    if ([secTxtFld isFirstResponder]) {
        [secTxtFld resignFirstResponder];
    }
}

- (IBAction)save:(UIButton *)sender {
    int sec = 0;
    int min = 0;
    int hour = 0;
    switch (optionView.selectIndex) {
        case 0:
            min = 5;
            break;
        case 1:
            min = 10;
            break;
        case 2:
            min = 30;
            break;
        case 3:
            hour = 1;
            break;
        case 4:
            hour = 1;
            min = 30;
            break;
        case 5:
            hour= 2;
            break;
        case 6:
            if ([hourTxtFld.text intValue]>99) {
                [AppWindow alertMessage:@"小时数0-99！"];
                return;
            }
            if ([minTxtFld.text intValue]>59) {
                [AppWindow alertMessage:@"分钟数0-59！"];
                return;
            }
            if ([secTxtFld.text intValue]>59) {
                [AppWindow alertMessage:@"秒数0-59！"];
                return;
            }
            hour = [hourTxtFld.text intValue];
            min = [minTxtFld.text intValue];
            sec = [secTxtFld.text intValue];
            
            break;
        default:
            break;
    }
//    [[[UdpSocket alloc] init]countDownDevice:mac enable:YES hour:hour min:min sec:sec];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
