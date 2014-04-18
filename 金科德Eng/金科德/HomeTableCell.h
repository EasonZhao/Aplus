//
//  HomeTableCell.h
//  金科德
//
//  Created by Yangliu on 13-9-6.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "MeTableCell.h"
#import "NetKit.h"

@protocol HomeCellSwitchDelegate <NSObject,NetKitDelegate>

-(void)tableView:(UITableView*)tableView switchAtIndexPath:(NSIndexPath*)indexPath status:(BOOL)isOn;

@end

@interface HomeTableCell : MeTableCell
{
    //IBOutlet UILabel *statusLbl;
}

-(void)sendSwitchCmd:(BOOL)isNo;

-(void)setCmdRet:(BOOL)isSuccess;

@property(nonatomic)BOOL isON;
@property(nonatomic,readonly)IBOutlet UILabel *indexLbl;
@property(nonatomic,readonly)IBOutlet UIImageView *statusImgV;
@property(nonatomic,readonly)IBOutlet UILabel *statusLbl;
@property(nonatomic,readonly)IBOutlet UILabel *nameLbl;
@property(nonatomic,readonly)IBOutlet UIButton *button;
@property(nonatomic,assign)id<HomeCellSwitchDelegate> delegate;
@end
