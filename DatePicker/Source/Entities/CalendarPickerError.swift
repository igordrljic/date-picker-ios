//
//  CalendarPickerError.swift
//  CalendarPicker
//
//  Created by Igor Drljic on 2.12.21..
//

import Foundation

public enum CalendarPickerError: Error {
    case metadataGenerationFailed
    case nextMonthCreationFailed(Date)
    case previousMonthCreationFailed(Date)
    
    var errorDescription: String? {
        switch self {
        case .metadataGenerationFailed:
            return "CalendarPicker metadata geenration failed"
        case let .nextMonthCreationFailed(date):
            return "Can't calculate next month for date: \(String(describing: date))"
        case let .previousMonthCreationFailed(date):
            return "Can't calculate previous month for date: \(String(describing: date))"
        }
    }
}
