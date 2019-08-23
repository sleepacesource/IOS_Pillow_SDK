//
//  UpgradeInfoObj.m
//  RestonSDKDemo
//
//  Created by San on 2017/9/12.
//  Copyright © 2017年 medica. All rights reserved.
//

#import "UpgradeInfoObj.h"

@implementation UpgradeInfoObj

+ (UpgradeInfoObj *)backUpgradeInfoFromDeviceNumber:(NSString *)numberString
{
    UpgradeInfoObj *upgradeInfo=[[UpgradeInfoObj alloc]init];
    
    NSString *filepath=[[NSBundle mainBundle] pathForResource:@"P200A_HP00X_20190820_V1.08(0.0.1)_Debug" ofType:@"des"];
    upgradeInfo.package=[NSData dataWithContentsOfFile:filepath];
    upgradeInfo.crcDes=2138129606;
    upgradeInfo.crcBin=1766804836;
    
    return upgradeInfo;
}

@end
