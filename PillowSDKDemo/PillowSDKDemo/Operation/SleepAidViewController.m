//
//  SleepAidViewController.m
//  PillowSDKDemo
//
//  Created by jie yang on 2021/9/17.
//  Copyright © 2021 medica. All rights reserved.
//

#import "SleepAidViewController.h"

#import "MusicInfo.h"
#import "MusicListViewController.h"
#import "Tool.h"
#import <Pillow/Pillow.h>

@interface SleepAidViewController ()<UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *musicContainer;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;

@property (weak, nonatomic) IBOutlet UIView *modeContainer;
@property (weak, nonatomic) IBOutlet UILabel *modeLabel;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UITextField *volumeField;
@property (weak, nonatomic) IBOutlet UIButton *sendVolBtn;

@property (weak, nonatomic) IBOutlet UIView *timeContainer;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *stopFlagContainer;
@property (weak, nonatomic) IBOutlet UILabel *stopFlagLabel;

@property (nonatomic, strong) NSMutableArray *musicList;

@property (nonatomic, assign) BOOL isPlayingMusic;

@property (nonatomic, assign) UInt16 assistMusicID;

@property (nonatomic, assign) UInt8 volume;

@property (nonatomic, assign) UInt8 circleMode;

@property (nonatomic, assign) UInt8 smartFlag;

@property (nonatomic, assign) UInt16 smartDuration;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (weak, nonatomic) IBOutlet UIButton *chooseMusicBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseModeBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseStopBtn;


@end

@implementation SleepAidViewController

-(NSMutableArray *)musicList{
    if (!_musicList) {
        _musicList = [NSMutableArray array];
        
        MusicInfo *musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31163;
        musicInfo.musicName = @"海浪";
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31164;
        musicInfo.musicName = @"雨";
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31162;
        musicInfo.musicName = @"冬日暖阳";
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31155;
        musicInfo.musicName = @"月光";
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31156;
        musicInfo.musicName = @"小小的我";
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31157;
        musicInfo.musicName = @"让旅程开始";
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31160;
        musicInfo.musicName = @"凯特人的摇篮曲";
        [_musicList addObject:musicInfo];
    }
    
    return _musicList;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self deviceDisconenct];
}

- (void)deviceDisconenct
{
    BOOL isConnected=self.selectPeripheral.peripheral&&[SLPBLESharedManager peripheralIsConnected:self.selectPeripheral.peripheral];
    self.playBtn.enabled=isConnected;
    self.sendVolBtn.enabled=isConnected;
    self.saveBtn.enabled=isConnected;
    self.chooseMusicBtn.enabled=isConnected;
    self.chooseModeBtn.enabled=isConnected;
    self.chooseTimeBtn.enabled=isConnected;
    self.chooseStopBtn.enabled=isConnected;
    self.volumeField.enabled = isConnected;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.assistMusicID = 31163;
    self.volume = 6;
    self.circleMode = 1;
    self.smartFlag = 0;
    self.smartDuration = 45;
    
    [self setUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDisconenct) name:kNotificationNameBLEDisable object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDisconenct) name:kNotificationNameBLEDeviceDisconnect object:nil];
}

- (NSString *)getSmartFlagName:(UInt8)smartFlag {
    if (smartFlag == 1) {
        return @"开";
    }
    
    return @"关";
}

- (NSString *)modeTextWith:(UInt8)mode {
    if (mode == 1) {
        return @"单曲循环";
    }
    
    return @"列表循环";
}

- (void)setUI {
    [Tool configSomeKindOfButtonLikeNomal:self.playBtn];
    [Tool configSomeKindOfButtonLikeNomal:self.sendVolBtn];
    [Tool configSomeKindOfButtonLikeNomal:self.saveBtn];
    
    self.musicNameLabel.text = [self getMusicNameWithMusicID:self.assistMusicID];
    self.volumeField.text = [NSString stringWithFormat:@"%d", self.volume];
    self.modeLabel.text = [self modeTextWith:self.circleMode];
    self.stopFlagLabel.text = [self getSmartFlagName:self.smartFlag];
    self.timeLabel.text = [NSString stringWithFormat:@"%d分钟", self.smartDuration];
    
    self.musicContainer.layer.masksToBounds = YES;
    self.musicContainer.layer.cornerRadius = 5;
    self.musicContainer.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.musicContainer.layer.borderWidth = 1;
    
    self.modeContainer.layer.masksToBounds = YES;
    self.modeContainer.layer.cornerRadius = 5;
    self.modeContainer.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.modeContainer.layer.borderWidth = 1;
    
    self.timeContainer.layer.masksToBounds = YES;
    self.timeContainer.layer.cornerRadius = 5;
    self.timeContainer.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.timeContainer.layer.borderWidth = 1;
    
    self.stopFlagContainer.layer.masksToBounds = YES;
    self.stopFlagContainer.layer.cornerRadius = 5;
    self.stopFlagContainer.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.stopFlagContainer.layer.borderWidth = 1;
}

