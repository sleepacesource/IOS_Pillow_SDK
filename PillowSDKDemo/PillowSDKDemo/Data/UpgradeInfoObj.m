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
    
    NSString *filepath=[[NSBundle mainBundle] pathForResource:@"P200A_HP00X-v1.22r(v2.0.10r)-u-20231109" ofType:@"des"];
    upgradeInfo.package=[NSData dataWithContentsOfFile:filepath];
    upgradeInfo.crcDes=1097605837;
    upgradeInfo.crcBin=3597493674;
    
    return upgradeInfo;
}

@end
