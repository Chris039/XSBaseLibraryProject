//
//  ChrisSScalendarManager.swift
//  松鼠Demo
//
//  Created by 管理员 on 2021/7/1.
//

import Foundation

class JTScalendarManager: NSObject {
    var startIndexpath : NSIndexPath?
    
    var todayDate : Date?
    var todayCompontents : NSDateComponents?
    var greCalendar : NSCalendar?
    var dateFormatter : DateFormatter?
    var chineseCalendarManager : JTChineseScalendarManager?
    var showChineseCalendar : Bool!
    var showChineseHolidaty : Bool!
    var startDate : NSInteger?
    init(showChineseHoliday:Bool,showChineseCalendar:Bool,startDate:NSInteger) {
        super.init()
        self.showChineseHolidaty = showChineseHoliday
        self.showChineseCalendar = showChineseCalendar
        self.startDate = startDate
        
        greCalendar = NSCalendar.init(identifier: .gregorian)
        todayDate = Date.init()
        todayCompontents = dateToComponents(date: todayDate!)
        dateFormatter = DateFormatter.init()
        chineseCalendarManager = JTChineseScalendarManager()
        startIndexpath = NSIndexPath.init(row: 99, section: 99)
    }
    
    func getCalendarDataSoruce(limitMonth:NSInteger,type:JTSenctionScalendarType) -> [Any] {
        var resultArray:[Any] = []
        let components = dateToComponents(date: todayDate!)
        
        components.day = 1
       
        if type == .JTSenctionScalendarFutureType{
            components.month -= 1
        }else if type == .JTSenctionScalendarPastType{
            components.month -= limitMonth
        }else{
            components.month -= (limitMonth + 1)/2
        }
        for i in 0..<limitMonth {
            components.month += 1
            let headerModel = JTSectionCalendarHeaderModel()
            let date = componentsToDate(components: components)
            dateFormatter?.dateFormat = "yyyy年MM月"
            let dateString = dateFormatter?.string(from: date)
            headerModel.headerText = dateString
            headerModel.calendarItemArray = getCalendarItemArray(date: date, section: i)
            resultArray.append(headerModel)
            
            
        }
        
        return resultArray
    }
    
    func getCalendarItemArray(date:Date,section:NSInteger) -> [Any] {
        var resultArray:[Any] = []
        let tatalDay = numberOfDaysInCurrentMonth(date: date)
        let firstDay = startDayOfWeek(date: date)
        let components = dateToComponents(date: date)
        let tempDay = tatalDay + firstDay - 1
        var column = 0
        if tempDay % 7 == 0 {
            column = Int(tempDay/7)
        }else{
            column = Int(tempDay/7 + 1)
        }
        components.day = 0
        for var i in 0..<column {
            for j in 0..<7{
                if i == 0 && j < firstDay - 1 {
                    let calendarItem = JTSectionCalendarModel()
                    calendarItem.year = 0
                    calendarItem.month = 0
                    calendarItem.day = 0
                    calendarItem.chineseCalendar = ""
                    calendarItem.holiday = ""
                    calendarItem.week = -1
                    calendarItem.dateInterval = -1
                    resultArray.append(calendarItem)
                    continue;
                }
                components.day += 1
                if components.day == tatalDay + 1 {
                    i = column
                    break
                }
                let calendarItem = JTSectionCalendarModel()
                calendarItem.year = components.year
                calendarItem.month = components.month
                calendarItem.day = components.day
                calendarItem.week = j
                let date = componentsToDate(components: components)
                calendarItem.dateInterval = dateToInterval(date: date)
                if startDate == calendarItem.dateInterval{
                    startIndexpath = NSIndexPath.init(row: 0, section: section)
                }
                setChineseCalendarAndHoliday(components: components as DateComponents, date: date, calendarItem: calendarItem)
                resultArray.append(calendarItem)
            }
        }
        
        return resultArray
    }
    func numberOfDaysInCurrentMonth(date:Date) -> Int {
        let NSG = greCalendar! as NSCalendar
        return NSG.range(of:NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: date).length
    }
    
    func startDayOfWeek(date:Date) -> Int {
        var startDate:NSDate? = nil
        let result = greCalendar?.range(of: NSCalendar.Unit.month, start: &startDate, interval: nil, for: date)
        if result == true {
            return (greCalendar?.ordinality(of: NSCalendar.Unit.day, in: NSCalendar.Unit.weekOfMonth, for: date))!
        }
        return 0
        
    }
    
    func dateToInterval(date:Date) -> Int {
        return Int(date.timeIntervalSince1970)
    }
    
    func setChineseCalendarAndHoliday(components:DateComponents,date:Date,calendarItem:JTSectionCalendarModel) {
        if components.year == todayCompontents?.year && components.month == todayCompontents?.month && components.day == todayCompontents?.day{
            calendarItem.type = JTSectionScalendType.JTTodayType
            calendarItem.holiday = "今天"
        }else{
            if date.compare(todayDate!) == .orderedDescending {
                calendarItem.type = JTSectionScalendType.JTNextType
            }else{
                calendarItem.type = JTSectionScalendType.JTLastType
            }
        }
        
        if components.month == 1 && components.day == 1{
            calendarItem.holiday = "元旦"
        }else if components.month == 2 && components.day == 14 {
            calendarItem.holiday = "情人节"
        }else if components.month == 3 && components.day == 8 {
            calendarItem.holiday = "妇女节"
        }else if components.month == 5 && components.day == 1 {
            calendarItem.holiday = "劳动节"
        }else if components.month == 5 && components.day == 4 {
            calendarItem.holiday = "青年节"
        }else if components.month == 6 && components.day == 1 {
            calendarItem.holiday = "儿童节"
        }else if components.month == 8 && components.day == 1 {
            calendarItem.holiday = "建军节"
        }else if components.month == 9 && components.day == 10 {
            calendarItem.holiday = "教师节"
        }else if components.month == 10 && components.day == 1 {
            calendarItem.holiday = "国庆节"
        }else if components.month == 12 && components.day == 25{
            calendarItem.holiday = "圣诞节"
        }
        if showChineseCalendar || showChineseHolidaty {
            chineseCalendarManager?.getChineseCalendarWithDate(date: date as NSDate, calendarItem: calendarItem)
        }
        
    }
    //pragma mark NSDate和NSDateComponents转换
    func dateToComponents(date:Date) -> NSDateComponents {

        return greCalendar!.components(NSCalendar.Unit(rawValue: NSCalendar.Unit.era.rawValue|NSCalendar.Unit.year.rawValue|NSCalendar.Unit.month.rawValue|NSCalendar.Unit.day.rawValue|NSCalendar.Unit.hour.rawValue|NSCalendar.Unit.minute.rawValue|NSCalendar.Unit.second.rawValue), from: date) as NSDateComponents
    }
    
    func componentsToDate(components:NSDateComponents) -> Date {
        components.hour = 0
        components.minute = 0
        components.second = 0
        let date = greCalendar?.date(from: components as DateComponents)
        return date!
    }

}

