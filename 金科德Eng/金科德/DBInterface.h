//
//  DBInterface.h
//  POTEK
//
//  Created by Eason Zhao on 14-2-28.
//  Copyright (c) 2014年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBInterface : NSObject

+ (DBInterface*)instance;

- (NSMutableArray*)readAdapterInfo;

- (void)deleteAdapter:(NSInteger)id;

- (BOOL)AdapterExist:(int)DevID;

- (BOOL)insertAdapter:(int)DevID name:(NSString*)name ico:(NSString*)ico type:(int)type;

- (BOOL)getAdapter:(int)DevID name:(NSString**)name ico:(NSString**)ico type:(int*)type;
@end
