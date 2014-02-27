//
//  TimeEditViewController.m
//  金科德
//
//  Created by Yangliu on 13-9-9.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "TimeEditViewController.h"
#import "WeekSwitch.h"
#import "UdpSocket.h"

@interface TimeEditViewController ()
{
    WeekSwitch *weekSwitch;
    IBOutlet UISwitch *randSwitch;
    IBOutlet UITextField *openTxtFld;
    IBOutlet UITextField *closeTxtFld;
}

@property(nonatomic,retain)IBOutletCollection(UIButton)NSArray *buttons;

-(IBAction)redundant:(UIButton*)sender;

@end

@implementation TimeEditViewController
@synthesize buttons;
@synthesize mac;
@synthesize data;
@synthesize timingTableView;
@synthesize isAdd;

- (void)dealloc
{
    [data release];
    [mac release];
    [weekSwitch release];
    [openTxtFld release];
    [closeTxtFld release];
    [randSwitch release];
    [buttons release];
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
//    self.navigationItem.leftBarButtonItem = [AppWindow getBarItemTitle:@"" Target:self Action:@selector(back:) ImageName:@"back"];
    weekSwitch = [[WeekSwitch alloc]init];
    if (data) {
        Byte week = [[data objectForKey:@"week"] intValue];
        Byte c = 0x01;
        for(UIButton *b in buttons)
        {
            int o = week&c;
            b.selected = o!=0;
            c = c<<1;
        }
        openTxtFld.text = [NSString stringWithFormat:@"%@:%@",[data objectForKey:@"hourON"],[data objectForKey:@"minON"]];
        closeTxtFld.text = [NSString stringWithFormat:@"%@:%@",[data objectForKey:@"hourOFF"],[data objectForKey:@"minOFF"]];
        randSwitch.on = [[data objectForKey:@"random"] boolValue];
    }
}

-(IBAction)redundant:(UIButton*)sender
{
    sender.selected = !sender.selected;
    switch (sender.tag) {
        case 1:
            sender.selected?[weekSwitch openMo]:[weekSwitch closeMo];
            break;
        case 2:
            sender.selected?[weekSwitch openTu]:[weekSwitch closeTu];
            break;
        case 3:
            sender.selected?[weekSwitch openWe]:[weekSwitch closeWe];
            break;
        case 4:
            sender.selected?[weekSwitch openTh]:[weekSwitch closeTh];
            break;
        case 5:
            sender.selected?[weekSwitch openFr]:[weekSwitch closeFr];
            break;
        case 6:
            sender.selected?[weekSwitch openSa]:[weekSwitch closeSa];
            break;
        case 7:
            sender.selected?[weekSwitch openSu]:[weekSwitch closeSu];
            break;
        default:
            break;
    }
}

- (IBAction)save:(UIButton *)sender {
    Byte week = [weekSwitch getWeek];
    int hourON = 0;
    int hourOFF = 0;
    int minON = 0;
    int minOFF = 0;
    if (openTxtFld.text.length) {
        NSArray *openTime = [openTxtFld.text componentsSeparatedByString:@":"];
        hourON = [[openTime objectAtIndex:0] intValue];
        minON = [[openTime objectAtIndex:1] intValue];
    }
    if (closeTxtFld.text.length) {
        NSArray *closeTime = [closeTxtFld.text componentsSeparatedByString:@":"];
        hourOFF = [[closeTime objectAtIndex:0] intValue];
        minOFF = [[closeTime objectAtIndex:1] intValue];
    }
    if (data) {
        [data setObject:[NSString stringWithFormat:@"%d",week] forKey:@"week"];
        [data setObject:[NSString stringWithFormat:@"%d",hourON] forKey:@"hourON"];
        [data setObject:[NSString stringWithFormat:@"%d",hourOFF] forKey:@"hourOFF"];
        [data setObject:[NSString stringWithFormat:@"%d",minON] forKey:@"minON"];
        [data setObject:[NSString stringWithFormat:@"%d",minOFF] forKey:@"minOFF"];
        [data setObject:randSwitch.on?@"1":@"0" forKey:@"random"];
        [data setObject:@"1" forKey:@"enable"];
    }else
    {
        self.data = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",week],@"week",[NSString stringWithFormat:@"%d",hourON],@"hourON",[NSString stringWithFormat:@"%d",hourOFF],@"hourOFF",[NSString stringWithFormat:@"%d",minON],@"minON",[NSString stringWithFormat:@"%d",minOFF],@"minOFF",randSwitch.on?@"1":@"0",@"random",@"1",@"enable", nil];
        if (!timingTableView.aryData) {
            timingTableView.aryData = [NSArray arrayWithObject:data];
        }else
        {
            NSMutableArray *a = [NSMutableArray arrayWithArray:timingTableView.aryData];
            [a addObject:data];
            timingTableView.aryData = a;
        }
        
    }
    [timingTableView reloadData];
    //[[[UdpSocket alloc]init] timingDevice:nil enable:YES weekON:week hourON:hourON hourRand:randSwitch.isOn minON:minON weekOFF:week hourOFF:hourOFF minOFF:minOFF];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteTiming:(UIButton *)sender {
    if (!isAdd) {
        NSMutableArray *a = [NSMutableArray arrayWithArray:timingTableView.aryData];
        [a removeObject:data];
        timingTableView.aryData = a;
        [timingTableView reloadData];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
