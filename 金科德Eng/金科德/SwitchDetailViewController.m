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


@interface SwitchDetailViewController ()
{
    IBOutlet UIButton *switchBtn;
}

@end

@implementation SwitchDetailViewController
@synthesize isOn;
@synthesize devID;
@synthesize mac;
@synthesize deviceInfo;
@synthesize lightSlider_;

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
    CGRect ret = lightSlider_.frame;
    ret.origin.x = 28;
    ret.origin.y = 110;
    ret.size.width = 32;
    ret.size.height = 240;
    lightSlider_.frame = ret;
    
    //[lightSlider_ addTarget:self action:@selector(startDrag:) forControlEvents:UIControlEventTouchDown];
    
    //[lightSlider_ addTarget:self action:@selector(updateThumb:) forControlEvents:UIControlEventValueChanged];
    
    [lightSlider_ addTarget:self action:@selector(endDrag:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
       // Do any additional setup after loading the view from its nib.
//    self.navigationItem.leftBarButtonItem = [AppWindow getBarItemTitle:@"" Target:self Action:nil ImageName:@"Wi-Fi"];
//    self.navigationItem.rightBarButtonItem = [AppWindow getBarItemTitle:@"" Target:self Action:@selector(back:) ImageName:@"back"];
    switchBtn.selected = isOn;
}

- (void)endDrag: (UISlider *) aSlider

{
    NSLog(@"value:%f", aSlider.value);
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
@end
