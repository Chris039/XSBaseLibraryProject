//
//  Date+Extension.swift
//  XSBaseLibraryProject
//
//  Created by chris lee on 2021/7/13.
//

import UIKit

// MARK: 获取时间
extension Date {
    
    /// 获取当前 秒级 时间戳 - 10位
    var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }

    /// 获取当前 毫秒级 时间戳 - 13位
    var msTimeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval * 1000))
        return "\(millisecond)"
    }
    
    /// 获取当前时间戳
    ///
    /// - Parameter isMsTime: 是否是毫秒级别
    /// - Returns: 时间戳
    static func getNowTimeInterval(_ isMsTime: Bool = false) -> TimeInterval{
        let date = Date()
        let timeInterval = date.timeIntervalSince1970
        let millisecond = isMsTime == true ? Double(timeInterval * 1000) : timeInterval
        return millisecond
    }
    
    /// 获取当前时间
    ///
    /// - Parameter dateFormat: 时间格式
    /// - Returns: 当前时间
    static func currentDateTime(_ dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale.current
        timeFormatter.timeZone = TimeZone.current
        timeFormatter.dateFormat = dateFormat
        return timeFormatter.string(from: date)
    }
    
    /// 获取当前年份
    ///
    /// - Returns: 当前时间
    static func currentYear() -> String {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale.current
        timeFormatter.timeZone = TimeZone.current
        timeFormatter.dateFormat = "yyyy"
        return timeFormatter.string(from: date)
    }
    
    /// 获取当前月
    ///
    /// - Returns: 当前时间
    static func currentMonth() -> String {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale.current
        timeFormatter.timeZone = TimeZone.current
        timeFormatter.dateFormat = "yyyy"
        return timeFormatter.string(from: date)
    }
    
    /// 获取当前年月日
    ///
    /// - Returns: 当前时间
    static func currentDay() -> String {
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale.current
        timeFormatter.timeZone = TimeZone.current
        timeFormatter.dateFormat = "yyyy-MM-dd"
        return timeFormatter.string(from: date)
    }
    
    /// 根据日历获取当前的日，月或年
    ///
    /// - Parameter component: 需要返回的值，枚举值，可以是日，月，年...
    /// - Returns: 当前日、月、年...
    func getComponent(component: Calendar.Component) -> Int {
        let calendar = Calendar.current
        return calendar.component(component, from: self)
    }
    
    /// Date实例转时间
    ///
    /// - Parameter dateFormat: 时间格式
    /// - Returns: 时间
    func getString(dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = dateFormat
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
}

// MARK: 时间转换
extension Date {
    
    /// Date转换String
    ///
    /// - Parameters:
    ///     - date: 需要转换的date
    ///     - dateFormat: 时间格式
    /// - Returns: 字符串格式时间
    static func dateToString(date:Date, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
    }
    
