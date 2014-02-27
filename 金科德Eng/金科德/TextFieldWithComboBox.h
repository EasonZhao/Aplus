//
//  TextFieldWithComboBox.h
//  iBanTest
//
//  Created by Yangliu on 12-10-15.
//  Copyright (c) 2012年 Yangliu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppBox.h"
#import "MeTextField.h"

@protocol chooseUsername <NSObject>

-(void)didSelectItemAtIndex:(int)index text:(NSString*)text;

@end

@interface TextFieldWithComboBox : UITextField<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *comboBoxTableView;
    BOOL _showComboBox;
    UIButton *pullDownBtn;
}
@property(nonatomic,retain)UITableView *comboBoxTableView;
@property(nonatomic, retain) NSMutableArray *comboBoxDatasource;
@property(nonatomic, assign)IBOutlet id <chooseUsername>dele;
@property(nonatomic, retain)NSString *selectedString;
@property(nonatomic)int selectedIndex;
@property(nonatomic)BOOL canBeActive;
@property(nonatomic)CGFloat comboHeight;
@property(nonatomic)CGFloat comboRowHeight;

- (void)show;
- (void)hidden;

@end
