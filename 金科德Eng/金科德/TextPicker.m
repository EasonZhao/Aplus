//
//  TextPicker.m
//  Cycon
//
//  Created by Yangliu on 13-3-26.
//  Copyright (c) 2013年 Yangliu. All rights reserved.
//

#import "TextPicker.h"

@implementation TextPicker
@synthesize dataAry;
@synthesize selectedText;

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
    [picker release];
    [toolbar release];
}

-(void)awakeFromNib
{
    NSDate *now = [NSDate date];
    NSLog(@"now date is: %@", now);
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:now];
    
    [picker selectRow:[comps hour] inComponent:0 animated:NO];
    [picker selectRow:[comps minute] inComponent:1 animated:NO];
}

-(void)reloadData_
{
    
}

-(void)cancelBtnCilcked
{
    if ([self isFirstResponder])
        [self resignFirstResponder];
}

-(void)doneBtnClicked
{
    int row0 = [picker selectedRowInComponent:0];
    NSString *row0T = [self pickerView:picker titleForRow:row0 forComponent:0];
    int row1 = [picker selectedRowInComponent:1];
    NSString *row1T = [self pickerView:picker titleForRow:row1 forComponent:1];
    self.text = [NSString stringWithFormat:@"%@:%@",row0T,row1T];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self resignFirstResponder];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return component?60:24;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [NSString stringWithFormat:@"%02d",row%24];
            break;
        case 1:
            return [NSString stringWithFormat:@"%02d",row%60];
            break;
        default:
            return nil;
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