    /// String转换Date
    ///
    /// - Parameters:
    ///     - dateStr: 需要转换的String
    ///     - dateFormat: 时间格式
    /// - Returns: 字符串格式时间
    static func stringToDate(dateStr: String, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: dateStr)
        return date
    }
    
    /// 时间戳转换时间
    ///
    /// - Parameters:
    ///     - timeStamp: 时间戳
    ///     - dateFormat: 时间格式
    /// - Returns: 字符串格式时间
    static func timeStampToString(timeStamp: String, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let timeSta: TimeInterval
        if timeStamp.count == 10 {
            timeSta = TimeInterval(timeStamp) ?? self.getNowTimeInterval()
        } else {
            timeSta = (TimeInterval(timeStamp) ?? self.getNowTimeInterval(true)) / 1000
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = dateFormat
        let date = Date(timeIntervalSince1970: timeSta)
        return dateFormatter.string(from: date)
    }
    
    /// 时间转换时间戳
    ///
    /// - Parameters:
    ///     - time: 时间
    ///     - dateFormat: 时间格式
    ///     - isMsTime: 是否毫秒级别
    /// - Returns: 时间戳
    static func timeToTimeStamp(time: String, dateFormat: String = "yyyy-MM-dd HH:mm:ss", isMsTime: Bool = false) -> TimeInterval {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = dateFormat
        let last = dateFormatter.date(from: time)
        guard let timeStamp = last?.timeIntervalSince1970 else { return Date.getNowTimeInterval(isMsTime) }
        return isMsTime ? (timeStamp * 1000) : timeStamp
    }
    
    /// 时间格式之间的转换
    ///
    /// - Parameters:
    ///     - timeStr: 时间
    ///     - dateFormat: 时间格式
    /// - Returns: 转换之后的时间
    static func getStringDateToStringWithFormat(timeStr: String, dateFormat: String) -> String {
        
        let date = Date.stringToDate(dateStr: timeStr) ?? Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = dateFormat
        
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
    /// 根据时间显示为（几分钟前，几小时前，几天前）
    ///
    /// - Parameters:
    ///     - str: 时间
    ///     - dateFormat: 时间格式
    ///     - isMsTime: 时间戳是否是毫秒级别
    /// - Returns: 返回几分钟前或者小时前
    static func compareCurrentTime(str: String, dateFormat: String = "yyyy-MM-dd HH:mm:ss", isMsTime: Bool = false) -> String {
        let timeStamp = timeToTimeStamp(time: str, dateFormat: dateFormat, isMsTime: isMsTime)
        
        return updateTimeToCurrentTime(timeStamp: TimeInterval(timeStamp), isMsTime: isMsTime)
    }
    
    /// 根据后台时间戳返回几分钟前，几小时前，几天前
    ///
    /// - Parameters:
    ///     - timeStamp: 时间戳
    ///     - isMsTime: 时间戳是否是毫秒级别
    /// - Returns: 返回几分钟前或者小时前
    static func updateTimeToCurrentTime(timeStamp: TimeInterval, isMsTime: Bool = false) -> String {
        //获取当前的时间戳
        let currentTime = Date.getNowTimeInterval(isMsTime)
        //时间差
        let reduceTime : TimeInterval = isMsTime ? (currentTime - timeStamp) / 1000 : (currentTime - timeStamp)
        //时间差小于60秒
        if reduceTime < 60 {
            return "刚刚"
        }
        //时间差大于一分钟小于60分钟内
        let mins = Int(reduceTime / 60)
        if mins < 60 {
            return "\(mins)分钟前"
        }
        let hours = Int(reduceTime / 3600)
        if hours < 24 {
            return "\(hours)小时前"
        }
        let days = Int(reduceTime / 3600 / 24)
        if days < 30 {
            return "\(days)天前"
        }
        //不满足上述条件---或者是未来日期-----直接返回日期
        let timeString = timeStampToString(timeStamp: String(timeStamp), dateFormat: "yyyy年MM月dd日 HH:mm:ss")
        return timeString
    }
}

// MARK: - 时间比较
extension Date {
    
    /// 时间差
    ///
    /// - Parameter fromDate: 起始时间
    /// - Returns: 对象
    public func daltaFrom(_ fromDate: Date) -> DateComponents {
        let calendar = Calendar.current
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        return calendar.dateComponents(components, from: fromDate, to: self)
    }

    /// 是否是同一年
    ///
    /// - Returns: ture or false
    func isThisYear() -> Bool {
        let calendar = Calendar.current
        let currendarYear = calendar.component(.year, from: Date())
        let selfYear =  calendar.component(.year, from: self)
        return currendarYear == selfYear
    }

    /// 是否是今天的时间
    ///
    /// - Returns: Bool
    public func isToday() -> Bool{
        let currentTime = Date().timeIntervalSince1970
        let selfTime = self.timeIntervalSince1970
        return (currentTime - selfTime) <= (24 * 60 * 60)
    }
    
    /// 通过NSCalendar判断是否是今天
    ///
    /// - Parameter dateStr: 时间
    /// - Returns: Bool
    static func checkToday(dateStr: String) -> Bool {
        let date = Date.stringToDate(dateStr: dateStr) ?? Date()
        let isToday = NSCalendar.current.isDateInToday(date)
        return isToday
    }

    /// 是否是昨天的时间
    ///
    /// - Returns: Bool
    public func isYesToday() -> Bool {
        let currentTime = Date().timeIntervalSince1970
        let selfTime = self.timeIntervalSince1970
        return (currentTime - selfTime) > (24 * 60 * 60)
    }
    
    /// 两个日期的间隔是否超过多少天
    ///
    /// - Parameters:
    ///     - dateString: 字符串时间
    ///     - dataFormart: 时间格式
    ///     - intervalTime: 间隔天数
    /// - Returns: 如果时间大于 intervalTime 为true 否位false
    static func checkDayOutsideDate(_ dateString: String, dataFormart: String = "yyyy-MM-dd HH:mm:ss" , intervalTime: Int = 7) -> Bool {
        if let date = Date.stringToDate(dateStr: dateString, dateFormat: dataFormart) {
            let components = Calendar.current.dateComponents([.day], from: date, to: Date())
            if abs(components.day!) > intervalTime {
                return true
            }
        }
        return false
    }
}
