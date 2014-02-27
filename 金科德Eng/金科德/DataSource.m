//
//  UdpSocket.h
//  金科德
//
//  Created by Yangliu on 13-10-18.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource
static DataSource *_sharedDataSource;

+(id)sharedDataSource
{
    if (!_sharedDataSource){
        _sharedDataSource = [[DataSource alloc] init];
    }
    return _sharedDataSource;
}

-(id)init
{
    self = [super init];
    if (self) {
        _localDBName = [[DataSource libraryPath:@"localDB.plist"] retain];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:_localDBName]) {
            _localDB = [[NSMutableDictionary alloc] init];
            [_localDB writeToFile:_localDBName atomically:YES];
        }else{
            _localDB = [[NSMutableDictionary alloc] initWithContentsOfFile:_localDBName];
        }
        
        NSError *error;
        NSString *data = [DataSource libraryPath:@"icon"];
        BOOL dir = YES;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:data isDirectory:&dir]) {
            [fileManager createDirectoryAtPath:data withIntermediateDirectories:YES attributes:nil error:&error];
        }
        
    }
    return self;
}

+(NSString*)cachePath:(NSString*)name
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [path stringByAppendingPathComponent:name];
}

+(NSString*)resourcePath:(NSString*)name
{
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name];
}

+(NSString*)documentPath:(NSString*)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *publicDocumentsDir = [paths objectAtIndex:0];
    return [publicDocumentsDir stringByAppendingPathComponent:name];
}

+(NSString*)libraryPath:(NSString*)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *publicDocumentsDir = [paths objectAtIndex:0];
    return [publicDocumentsDir stringByAppendingPathComponent:name];
}

+(NSString*)iconPath:(NSString*)name
{
    return [DataSource libraryPath:[@"icon" stringByAppendingPathComponent:name]];
}

+(NSString*)saveData:(UIImage*)img
{
    NSData *imgData = UIImageJPEGRepresentation(img, 0.8f);
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSString *path = [NSString stringWithFormat:@"%d.jpg",(int)now];
    path = [DataSource iconPath:path];
    [imgData writeToFile:path atomically:YES];
    return path;
}

-(NSMutableArray*)deviceDatas
{
    if (![_localDB objectForKey:@"devices"]) {
        [_localDB setValue:[NSMutableArray array] forKey:@"devices"];
        [self saveDB];
    }
    return  [_localDB objectForKey:@"devices"];
}

-(NSMutableDictionary*)newDeviceData:(NSString*)mac
{
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 mac,@"mac",
                                 [NSMutableArray array],@"timing",
                                 nil];
    [[self deviceDatas] addObject:data];
    [self saveDB];
    return data;
}

-(void)saveDB
{
    [_localDB writeToFile:_localDBName atomically:YES];
}
@end
