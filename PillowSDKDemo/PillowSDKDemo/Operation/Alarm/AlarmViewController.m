//
//  AlarmViewController.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/14.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "AlarmViewController.h"

#import "SLPTableSectionData.h"
#import "TitleSwitchCell.h"
#import "SLPWeekDay.h"
#import "SLPViewInfo.h"
#import "SLPLabelFooter.h"
#import "SLPAlarmFooter.h"
#import "SLPMinuteSelectView.h"
#import "WeekdaySelectViewController.h"
#import "MusicListViewController.h"
#import "TitleSubTitleArrowCell.h"
#import "MusicInfo.h"
#import "TimePickerSelectView.h"
#import "SLPUtilHeads.h"
#import "UtilsHeads.h"
#import "TitleSubTitleContentArrowCell.h"

#import <Pillow/Pillow.h>

static NSString *const kSection_SetDeviceInfo = @"kSection_SetDeviceInfo";

static NSString *const kRowTime = @"kRowTime";
static NSString *const kRowRepeat = @"kRowRepeat";
static NSString *const kRowMusic = @"kRowMusic";
static NSString *const kRowMusicVolumn = @"kRowMusicVolumn";
//static NSString *const kRowLightWake = @"kRowLightWake";
static NSString *const kRowSmartWake = @"kRowSmartWake";
static NSString *const kRowWakeTime = @"kRowWakeTime";

static NSString *const kRowSnooze = @"kRowSnooze";
static NSString *const kRowSnoozeTime = @"kRowSnoozeTime";

@interface AlarmViewController ()<UITableViewDataSource, UITableViewDelegate, SLPAlarmFooterDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray <SLPTableSectionData *>* sectionDataList;

//section的footer
@property (nonatomic, strong) NSMutableArray<SLPViewInfo *> *sectionFooterList;

@property (nonatomic,strong) SLPAlarmFooter *alarmFooter;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (nonatomic, strong) NSMutableArray *musicList;

@property (strong, nonatomic) PillowAlarmInfo *alarmDataNew;

@end

@implementation AlarmViewController

-(NSMutableArray *)musicList{
    if (!_musicList) {
        _musicList = [NSMutableArray array];
        
        MusicInfo *musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31166;
        musicInfo.musicName = NSLocalizedString(@"music_list_1", nil);
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31167;
        musicInfo.musicName = NSLocalizedString(@"music_list_2", nil);
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31168;
        musicInfo.musicName = NSLocalizedString(@"music_list_3", nil);
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31169;
        musicInfo.musicName = NSLocalizedString(@"music_list_4", nil);
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31170;
        musicInfo.musicName = NSLocalizedString(@"music_list_5", nil);
        [_musicList addObject:musicInfo];
    }
    
    return _musicList;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self loadSectionData];
    
    [self createFooterList];
}

- (void)setUI
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 30, 0.001)];
    self.tableView.tableHeaderView = view;
    self.alarmDataNew = [[PillowAlarmInfo alloc] init];
    if (self.alarmPageType == AlarmPageType_Add) {
        self.titleLabel.text = NSLocalizedString(@"add_alarm", nil);
        [self initDefaultAlarmData];
    }else{
        self.titleLabel.text = NSLocalizedString(@"edit_alarm", nil);
        
        [self initAlarmDataWithOriginal];
    }
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveData)];
    self.navigationItem.rightBarButtonItem = item1;
}

