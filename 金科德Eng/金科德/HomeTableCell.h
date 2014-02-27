//
//  HomeTableCell.h
//  金科德
//
//  Created by Yangliu on 13-9-6.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "MeTableCell.h"

@protocol HomeCellSwitchDelegate <NSObject>

-(void)tableView:(UITableView*)tableView switchAtIndexPath:(NSIndexPath*)indexPath status:(BOOL)isOn;

@end

@interface HomeTableCell : MeTableCell
{
    //IBOutlet UILabel *statusLbl;
}
@property(nonatomic)BOOL isON;
@property(nonatomic,readonly)IBOutlet UILabel *indexLbl;
@property(nonatomic,readonly)IBOutlet UIImageView *statusImgV;
@property(nonatomic,readonly)IBOutlet UILabel *statusLbl;
@property(nonatomic,assign)id<HomeCellSwitchDelegate> delegate;

@end
