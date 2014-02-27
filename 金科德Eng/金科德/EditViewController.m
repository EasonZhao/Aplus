//
//  EditViewController.m
//  金科德
//
//  Created by Yangliu on 13-9-10.
//  Copyright (c) 2013年 TouchCloud Information Technology (Shanghai) Co.,Ltd. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation EditViewController
@synthesize mac;

- (void)dealloc
{
    [mac release];
    [super dealloc];
}

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
    // Do any additional setup after loading the view from its nib.
//    self.navigationItem.leftBarButtonItem = [AppWindow getBarItemTitle:@"" Target:self Action:nil ImageName:@"Wi-Fi"];
//    self.navigationItem.rightBarButtonItem = [AppWindow getBarItemTitle:@"" Target:self Action:@selector(back:) ImageName:@"back"];
}

- (IBAction)image:(UIButton *)sender {
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从产品图库选择",@"从相机选择",@"从相机图库选择", nil];
    [action showInView:self.view];
    [action release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=actionSheet.cancelButtonIndex) {
        switch (buttonIndex) {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"" message:@"设备不支持" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] autorelease];
                    [alertView show];
                    return;
                }
                UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
                [picker setDelegate:self];
                [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
                [self presentModalViewController:picker animated:YES];
            }
                break;
            case 2:
            {
                UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
                [picker setDelegate:self];
                [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                [self presentModalViewController:picker animated:YES];
            }
                break;
            default:
                break;
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
