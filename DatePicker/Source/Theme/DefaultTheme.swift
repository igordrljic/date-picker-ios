//
//  DefaultTheme.swift
//  CalendarPicker
//
//  Created by Igor Drljic on 2.12.21..
//

import Foundation
import UIKit

class DefaultTheme: Theme {
    var colors: Colors = DefaultThemeColors()
    var images: Images = DefaultThemeImages()
    var fonts: Fonts = DefaultThemeFonts()
}

class DefaultThemeColors: Colors {
    var background: UIColor { .white }
    var dimmedBackground: UIColor { .darkGray.withAlphaComponent(0.5) }
    var primary: UIColor { .systemBlue }
    var secondary: UIColor { .systemBlue.withAlphaComponent(0.5) }
    var primaryText: UIColor { .label }
    var secondaryText: UIColor { .secondaryLabel }
    var separator: UIColor { .separator }
    var confirmAction: UIColor { .systemBlue }
    var cancelAction: UIColor { .systemBlue }
}

class DefaultThemeImages: Images {
    var leftArrow: UIImage {
        UIImage(systemName: "chevron.left")!.withRenderingMode(.alwaysTemplate)
    }
    var rightArrow: UIImage {
        UIImage(systemName: "chevron.right")!.withRenderingMode(.alwaysTemplate)
    }
}

class DefaultThemeFonts: Fonts {
    var regular: UIFont { .systemFont(ofSize: UIFont.systemFontSize) }
    var semibold: UIFont { .systemFont(ofSize: UIFont.systemFontSize, weight: .semibold) }
}
