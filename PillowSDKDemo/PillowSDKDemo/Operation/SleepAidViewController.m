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
    
}

- (void)stopMusicWitCompletion:(void(^)(SLPDataTransferStatus status))completion
{

}

- (IBAction)chooseMode:(UIButton *)sender {
}

- (IBAction)playMusic:(UIButton *)sender {
}

- (IBAction)chooseStop:(UIButton *)sender {
}

- (IBAction)saveData:(UIButton *)sender {
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
@end
