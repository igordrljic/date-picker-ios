//
//  Day.swift
//  CalendarPicker
//
//  Created by Igor Drljic on 2.12.21..
//

import Foundation

struct Day {
    let date: Date
    let number: String
    let selectionType: SelectionType
    let isWithinDisplayedMonth: Bool
    let isSelectable: Bool
    
    var dayOfWeekSingleLetter: String {
        let formatter = DateFormatter.prefered
        formatter.dateFormat = "EEEEE"
        return formatter.string(from: date)
    }
}
