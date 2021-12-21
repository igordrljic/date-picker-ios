//
//  CalendarPickerModel.swift
//  CalendarPicker
//
//  Created by Igor Drljic on 2.12.21..
//

import Foundation

extension Calendar {
    
    static let `default`: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone.current
        return calendar
    }()
    
    func nextMonth(for date: Date) throws -> Date {
        guard let nextMonth = self.date(byAdding: .month, value: 1, to: date)
        else { throw CalendarPickerError.nextMonthCreationFailed(date) }
        return nextMonth
    }
    
    func previousMonth(for date: Date) throws -> Date {
        guard let previousMonth = self.date(byAdding: .month, value: -1, to: date)
        else { throw CalendarPickerError.nextMonthCreationFailed(date) }
        return previousMonth
    }
}
