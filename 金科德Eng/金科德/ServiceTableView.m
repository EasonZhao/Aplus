//
//  ServiceTableView.m
//  金科德
//
//  Created by Yangliu on 13-9-8.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "ServiceTableView.h"
#import "ServiceTableCell.h"

@implementation ServiceTableView

static NSString *REUSE_ID_Cell = @"ServiceTableCell";

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
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ServiceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_ID_Cell];
    switch (indexPath.row) {
        case 0:
        {
            cell.imgV.image = [UIImage imageNamed:@"Wi-Fi_03.png"];
            cell.nameLbl.text = @"User help";
        }
            break;
        case 1:
        {
            cell.imgV.image = [UIImage imageNamed:@"Wi-Fi_06.png"];
            cell.nameLbl.text = @"FAQ";
        }
            break;
        case 2:
        {
            cell.imgV.image = [UIImage imageNamed:@"Wi-Fi_08.png"];
            cell.nameLbl.text = @"Share";
        }
            break;
        case 3:
        {
            cell.imgV.image = [UIImage imageNamed:@"Wi-Fi_10.png"];
            cell.nameLbl.text = @"About us";
        }
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
