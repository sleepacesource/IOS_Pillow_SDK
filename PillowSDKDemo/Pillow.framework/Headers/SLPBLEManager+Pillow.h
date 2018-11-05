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

/*设置自动开始采集
 valid: 是开启自动采集
 hour：时
 minute：分
 repeat：循环：位结构，最低位表示星期1，最高位无效
 */
- (void)pillow:(CBPeripheral *)peripheral setAutoCollection:(BOOL)valid
          hour:(UInt8)hour
        minute:(UInt8)minute
        repeat:(UInt8)repeat
       timeout:(CGFloat)timeout
      callback:(SLPTransforCallback)handle;

/*开始采集
 */
- (void)pillow:(CBPeripheral *)peripheral startCollectionWithTimeout:(CGFloat)timeout
      callback:(SLPTransforCallback)handle;

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

/*历史数据下载
 type: 样本数据的人群类型
 startTime:开始时间戳
 endTime:结束时间戳 一般传当前时间
 eachhandle:每次获取到一段报告回调一次 回调返回SLPillowHistoryData
 finishHandle:最终结束的回调
 */
- (void)pillow:(CBPeripheral *)peripheral personType:(SLPSleepPersonTypes)type
historyDownloadWithStartTime:(NSInteger)startTime
       endTime:(NSInteger)endTime
eachDataCallback:(SLPTransforCallback)eachhandle
finishCallback:(SLPTransforCallback)finishHandle;

@end
