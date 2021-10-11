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
@property (weak, nonatomic) IBOutlet UILabel *labe1;
@property (weak, nonatomic) IBOutlet UILabel *labe2;
@property (weak, nonatomic) IBOutlet UILabel *labe3;
@property (weak, nonatomic) IBOutlet UILabel *labe4;
@property (weak, nonatomic) IBOutlet UILabel *labe5;

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
        musicInfo.musicName = NSLocalizedString(@"Ocean Sea Waves", nil);
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31164;
        musicInfo.musicName =NSLocalizedString( @"Sleeping_music_07", nil);
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31162;
        musicInfo.musicName = NSLocalizedString( @"Sleeping_music_05", nil);
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31155;
        musicInfo.musicName = NSLocalizedString( @"Sleeping_music_01", nil);
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31156;
        musicInfo.musicName = NSLocalizedString( @"Sleeping_music_02", nil);
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31157;
        musicInfo.musicName = NSLocalizedString( @"Sleeping_music_03", nil);
        [_musicList addObject:musicInfo];
        
        musicInfo = [[MusicInfo alloc] init];
        musicInfo.musicID = 31160;
        musicInfo.musicName = NSLocalizedString( @"Sleeping_music_04", nil);
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
        return NSLocalizedString( @"ON", nil);
    }
    
    return NSLocalizedString( @"OFF", nil);
}

- (NSString *)modeTextWith:(UInt8)mode {
    if (mode == 1) {
        return NSLocalizedString( @"music_single_cycle", nil);
    }
    
    return NSLocalizedString( @"music_order_play", nil);
}

- (void)setUI {
    [Tool configSomeKindOfButtonLikeNomal:self.playBtn];
    [Tool configSomeKindOfButtonLikeNomal:self.sendVolBtn];
    [Tool configSomeKindOfButtonLikeNomal:self.saveBtn];
    
    self.musicNameLabel.text = [self getMusicNameWithMusicID:self.assistMusicID];
    self.volumeField.text = [NSString stringWithFormat:@"%d", self.volume];
    self.modeLabel.text = [self modeTextWith:self.circleMode];
    self.stopFlagLabel.text = [self getSmartFlagName:self.smartFlag];
    self.timeLabel.text = [NSString stringWithFormat:@"%d%@", self.smartDuration,NSLocalizedString( @"unit_m", nil)];
    
    [self.playBtn setTitle:NSLocalizedString(@"play", nil) forState:UIControlStateNormal];
    [self.saveBtn setTitle:NSLocalizedString(@"save", nil) forState:UIControlStateNormal];
    [self.sendVolBtn setTitle:NSLocalizedString(@"send", nil) forState:UIControlStateNormal];
    self.labe1.text = NSLocalizedString( @"music", nil);
    self.labe2.text = NSLocalizedString( @"cycle_mode", nil);
    self.labe3.text = NSLocalizedString( @"volume", nil);
    self.labe4.text = NSLocalizedString( @"time_end", nil);
    self.labe5.text = NSLocalizedString( @"smart_stop_play", nil);
    
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
    vc.title = NSLocalizedString( @"music_list", nil);
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
    NSLog(@"smartflag1---%d,smartduration---%d",self.smartFlag,self.smartDuration);
    [SLPBLESharedManager pillow:self.selectPeripheral.peripheral sleepAidOperation:1 musicId:self.assistMusicID volume:self.volume circleMode:self.circleMode lightEnable:0 brightness:0 light:0 smartEnable:self.smartFlag smartDuration:self.smartDuration timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (completion) {
            completion(status);
        }
    }];
}

- (void)stopMusicWitCompletion:(void(^)(SLPDataTransferStatus status))completion
{
    NSLog(@"smartflag1---%d,smartduration---%d",self.smartFlag,self.smartDuration);
    [SLPBLESharedManager pillow:self.selectPeripheral.peripheral sleepAidOperation:0 musicId:self.assistMusicID volume:self.volume circleMode:self.circleMode lightEnable:0 brightness:0 light:0 smartEnable:self.smartFlag smartDuration:self.smartDuration timeout:0 callback:^(SLPDataTransferStatus status, id data) {
        if (completion) {
            completion(status);
        }
    }];
}

- (IBAction)chooseMode:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"cycle_mode", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"music_order_play", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.circleMode = 0;
        weakSelf.modeLabel.text = [self modeTextWith:weakSelf.circleMode];
        if (weakSelf.isPlayingMusic) {
            [weakSelf playMusicWitCompletion:nil];
        }
    }];
    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"music_single_cycle", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
                [weakSelf.playBtn setTitle:NSLocalizedString(@"play", nil) forState:UIControlStateNormal];
                [Tool configSomeKindOfButtonLikeNomal:weakSelf.playBtn];
                weakSelf.isPlayingMusic = NO;
            }
        }];
    }else{
        [self playMusicWitCompletion:^(SLPDataTransferStatus status) {
            if (status != SLPDataTransferStatus_Succeed) {
//                [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            }else{
                sender.selected = YES;
                [weakSelf.playBtn setTitle:NSLocalizedString(@"pause", nil) forState:UIControlStateNormal];
                [Tool configSomeKindOfButtonLikeNomal:weakSelf.playBtn];
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
            [weakSelf.playBtn setTitle:NSLocalizedString(@"pause", nil) forState:UIControlStateNormal];
            weakSelf.isPlayingMusic = YES;
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
        weakSelf.smartDuration = 15;
        weakSelf.timeLabel.text = str1;
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:str2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.smartDuration = 30;
        weakSelf.timeLabel.text = str2;
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:str3 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.smartDuration = 45;
        weakSelf.timeLabel.text = str3;
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:str4 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.smartDuration = 60;
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
        weakSelf.smartFlag = 0;
        weakSelf.stopFlagLabel.text = NSLocalizedString(@"OFF", nil);
//        if (weakSelf.isPlayingMusic) {
//            [weakSelf playMusicWitCompletion:nil];
//        }
    }];
    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"ON", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.smartFlag = 1;
        weakSelf.stopFlagLabel.text = NSLocalizedString(@"ON", nil);
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
    [SLPBLESharedManager pillow:self.selectPeripheral.peripheral sleepAidOperation:self.isPlayingMusic ? 1: 0 musicId:self.assistMusicID volume:self.volume circleMode:self.circleMode lightEnable:0 brightness:0 light:0 smartEnable:self.smartFlag smartDuration:self.smartDuration timeout:0 callback:^(SLPDataTransferStatus status, id data) {

        
    }];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
@end
