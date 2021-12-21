//
//  LocalizationManager.swift
//  DatePicker
//
//  Created by Igor Drljic on 21.12.21..
//

import Foundation

public struct Localization {
    static var prefered = Localization(cancel: "Cancel", confirm: "Confirm")
    
    public let cancel: String
    public let confirm: String
    
    public init(cancel: String, confirm: String) {
        self.cancel = cancel
        self.confirm = confirm
    }
}
