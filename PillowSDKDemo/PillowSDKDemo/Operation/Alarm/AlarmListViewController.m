//
//  AlarmListViewController.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/13.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "AlarmListViewController.h"

#import "SLPWeekDay.h"
#import "AlarmDataModel.h"
#import "AlarmViewController.h"
#import "TitleValueSwitchCellTableViewCell.h"
#import <Pillow/Pillow.h>
#import <Pillow/PillowAlarmInfo.h>
#import "UtilsHeads.h"
#import "SLPUtilHeads.h"
#import "TitleSubTitleArrowCell.h"
#import "TitleSwitchCell.h"
#import "Tool.h"


@interface AlarmListViewController ()<UITableViewDataSource, UITableViewDelegate, AlarmViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSMutableArray *alarmList;

@property (nonatomic, strong) LeftBedAlarmInfo *leftBedAlarmInfo;

@end

@implementation AlarmListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadData];
    
    [self setUI];
}

- (void)loadData
{
    __weak typeof(self) wealSelf = self;
    [SLPBLESharedManager pillow:SharedDataManager.peripheral getLeftBedAlarmInfoWithTimeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            wealSelf.leftBedAlarmInfo = data;
            [wealSelf.tableView reloadData];
        }
    }];
    
    [SLPBLESharedManager pillow:SharedDataManager.peripheral getAlarmListWithTimeout:0 callback:^(SLPDataTransferStatus status, id data) {
        NSArray *tempList = (NSArray *)data;
        if (tempList.count) {
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < tempList.count; i++) {
                PillowAlarmInfo *info = [tempList objectAtIndex:i];
                if (info.isValid == 1) {
                    [array addObject:info];
                }
            }
            wealSelf.alarmList = array;
            [wealSelf.tableView reloadData];
            SharedDataManager.alarmList = array;
        }
        
    }];
    
    
}

- (void)setUI
{
    self.titleLabel.text = NSLocalizedString(@"alarm", nil);
    [Tool configSomeKindOfButtonLikeNomal:self.addButton];
    [self.addButton setTitle:NSLocalizedString(@"add_alarm", nil) forState:UIControlStateNormal];
    
    self.alarmList = SharedDataManager.alarmList;
    if (self.alarmList && self.alarmList.count > 0) {
        [self.tableView reloadData];
    }
}

- (void)goAddAlarm
{
    if (self.alarmList.count >= 5) {
        [Utils showMessage:NSLocalizedString(@"max_count_per_device", nil) controller:self];
        return;
    }
    
    NSInteger alarmID = 0;
    if (self.alarmList.count > 0) {
        
        for (int i = 0; i < 5; i++) {
            BOOL isExist = NO;
            for (int j = 0; j < self.alarmList.count; j++) {
                PillowAlarmInfo *info = [self.alarmList objectAtIndex:j];
                if (i == info.alarmID) {
                    isExist = YES;
                }
            }
            if (!isExist) {
                alarmID = i;
                break;
            }
        }
    }
    AlarmViewController *vc = [AlarmViewController new];
    vc.title = NSLocalizedString(@"add_alarm", nil);
    vc.delegate = self;
    vc.addAlarmID = alarmID;
    vc.alarmPageType = AlarmPageType_Add;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger extroNum = 1;
    if (self.leftBedAlarmInfo.isOpen) {
        extroNum = 2;
    }
    return self.alarmList.count > 0 ? extroNum + self.alarmList.count : 0;
}

- (NSString *)getLeftOperationStr:(UInt8)operation {
    NSString *str = NSLocalizedString(@"snooze_", nil);
    if (operation == 1) {
        str = NSLocalizedString(@"turn_off_alarm", nil);
    }
    
    return  str;
}

