//
//  HomeTableCell.m
//  金科德
//
//  Created by Yangliu on 13-9-6.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "HomeTableCell.h"

@implementation HomeTableCell
{
    NSTimer *timer_;        
}
@synthesize delegate;
@synthesize isON;
@synthesize indexLbl;
@synthesize statusImgV;
@synthesize statusLbl;
@synthesize nameLbl;
@synthesize button;
@synthesize socket = socket_;

- (void)dealloc
{
    [statusImgV release];
    [indexLbl release];
    [statusLbl release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)timeoutHandle
{
    [self.button setEnabled:TRUE];
}

-(void)sendSwitchCmd:(BOOL)isNo
{
     Byte devID = [self.indexLbl.text intValue];
    [self.socket switchDevice:isNo devID:devID];
    [self.button setEnabled:FALSE];
    //启动定时器
    timer_ = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timeoutHandle) userInfo:nil repeats:NO];
}

- (IBAction)switchBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self sendSwitchCmd:sender.selected];
    
    /*
    statusLbl.text = sender.selected?@"on":@"off";
    self.isON = sender.selected;
    UITableView *tableView = (UITableView*)self.superview;
    while (tableView) {
        if ([tableView isKindOfClass:[UITableView class]]) {
            break;
        }
        tableView = (UITableView*)tableView.superview;
    }
    NSIndexPath *indexPath = [tableView indexPathForCell:self];
    if (delegate&&[delegate respondsToSelector:@selector(tableView:switchAtIndexPath:status:)]) {
        [delegate tableView:tableView switchAtIndexPath:indexPath status:sender.selected];
    }*/
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
