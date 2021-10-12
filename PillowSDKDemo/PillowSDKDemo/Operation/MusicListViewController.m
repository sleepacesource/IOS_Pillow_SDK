//
//  MusicListViewController.m
//  SA1001-2-demo
//
//  Created by jie yang on 2018/11/14.
//  Copyright © 2018年 jie yang. All rights reserved.
//

#import "MusicListViewController.h"

#import "SelectItemCell.h"
#import "MusicInfo.h"
#import <Pillow/Pillow.h>
#import "UtilsHeads.h"

@interface MusicListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic,weak) IBOutlet UIButton *backButton;

@end

@implementation MusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self play];
}

- (void)play{
    [self playMusic:self.musicID];
}

- (void)setUI
{
//    self.titleLabel.text = LocalizedString(@"music_list");
    
    [self.saveBtn setTitle:NSLocalizedString(@"save", nil) forState:UIControlStateNormal];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveData)];
    self.navigationItem.rightBarButtonItem = item1;
    
    if (self.mode == FromMode_Alarm) {
        self.saveBtn.hidden = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self stopMusic];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellNibName:(NSString *)nibName{
    if (!tableView || [nibName length] == 0){
        return nil;
    }
    
    NSString *cellID = nibName;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell){
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:cellID];
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.musicList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SelectItemCell *cell = (SelectItemCell *)[self tableView:tableView cellNibName:@"SelectItemCell"];
    MusicInfo *musicInfo = [self.musicList objectAtIndex:indexPath.row];
    cell.titleLabel.text = musicInfo.musicName;
    if (musicInfo.musicID == self.musicID) {
        cell.selectIcon.hidden = NO;
    }else{
        cell.selectIcon.hidden = YES;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MusicInfo *musicInfo = [self.musicList objectAtIndex:indexPath.row];
    self.musicID = musicInfo.musicID;
    
    [self playMusic:self.musicID];
    
    [self.tableView reloadData];
}

- (void)playMusic:(NSInteger)musicID
{
//    if (![SLPBLESharedManager blueToothIsOpen]) {
//        [Utils showMessage:@"蓝牙未打开" controller:self];
//        return;
//    }
    __weak typeof(self) weakSelf = self;
    if (self.mode == FromMode_Alarm) {
        [SLPBLESharedManager pillow:SharedDataManager.peripheral playMusicWithOperation:1 musicId:musicID volume:6 timeout:0 callback:^(SLPDataTransferStatus status, id data) {
            if (status != SLPDataTransferStatus_Succeed) {
                [Utils showDeviceOperationFailed:status atViewController:weakSelf];
            }
        }];
    }
}

- (void)saveData {
    
    if (self.musicBlock) {
        self.musicBlock(self.musicID);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)stopMusic
{
    __weak typeof(self) weakSelf = self;
    if (self.mode == FromMode_Alarm) {
//        if (![SLPBLESharedManager blueToothIsOpen]) {
//            [Utils showMessage:@"蓝牙未打开" controller:self];
//            return;
//        }
        
        [SLPBLESharedManager pillow:SharedDataManager.peripheral playMusicWithOperation:0 musicId:self.musicID volume:6 timeout:0 callback:^(SLPDataTransferStatus status, id data) {
            
        }];
        
//        [SLPBLESharedManager bleNox:SharedDataManager.peripheral turnOffMusicTimeout:0 callback:^(SLPDataTransferStatus status, id data) {
//            if (status != SLPDataTransferStatus_Succeed) {
//                [Utils showDeviceOperationFailed:status atViewController:weakSelf];
//            }else{
//                if (self.musicBlock) {
//                    self.musicBlock(self.musicID);
//                }
//            }
//        }];
    }
}

-(void)back
{
//    if (self.mode == FromMode_Alarm) {
//        [self stopMusic];
//    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
