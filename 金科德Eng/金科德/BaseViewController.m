//
//  BaseViewController.m
//  金科德
//
//  Created by Yangliu on 13-9-2.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.titleView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]] autorelease];
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    [[UINavigationBar appearance]setTintColor:[UIColor colorWithRed:0. green:154./255. blue:209./255. alpha:1.]];
    [[UITabBar appearance]setSelectionIndicatorImage:[UIImage imageNamed:@"tabbarS.png"]];
    [[UITabBar appearance]setTintColor:color];
    self.view.backgroundColor = color;
    
//    [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"top-bar_bg.png"] forBarMetrics:UIBarMetricsDefault];
//    [[UITabBar appearance]setSelectionIndicatorImage:[UIImage imageNamed:@"tabbarSelectionIndicator.png"]];
//    [[UITabBar appearance]setBackgroundImage:[UIImage imageNamed:@"tabbar.png"]];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mian_bg.png"]];//[UIColor colorWithRed:67./255. green:67./255. blue:67./255. alpha:1.];
    if (self.navigationController.viewControllers.count>1) {
        self.navigationItem.leftBarButtonItem = [AppWindow getBarItemTitle:@"" Target:self Action:@selector(back:) ImageName:@"返回"];
    }
}

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
