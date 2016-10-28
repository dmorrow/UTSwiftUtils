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
}
