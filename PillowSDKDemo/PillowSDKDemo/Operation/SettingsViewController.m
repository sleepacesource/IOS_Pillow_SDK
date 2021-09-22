//
//  SettingsViewController.m
//  PillowSDKDemo
//
//  Created by jie yang on 2021/9/22.
//  Copyright © 2021 medica. All rights reserved.
//

#import "SettingsViewController.h"
#import "BLEMuiscViewController.h"
#import "AlarmListViewController.h"

@interface SettingsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.tableFooterView = [UIView new];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.text = @"蓝牙音乐";
    if (indexPath.row == 1) {
        cell.textLabel.text = @"闹钟";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        BLEMuiscViewController *vc = [BLEMuiscViewController new];
        vc.title = @"蓝牙音乐";
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        AlarmListViewController *vc = [AlarmListViewController new];
        vc.title = @"闹钟";
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end