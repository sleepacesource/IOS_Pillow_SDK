//
//  SLPBLEManager+pillow.h
//  Sleepace
//
//  Created by Martin on 6/14/16.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import <BluetoothManager/SLPBLEManager.h>
#import "PillowDeviceInfo.h"
#import "PillowBatteryInfo.h"
#import "PillowDeviceVersion.h"
#import "PillowCollectionStatus.h"
#import "PillowRealTimeData.h"
#import "PillowOriginalData.h"
#import "PillowUpgradeInfo.h"
#import "Pillow_HistoryData.h"
#import "PEnvironmentalData.h"
#import "PillowSleepAidInfo.h"
#import "PillowSmartStop.h"
#import "PillowAlarmInfo.h"
#import "LeftBedAlarmInfo.h"
@interface SLPBLEManager (Pillow)

/*deviceName 设备名称 和设备ID区分一下
 deviceCode 设备编码
 userId 用户ID
 timeoutInterval 超时时间，如果为0时则用默认超时时间10秒
 回调值为 PillowDeviceInfo
 */
- (void)pillow:(CBPeripheral *)peripheral loginWithDeviceName:(NSString *)deviceName
    deviceCode:(NSString *)deviceCode
        userId:(NSInteger)userId
      callback:(SLPTransforCallback)handle;

/*获取设备信息
 回调返回PillowDeviceInfo
 */
- (void)pillow:(CBPeripheral *)peripheral getDeviceInfoTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*获取电量
 回调返回 PillowBatteryInfo
 */
- (void)pillow:(CBPeripheral *)peripheral getBatteryWithTimeout:(CGFloat)timeout
      callback:(SLPTransforCallback)handle;

/*获取设备版本信息
 回调返回 PillowDeviceVersion
 */
- (void)pillow:(CBPeripheral *)peripheral getDeviceVersionWithTimeout:(CGFloat)timeout
      callback:(SLPTransforCallback)handle;

/*获取设备的环境数据
 回调返回PillowEnvironmentalData
 */
- (void)pillow:(CBPeripheral *)peripheral getEnvironmentalDataTimeout:(CGFloat)timeout completion:(SLPTransforCallback)handle;

/*结束采集
 */
- (void)pillow:(CBPeripheral *)peripheral stopCollectionWithTimeout:(CGFloat)timeout
      callback:(SLPTransforCallback)handle;


/*查询采集状态
 回调返回 PillowCollectionStatus
 */
- (void)pillow:(CBPeripheral *)peripheral getCollectionStatusWithTimeout:(CGFloat)timeout
      callback:(SLPTransforCallback)handle;

/*开始查看实时数据
 实时数据通过通知kNotificationNameBLEpillowRealtimeData 广播出<kNotificationPostData:PillowRealTimeData>
 */
- (void)pillow:(CBPeripheral *)peripheral startRealTimeDataWithTimeout:(CGFloat)timeout
      callback:(SLPTransforCallback)handle;

/*结束查看实时数据
 */
- (void)pillow:(CBPeripheral *)peripheral stopRealTimeDataWithTimeout:(CGFloat)timeout
      callback:(SLPTransforCallback)handle;

/*开始查看原始数据
 原始数据数据通过通知kNotificationNameBLEpillowOriginalData 广播出<kNotificationPostData:PillowOriginalData>
 */
- (void)pillow:(CBPeripheral *)peripheral startOriginalDataWithTimeout:(CGFloat)timeout
      callback:(SLPTransforCallback)handle;

/*结束查看原始数据
 */
- (void)pillow:(CBPeripheral *)peripheral stopOriginalDataWithTimeout:(CGFloat)timeout
      callback:(SLPTransforCallback)handle;

/*升级
 crcDes:加密包CRC32
 crcBin:原始包CRC32
 package:升级包
 回调返回 PillowUpgradeInfo
 */
- (void)pillow:(CBPeripheral *)peripheral upgradeDeviceWithCrcDes:(long)crcDes
        crcBin:(long)crcBin
