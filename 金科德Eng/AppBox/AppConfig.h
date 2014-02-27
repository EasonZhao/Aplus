//
//  AppConfig.h
//  MeAppBox
//
//  Created by absir on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef MeAppBox_AppConfig_h
#define MeAppBox_AppConfig_h

//全局设置
#define SYS_OBJ_NULL    @""
#define SYS_VERSION     100
#define SYS_LANGUAGE    @"CN"

//iPhone/iPad
//UNIVERSAL_DEVICES
#define IPHONE_SUFFIX   @""
#define IPAD_SUFFIX     @"_iPad"

#define RES_NORMAL_PNG  @".png"
#define RES_DOWN_PNG    @"_c.png"
#define RES_SELECT_PNG  @"_s.png"
#define RES_DISABLE_PNG @"_d.png"

#define BUNLD_APPID     @"631159904"
#define BUNLD_AUTHOR    @"authorID"

#define IS_IPAD  ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] &&[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define IS_IPHONE_5 ([[UIScreen mainScreen ] bounds].size.height > 480)

#define isSimulator (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location) 

//服务器设置

/*--DEBUG 参数
 defined SERVER_DEBUG -> url; 
 0x01 -> Response; 
 0x02 -> RequestHeader; 
 0x04 -> RequestBody; 
 0x08 -> ResponseHeader; 
 */
#define SERVER_DEBUG    0x01|0x02|0x04

//@"http://:8080/SanguoGameServer/client/"
//@"http://203.156.199.12:8080"
//http://touchcloud.dlinkddns.com/ecshop/
//http://cyconapp.cycon.cn/
#define SERVER_URL_PATH @"http://cyconapp.cycon.cn/app/"
#define SERVER_RES_PATH @"http://cyconapp.cycon.cn/"

#endif
