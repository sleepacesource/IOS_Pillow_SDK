//
//  PillowSleepAidInfo.h
//  Pillow
//
//  Created by jie yang on 2021/9/17.
//  Copyright © 2021 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BluetoothManager/BluetoothManager.h>

@interface PillowSleepAidInfo : NSObject

@property (nonatomic, assign) UInt8 musicEnable;  // 音乐开关
@property (nonatomic, assign) UInt16 musicId;  // 音乐ID
@property (nonatomic, assign) UInt8 volume; // 音乐音量
@property (nonatomic, assign) UInt8 circleMode; // 循环模式
@property (nonatomic, assign) UInt8 lightEnable; // 灯光开关
@property (nonatomic, assign) UInt8 brightness; // 灯光亮度
@property (nonatomic, strong) SLPLight *light; // 灯光结构
@property (nonatomic, assign) UInt8 smartEnable; // 智能助眠开关
@property (nonatomic, assign) UInt16 smartDuration; //智能助眠时长

@end
