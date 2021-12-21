//
//  Date+Extension.swift
//  DatePicker
//
//  Created by Igor Drljic on 7.12.21..
//

import Foundation

extension Date {
    
    func isEqualOrMoreRecent(than date: Date) -> Bool {
        self >= date
    }
}
