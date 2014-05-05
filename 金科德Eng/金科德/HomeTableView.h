//
//  HomeTableView.h
//  金科德
//
//  Created by Yangliu on 13-9-6.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "MeTableView.h"

@protocol HomeViewDelegate <NSObject>

- (void)delDev:(Byte)DevID;

@end

@interface HomeTableView : MeTableView

@property(nonatomic,retain)NSMutableArray *cells;

- (void)setDelDelegate:(id)delegate;

@end