upgradePackage:(NSData *)package
      callback:(SLPTransforCallback)handle;

/*ZP100/P401M/PHP1301/P102T升级
 pkey:私钥
hashCode: 哈希值
 package:升级包
 回调返回 PillowUpgradeInfo
 */
- (void)pillow:(CBPeripheral *)peripheral upgradeDeviceWithPkey:(NSString *)pkey
        hashCode:(NSString *)hashCode
upgradePackage:(NSData *)package
      callback:(SLPTransforCallback)handle;

/*历史数据下载(全自动)
 type: 样本数据的人群类型
 startTime:开始时间戳
 endTime:结束时间戳 一般传当前时间
 eachhandle:每次获取到一段报告回调一次 回调返回SLPillowHistoryData
 finishHandle:最终结束的回调
 */
- (void)autoPillow:(CBPeripheral *)peripheral personType:(SLPSleepPersonTypes)type
historyDownloadWithStartTime:(NSInteger)startTime
       endTime:(NSInteger)endTime
eachDataCallback:(SLPTransforCallback)eachhandle
finishCallback:(SLPTransforCallback)finishHandle;

/* 助眠操作接口
 musicEnable: 音乐开关  0: 关  1: 开
 musicId: 音乐ID
 volume: 音乐音量
 circleMode: 循环模式    0列表播放 1单曲循环
 lightEnable: 灯光开关  0: 关  1: 开
 brightness: 灯光亮度     0  -  100
 SLPLight: 灯光结构
 smartEnable: 是否开启智能助眠  0: 关  1: 开
 smartDuration: 助眠停止时长  单位分钟，默认45分钟,0睡着后再结束
 */
- (void)pillow:(CBPeripheral *)peripheral sleepAidOperation:(UInt8)musicEnable musicId:(UInt16)musicId volume:(UInt8)volume circleMode:(UInt8)circleMode lightEnable:(UInt8)lightEnable brightness:(UInt8)brightness light:(SLPLight *)light smartEnable:(UInt8)smartEnable smartDuration:(UInt16)smartDuration timeout:(CGFloat)timeout
      callback:(SLPTransforCallback)handle;

/* 获取助眠操作
 */
- (void)pillow:(CBPeripheral *)peripheral getSleepAidOperationWithTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*
 蓝牙智能停止
 PillowSmartStop
 */
- (void)pillow:(CBPeripheral *)peripheral smartStopConfig:(PillowSmartStop *)smartStopInfo timeout:(CGFloat)timeout
      callback:(SLPTransforCallback)handle;

/* 获取蓝牙智能停止
 */
- (void)pillow:(CBPeripheral *)peripheral getSmartStopWithTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/**
 获取闹钟列表
 @param peripheral 蓝牙句柄
 @param timeout 超时（单位秒）
 @param handle 回调 返回 NSArray<SABAlarmInfo *>
 */
- (void)pillow:(CBPeripheral *)peripheral getAlarmListWithTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*添加或修改闹铃
 alarmInfo: 闹铃信息
 timeout:超时
 */
- (void)pillow:(CBPeripheral *)peripheral alarmConfig:(PillowAlarmInfo *)alarmInfo
       timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*离枕闹钟设置
 alarmInfo: 闹铃信息
 timeout:超时
 */
- (void)pillow:(CBPeripheral *)peripheral leftBedAlarmConfig:(LeftBedAlarmInfo *)alarmInfo
       timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*离枕闹钟获取
 */
- (void)pillow:(CBPeripheral *)peripheral getLeftBedAlarmInfoWithTimeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;

/*闹钟音乐试听功能
 */
- (void)pillow:(CBPeripheral *)peripheral playMusicWithOperation:(UInt8)operation musicId:(UInt16)musicId volume:(UInt8)volume timeout:(CGFloat)timeout callback:(SLPTransforCallback)handle;
@end
