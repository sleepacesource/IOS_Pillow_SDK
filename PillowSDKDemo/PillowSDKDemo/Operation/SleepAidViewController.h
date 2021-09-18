//
//  SleepAidViewController.h
//  PillowSDKDemo
//
//  Created by jie yang on 2021/9/17.
//  Copyright © 2021 medica. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <BluetoothManager/SLPBLEManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface SleepAidViewController : UIViewController

@property(nonatomic,strong) SLPPeripheralInfo *selectPeripheral;
@property(nonatomic,strong) NSString *userID;

@end

NS_ASSUME_NONNULL_END
