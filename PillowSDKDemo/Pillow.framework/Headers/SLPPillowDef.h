//
//  SLPPillowDef.h
//  SDK
//
//  Created by Martin on 2017/8/9.
//  Copyright © 2017年 Martin. All rights reserved.
//

#ifndef SLPPillowDef_h
#define SLPPillowDef_h

/*
 object: 蓝牙设备的句柄 CBPeripheral *peripheral
 userInfo: @{kNotificationPostData:PillowRealtimeDataEntity}
 */
#define kNotificationNameBLEPillowRealtimeData @"kNotificationNameBLEPillowRealtimeData" //实时数据
/*
 object: 蓝牙设备的句柄 CBPeripheral *peripheral
 userInfo: @{kNotificationPostData:PillowOriginalData}
 */
#define kNotificationNameBLEPillowOriginalData @"kNotificationNameBLEPillowOriginalData" //原始数据
/*
 object: 蓝牙设备的句柄 CBPeripheral *peripheral
 userInfo: @{kNotificationPostData:[NSNumber numberWithInteger:电量(0~100)]}
 */
#define kNotificationNameBLEPillowBattery @"kNotificationNameBLEPillowBattery"//Pillow 电量
/*
 object: 蓝牙设备的句柄 CBPeripheral *peripheral
 userInfo: nil
 */
#define kNotificationNameBLEPillowStartCollection @"kNotificationNameBLEPillowStartCollection"//Pillow开始采集
/*
 object: 蓝牙设备的句柄 CBPeripheral *peripheral
 userInfo: nil
 */
#define kNotificationNameBLEPillowStopCollection @"kNotificationNameBLEPillowStopCollection"//Pillow停止采集

#endif /* SLPPillowDef_h */
