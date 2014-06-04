//
//  SettingTableView.m
//  金科德
//
//  Created by Yangliu on 13-9-6.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "SettingTableView.h"
#import "SettingTableCell.h"
#import "AddDeviceViewController.h"
#import "NetKit.h"
#import "SVProgressHUD.h"

@interface SettingTableView ()<SettingCellSwitchDelegate, NetKitDelegate>

@end

@implementation SettingTableView
{
    NSTimer *timer_;
}

static NSString *REUSE_ID_Cell = @"SettingTableCell";

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
}

-(void)awakeFromNib
{
    [self registerNIBs];
}

- (void)registerNIBs
{
    //NSBundle *classBundle = [NSBundle bundleForClass:[CustomCell class]];
    
    UINib *CellMoreNib = [UINib nibWithNibName:REUSE_ID_Cell bundle:nil];
    [self registerNib:CellMoreNib forCellReuseIdentifier:REUSE_ID_Cell];
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
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_ID_Cell];
    switch (indexPath.row) {
        case 0:
        {
            cell.switchBtn.hidden = YES;
            cell.imgV.image = [UIImage imageNamed:@"添加设备.png"];
            cell.nameLbl.text = @"Add a new device";
        }
            break;
        case 1:
        {
            cell.imgV.image = [UIImage imageNamed:@"震动.png"];
            cell.nameLbl.text = @"Key vibration";
        }
            break;
        case 2:
        {
            cell.imgV.image = [UIImage imageNamed:@"下载更新.png"];
            cell.nameLbl.text = @"Auto update";
        }
            break;
        default:
            break;
    }
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView switchAtIndexPath:(NSIndexPath *)indexPath status:(BOOL)isOn
{
    NSLog(@"switch %@ %@",indexPath,isOn?@"on":@"off");
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!indexPath.row) {
        
//        AddDeviceViewController *addDevice = [[AddDeviceViewController alloc]initWithNibName:@"AddDeviceViewController" bundle:nil];
//        [[AppWindow getNavigationController] pushViewController:addDevice animated:YES];
//        [addDevice release];
        [[NetKit instance] addDevice:self];
        timer_ = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timeoutHandle) userInfo:nil repeats:NO];
        //提示
        [SVProgressHUD showWithStatus:@"添加中..." maskType:SVProgressHUDMaskTypeClear];
    }
}

-(void)addDeviceHandler:(BOOL)success
{
    if (timer_ && [timer_ isValid]) {
        [timer_ invalidate];
    }
    if (success) {
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"指令失败"];
    }
}

- (void)timeoutHandle
{
    [SVProgressHUD showErrorWithStatus:@"指令失败"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
