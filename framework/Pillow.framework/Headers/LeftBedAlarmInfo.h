//
//  LeftBedAlarmInfo.h
//  Pillow
//
//  Created by jie yang on 2021/9/22.
//  Copyright © 2021 Martin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LeftBedAlarmInfo : NSObject

@property (nonatomic, assign) UInt8 isOpen; // 0：关 1：开

@property (nonatomic, assign) UInt8 operation; // 0：进入贪睡  1：关闭闹钟

@end

NS_ASSUME_NONNULL_END
