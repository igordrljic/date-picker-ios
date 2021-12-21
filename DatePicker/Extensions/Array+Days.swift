//
//  Array+Days.swift
//  CalendarPicker
//
//  Created by Igor Drljic on 3.12.21..
//

import Foundation

extension Array where Element == Day {
    
    func firstDayOfTheMonth() -> Day {
        first(where: { $0.isWithinDisplayedMonth })!
    }
}
