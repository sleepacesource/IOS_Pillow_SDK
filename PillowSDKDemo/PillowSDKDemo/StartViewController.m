//
//  StartViewController.m
//  RestonSDKDemo
//
//  Created by San on 2017/8/2.
//  Copyright © 2017年 medica. All rights reserved.
//

#import "StartViewController.h"
#import "ScanDeviceViewController.h"
#import "Tool.h"
#import "DeviceViewController.h"
#import "ControlViewController.h"
#import "DataViewController.h"
#import "AppDelegate.h"
#import "SleepAidViewController.h"
#import "SettingsViewController.h"

@interface StartViewController ()
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    [self setUI];
}

- (void)setUI
{
    SLPBLESharedManager;
    [self.searchButton setTitle:NSLocalizedString(@"search_device", nil) forState:UIControlStateNormal];
    [self.skipButton setTitle:NSLocalizedString(@"ignore", nil) forState:UIControlStateNormal];
    [Tool configSomeKindOfButtonLikeNomal:self.searchButton];
    [Tool configSomeKindOfButtonLikeNomal:self.skipButton];
    self.label1.text=NSLocalizedString(@"index_guide1", nil);
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.label3.text=[NSString stringWithFormat:NSLocalizedString(@"cur_app_version", nil), version];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=YES;
    [Tool writeStringToDocument:@""];
}

- (IBAction)pressScanDevice:(id)sender
{
    ScanDeviceViewController *scanVC=[[ScanDeviceViewController alloc]initWithNibName:@"ScanDeviceViewController" bundle:nil];
    self.navigationController.navigationBar.hidden=NO;
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (IBAction)pressSkip:(id)sender
{
    DeviceViewController *deviceVC=[[DeviceViewController alloc]initWithNibName:@"DeviceViewController" bundle:nil];
    deviceVC.title=NSLocalizedString(@"device_", nil);
    deviceVC.tabBarItem.image = [UIImage imageNamed:@"home.png"];
    
    ControlViewController *controlVC=[[ControlViewController alloc]initWithNibName:@"ControlViewController" bundle:nil];
    controlVC.title=NSLocalizedString(@"im_data", nil);
    controlVC.tabBarItem.image = [UIImage imageNamed:@"control.png"];
    
    SleepAidViewController *sleepAidVC=[[SleepAidViewController alloc]initWithNibName:@"SleepAidViewController" bundle:nil];
    sleepAidVC.title=NSLocalizedString(@"control_", nil);
    sleepAidVC.tabBarItem.image = [UIImage imageNamed:@"control.png"];
    
    SettingsViewController *settingsVC = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    settingsVC.title = NSLocalizedString(@"setting", nil);
    settingsVC.tabBarItem.image = [UIImage imageNamed:@"control.png"];
    
    DataViewController *dataVC=[[DataViewController alloc]initWithNibName:@"DataViewController" bundle:nil];
    dataVC.title=NSLocalizedString(@"tab_data", nil);
    dataVC.tabBarItem.image = [UIImage imageNamed:@"data.png"];
    
    UINavigationController *un1=[[UINavigationController alloc]initWithRootViewController:deviceVC];
    UINavigationController *un2=[[UINavigationController alloc]initWithRootViewController:controlVC];
    UINavigationController *un3=[[UINavigationController alloc]initWithRootViewController:sleepAidVC];
    UINavigationController *un4=[[UINavigationController alloc]initWithRootViewController:settingsVC];
    UINavigationController *un5=[[UINavigationController alloc]initWithRootViewController:dataVC];
    
    UITabBarController *tabbarVC=[[UITabBarController alloc]init];
    tabbarVC.viewControllers=[NSArray arrayWithObjects:un1,un2,un3,un4,un5, nil];
    self.navigationController.navigationBar.hidden=YES;
    [self.navigationController pushViewController:tabbarVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
