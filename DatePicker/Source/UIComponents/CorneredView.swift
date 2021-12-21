//
//  CorneredView.swift
//  DatePicker
//
//  Created by Igor Drljic on 21.12.21..
//

import UIKit

class CorneredView: UIView {
    private let cornerLayer = CAShapeLayer()
    private var cornerRadius: CGFloat = 32
    private var corners: UIRectCorner = [.topLeft, .topRight]
    
//    var borderWidth: CGFloat? {
//        set { cornerLayer.borderWidth = newValue ?? 0 }
//        get { cornerLayer.borderWidth }
//    }
//
//    var borderColor: UIColor? {
//        set { cornerLayer.borderColor = newValue?.cgColor }
//        get {
//            guard let borderColor = cornerLayer.borderColor else { return nil }
//            return UIColor(cgColor: borderColor)
//        }
//    }
    
    var borderWidth: CGFloat? {
        set { layer.borderWidth = newValue ?? 0 }
        get { layer.borderWidth }
    }
    
    var borderColor: UIColor? {
        set { layer.borderColor = newValue?.cgColor }
        get {
            guard let borderColor = layer.borderColor else { return nil }
            return UIColor(cgColor: borderColor)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
    }
    
    func set(corners: UIRectCorner = [.topLeft, .topRight], cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
        self.corners = corners
        setNeedsLayout()
//        layoutIfNeeded()
    }
    
    func set(borderWidth: CGFloat, borderColor: UIColor) {
        cornerLayer.borderWidth = borderWidth
        cornerLayer.borderColor = borderColor.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cornerLayer.frame = self.bounds
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        cornerLayer.path = path.cgPath
        self.layer.mask = cornerLayer
    }
}
