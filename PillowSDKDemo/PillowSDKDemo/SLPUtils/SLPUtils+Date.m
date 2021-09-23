//
//  SLPUtils+Date.m
//  Sleepace
//
//  Created by Shawley on 09/12/2016.
//  Copyright © 2016 com.medica. All rights reserved.
//

#import "SLPUtils+Date.h"
#import "SLPTime24.h"
#import "SLPTime12.h"

static NSString *const kSourceTimeZone = @"Asia/Beijin";

@implementation SLPUtils (Date)

+ (BOOL)isTimeMode24{
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL isMode24 = (containsA.location == NSNotFound);
    return isMode24;
}

+ (NSString *)timeStringFrom:(NSInteger)hour minute:(NSInteger)minute isTimeMode24:(NSInteger)isTime24{
    SLPTime24 *time24 = [[SLPTime24 alloc] init];
    time24.hour = hour;
    time24.minute = minute;
    if (isTime24){
        return [time24 timeStringWithFormat:SLP_Time_String_Format_HM];
    }else{
        SLPTime12 *time12 = [time24 convertToTime12];
        return [time12 timeStringWithFormat:SLP_Time_String_Format_HM];
    }
}

+ (NSString *)sleepStartTimeFrom:(NSInteger)startTime;
{
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents   *comps1;
    
    //当前的时分秒获得
    comps1 =[calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond)
                        fromDate:currentDate];
    NSInteger hour = [comps1 hour];
    
    if (hour >= 0  && hour < 6 )
    {
        [comps1 setHour:-24];
        [comps1 setMinute:0];
        [comps1 setSecond:0];
        
        currentDate = [calendar dateByAddingComponents:comps1 toDate:currentDate options:0];
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    
    NSString *s = [df stringFromDate:currentDate];
    return s;
}

+ (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

+ (NSString *)getEnMonthAndDayWithChDate:(NSString *)chDate {
    return [self transformDateStr:chDate souFormat:@"MM/dd" desFormat:@"MMM dd"];
}

+ (NSString *)getEnMonthAndYearWithChDate:(NSString *)chDate {
    return [self transformDateStr:chDate souFormat:@"yyyy/MM" desFormat:@"MMM yyyy"];
}

+ (NSString *)getEnDateWithChDate:(NSString *)chDate {
    return [self transformDateStr:chDate souFormat:@"yyyy/MM/dd" desFormat:@"MMM dd,yyyy"];
}

+ (NSString *)transformDateStr:(NSString *)souStr souFormat:(NSString *)souFormat desFormat:(NSString *)desFormat  {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:souFormat];
    NSDate *date = [dateFormatter dateFromString:souStr];
    [dateFormatter setDateFormat:desFormat];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getCurrentDateString {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:kDateFormat];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getDateStringFromTimeStamp:(NSString *)timeStamp {
    NSDate *updateDate = [NSDate dateWithTimeIntervalSince1970:timeStamp.integerValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateFormat];
    return [dateFormatter stringFromDate:updateDate];
}

+ (NSString *)getLocalTimeString:(NSString *)utc8TimeStr {
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithName:kSourceTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateFormat];
    [dateFormatter setTimeZone:sourceTimeZone];
    NSDate *updateDate = [dateFormatter dateFromString:utc8TimeStr];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:timeZone];
    return [dateFormatter stringFromDate:updateDate];
}

+ (NSCalendarUnit)calendarUnitAll{
    NSCalendarUnit unit = kCFCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay|kCFCalendarUnitHour|kCFCalendarUnitMinute|kCFCalendarUnitSecond|kCFCalendarUnitWeekday;
    return unit;
}

+ (NSDateComponents *)dateCompsFromDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:[self calendarUnitAll] fromDate:date];
    return cmps;
}

+ (int32_t)getTimeStampFromDateStr:(NSString *)dateStr {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:kDateFormat];
    NSDate *updateDate = [dateFormatter dateFromString:dateStr];
    return [updateDate timeIntervalSince1970];
}

+ (NSInteger)daysOfDateSinceToday:(NSDate *)date{
    NSDate *today = [NSDate date];
    NSInteger secondsPerDay = 3600 * 24;
    NSInteger dateDays = [date timeIntervalSince1970]/secondsPerDay;
    NSTimeInterval todayDays = [today timeIntervalSince1970]/secondsPerDay;
    NSInteger days = dateDays - todayDays;
    return days;
}

+ (BOOL)isDateToday:(NSDate *)date{
    NSInteger days = [self daysOfDateSinceToday:date];
    BOOL ret = (days == 0);
    return ret;
}
    
+ (BOOL)isDateYesterday:(NSDate *)date{
    NSInteger days = [self daysOfDateSinceToday:date];
    BOOL ret = (days == -1);
    return ret;
}
@end
