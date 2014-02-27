//
//  TimingTableCell.h
//  金科德
//
//  Created by Yangliu on 13-9-10.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "MeTableCell.h"

@protocol TimingEnableSwitchDelegate <NSObject>

-(void)tableView:(UITableView*)tableView switchAtIndexPath:(NSIndexPath*)indexPath status:(BOOL)isOn;

@end

@interface TimingTableCell : MeTableCell

@property(nonatomic,readonly)IBOutlet UILabel *openLbl;
@property(nonatomic,readonly)IBOutlet UILabel *closeLbl;
@property(nonatomic,readonly)IBOutletCollection(UIButton)NSArray *buttons;
@property(nonatomic,readonly)IBOutlet UISwitch *switchBtn;
@property(nonatomic,assign)id<TimingEnableSwitchDelegate> delegate;

@end
