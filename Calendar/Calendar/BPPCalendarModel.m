//
//  BPPCalendarModel.m
//  Animation
//
//  Created by Onway on 2017/4/7.
//  Copyright © 2017年 Onway. All rights reserved.
//

#import "BPPCalendarModel.h"

@interface BPPCalendarModel ()

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, assign) NSInteger day;//天
@property (nonatomic, assign) NSInteger month;//月
@property (nonatomic, assign) NSInteger year;//年
@property (nonatomic, strong) NSMutableArray *dayArray;

@end

@implementation BPPCalendarModel

- (instancetype)init {
    if (self = [super init]) {
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *nowCompoents =[self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
        self.year = nowCompoents.year;
        self.month = nowCompoents.month;
        self.day = nowCompoents.day;
        self.dayArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)setDayArr {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * nowDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld",_year,_month,_day]];
    //本月的天数范围
    NSRange dayRange = [_calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:nowDate];
    //上个月的天数范围
    NSRange lastdayRange = [_calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[self setLastMonthWithDay]];
    //本月第一天的NSDate对象
    NSDate *nowMonthfirst = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%d",_year,_month,1]];
    //本月第一天是星期几
    NSDateComponents * components = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:nowMonthfirst];
    //本月最后一天的NSDate对象
    NSDate * nextDay = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld",_year,_month,dayRange.length]];
    NSDateComponents * lastDay = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:nextDay];
    //上个月遗留的天数
    for (NSInteger i = lastdayRange.length - components.weekday + 2; i <= lastdayRange.length; i++) {
        NSString * string = [NSString stringWithFormat:@"%ld",i];
        [self.dayArray addObject:string];
    }
    //本月的总天数
    for (NSInteger i = 1; i <= dayRange.length ; i++) {
        NSString * string = [NSString stringWithFormat:@"%ld",i];
        [self.dayArray addObject:string];
    }
    //下个月空出的天数
    for (NSInteger i = 1; i <= (7 - lastDay.weekday); i++) {
        NSString * string = [NSString stringWithFormat:@"%ld",i];
        [self.dayArray addObject:string];
    }
    self.index = components.weekday - 2 + self.day;
    self.block(_year, _month);
    return self.dayArray;
}

//返回本月第一天的NSDate对象
- (NSDate *)firstDayDate {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = self.year;
    components.month = self.month;
    components.day = 1;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

//返回上个月第一天的NSDate对象
- (NSDate *)setLastMonthWithDay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = nil;
    if (self.month != 1) {
        
        date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%d",self.year,self.month-1,01]];
        
    }else{
        
        date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%d-%d",self.year - 1,12,01]];
    }
    return date;
}

//下个月的数据
- (NSArray *)nextMonthDataArr {
    [self.dayArray removeAllObjects];
    if (_month == 12) {
        _month = 1;
        _year ++;
    }else {
        _month ++;
    }
    return [self setDayArr];
}

//上个月的数据
- (NSArray *)lastMonthDataArr {
    [self.dayArray removeAllObjects];
    if (_month == 1) {
        _month = 12;
        _year --;
    }else {
        _month --;
    }
    return [self setDayArr];
}

@end
