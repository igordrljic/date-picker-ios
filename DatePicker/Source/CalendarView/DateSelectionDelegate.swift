//
//  DateSelectionDelegate.swift
//  CalendarPicker
//
//  Created by Igor Drljic on 4.12.21..
//

import Foundation

protocol DateSelectionDelegate: AnyObject {
    func didSelect(day selectedDay: Day)
}
