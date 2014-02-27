//
//  MeOptionView.h
//  MeAppBox
//
//  Created by absir on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//配置选择控件
@interface MeOptionView : UIView
{
    int selectIndex;
    UIButton *selectBtn;
    NSMutableArray *optionBtns;
}
@property(nonatomic, assign)int selectIndex;
-(void)selectIndex:(int)selectIndex_;
@end

//配置选择控件必需控件
@interface RequireOptionView : MeOptionView

@property(nonatomic, retain)IBOutlet UIControl *requireControl;

@end