//
//  ChrisSectionCalendarModel.swift
//  松鼠Demo
//
//  Created by 管理员 on 2021/7/1.
//

import UIKit

enum JTSectionScalendType: Int {
    case JTTodayType = 1
    case JTLastType = 2
    case JTNextType = 3
}
class JTSectionCalendarModel: NSObject {

    var year : NSInteger?
    var month : NSInteger?
    var day : NSInteger?
    
    var dateInterval : NSInteger?
    var week : NSInteger?
    var holiday:String?
    var chineseCalendar : String?
    var type : JTSectionScalendType?
}

class JTSectionCalendarHeaderModel: NSObject {
    var headerText:String?
    var calendarItemArray=[Any]()
}
