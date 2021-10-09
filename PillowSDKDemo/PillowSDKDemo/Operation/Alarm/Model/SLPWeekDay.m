//
//  SLPWeekDay.m
//  Sleepace
//
//  Created by Shawley on 01/12/2016.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import "SLPWeekDay.h"

@implementation SLPWeekDay

+ (NSString *)getNameWithIndex:(WeekDayMode)index {
    NSString *weekDayName = @"";
    switch (index) {
        case WeekDayModeMonday:
            weekDayName = NSLocalizedString(@"Monday", nil);
            break;
        case WeekDayModeTuesday:
            weekDayName = NSLocalizedString(@"Tuesday", nil);
            break;
        case WeekDayModeWednesday:
            weekDayName = NSLocalizedString(@"Wednesday", nil);
            break;
        case WeekDayModeTursday:
            weekDayName = NSLocalizedString(@"Thursday", nil);
            break;
        case WeekDayModeFriday:
            weekDayName = NSLocalizedString(@"Friday", nil);
            break;
        case WeekDayModeSatarday:
            weekDayName = NSLocalizedString(@"Saturday", nil);
            break;
        case WeekDayModeSunday:
            weekDayName = NSLocalizedString(@"Sunday", nil);
            break;
        default:
            break;
    }
    return weekDayName;
}

+ (NSString *)getAlarmRepeatDayStringWithWeekDay:(int)weekDay {
    NSString *repeatDayStr = @"";
    UInt8 weekDayNumber = weekDay;
    if (weekDay == 0x7f) {
        repeatDayStr = NSLocalizedString(@"EveryDay", nil);
        return  repeatDayStr;
    }
    
    for (int i = 0; i < 7; i++) {
        UInt8 repeatDay = 1 << i;
        BOOL isRepeat = repeatDay & weekDayNumber;
        if (isRepeat) {
            NSString *dayStr = [SLPWeekDay getNameWithIndex:i];
            dayStr = [dayStr stringByAppendingString:@"、"];
            repeatDayStr = [repeatDayStr stringByAppendingString:dayStr];
        }
    }
    if (repeatDayStr.length) {
        repeatDayStr = [repeatDayStr substringToIndex:repeatDayStr.length - 1];
    } else {
        repeatDayStr = NSLocalizedString(@"Signal", nil);
    }
    return repeatDayStr;
}

@end
