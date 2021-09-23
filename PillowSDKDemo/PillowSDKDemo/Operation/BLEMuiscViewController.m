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

@interface BLEMuiscViewController ()

@property (weak, nonatomic) IBOutlet UIView *timeContainer;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *stopFlagContainer;
@property (weak, nonatomic) IBOutlet UILabel *stopFlagLabel;

@property (nonatomic, strong) PillowSmartStop *smartStopInfo;

@end

@implementation BLEMuiscViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];
    
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
            weakSelf.timeLabel.text = [NSString stringWithFormat:@"%d分钟", self.smartStopInfo.duration];
        }
    }];
}

- (NSString *)getSmartFlagName:(UInt8)smartFlag {
    if (smartFlag == 1) {
        return @"开";
    }
    
    return @"关";
}

- (void)setUI {
    self.stopFlagLabel.text = [self getSmartFlagName:self.smartStopInfo.operation];
    self.timeLabel.text = [NSString stringWithFormat:@"%d分钟", self.smartStopInfo.duration];
    
    self.timeContainer.layer.masksToBounds = YES;
    self.timeContainer.layer.cornerRadius = 5;
    self.timeContainer.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.timeContainer.layer.borderWidth = 1;
    
    self.stopFlagContainer.layer.masksToBounds = YES;
    self.stopFlagContainer.layer.cornerRadius = 5;
    self.stopFlagContainer.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.stopFlagContainer.layer.borderWidth = 1;
}

- (void)setSmartStopInfo {
    __weak typeof(self) weakSelf = self;
    [SLPBLESharedManager pillow:SharedDataManager.peripheral smartStopConfig:self.smartStopInfo timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (status != SLPDataTransferStatus_Succeed) {
            [Utils showDeviceOperationFailed:status atViewController:weakSelf];
        } else {
            [Utils showMessage:@"保存成功" controller:weakSelf];
        }
        
    }];
}

- (IBAction)chooseTime:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"定时结束" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"15分钟" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.smartStopInfo.duration = 15;
        weakSelf.timeLabel.text = @"15分钟";
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"30分钟" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.smartStopInfo.duration = 30;
        weakSelf.timeLabel.text = @"30分钟";
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"45分钟" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.smartStopInfo.duration = 45;
        weakSelf.timeLabel.text = @"45分钟";
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"60分钟" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.smartStopInfo.duration = 60;
        weakSelf.timeLabel.text = @"60分钟";
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [alertController addAction:action4];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)chooseStop:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"智能停止播放" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"关" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.smartStopInfo.operation = 0;
        weakSelf.stopFlagLabel.text = @"关";
    }];
    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:@"开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.smartStopInfo.operation = 1;
        weakSelf.stopFlagLabel.text = @"开";
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
