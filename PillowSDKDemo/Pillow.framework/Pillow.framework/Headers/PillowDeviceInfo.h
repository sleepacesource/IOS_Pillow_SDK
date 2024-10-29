//
//  PillowDeviceInfo.h
//  SDK
//
//  Created by Martin on 2017/8/10.
//  Copyright © 2017年 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PillowDeviceInfo : NSObject
@property (nonatomic,copy) NSString *hardwareVersion;//硬件版本
//设备ID	Char[13]	13	UTF-8字串，不带结束符
@property (nonatomic,copy) NSString *deviceID;
@end
