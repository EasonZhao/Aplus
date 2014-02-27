//
//  SettingTableCell.h
//  金科德
//
//  Created by Yangliu on 13-9-6.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "MeTableCell.h"

@protocol SettingCellSwitchDelegate <NSObject>

-(void)tableView:(UITableView*)tableView switchAtIndexPath:(NSIndexPath*)indexPath status:(BOOL)isOn;

@end

@interface SettingTableCell : MeTableCell
{
    
}

@property(nonatomic,assign)id<SettingCellSwitchDelegate> delegate;
@property(nonatomic,readonly)IBOutlet UIImageView *imgV;
@property(nonatomic,readonly)IBOutlet UILabel *nameLbl;
@property(nonatomic,readonly)IBOutlet UIButton *switchBtn;

@end
