//
//  ComboboxPicker.m
//  POTEK
//
//  Created by Eason Zhao on 14-6-8.
//  Copyright (c) 2014年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "ComboboxPicker.h"

@implementation ComboboxPicker

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    picker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    
    toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleBlackOpaque;
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]
                               initWithTitle:@"取消" style:UIBarButtonItemStyleDone
                               target:self action:@selector(cancelBtnCilcked)];
    [barItems addObject:cancel];
    [cancel release];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:self action:nil];
    [barItems addObject:flexSpace];
    [flexSpace release];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]
                            initWithTitle:@"完成" style:UIBarButtonItemStyleDone
                            target:self action:@selector(doneBtnClicked)];
    [barItems addObject:btn];
    [btn release];
    
    [toolbar setItems:barItems animated:YES];
    [barItems release];
    toolbar.frame = CGRectMake(0, 0, 320, 46);
    
    self.inputView = picker;
    self.inputAccessoryView = toolbar;
    self.text = @"1";
    [picker release];
    [toolbar release];
}

-(void)doneBtnClicked
{
    int row0 = [picker selectedRowInComponent:0];
    NSString *row0T = [self pickerView:picker titleForRow:row0 forComponent:0];
    if (![self.text isEqualToString:[NSString stringWithFormat:@"%@",row0T]]) {
        self.text = [NSString stringWithFormat:@"%@",row0T];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    } 
    [self resignFirstResponder];
}

- (void)cancelBtnCilcked
{
    if ([self isFirstResponder])
        [self resignFirstResponder];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [NSString stringWithFormat:@"%d",row+1];
            break;
        case 1:
            return [NSString stringWithFormat:@"%d",row];
            break;
        default:
            return nil;
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

@end
