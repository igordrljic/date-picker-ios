//
//  DateFormatter+Extension.swift
//  DatePicker
//
//  Created by Igor Drljic on 21.12.21..
//

import Foundation

extension DateFormatter {
    static var prefered: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.prefered
        dateFormatter.locale = Locale.prefered
        return dateFormatter
    }
}
