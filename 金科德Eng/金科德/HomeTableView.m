//
//  HomeTableView.m
//  金科德
//
//  Created by Yangliu on 13-9-6.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "HomeTableView.h"
#import "HomeTableCell.h"
#import "SwitchDetailViewController.h"
#import "UdpSocket.h"
#import "DBInterface.h"
#import "AAdapter.h"

@interface HomeTableView ()<HomeCellSwitchDelegate>
{
    
}

-(IBAction)allOn:(id)sender;
-(IBAction)allOff:(id)sender;


@end

@implementation HomeTableView

@synthesize cells = cells_;

static NSString *REUSE_ID_Cell = @"HomeTableCell";

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    //aryData = [[NSMutableArray alloc]initWithObjects:@"",@"", nil];
    //此处载入设备记录
    //aryData = [[DBInterface instance] readAdapterInfo];
}

-(void)awakeFromNib
{
    [self registerNIBs];
    self.cells = [[NSMutableArray alloc] init];
}

- (void)registerNIBs
{
    //NSBundle *classBundle = [NSBundle bundleForClass:[CustomCell class]];
    
    UINib *CellMoreNib = [UINib nibWithNibName:REUSE_ID_Cell bundle:nil];
    [self registerNib:CellMoreNib forCellReuseIdentifier:REUSE_ID_Cell];
    //[[UdpSocket shared]checkStatus];
}

-(IBAction)allOn:(id)sender
{
    for (int i=0; i<self.aryData.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        HomeTableCell *cell = (HomeTableCell*)[self cellForRowAtIndexPath:indexPath];
        [cell sendSwitchCmd:YES];
    }
}

-(IBAction)allOff:(id)sender
{
    for (int i=0; i<self.aryData.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        HomeTableCell *cell = (HomeTableCell*)[self cellForRowAtIndexPath:indexPath];
        [cell sendSwitchCmd:NO];
    }
}

static CGFloat _s_unHeight1 = RAND_MAX;
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_s_unHeight1 == RAND_MAX)
    {
        _s_unHeight1 = [[AppWindow loadNibName:REUSE_ID_Cell] bounds].size.height;
    }
    return _s_unHeight1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.aryData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_ID_Cell];
    [self.cells addObject:cell];
    cell.delegate = self;
    cell.indexLbl.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    AAdapter *ada = [self.aryData objectAtIndex:indexPath.row];
    //设置名称
    cell.nameLbl.text = ada.name;
    //设置图标
    UIImage *image = [UIImage imageNamed:ada.ico];
    [cell.button setBackgroundImage:image forState:UIControlStateNormal];
    //设置状态
    switch ([ada getState]) {
        case ADA_ON:
            [cell.statusLbl setText:@"ON"];
            break;
        case ADA_OFF:
            [cell.statusLbl setText:@"OFF"];
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView switchAtIndexPath:(NSIndexPath *)indexPath status:(BOOL)isOn
{
    //[[[UdpSocket alloc]init]switchDevice:nil status:isOn];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *deviceInfo = [self.aryData objectAtIndex:indexPath.row];
    HomeTableCell *cell = (HomeTableCell*)[tableView cellForRowAtIndexPath:indexPath];
    SwitchDetailViewController *switchDetail = [[SwitchDetailViewController alloc]initWithNibName:@"SwitchDetailViewController" bundle:nil];
//    switchDetail.mac =
    switchDetail.deviceInfo = deviceInfo;
    switchDetail.isOn = cell.isON;
    switchDetail.hidesBottomBarWhenPushed = YES;
    switchDetail.devID = [cell.indexLbl.text integerValue];
    
    [[AppWindow getNavigationController] pushViewController:switchDetail animated:YES];
    [switchDetail release];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        AAdapter *ada = [self.aryData objectAtIndex:indexPath.row];
        [ada deleteThisAdapter];
        //[self.aryData removeObjectAtIndex:indexPath.row];
        [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


@end
