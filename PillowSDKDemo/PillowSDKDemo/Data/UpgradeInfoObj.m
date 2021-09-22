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
    
    NSString *filepath=[[NSBundle mainBundle] pathForResource:@"P102T-v1.13r(v2.0.1b)-g-20210816" ofType:@"img"];
    upgradeInfo.package=[NSData dataWithContentsOfFile:filepath];
    upgradeInfo.crcDes=1119821362;
    upgradeInfo.crcBin=256003259;
    
    return upgradeInfo;
}

@end
