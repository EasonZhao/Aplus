//
//  AAdapter.h
//  POTEK
//
//  Created by Eason Zhao on 14-3-1.
//  Copyright (c) 2014年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAdapter : NSObject


@property(nonatomic, retain) NSString *name;

@property(nonatomic, retain) NSString *ico;


- (void)setId:(int)id;

- (void)deleteThisAdapter;
@end