- (NSString *)getMusicNameWithMusicID:(UInt16)musicID
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

- (IBAction)chooseMusic:(UIButton *)sender {
    MusicListViewController *vc = [MusicListViewController new];
    vc.musicList = self.musicList;
    vc.musicID = self.assistMusicID;
    vc.mode = FromMode_SleepAid;
    vc.title = @"音乐列表";
    __weak typeof(self) weakSelf = self;
    vc.musicBlock = ^(NSInteger musicID) {
        self.assistMusicID = musicID;
        weakSelf.musicNameLabel.text = [weakSelf getMusicNameWithMusicID:musicID];
        
        if (weakSelf.isPlayingMusic) {
            [weakSelf playMusicWitCompletion:nil];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)playMusicWitCompletion:(void(^)(SLPDataTransferStatus status))completion
{
    [SLPBLESharedManager pillow:self.selectPeripheral.peripheral sleepAidOperation:1 musicId:self.assistMusicID volume:self.volume circleMode:self.circleMode lightEnable:0 brightness:0 light:0 smartEnable:self.smartFlag smartDuration:self.smartDuration timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (completion) {
            completion(status);
        }
    }];
}

- (void)stopMusicWitCompletion:(void(^)(SLPDataTransferStatus status))completion
{
    [SLPBLESharedManager pillow:self.selectPeripheral.peripheral sleepAidOperation:0 musicId:self.assistMusicID volume:self.volume circleMode:self.circleMode lightEnable:0 brightness:0 light:0 smartEnable:self.smartFlag smartDuration:self.smartDuration timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (completion) {
            completion(status);
        }
    }];
}

- (IBAction)chooseMode:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"循环模式" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"列表循环" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.circleMode = 0;
        weakSelf.modeLabel.text = [self modeTextWith:weakSelf.circleMode];
        if (weakSelf.isPlayingMusic) {
            [weakSelf playMusicWitCompletion:nil];
        }
    }];
    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:@"单曲循环" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.circleMode = 1;
        weakSelf.modeLabel.text = [self modeTextWith:weakSelf.circleMode];
        if (weakSelf.isPlayingMusic) {
            [weakSelf playMusicWitCompletion:nil];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [alertController addAction:resetAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)playMusic:(UIButton *)sender {
    
    __weak typeof(self) weakSelf = self;
    if (sender.selected) {
        
        [self stopMusicWitCompletion:^(SLPDataTransferStatus status) {
            if (status != SLPDataTransferStatus_Succeed) {
//                [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            }else{
                sender.selected = NO;
                [weakSelf.playBtn setTitle:@"播放" forState:UIControlStateNormal];
                weakSelf.isPlayingMusic = NO;
            }
        }];
    }else{
        [self playMusicWitCompletion:^(SLPDataTransferStatus status) {
            if (status != SLPDataTransferStatus_Succeed) {
//                [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            }else{
                sender.selected = YES;
                [weakSelf.playBtn setTitle:@"暂停" forState:UIControlStateNormal];
                weakSelf.isPlayingMusic = YES;
            }
        }];
    }
}

- (IBAction)sendVol:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString *txt = self.volumeField.text;
    UInt8 vol = (UInt8)[txt intValue];
    
    __weak typeof(self) weakSelf = self;
    self.volume = vol;
    [self playMusicWitCompletion:^(SLPDataTransferStatus status) {
        if (status == SLPDataTransferStatus_Succeed) {
            weakSelf.playBtn.selected = YES;
            [weakSelf.playBtn setTitle:@"暂停" forState:UIControlStateNormal];
            weakSelf.isPlayingMusic = YES;
        }
    }];
}

- (IBAction)chooseTime:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"定时结束" preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"15分钟" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.smartDuration = 15;
        weakSelf.timeLabel.text = @"15分钟";
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"30分钟" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.smartDuration = 30;
        weakSelf.timeLabel.text = @"30分钟";
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"45分钟" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.smartDuration = 45;
        weakSelf.timeLabel.text = @"45分钟";
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"60分钟" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.smartDuration = 60;
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
        weakSelf.smartFlag = 0;
        weakSelf.stopFlagLabel.text = @"关";
//        if (weakSelf.isPlayingMusic) {
//            [weakSelf playMusicWitCompletion:nil];
//        }
    }];
    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:@"开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.smartFlag = 1;
        weakSelf.stopFlagLabel.text = @"开";
//        if (weakSelf.isPlayingMusic) {
//            [weakSelf playMusicWitCompletion:nil];
//        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [alertController addAction:resetAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)saveData:(UIButton *)sender {
    __weak typeof(self) weakSelf = self;
    if (self.isPlayingMusic) {
        [self playMusicWitCompletion:^(SLPDataTransferStatus status) {
            
        }];
    } else {
        [self stopMusicWitCompletion:^(SLPDataTransferStatus status) {
            
        }];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
@end
