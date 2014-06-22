//
//  SwitchDetailViewController.h
//  金科德
//
//  Created by Yangliu on 13-9-9.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "BaseViewController.h"
#import "NetKit.h"

@interface SwitchDetailViewController : BaseViewController<NetKitDelegate>
{
    UISlider *lightSlider_;
}
@property(nonatomic,retain)NSString *mac;
@property(nonatomic)BOOL isOn;
@property(nonatomic,retain)NSString *deviceInfo;
@property(nonatomic)int devID;

@property(nonatomic,assign)IBOutlet UISlider *lightSlider_;

@end
