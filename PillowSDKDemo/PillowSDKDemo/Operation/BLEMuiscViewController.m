//
//  BLEMuiscViewController.m
//  PillowSDKDemo
//
//  Created by jie yang on 2021/9/22.
//  Copyright © 2021 medica. All rights reserved.
//

#import "BLEMuiscViewController.h"

#import <Pillow/Pillow.h>
#import "UtilsHeads.h"
#import "Tool.h"
@interface BLEMuiscViewController ()

@property (weak, nonatomic) IBOutlet UIView *timeContainer;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *stopFlagContainer;
@property (weak, nonatomic) IBOutlet UILabel *stopFlagLabel;

@property (nonatomic, strong) PillowSmartStop *smartStopInfo;

@property (weak, nonatomic) IBOutlet UIButton *saveBT;
@property (weak, nonatomic) IBOutlet UILabel *labe1;
@property (weak, nonatomic) IBOutlet UILabel *labe2;

@end

@implementation BLEMuiscViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];
    //default
    self.smartStopInfo.duration = 45;
    
    [self getData];
}

- (void)getData {
    __weak typeof(self) weakSelf = self;
    [SLPBLESharedManager pillow:SharedDataManager.peripheral getSmartStopWithTimeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status == SLPDataTransferStatus_Succeed) {
            weakSelf.smartStopInfo = data;
            if (weakSelf.smartStopInfo.duration == 0) {
                weakSelf.smartStopInfo.duration = 45;
            }
            weakSelf.stopFlagLabel.text = [weakSelf getSmartFlagName:self.smartStopInfo.operation];
            weakSelf.timeLabel.text = [NSString stringWithFormat:@"%d%@", self.smartStopInfo.duration,NSLocalizedString(@"unit_m", nil)];
        }
    }];
}

- (NSString *)getSmartFlagName:(UInt8)smartFlag {
    if (smartFlag == 1) {
        return NSLocalizedString(@"ON", nil);
    }
    
    return NSLocalizedString(@"OFF", nil);
}

- (void)setUI {
    
    [Tool configSomeKindOfButtonLikeNomal:self.saveBT];
    self.stopFlagLabel.text = [self getSmartFlagName:self.smartStopInfo.operation];
    self.timeLabel.text = [NSString stringWithFormat:@"%d%@", self.smartStopInfo.duration,NSLocalizedString(@"unit_m", nil)];
    
    self.timeContainer.layer.masksToBounds = YES;
    self.timeContainer.layer.cornerRadius = 5;
    self.timeContainer.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.timeContainer.layer.borderWidth = 1;
    
    self.stopFlagContainer.layer.masksToBounds = YES;
    self.stopFlagContainer.layer.cornerRadius = 5;
    self.stopFlagContainer.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.stopFlagContainer.layer.borderWidth = 1;
    
    [self.saveBT setTitle:NSLocalizedString(@"save", nil) forState:UIControlStateNormal];
    self.labe1.text = NSLocalizedString( @"time_end", nil);
    self.labe2.text = NSLocalizedString( @"smart_stop_play", nil);
    
}

- (void)setSmartStopInfo {
    __weak typeof(self) weakSelf = self;
//    self.smartStopInfo.duration = 1;
    [SLPBLESharedManager pillow:SharedDataManager.peripheral smartStopConfig:self.smartStopInfo timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        } else {
            [Utils showMessage:NSLocalizedString(@"save_succeed", nil) controller:weakSelf];
        }
    }];
}

- (IBAction)chooseTime:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"time_end", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    NSString * str1 = [NSString stringWithFormat:@"15%@",NSLocalizedString( @"unit_m", nil)];
    NSString * str2 = [NSString stringWithFormat:@"30%@",NSLocalizedString( @"unit_m", nil)];
    NSString * str3 = [NSString stringWithFormat:@"45%@",NSLocalizedString( @"unit_m", nil)];
    NSString * str4 = [NSString stringWithFormat:@"60%@",NSLocalizedString( @"unit_m", nil)];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:str1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.smartStopInfo.duration = 15;
        weakSelf.timeLabel.text = str1;
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:str2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.smartStopInfo.duration = 30;
        weakSelf.timeLabel.text = str2;
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:str3 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.smartStopInfo.duration = 45;
        weakSelf.timeLabel.text = str3;
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:str4 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.smartStopInfo.duration = 60;
        weakSelf.timeLabel.text = str4;
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [alertController addAction:action4];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)chooseStop:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"smart_stop_play", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OFF", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.smartStopInfo.operation = 0;
        weakSelf.stopFlagLabel.text = NSLocalizedString(@"OFF", nil);
    }];
    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ON", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.smartStopInfo.operation = 1;
        weakSelf.stopFlagLabel.text = NSLocalizedString(@"ON", nil);
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [alertController addAction:resetAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)saveData:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    [self setSmartStopInfo];
}
@end
