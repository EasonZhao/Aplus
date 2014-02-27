//
//  TimingTableView.m
//  金科德
//
//  Created by Yangliu on 13-9-10.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "TimingTableView.h"
#import "TimingTableCell.h"
#import "TimeEditViewController.h"

@interface TimingTableView ()<TimingEnableSwitchDelegate>

@end

@implementation TimingTableView

static NSString *REUSE_ID_Cell = @"TimingTableCell";

- (id)initWithFrame:(CGRect)frame
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
    return aryData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_ID_Cell];
    NSDictionary *data = [aryData objectAtIndex:indexPath.row];
    Byte week = [[data objectForKey:@"week"] intValue];
    Byte c = 0x01;
    for(UIButton *b in cell.buttons)
    {
        int o = week&c;
        b.selected = o!=0;
        c = c<<1;
    }
    cell.openLbl.text = [NSString stringWithFormat:@"%@:%@",[data objectForKey:@"hourON"],[data objectForKey:@"minON"]];
    cell.closeLbl.text = [NSString stringWithFormat:@"%@:%@",[data objectForKey:@"hourOFF"],[data objectForKey:@"minOFF"]];
    cell.switchBtn.on = [[data objectForKey:@"enable"] boolValue];
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView switchAtIndexPath:(NSIndexPath *)indexPath status:(BOOL)isOn
{
    NSMutableDictionary *data = [aryData objectAtIndex:indexPath.row];
    [data setObject:isOn?@"1":@"0" forKey:@"enable"];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *data = [aryData objectAtIndex:indexPath.row];
    TimeEditViewController *timeEdit = [[TimeEditViewController alloc]initWithNibName:@"TimeEditViewController" bundle:nil];
    timeEdit.timingTableView = self;
    timeEdit.data = (NSMutableDictionary*)data;
    timeEdit.isAdd = NO;
    [[AppWindow getNavigationController] pushViewController:timeEdit animated:YES];
    [timeEdit release];
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
