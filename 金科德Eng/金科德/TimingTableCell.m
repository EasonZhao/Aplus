//
//  TimingTableCell.m
//  金科德
//
//  Created by Yangliu on 13-9-10.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "TimingTableCell.h"

@implementation TimingTableCell
@synthesize openLbl;
@synthesize closeLbl;
@synthesize buttons;
@synthesize switchBtn;
@synthesize delegate;

- (void)dealloc
{
    [openLbl release];
    [closeLbl release];
    [buttons release];
    [switchBtn release];
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

- (IBAction)switchChanged:(UISwitch *)sender {
    UITableView *tableView = (UITableView*)self.superview;
    while (tableView) {
        if ([tableView isKindOfClass:[UITableView class]]) {
            break;
        }
        tableView = (UITableView*)tableView.superview;
    }
    NSIndexPath *indexPath = [tableView indexPathForCell:self];
    if (delegate&&[delegate respondsToSelector:@selector(tableView:switchAtIndexPath:status:)]) {
        [delegate tableView:tableView switchAtIndexPath:indexPath status:sender.isOn];
    }
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
