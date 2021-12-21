//
//  Themable.swift
//  CalendarPicker
//
//  Created by Igor Drljic on 5.12.21..
//

protocol Themable {
    var theme: Theme { get }
}

extension Themable {
    var theme: Theme {
        ThemeManager.theme
    }
}
