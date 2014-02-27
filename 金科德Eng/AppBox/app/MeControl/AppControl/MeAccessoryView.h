//
//  MeAccessoryView.h
//  MeAppOA
//
//  Created by absir on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//取消 确定|清除导航条
@interface MeAccessoryToolBar : UIToolbar 
{
    IBOutlet UIBarButtonItem *leftItem;
    IBOutlet UIBarButtonItem *rightItem;
    
    UIControl *_responder;
}
@property(nonatomic, readonly)UIBarButtonItem *leftItem;
@property(nonatomic, readonly)UIBarButtonItem *rightItem;

//取消
- (IBAction)leftItemClick:(id)sender;

//确定|清除
- (IBAction)rightItemClick:(id)sender;

//设置方法
- (void)setAccessoryResponder:(UIControl *)responder;

@end

//上一个->下一个 导航条
@interface NextAccessoryToolBar : MeAccessoryToolBar
{
    IBOutlet UIBarItem *secendItem;
    
    UIResponder *preResponder;
    UIResponder *nextResPonder;
}

//下一个
- (IBAction)secendItemClick:(id)sender;

@end