- (void)saveData {
    if (![SLPBLESharedManager blueToothIsOpen]) {
        [Utils showMessage:NSLocalizedString(@"not_bluetooth", nil) controller:self];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    self.alarmDataNew.isOpen = YES;
    [SLPBLESharedManager pillow:SharedDataManager.peripheral alarmConfig:self.alarmDataNew timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }else{
            if ([self.delegate respondsToSelector:@selector(editAlarmInfoAndShouldReload)]) {
                [self.delegate editAlarmInfoAndShouldReload];
            }

            [Utils showMessage:NSLocalizedString(@"save_succeed", nil) controller:weakSelf];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

- (void)initAlarmDataWithOriginal
{
    self.alarmDataNew.alarmID = self.orignalAlarmData.alarmID;
    self.alarmDataNew.isOpen = self.orignalAlarmData.isOpen;
    self.alarmDataNew.hour = self.orignalAlarmData.hour;
    self.alarmDataNew.minute = self.orignalAlarmData.minute;
    self.alarmDataNew.repeat = self.orignalAlarmData.repeat;
    self.alarmDataNew.smartFlag = self.orignalAlarmData.smartFlag;
    self.alarmDataNew.smartOffset = self.orignalAlarmData.smartOffset;
    self.alarmDataNew.snoozeTime = self.orignalAlarmData.snoozeTime;
    self.alarmDataNew.snoozeLength = self.orignalAlarmData.snoozeLength;
    self.alarmDataNew.volume = self.orignalAlarmData.volume;
    self.alarmDataNew.brightness = self.orignalAlarmData.brightness;
    self.alarmDataNew.musicID = self.orignalAlarmData.musicID;
    //    self.alarmDataNew.aromaRate = self.orignalAlarmData.aromaRate;
    self.alarmDataNew.timestamp = [[NSDate date] timeIntervalSince1970];
    self.alarmDataNew.isValid = self.orignalAlarmData.isValid;
}

- (void)initDefaultAlarmData
{
    self.alarmDataNew.alarmID = self.addAlarmID;
    self.alarmDataNew.isOpen = true;
    self.alarmDataNew.hour = 8;
    self.alarmDataNew.minute = 0;
    self.alarmDataNew.repeat = 0;
    self.alarmDataNew.smartFlag = YES;
    self.alarmDataNew.smartOffset = 15;
    self.alarmDataNew.snoozeTime = 3;
    self.alarmDataNew.snoozeLength = 5;
    self.alarmDataNew.volume = 4;
    self.alarmDataNew.brightness = 100;
    self.alarmDataNew.musicID = 31166;
    //    self.alarmDataNew.aromaRate = 2;
    self.alarmDataNew.timestamp = [[NSDate date] timeIntervalSince1970];
    self.alarmDataNew.isValid = 1;
}

- (void)loadSectionData
{
    NSMutableArray *aSectionList = [NSMutableArray array];
    
    SLPTableSectionData *sectionData1 = [[SLPTableSectionData alloc] init];
    sectionData1.sectionEnum = kSection_SetDeviceInfo;
    NSMutableArray *rowEnumList1 = [NSMutableArray arrayWithObjects:kRowTime, kRowRepeat, kRowMusic, kRowMusicVolumn, kRowSmartWake, nil];
    if (self.alarmDataNew.smartFlag) {
        [rowEnumList1 addObject:kRowWakeTime];
    }
    [rowEnumList1 addObject:kRowSnoozeTime];
    sectionData1.rowEnumList = rowEnumList1;
    [aSectionList addObject:sectionData1];
    
    self.sectionDataList = aSectionList;
}

//SLPAlarmFooter
- (void)createFooterList{
    //section的数目
    self.sectionFooterList = [NSMutableArray array];
    NSInteger sectionNumber = self.sectionDataList.count;
    for (SLPTableSectionData *section in self.sectionDataList) {
        NSInteger index = [self.sectionDataList indexOfObject:section];
        SLPViewInfo *info = nil;
        if (index == sectionNumber - 1) {//最后一个
            info = [self createLastFooterForSectionName:section.sectionEnum];
        }else{
            info = [self createUnLastFooterForSectionName:section.sectionEnum];
        }
        [self.sectionFooterList addObject:info];
    }
}

- (SLPViewInfo *)createUnLastFooterForSectionName:(NSString *)sectionName {
    //    NSString *tip = LocalizedString(@"");
    SLPLabelFooter *footer = [SLPLabelFooter footerViewWithTextStr:@""];
    [footer setHidden:NO];
    SLPViewInfo *info = [SLPViewInfo new];
    [info setView:footer];
    [info setHeight:[SLPLabelFooter footerHeight:@""]];
    return info;
}

- (SLPViewInfo *)createLastFooterForSectionName:(NSString *)sectionName {
    NSString *tip = @"";
    
    UIView *view = nil;
    CGFloat height = 0;
    SLPAlarmFooter *footer = [SLPAlarmFooter footerViewWithTextStr:tip];
    footer.backgroundColor = [UIColor whiteColor];
    self.alarmFooter = footer;
    [footer setDelegate:self];
    view = footer;
    
    if (self.alarmPageType == AlarmPageType_Add){
        [footer.deleteBtn setHidden:YES];
    }else {
        [footer.deleteBtn setHidden:NO];
    }
    height = [footer height];
    
    SLPViewInfo *info = [SLPViewInfo new];
    [info setView:view];
    [info setHeight:height];
    return info;
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionDataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SLPTableSectionData *sectionData = [self.sectionDataList objectAtIndex:section];
    return sectionData.rowEnumList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLPTableSectionData *sectionData = [self.sectionDataList objectAtIndex:indexPath.section];
    NSString *rowName = [sectionData .rowEnumList objectAtIndex:indexPath.row];
    if ([rowName isEqualToString:kRowWakeTime] || [rowName isEqualToString:kRowSnoozeTime]) {
        return 150;
    }
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SLPTableSectionData *sectionData = [self.sectionDataList objectAtIndex:indexPath.section];
    NSString *rowName = [sectionData .rowEnumList objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [self getTableCellWithRowName:rowName];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    SLPViewInfo *viewInfo = [self.sectionFooterList objectAtIndex:section];
    return viewInfo.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    SLPViewInfo *viewInfo = [self.sectionFooterList objectAtIndex:section];
    return viewInfo.view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SLPTableSectionData *sectionData = [self.sectionDataList objectAtIndex:indexPath.section];
    NSString *rowName = [sectionData.rowEnumList objectAtIndex:indexPath.row];
    if ([rowName isEqualToString:kRowTime]) {
        [self showTimeSelector];
    }else if ([rowName isEqualToString:kRowRepeat]){
        [self goSelectWeekdayPage];
    }else if ([rowName isEqualToString:kRowMusic]){
        [self goSelectMusicPage];
    }else if ([rowName isEqualToString:kRowSnoozeTime]){
        [self showSnoozeTimeSelector];
    }else if ([rowName isEqualToString:kRowMusicVolumn]){
        [self showVolumeSelector];
    }else if ([rowName isEqualToString:kRowWakeTime]) {
        [self showSmartWakeSelector];
    }
}

- (void)showVolumeSelector
{
    NSMutableArray *values = [NSMutableArray array];
    for (int i = 1; i <= 8; i++) {
        [values addObject:@(i)];
    }
    SLPMinuteSelectView *minuteSelectView = [SLPMinuteSelectView minuteSelectViewWithValues:values];
    __weak typeof(self) weakSelf = self;
    [minuteSelectView showInView:[UIApplication sharedApplication].keyWindow mode:SLPMinutePickerMode_Second time:self.alarmDataNew.volume finishHandle:^(NSInteger timeValue) {
        weakSelf.alarmDataNew.volume = timeValue;
        [weakSelf.tableView reloadData];
    } cancelHandle:nil];
}

- (void)showTimeSelector
{
    SLPTime24 *time24 = [[SLPTime24 alloc] init];
    time24.hour = self.alarmDataNew.hour;
    time24.minute = self.alarmDataNew.minute;
    
    __weak typeof(self) weakSelf = self;
    TimePickerSelectView *timePick = [TimePickerSelectView timePickerSelectView];
    [timePick showInView:[UIApplication sharedApplication].keyWindow mode:![SLPUtils isTimeMode24] time:time24 finishHandle:^(SLPTime24 * _Nonnull time24) {
        weakSelf.alarmDataNew.hour = time24.hour;
        weakSelf.alarmDataNew.minute = time24.minute;
        [weakSelf.tableView reloadData];
    } cancelHandle:^{
        
    }];
}

- (void)goSelectWeekdayPage
{
    WeekdaySelectViewController *vc = [WeekdaySelectViewController new];
    vc.selectWeekDay = self.alarmDataNew.repeat;
    
    __weak typeof(self) weakSelf = self;
    vc.weekdayBlock = ^(NSInteger weekday) {
        weakSelf.alarmDataNew.repeat = weekday;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goSelectMusicPage
{
    if (self.alarmFooter.isPreviewEnabled) {
        [self stopPreView];
    }
    
    MusicListViewController *vc = [MusicListViewController new];
    vc.musicID = self.alarmDataNew.musicID;
    vc.musicList = self.musicList;
    vc.mode = FromMode_Alarm;
    vc.title = NSLocalizedString(@"music_list", nil);
    __weak typeof(self) weakSelf = self;
    vc.musicBlock = ^(NSInteger musicID) {
        weakSelf.alarmDataNew.musicID = musicID;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showSmartWakeSelector
{
    NSArray *values = @[@15,@20,@30];
    SLPMinuteSelectView *minuteSelectView = [SLPMinuteSelectView minuteSelectViewWithValues:values];
    __weak typeof(self) weakSelf = self;
    [minuteSelectView showInView:[UIApplication sharedApplication].keyWindow mode:SLPMinutePickerMode_Minute time:self.alarmDataNew.smartOffset finishHandle:^(NSInteger timeValue) {
        weakSelf.alarmDataNew.smartOffset = timeValue;
        [weakSelf.tableView reloadData];
    } cancelHandle:nil];
}

- (void)showSnoozeTimeSelector
{
    NSArray *values = @[@5,@10,@15];
    SLPMinuteSelectView *minuteSelectView = [SLPMinuteSelectView minuteSelectViewWithValues:values];
    __weak typeof(self) weakSelf = self;
    [minuteSelectView showInView:[UIApplication sharedApplication].keyWindow mode:SLPMinutePickerMode_Minute time:self.alarmDataNew.snoozeLength finishHandle:^(NSInteger timeValue) {
        weakSelf.alarmDataNew.snoozeLength = timeValue;
        [weakSelf.tableView reloadData];
    } cancelHandle:nil];
}

- (UITableViewCell *)getTableCellWithRowName:(NSString *)rowName
{
    BaseTableViewCell *cell = nil;
    
    __weak typeof(self) weakSelf = self;
    
    if ([rowName isEqualToString:kRowTime]) {
        TitleSubTitleArrowCell *baseCell = (TitleSubTitleArrowCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSubTitleArrowCell"];
        baseCell.titleLabel.text = NSLocalizedString(@"time", nil);
        baseCell.subTitleLabel.text = [self getAlarmTimeStringWithDataModle:self.alarmDataNew];
        [Utils configCellTitleLabel:baseCell.textLabel];
        cell = baseCell;
    }else if ([rowName isEqualToString:kRowRepeat]){
        TitleSubTitleArrowCell *baseCell = (TitleSubTitleArrowCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSubTitleArrowCell"];
        baseCell.titleLabel.text = NSLocalizedString(@"replay", nil);
        baseCell.subTitleLabel.text = [SLPWeekDay getAlarmRepeatDayStringWithWeekDay:self.alarmDataNew.repeat];
        [Utils configCellTitleLabel:baseCell.textLabel];
        cell = baseCell;
    }else if ([rowName isEqualToString:kRowMusic]){
        TitleSubTitleArrowCell *baseCell = (TitleSubTitleArrowCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSubTitleArrowCell"];
        baseCell.titleLabel.text =NSLocalizedString(@"music", nil);
        baseCell.subTitleLabel.text = [self getMusicNameWithMusicID:self.alarmDataNew.musicID];
        [Utils configCellTitleLabel:baseCell.textLabel];
        cell = baseCell;
    }else if([rowName isEqualToString:kRowMusicVolumn]){
        TitleSubTitleArrowCell *baseCell = (TitleSubTitleArrowCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSubTitleArrowCell"];
        baseCell.titleLabel.text = NSLocalizedString(@"volume", nil);
        baseCell.subTitleLabel.text = [NSString stringWithFormat:@"%d", self.alarmDataNew.volume];
        [Utils configCellTitleLabel:baseCell.textLabel];
        cell = baseCell;
    } else if ([rowName isEqualToString:kRowSmartWake]) {
        TitleSwitchCell *sCell = (TitleSwitchCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSwitchCell"];
        sCell.titleLabel.text = NSLocalizedString(@"smart_wake", nil);
        sCell.switcher.on = self.alarmDataNew.smartFlag;
        
        
        sCell.switchBlock = ^(UISwitch *sender) {
            weakSelf.alarmDataNew.smartFlag = sender.on;
            [weakSelf loadSectionData];
            [weakSelf.tableView reloadData];
        };
        cell = sCell;
    } else if ([rowName isEqualToString:kRowWakeTime]) {
        TitleSubTitleContentArrowCell *baseCell = (TitleSubTitleContentArrowCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSubTitleContentArrowCell"];
        baseCell.titleLabel.text = NSLocalizedString(@"wake_range", nil);
        NSString *timeStr = [NSString stringWithFormat:@"%d%@", self.alarmDataNew.smartOffset, NSLocalizedString(@"unit_m", nil)];
        baseCell.subTitleLabel.text = timeStr;
        baseCell.contentLabel.text = NSLocalizedString(@"wake_explain", nil);
        [Utils configCellTitleLabel:baseCell.textLabel];
        cell = baseCell;
    }
    
    else if ([rowName isEqualToString:kRowSnooze]){
        TitleSwitchCell *sCell = (TitleSwitchCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSwitchCell"];
        sCell.titleLabel.text = NSLocalizedString(@"snooze_count", nil);
        sCell.switcher.on = self.alarmDataNew.snoozeTime;
        [Utils configCellTitleLabel:sCell.titleLabel];
        
        
        sCell.switchBlock = ^(UISwitch *sender) {
            weakSelf.alarmDataNew.snoozeTime = sender.on;
            [weakSelf loadSectionData];
            [weakSelf.tableView reloadData];
        };
        cell = sCell;
    }else if ([rowName isEqualToString:kRowSnoozeTime]){
        TitleSubTitleContentArrowCell *baseCell = (TitleSubTitleContentArrowCell *)[SLPUtils tableView:self.tableView cellNibName:@"TitleSubTitleContentArrowCell"];
        baseCell.titleLabel.text = NSLocalizedString(@"snooze_time", nil);
        NSString *timeStr = [NSString stringWithFormat:@"%d%@", self.alarmDataNew.snoozeLength, NSLocalizedString(@"unit_m", nil)];
        baseCell.subTitleLabel.text = timeStr;
        baseCell.contentLabel.text = NSLocalizedString(@"snooze_content", nil);
        [Utils configCellTitleLabel:baseCell.textLabel];
        cell = baseCell;
    }
    
    return cell;
}

- (NSString *)getMusicNameWithMusicID:(NSInteger)musicID
{
    NSString *musicName = @"";
    for (MusicInfo *musicInfo in self.musicList) {
        if (musicInfo.musicID == musicID) {
            musicName = musicInfo.musicName;
            break;
        }
    }
    
    return musicName;
}

- (NSString *)getAlarmTimeStringWithDataModle:(PillowAlarmInfo *)dataModel {
    return [SLPUtils timeStringFrom:dataModel.hour minute:dataModel.minute isTimeMode24:[SLPUtils isTimeMode24]];
}


-(void)previewBtnTapped:(BOOL)isSelected completion:(void (^)(BOOL))completion
{
    if (isSelected) {
        [self startPreView];
    }else{
        [self stopPreView];
    }
    
}

- (void)startPreView
{
    if (![SLPBLESharedManager blueToothIsOpen]) {
        [Utils showMessage:NSLocalizedString(@"not_bluetooth", nil) controller:self];
        return;
    }
    __weak typeof(self) weakSelf = self;
//    [SLPBLESharedManager bleNox:SharedDataManager.peripheral startAlarmRreviewvolume:self.alarmDataNew.volume brightness:self.alarmDataNew.brightness musicID:self.alarmDataNew.musicID timeout:0 callback:^(SLPDataTransferStatus status, id data) {
//        if (status != SLPDataTransferStatus_Succeed) {
//            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
//        }else{
//            weakSelf.alarmFooter.isPreviewEnabled = YES;
//        }
//    }];
}

- (void)stopPreView
{
    if (![SLPBLESharedManager blueToothIsOpen]) {
        [Utils showMessage:NSLocalizedString(@"not_bluetooth", nil) controller:self];
        return;
    }
    __weak typeof(self) weakSelf = self;
//    [SLPBLESharedManager bleNox:SharedDataManager.peripheral stopAlarmRreviewTimeout:0 callback:^(SLPDataTransferStatus status, id data) {
//        if (status != SLPDataTransferStatus_Succeed) {
//            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
//        }else{
//            weakSelf.alarmFooter.isPreviewEnabled = NO;
//        }
//    }];
}

-(void)deleteBtnTapped
{
    if (![SLPBLESharedManager blueToothIsOpen]) {
        [Utils showMessage:NSLocalizedString(@"not_bluetooth", nil) controller:self];
        return;
    }
    __weak typeof(self) weakSelf = self;
    self.alarmDataNew.isValid = 0;
    [SLPBLESharedManager pillow:SharedDataManager.peripheral alarmConfig:self.alarmDataNew timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        }else{
            if ([self.delegate respondsToSelector:@selector(editAlarmInfoAndShouldReload)]) {
                [self.delegate editAlarmInfoAndShouldReload];
            }

            [Utils showMessage:NSLocalizedString(@"delete_succeed", nil) controller:weakSelf];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
//    [SLPBLESharedManager bleNox:SharedDataManager.peripheral delAlarm:self.alarmDataNew.alarmID timeout:0 callback:^(SLPDataTransferStatus status, id data) {
//        if (status != SLPDataTransferStatus_Succeed) {
//            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
//        }else{
//
//            int index = 0;
//            BOOL isExist = NO;
//            for (int i = 0; i < SharedDataManager.alarmList.count; i++) {
//                BleNoxAlarmInfo *info = [SharedDataManager.alarmList objectAtIndex:i];
//                if (info.alarmID == self.alarmDataNew.alarmID) {
//                    isExist = YES;
//                    index = i;
//                    break;
//                }
//            }
//
//            if (isExist) {
//                [SharedDataManager.alarmList removeObjectAtIndex:index];
//            }
//
//            if ([self.delegate respondsToSelector:@selector(editAlarmInfoAndShouldReload)]) {
//                [self.delegate editAlarmInfoAndShouldReload];
//            }
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//        }
//    }];
}

-(void)back
{
    [self stopPreView];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
