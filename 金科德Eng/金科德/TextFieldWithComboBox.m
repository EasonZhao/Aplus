//
//  TextFieldWithComboBox.m
//  iBanTest
//
//  Created by Yangliu on 12-10-15.
//  Copyright (c) 2012年 Yangliu. All rights reserved.
//

#import "TextFieldWithComboBox.h"
#import <QuartzCore/QuartzCore.h>
#import "AppBox.h"

@implementation TextFieldWithComboBox
@synthesize comboBoxDatasource,dele,selectedString,selectedIndex;
@synthesize canBeActive;
@synthesize comboHeight;
@synthesize comboRowHeight;
@synthesize comboBoxTableView;

- (void)dealloc
{
    comboBoxTableView.delegate		= nil;
    comboBoxTableView.dataSource	= nil;
    [comboBoxDatasource release];
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
    if (self){
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    UILabel *userName= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 28)];
    userName.text = @"帐号:";
    userName.font = [UIFont systemFontOfSize:14];
    userName.backgroundColor = [UIColor clearColor];
    self.leftView = userName;
    [userName release];
    self.leftViewMode = UITextFieldViewModeAlways;
    _showComboBox = NO;
}

-(BOOL)canBecomeFirstResponder
{
    return canBeActive;
}

//- (CGRect)textRectForBounds:(CGRect)bounds {
//    return CGRectMake(bounds.origin.x + 42.0f, bounds.origin.y, bounds.size.width, bounds.size.height);
//}
//
//- (CGRect)editingRectForBounds:(CGRect)bounds {
//    return CGRectMake(bounds.origin.x + 42.0f, bounds.origin.y, bounds.size.width, bounds.size.height);
//}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    pullDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *downImg = [UIImage imageNamed:@"down.png"];
    pullDownBtn.frame = CGRectMake(self.bounds.size.width-downImg.size.width+2, (self.bounds.size.height-downImg.size.width)/2, downImg.size.width, downImg.size.height);
    [pullDownBtn setImage:downImg forState:UIControlStateNormal];
//    pullDownBtn.backgroundColor = [UIColor redColor];
//    [pullDownBtn setBackgroundColor:[UIColor redColor]];
    [pullDownBtn addTarget:self action:@selector(pulldownButtonWasClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pullDownBtn];
    
    //self.comboBoxDatasource = [NSMutableArray arrayWithObjects:@"一般客户系统",@"被子面料客户系统", nil];
    
//    SqliteClass *sql = [SqliteClass shared];
//    NSArray *userAry = [sql query:@"select DISTINCT username from USERINFO "];
//    for (NSDictionary *usernameDic in userAry)
//    {
//        [comboBoxDatasource addObject:[usernameDic objectForKey:@"username"]];
//    }
    
    //[comboBoxDatasource addObjectsFromArray:[NSArray arrayWithObjects:@"one", @"two", @"three", @"four", @"five", @"six", @"seven", @"eight", nil]];
#ifdef UNIVERSAL
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        comboBoxTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y+self.bounds.size.height, self.bounds.size.width, comboHeight?comboHeight:200)];
    }else
#endif
    {
        comboBoxTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x,self.frame.origin.y+self.bounds.size.height, self.bounds.size.width, comboHeight?comboHeight:100)];
    }
    
	comboBoxTableView.dataSource = self;
	comboBoxTableView.delegate = self;
	//comboBoxTableView.backgroundColor = [UIColor clearColor];
	//comboBoxTableView.separatorColor = [UIColor blackColor];
	comboBoxTableView.hidden = YES;
    UIView *superview = self.superview;
    if (superview) 
        [superview addSubview:comboBoxTableView];
    if(newSuperview)
        [newSuperview addSubview:comboBoxTableView];
    //设置layer
    CALayer *layer=[comboBoxTableView layer];
    //是否设置边框以及是否可见
    [layer setMasksToBounds:YES];
    //设置边框圆角的弧度
    [layer setCornerRadius:5.0];
    //设置边框线的宽
    [layer setBorderWidth:0.2];
    //设置边框线的颜色
    [layer setBorderColor:[[UIColor blackColor] CGColor]];
    
	[comboBoxTableView release];
    
}

-(void)setComboRowHeight:(CGFloat)comboRowHeight_
{
    comboRowHeight = comboRowHeight_;
    [comboBoxTableView reloadData];
}

-(void)setComboHeight:(CGFloat)comboHeight_
{
    comboHeight = comboHeight_;
    CGRect rect = comboBoxTableView.frame;
    rect.size.height = comboHeight_;
    comboBoxTableView.frame = rect;
}

-(BOOL)isFirstResponder
{
    [self bringSubviewToFront:pullDownBtn];
    //pullDownBtn.hidden = YES;
    return [super isFirstResponder];
}

-(BOOL)resignFirstResponder
{
    [self hidden];
    //pullDownBtn.hidden = NO;
    return [super resignFirstResponder];
}

- (void)setContent:(NSString *)content {
	self.text = content;
}

- (void)show {
    [self.superview bringSubviewToFront:comboBoxTableView];
	comboBoxTableView.hidden = NO;
	_showComboBox = YES;
}

- (void)hidden {
	comboBoxTableView.hidden = YES;
	_showComboBox = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [comboBoxDatasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"ListCellIdentifier";
	UITableViewCell *cell = [comboBoxTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	cell.textLabel.text = (NSString *)[comboBoxDatasource objectAtIndex:indexPath.row];
	cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	return cell;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        [[SqliteClass shared]deleteTable:@"USERINFO" SqlStr:[NSString stringWithFormat:@"where username='%@'",[comboBoxDatasource objectAtIndex:indexPath.row]]];
//        [comboBoxDatasource removeObjectAtIndex:indexPath.row];
//        [comboBoxTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return comboRowHeight?comboRowHeight:35.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self hidden];
	self.text = (NSString *)[comboBoxDatasource objectAtIndex:indexPath.row];
    self.selectedString = self.text;
    self.selectedIndex = indexPath.row;
    if (dele&&[dele respondsToSelector:@selector(didSelectItemAtIndex:text:)]) {
        [dele didSelectItemAtIndex:indexPath.row text:self.text];
    }
}

- (void)pulldownButtonWasClicked:(id)sender {
	if (_showComboBox == YES) {
		[self hidden];
	}else {
		[self show];
	}
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
