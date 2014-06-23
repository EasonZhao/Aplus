//
//  SwitchDetailViewController.m
//  金科德
//
//  Created by Yangliu on 13-9-9.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "SwitchDetailViewController.h"
#import "CountDownViewController.h"
#import "TimingViewController.h"
#import "EditViewController.h"
#import "SVProgressHUD.h"

@interface SwitchDetailViewController ()
{
    IBOutlet UIButton *switchBtn;
    float lightValue_;
    float colorValue_;
    NSTimer *timer_;
}

@end

@implementation SwitchDetailViewController
@synthesize isOn;
@synthesize devID;
@synthesize mac;
@synthesize deviceInfo;
@synthesize lightSlider_;
@synthesize colorSlider_;

- (void)dealloc
{
    [deviceInfo release];
    [mac release];
    [switchBtn release];
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
    CGAffineTransform rotation = CGAffineTransformMakeRotation(-1.57079633);
    lightSlider_.transform = rotation;
    colorSlider_.transform = rotation;
    CGRect ret = lightSlider_.frame;
    ret.origin.x = 28;
    ret.origin.y = 110;
    ret.size.width = 32;
    ret.size.height = 240;
    lightSlider_.frame = ret;
    ret.origin.x += 230;
    colorSlider_.frame = ret;
    [lightSlider_ addTarget:self action:@selector(startDrag:) forControlEvents:UIControlEventTouchDown];
    [colorSlider_ addTarget:self action:@selector(startDrag:) forControlEvents:UIControlEventTouchDown];
    //[lightSlider_ addTarget:self action:@selector(updateThumb:) forControlEvents:UIControlEventValueChanged];
    
    [lightSlider_ addTarget:self action:@selector(endDrag:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [colorSlider_ addTarget:self action:@selector(endDrag:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    lightValue_ = lightSlider_.value;
    colorValue_ = lightSlider_.value;
       // Do any additional setup after loading the view from its nib.
//    self.navigationItem.leftBarButtonItem = [AppWindow getBarItemTitle:@"" Target:self Action:nil ImageName:@"Wi-Fi"];
//    self.navigationItem.rightBarButtonItem = [AppWindow getBarItemTitle:@"" Target:self Action:@selector(back:) ImageName:@"back"];
    switchBtn.selected = isOn;
}

- (void)endDrag:(UISlider *)aSlider
{
    NSLog(@"value:%f", aSlider.value);
    if (aSlider==lightSlider_) {
        Byte value = [self convertLightValue:aSlider.value];
        [[NetKit instance] setLightValue:devID value:value delegate:self];
    } else if (aSlider==colorSlider_) {
        Byte value = [self convertColorValue:aSlider.value];
        [[NetKit instance] setColorValue:devID value:value delegate:self];
    }
    
    //提示
    timer_ = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timeoutHandle) userInfo:nil repeats:NO];
    [SVProgressHUD showWithStatus:@"请稍后..." maskType:SVProgressHUDMaskTypeClear];
}

- (void)startDrag:(UISlider *)slider
{
    if (slider==lightSlider_) {
        lightValue_ = slider.value;
    } else if (slider==colorSlider_) {
        colorValue_ = slider.value;
    }
}

- (IBAction)switchON:(UIButton *)sender {
    

    [[NetKit instance] switchDevice:!isOn devID:self.devID delegate:self];
//    [[[UdpSocket alloc]init]switchDevice:nil status:sender.selected];
}

- (IBAction)countDown:(UIButton *)sender {
    CountDownViewController *countDowm = [[CountDownViewController alloc]initWithNibName:@"CountDownViewController" bundle:nil];
    countDowm.mac = self.mac;
    [self.navigationController pushViewController:countDowm animated:YES];
    [countDowm release];
}

- (IBAction)timing:(id)sender {
    TimingViewController *timing = [[TimingViewController alloc]initWithNibName:@"TimingViewController" bundle:nil];
    timing.mac = self.mac;
    timing.deviceInfo = self.deviceInfo;
    [timing setDevID:devID];
    [[AppWindow getNavigationController] pushViewController:timing animated:YES];
    [timing release];
}

- (IBAction)edit:(UIButton *)sender {
    EditViewController *edit = [[EditViewController alloc]initWithNibName:@"EditViewController" bundle:nil];
    edit.mac = self.mac;
    [self.navigationController pushViewController:edit animated:YES];
    [edit release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)switchDeviceHandler:(BOOL)success devID:(Byte)devID
{
    if (!success) {
        return;
    }
    if (devID==self.devID) {
        switchBtn.selected = !switchBtn.selected;
        self.isOn = switchBtn.selected;
    }
}

- (void)timeoutHandle
{
    if (lightSlider_.value!=lightValue_) {
        lightSlider_.value = lightValue_;
    }
    if (colorSlider_.value!=colorValue_) {
        colorSlider_.value = colorValue_;
    }
    [SVProgressHUD showErrorWithStatus:@"指令失败"];
}

- (void)setLightValueHandler:(BOOL)success devID:(Byte)devID
{
    if (devID!=self.devID) {
        return;
    }
    if ([timer_ isValid]&&timer_) {
        [timer_ invalidate];
    }
    if (success) {
        if (!switchBtn.selected) {
            switchBtn.selected = YES;
            isOn = YES;
        }
        lightValue_ = lightSlider_.value;
        [SVProgressHUD showSuccessWithStatus:@"成功"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"指令失败"];
    }
}

- (void)setColorValueHandler:(BOOL)success devID:(Byte)devID
{
    if (devID!=self.devID) {
        return;
    }
    if ([timer_ isValid]&&timer_) {
        [timer_ invalidate];
    }
    if (success) {
        if (!switchBtn.selected) {
            switchBtn.selected = YES;
            isOn = YES;
        }
        colorValue_ = colorSlider_.value;
        [SVProgressHUD showSuccessWithStatus:@"成功"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"指令失败"];
    }
}

- (Byte)convertLightValue:(int)value
{
    if (value==0) {
        return 0xBB;
    }
    else if (value<10) {
        return 0xaa;
    } else if (value<20) {
        return 0x99;
    } else if (value<30) {
        return 0x88;
    } else if (value<40) {
        return 0x77;
    } else if (value<50) {
        return 0x66;
    } else if (value<60) {
        return 0xee;
    } else if (value<70) {
        return 0x44;
    } else if (value<80) {
        return 0x33;
    } else if (value<90) {
        return 0x22;
    } else {
        return 0xdd;
    }
    return 0x00;
}

- (Byte)convertColorValue:(int)value
{
    if (value==0) {
        return 0xD1;
    }
    else if (value<10) {
        return 0xD2;
    } else if (value<20) {
        return 0xD3;
    } else if (value<30) {
        return 0xD4;
    } else if (value<40) {
        return 0xD5;
    } else if (value<50) {
        return 0xD6;
    } else if (value<60) {
        return 0xD7;
    } else if (value<70) {
        return 0xD7;
    } else if (value<80) {
        return 0xD9;
    } else if (value<90) {
        return 0xDA;
    } else {
        return 0xDB;
    }
    return 0x00;
}

@end