- (void)configLeftBedAlarmInfo {
    [SLPBLESharedManager pillow:SharedDataManager.peripheral leftBedAlarmConfig:self.leftBedAlarmInfo timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tempCell = nil;
    if (indexPath.row == 0) {
        TitleSwitchCell *cell = (TitleSwitchCell *)[SLPUtils tableView:tableView cellNibName:@"TitleSwitchCell"];
        
        cell.titleLabel.text = NSLocalizedString(@"leave_bed_alarm", nil);
        cell.switcher.on = self.leftBedAlarmInfo.isOpen;
        
        __weak typeof(self) weakSelf = self;
        cell.switchBlock = ^(UISwitch *sender) {
            weakSelf.leftBedAlarmInfo.isOpen = sender.on;
            [weakSelf configLeftBedAlarmInfo];
            [weakSelf.tableView reloadData];
        };
        
        tempCell = cell;
    } else if(indexPath.row == 1) {
        if (self.leftBedAlarmInfo.isOpen) {
            TitleSubTitleArrowCell *baseCell = (TitleSubTitleArrowCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSubTitleArrowCell"];
            baseCell.titleLabel.text = NSLocalizedString(@"off_pillow", nil);
            baseCell.subTitleLabel.text = [self getLeftOperationStr:self.leftBedAlarmInfo.operation];
            [Utils configCellTitleLabel:baseCell.textLabel];
            tempCell = baseCell;
        } else {
            TitleValueSwitchCellTableViewCell *cell = (TitleValueSwitchCellTableViewCell *)[SLPUtils tableView:tableView cellNibName:@"TitleValueSwitchCellTableViewCell"];
            
            PillowAlarmInfo *alarmData = [self.alarmList objectAtIndex:indexPath.row - 1];
            cell.titleLabel.text = [self getAlarmTimeStringWithDataModle:alarmData];
            cell.subTitleLbl.text = [SLPWeekDay getAlarmRepeatDayStringWithWeekDay:alarmData.repeat];
            cell.switcher.on = alarmData.isOpen;
            
            __weak typeof(self) weakSelf = self;
            cell.switchBlock = ^(UISwitch *sender) {
                if (sender.on) {
                    [weakSelf turnOnAlarmWithAlarm:alarmData];
                }else{
                    [weakSelf turnOffAlarmWithAlarm:alarmData];
                }
            };
            
            tempCell = cell;
        }
        
    } else {
        TitleValueSwitchCellTableViewCell *cell = (TitleValueSwitchCellTableViewCell *)[SLPUtils tableView:tableView cellNibName:@"TitleValueSwitchCellTableViewCell"];
        NSInteger index = indexPath.row - 1;
        if (self.leftBedAlarmInfo.isOpen) {
            index = indexPath.row - 2;
        }
        PillowAlarmInfo *alarmData = [self.alarmList objectAtIndex:index];
        cell.titleLabel.text = [self getAlarmTimeStringWithDataModle:alarmData];
        cell.subTitleLbl.text = [SLPWeekDay getAlarmRepeatDayStringWithWeekDay:alarmData.repeat];
        cell.switcher.on = alarmData.isOpen;
        
        __weak typeof(self) weakSelf = self;
        cell.switchBlock = ^(UISwitch *sender) {
            if (sender.on) {
                [weakSelf turnOnAlarmWithAlarm:alarmData];
            }else{
                [weakSelf turnOffAlarmWithAlarm:alarmData];
            }
        };
        
        tempCell = cell;
    }
    
    return tempCell;
}

- (void)turnOnAlarmWithAlarm:(PillowAlarmInfo *)alarmInfo
{
    if (![SLPBLESharedManager blueToothIsOpen]) {
        [self.tableView reloadData];
        [Utils showMessage:NSLocalizedString(@"not_bluetooth", nil) controller:self];
        return;
    }
    __weak typeof(self) weakSelf = self;
    alarmInfo.isOpen = YES;
    [SLPBLESharedManager pillow:SharedDataManager.peripheral alarmConfig:alarmInfo timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)turnOffAlarmWithAlarm:(PillowAlarmInfo *)alarmInfo
{
    if (![SLPBLESharedManager blueToothIsOpen]) {
        [self.tableView reloadData];
        [Utils showMessage:NSLocalizedString(@"not_bluetooth", nil) controller:self];
        return;
    }
    __weak typeof(self) weakSelf = self;
    alarmInfo.isOpen = NO;
    [SLPBLESharedManager pillow:SharedDataManager.peripheral alarmConfig:alarmInfo timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            [weakSelf.tableView reloadData];
        }
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return;
    }
    if (indexPath.row == 1) {
        if (self.leftBedAlarmInfo.isOpen) {
            [self goSelectLeftBedOperation];
            return;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger index = indexPath.row - 1;
    if (self.leftBedAlarmInfo.isOpen) {
        index = indexPath.row - 2;
    }
    PillowAlarmInfo *alarmData = [self.alarmList objectAtIndex:index];
    
    [self goAlarmVCWithAlarmData:alarmData];
}

- (void)goSelectLeftBedOperation {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"off_pillow", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"turn_off_alarm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.leftBedAlarmInfo.operation = 1;
        [weakSelf configLeftBedAlarmInfo];
        [weakSelf.tableView reloadData];
    }];
    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"snooze_", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.leftBedAlarmInfo.operation = 0;
        [weakSelf configLeftBedAlarmInfo];
        [weakSelf.tableView reloadData];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [alertController addAction:resetAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)goAddAlarm:(UIButton *)sender {
    [self goAddAlarm];
}

- (void)goAlarmVCWithAlarmData:(PillowAlarmInfo *)alarmData
{
    AlarmViewController *vc = [AlarmViewController new];
    vc.delegate = self;
    vc.title = NSLocalizedString(@"edit_alarm", nil);
    vc.orignalAlarmData = alarmData;
    vc.alarmPageType = AlarmPageType_edit;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 ) {
        return 60;
    } else if (indexPath.row == 1) {
        if (self.leftBedAlarmInfo.isOpen) {
            return 60;
        }
    }
    
    return 80;
}

- (NSString *)getAlarmTimeStringWithDataModle:(PillowAlarmInfo *)dataModel {
    return [SLPUtils timeStringFrom:dataModel.hour minute:dataModel.minute isTimeMode24:[SLPUtils isTimeMode24]];
}

- (void)editAlarmInfoAndShouldReload
{
    [self loadData];
}
@end
