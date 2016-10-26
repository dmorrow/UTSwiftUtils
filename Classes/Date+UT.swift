//
//  Date+UT.swift
//
//  Created by Daniel Morrow on 10/25/16.
//  Copyright (c) 2015 John Busby. All rights reserved.
//

import Foundation

extension Date
{
    
    public var components:DateComponents {
        get {
            return Calendar.autoupdatingCurrent.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.weekday], from: self)
        }
    }
    
    public static func from(year:Int, month:Int, day:Int) -> Date {
        var c = DateComponents()
        c.year = year
        c.month = month
        c.day = day
        
        let gregorian = Calendar(identifier:Calendar.Identifier.gregorian)
        if let date = gregorian.date(from: c) {
            return date
        } else {
            return Date(year:year, month: month, day: day)
        }
    }
    
    public static func parse(_ dateStr:String, format:String="yyyy-MM-dd") -> Date {
        let dateFmt = DateFormatter()
        dateFmt.timeZone = TimeZone.current
        dateFmt.dateFormat = format
        return dateFmt.date(from: dateStr)!
    }
    
    public func dateString(format:String="M-dd-yyyy") -> String {
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = format
        return dateFmt.string(from: self)
    }
    
    public init(dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = Locale(identifier: "en_US_POSIX")
        let d = dateStringFormatter.date(from: dateString)
        self.init(timeInterval:0, since:d!)
    }
    
    public init(year:Int, month:Int, day:Int) {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        self.init(timeInterval:0, since:Calendar.autoupdatingCurrent.date(from: components)!)
    }
    
    public func dateByAdding(days:Int)-> Date {
        var components = DateComponents()
        components.day = days
        return Calendar.autoupdatingCurrent.date(byAdding: components, to:self, wrappingComponents:false)!
    }
    
    public func sameDayAs(_ date:Foundation.Date)->Bool {
        return self.components.day == date.components.day && self.components.month == date.components.month && self.components.year == date.components.year
    }
    
//    - (NSDate*) firstDateOfWeek
//    {
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents* startDate = [gregorian components:NSWeekdayCalendarUnit fromDate:self];
//    if (startDate.weekday > 0)
//    {
//    NSDateComponents* offsetDate = [[NSDateComponents alloc] init];
//    //1 == sunday
//    offsetDate.day = -startDate.weekday+1;
//    //if (!_weekStartsWithSunday) offsetDate.day += 1;
//    return [gregorian dateByAddingComponents:offsetDate toDate:self options:0];
//    }
//    return self;
//    }
    
//    - (NSDate*) firstDateOfMonth
//    {
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents* currentDate = [gregorian components:NSYearCalendarUnit |NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
//    NSDateComponents* startDate = [[NSDateComponents alloc] init];
//    startDate.calendar = gregorian;
//    startDate.year = currentDate.year;
//    startDate.month = currentDate.month;
//    startDate.day = 1;
//    return [gregorian dateFromComponents:startDate];
//    }
    
    
    
//    - (NSUInteger) numWeeksInMonth
//    {
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents* currentDate = [gregorian components:NSYearCalendarUnit |NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
//    
//    NSRange range = [gregorian rangeOfUnit:NSDayCalendarUnit
//    inUnit:NSMonthCalendarUnit
//    forDate:self];
//    
//    NSDateComponents* date = [[NSDateComponents alloc] init];
//    date.calendar = gregorian;
//    date.year = currentDate.year;
//    date.month = [self dateComponents].month;
//    date.day = range.length;
//    
//    NSDateComponents* lastWeek = [gregorian components:NSWeekOfMonthCalendarUnit fromDate:[gregorian dateFromComponents:date]];
//    return lastWeek.weekOfMonth;
//    }
//    
//    - (NSDate*) previousMonth
//    {
//    NSDateComponents* currentDate = [self dateComponents];
//    NSUInteger year = currentDate.year;
//    NSUInteger month = currentDate.month - 1;
//    if (month <= 0)
//    {
//    month = 12;
//    year--;
//    }
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents* date = [[NSDateComponents alloc] init];
//    date.calendar = gregorian;
//    date.year = year;
//    date.month = month;
//    date.day = 1;
//    
//    return [gregorian dateFromComponents:date];
//    }
//    
//    - (NSDate*) nextMonth
//    {
//    NSDateComponents* currentDate = [self dateComponents];
//    NSUInteger year = currentDate.year;
//    NSUInteger month = currentDate.month + 1;
//    if (month > 12)
//    {
//    month = 1;
//    year++;
//    }
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents* date = [[NSDateComponents alloc] init];
//    date.calendar = gregorian;
//    date.year = year;
//    date.month = month;
//    date.day = 1;
//    
//    return [gregorian dateFromComponents:date];
//    }
//    
//    - (NSInteger) weeksBetweenDate:(NSDate*)date
//    {
//    NSInteger days = [self daysBetweenDate:date];
//    return floor(days/7);
//    }
//    - (NSInteger) daysBetweenDate:(NSDate*)date
//    {
//    NSTimeInterval time = [self timeIntervalSinceDate:date];
//    return ((fabs(time) / kSecondsInDay) + 0.5);
//    }
//    
//    - (NSInteger) monthsBetweenDate:(NSDate *)date
//    {
//    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    
//    NSDateComponents *components = [gregorian components:NSMonthCalendarUnit
//    fromDate:self
//    toDate:date
//    options:0];
//    NSInteger months = [components month];
//    return labs(months);
//    }

    
}
