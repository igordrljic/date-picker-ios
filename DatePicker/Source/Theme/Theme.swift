//
//  Theme.swift
//  CalendarPicker
//
//  Created by Igor Drljic on 2.12.21..
//

import Foundation
import UIKit

public protocol Theme {
    var colors: Colors { get }
    var images: Images { get }
    var fonts: Fonts { get }
}

public protocol Colors {
    var background: UIColor { get }
    var dimmedBackground: UIColor { get }
    var primary: UIColor { get }
    var secondary: UIColor { get }
    var primaryText: UIColor { get }
    var secondaryText: UIColor { get }
    var separator: UIColor { get }
    var confirmAction: UIColor { get }
    var cancelAction: UIColor { get }
}

public protocol Images {
    var leftArrow: UIImage { get }
    var rightArrow: UIImage { get }
}

public protocol Fonts {
    var regular: UIFont { get }
    var semibold: UIFont { get }
}
