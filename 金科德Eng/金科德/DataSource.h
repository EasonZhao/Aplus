//
//  UdpSocket.h
//  金科德
//
//  Created by Yangliu on 13-10-18.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject
{
    NSMutableDictionary *_localDB;
    NSString            *_localDBName;
}

+(id)sharedDataSource;

+(NSString*)resourcePath:(NSString*)name;
+(NSString*)documentPath:(NSString*)name;
+(NSString*)libraryPath:(NSString*)name;
+(NSString*)iconPath:(NSString*)name;
+(NSString*)saveData:(UIImage*)img;
+(NSString*)cachePath:(NSString*)name;

-(NSMutableArray*)deviceDatas;
-(NSMutableDictionary*)newDeviceData:(NSString*)mac;
-(void)saveDB;

@end
