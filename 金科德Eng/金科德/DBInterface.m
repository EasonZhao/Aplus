//
//  DBInterface.m
//  POTEK
//
//  Created by Eason Zhao on 14-2-28.
//  Copyright (c) 2014年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "DBInterface.h"
#import "AAdapter.h"

#define DBNAME @"apluse.sqlite"
#define CREATE_TABLE_ADAPTER @"CREATE  TABLE \"main\".\"Adapter\" (\"ID\" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , \"Name\" TEXT NOT NULL , \"Ico\" TEXT NOT NULL , \"Type\" INTEGER)"

static DBInterface *_instance = nil;

///数据库访问接口
@implementation DBInterface
{
    sqlite3 *_db;
}

+ (DBInterface*)instance
{
    if (_instance==nil) {
        _instance = [[super alloc] init];
    }
    return _instance;
}

//+ (id)allocWithZone:(struct _NSZone *)zone
//{
//    return [self instance];
//}
//
//+ (id)copyWithZone:(struct _NSZone *)zone
//{
//    return [self instance];
//}

- (id)init
{
    if (_instance) {
        return _instance;
    }
    self = [super init];
    if(self){
        _db = nil;
        //初始化db接口
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *db_path = Nil;
        if ([paths count]>0) {
            db_path = [paths objectAtIndex:0];
            db_path = [db_path stringByAppendingPathComponent:DBNAME];
        }
        //判断文件是否存在
        if (![[NSFileManager defaultManager] fileExistsAtPath:db_path]) {
            NSAssert([self createDataBase:db_path], @"create database failure!");
        }
        NSAssert(sqlite3_open([db_path UTF8String], &_db)==SQLITE_OK,
                 @"open sql failure!") ;
    }
    return self;
}

//- (id)retain
//{
//    return self;
//}
//
//- (oneway void)release
//{
//    
//}
//
//- (id)autorelease
//{
//    return self;
//}
//
//- (NSUInteger)retainCount
//{
//    return NSUIntegerMax;
//}

- (BOOL)createDataBase:(NSString *)path
{
    BOOL createResult = NO;
    int result = sqlite3_open([path UTF8String], &_db);
    switch (result) {
        case SQLITE_OK:
            NSLog(@"create success");
            createResult = YES;
            break;
            
        default:
            NSLog(@"create database failure %s", sqlite3_errmsg(_db));
            createResult = NO;
            break;
    }
    //创建表格
    NSString *createAdapterTableSql = CREATE_TABLE_ADAPTER;
    BOOL createTableRet = [self execSql:createAdapterTableSql];
    if (!createTableRet) {
        sqlite3_close(_db);
        return NO;
    }
    createResult = YES;
    sqlite3_close(_db);
    return createResult;
}

-(BOOL) execSql:(NSString*)sql
{
    char *err;
    BOOL ret = YES;
    int exeRet = sqlite3_exec(_db, [sql UTF8String], NULL, NULL, &err);
    if (exeRet!=SQLITE_OK) {
        sqlite3_close(_db);
        NSLog(@"slq exe faiulre: %s", sqlite3_errmsg(_db));
        ret = NO;
    }
    return ret;
}

-(NSMutableArray*) readAdapterInfo
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSString *sql = @"SELECT * FROM Adapter";
    sqlite3_stmt *statement;
    int retval = sqlite3_prepare_v2(_db, [sql UTF8String], -1, &statement, nil);
    if(retval!=SQLITE_OK)
        return nil;
    while (sqlite3_step(statement)==SQLITE_ROW) {
        AAdapter *ada = [[AAdapter alloc] init];
        int id = sqlite3_column_int(statement, 0);
        
        [ada setId:id];
        char *nameStr = (char*)sqlite3_column_text(statement, 1);
        NSString *name = [[NSString alloc] initWithUTF8String:nameStr];
        ada.name = name;
        char *icoStr = (char*)sqlite3_column_text(statement, 2);
        NSString *ico = [[NSString alloc] initWithUTF8String:icoStr];
        ada.ico = ico;
        int type = sqlite3_column_int(statement, 3);
        NSLog(@"id:%d, name:%@, ico:%@, type:%d", id,
              name, ico, type);
        [arr addObject: ada];
    }
    return arr;
}

- (void)deleteAdapter:(NSInteger)id
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM Adapter WHERE ID=%d", id];
    NSAssert([self execSql:sql], @"delete adapter failure!");
}

@end
