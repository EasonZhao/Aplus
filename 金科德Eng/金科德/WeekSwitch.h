//
//  WeekSwitch.h
//  TestUdpClient
//
//  Created by Yangliu on 13-10-17.
//  Copyright (c) 2013年 e-linkway.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeekSwitch : NSObject
-(void)enable;
-(void)openSu;;
-(void)openSa;
-(void)openFr;
-(void)openTh;
-(void)openWe;
-(void)openTu;
-(void)openMo;;
-(void)disable;
-(void)closeSu;
-(void)closeSa;
-(void)closeFr;
-(void)closeTh;;
-(void)closeWe;
-(void)closeTu;
-(void)closeMo;
-(Byte)getWeek;
-(void)setWeek:(Byte)week_;
@end
