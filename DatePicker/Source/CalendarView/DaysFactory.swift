//
//  DaysFactory.swift
//  CalendarPicker
//
//  Created by Igor Drljic on 2.12.21..
//

import Foundation

class DaysFactory {
    let calendar = Calendar.prefered
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter.prefered
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()
    private var dateSelection: DateSelection?
    private let minDate: Date?
    private let maxDate: Date?
    
    init(minDate: Date?, maxDate: Date?) {
        self.minDate = minDate
        self.maxDate = maxDate
    }

    func generateDaysInMonth(for baseDate: Date,
                             selection dateSelection: DateSelection? = nil) -> [Day] {
        self.dateSelection = dateSelection
        guard let metadata = try? monthMetadata(for: baseDate) else {
            fatalError("An error occurred when generating the metadata for \(baseDate)")
        }
        
        let numberOfDaysInMonth = metadata.numberOfDays
        let offsetInInitialRow = metadata.firstDayWeekday > 0 ?
            metadata.firstDayWeekday
            :
            1 + abs(metadata.firstDayWeekday)
        let firstDayOfMonth = metadata.firstDay
        
        var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow))
            .map { day in
                let isWithinDisplayedMonth = day >= offsetInInitialRow
                let dayOffset =
                    isWithinDisplayedMonth ?
                    day - offsetInInitialRow :
                    -(offsetInInitialRow - day)
                return generateDay(
                    offsetBy: dayOffset,
                    for: firstDayOfMonth,
                    isWithinDisplayedMonth: isWithinDisplayedMonth
                )
            }
        days.append(contentsOf: generateStartOfNextMonth(using: firstDayOfMonth))
        return days
    }
    
    private func generateDay(offsetBy dayOffset: Int,
                             for baseDate: Date,
                             isWithinDisplayedMonth: Bool) -> Day {
        let date = calendar.date(byAdding: .day,
                                 value: dayOffset,
                                 to: baseDate)
            ?? baseDate
        return Day(date: date,
                   number: dateFormatter.string(from: date),
                   selectionType: selectionType(for: date),
                   isWithinDisplayedMonth: isWithinDisplayedMonth,
                   isSelectable: isWithinDisplayedMonth && isValid(date))
    }
    
    private func selectionType(for date: Date) -> SelectionType {
        guard let dateSelection = dateSelection else {
            return .none
        }
        switch dateSelection {
        case let .single(selectedDate):
            return calendar.isDate(date, inSameDayAs: selectedDate) ? .single : .none
        case let .range(startDate, endDate):
            if calendar.isDate(date, inSameDayAs: startDate) {
                return .start
            } else if calendar.isDate(date, inSameDayAs: endDate) {
                return .end
            } else if date > startDate && date < endDate {
                return .middle
            } else {
                return .none
            }
        }
    }
    
    private func generateStartOfNextMonth(using firstDayOfDisplayedMonth: Date) -> [Day] {
        guard let lastDayInMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1),
                                                 to: firstDayOfDisplayedMonth)
        else {
            return []
        }
        let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth) + 1
        guard additionalDays > 0 && additionalDays < 7 else {
            return []
        }
        let days: [Day] = (1...additionalDays).map {
            generateDay(offsetBy: $0, for: lastDayInMonth, isWithinDisplayedMonth: false)
        }
        return days
    }
    
    private func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
        guard
            let numberOfDaysInMonth = calendar.range(of: .day,
                                                     in: .month,
                                                     for: baseDate)?.count,
            let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month],
                                                                              from: baseDate))
        else {
            throw CalendarPickerError.metadataGenerationFailed
        }
        let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 1
        return MonthMetadata(numberOfDays: numberOfDaysInMonth,
                             firstDay: firstDayOfMonth,
                             firstDayWeekday: firstDayWeekday
        )
    }
    
    private func isValid(_ date: Date) -> Bool {
        if let minDate = minDate, let maxDate = maxDate {
            return date.isEqualOrMoreRecent(than: minDate) && maxDate.isEqualOrMoreRecent(than: date)
        } else if let minDate = minDate {
            return date.isEqualOrMoreRecent(than: minDate)
        } else if let maxDate = maxDate {
            return maxDate.isEqualOrMoreRecent(than: date)
        }
        return true
    }
}
