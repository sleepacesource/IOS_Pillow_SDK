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
    if ([numberString isEqualToString:@"3-0"]) {
         NSString *filepath=[[NSBundle mainBundle] pathForResource:@"3-0_1.12" ofType:@"des"];
        upgradeInfo.package=[NSData dataWithContentsOfFile:filepath];
        upgradeInfo.crcDes=4013397468;
        upgradeInfo.crcBin=3178547150;
    }
    else if ([numberString isEqualToString:@"3-1"])
    {
        NSString *filepath=[[NSBundle mainBundle] pathForResource:@"3-1_1.04" ofType:@"des"];
        upgradeInfo.package=[NSData dataWithContentsOfFile:filepath];
        upgradeInfo.crcDes=542788408;
        upgradeInfo.crcBin=709647589;
    }
    else if ([numberString isEqualToString:@"3-2"])
    {
        NSString *filepath=[[NSBundle mainBundle] pathForResource:@"3-2_1.12" ofType:@"des"];
        upgradeInfo.package=[NSData dataWithContentsOfFile:filepath];
        upgradeInfo.crcDes=4013397468;
        upgradeInfo.crcBin=3178547150;
    }
    else if ([numberString isEqualToString:@"3-3"])
    {
        NSString *filepath=[[NSBundle mainBundle] pathForResource:@"3-3_1.04" ofType:@"des"];
        upgradeInfo.package=[NSData dataWithContentsOfFile:filepath];
        upgradeInfo.crcDes=542788408;
        upgradeInfo.crcBin=709647589;
    }
    else if ([numberString isEqualToString:@"3-4"])
    {
        NSString *filepath=[[NSBundle mainBundle] pathForResource:@"3-4_1.04" ofType:@"des"];
        upgradeInfo.package=[NSData dataWithContentsOfFile:filepath];
        upgradeInfo.crcDes=542788408;
        upgradeInfo.crcBin=709647589;
    }
    else if ([numberString isEqualToString:@"3-5"])
    {
        NSString *filepath=[[NSBundle mainBundle] pathForResource:@"3-5_1.04" ofType:@"des"];
        upgradeInfo.package=[NSData dataWithContentsOfFile:filepath];
        upgradeInfo.crcDes=542788408;
        upgradeInfo.crcBin=709647589;
    }
    else if ([numberString isEqualToString:@"3-6"])
    {
        NSString *filepath=[[NSBundle mainBundle] pathForResource:@"3-6_1.04" ofType:@"des"];
        upgradeInfo.package=[NSData dataWithContentsOfFile:filepath];
        upgradeInfo.crcDes=542788408;
        upgradeInfo.crcBin=709647589;
    }
    else if ([numberString isEqualToString:@"34-3"])
    {
        NSString *filepath=[[NSBundle mainBundle] pathForResource:@"34-3_1.15" ofType:@"des"];
        upgradeInfo.package=[NSData dataWithContentsOfFile:filepath];
        upgradeInfo.crcDes=4206117993;
        upgradeInfo.crcBin=1630395148;
    }
    else
    {

    }
    
    return upgradeInfo;
}

@end
