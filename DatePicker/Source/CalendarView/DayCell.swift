//
//  DayCollectionCell.swift
//  CalendarPicker
//
//  Created by Igor Drljic on 2.12.21..
//

import Foundation
import UIKit

class DayCell: UICollectionViewCell, Themable {
    static let reuseIdentifier = String(describing: self)
    
    private let number = UILabel().autolayoutView
    private let selectionPrimaryBackground = CorneredView().autolayoutView
    private let selectionSecondaryBackground = CorneredView().autolayoutView
    private var cellWidth: CGFloat = 0
    private var selectionType: SelectionType = .none
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with day: Day) {
        selectionType = day.selectionType
        number.text = day.number
        number.textColor = day.isWithinDisplayedMonth && day.isSelectable
            ? theme.colors.primaryText : theme.colors.secondaryText
        number.font = theme.fonts.regular
        setLayers(for: selectionType)
        draw(selectionType: selectionType)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.width != cellWidth {
            cellWidth = bounds.width
            setLayers(for: selectionType)
        }
    }
    
    func setViews() {
        backgroundColor = theme.colors.background
        
        contentView.addSubview(selectionSecondaryBackground)
        
        selectionPrimaryBackground.clipsToBounds = true
        contentView.addSubview(selectionPrimaryBackground)
        
        number.textAlignment = .center
        number.numberOfLines = 1
        contentView.addSubview(number)
    }
    
    func setConstraints() {
        contentView.constrain(subview: number, padding: .zero)
        contentView.constrain(subview: selectionPrimaryBackground, padding: .zero)
        [selectionSecondaryBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         selectionSecondaryBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         selectionSecondaryBackground.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
         selectionSecondaryBackground.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8)]
            .forEach { $0.isActive = true }
    }
    
    private func draw(selectionType: SelectionType) {
        switch selectionType {
        case .single:
            selectionPrimaryBackground.backgroundColor = theme.colors.primary
            selectionPrimaryBackground.isHidden = false
            
            selectionSecondaryBackground.isHidden = true
        case .start:
            selectionPrimaryBackground.isHidden = false
            selectionPrimaryBackground.backgroundColor = theme.colors.primary
            
            selectionSecondaryBackground.isHidden = false
            selectionSecondaryBackground.backgroundColor = theme.colors.secondary
        case .end:
            selectionPrimaryBackground.backgroundColor = theme.colors.primary
            selectionPrimaryBackground.isHidden = false
            
            selectionSecondaryBackground.isHidden = false
            selectionSecondaryBackground.backgroundColor = theme.colors.secondary
        case .middle:
            selectionPrimaryBackground.backgroundColor = theme.colors.background
            selectionPrimaryBackground.isHidden = true
            
            selectionSecondaryBackground.isHidden = false
            selectionSecondaryBackground.backgroundColor = theme.colors.secondary
        case .none:
            selectionPrimaryBackground.isHidden = true
            selectionSecondaryBackground.isHidden = true
        }
    }
    
    private func setLayers(for selectionType: SelectionType) {
        selectionPrimaryBackground.set(corners: .allCorners, cornerRadius: cellWidth / 2)
        switch selectionType {
        case .start:
            selectionSecondaryBackground.set(corners: [.topLeft, .bottomLeft], cornerRadius: cellWidth / 2)
        case .end:
            selectionSecondaryBackground.set(corners: [.topRight, .bottomRight], cornerRadius: cellWidth / 2)
        case .middle:
            selectionSecondaryBackground.set(corners: .allCorners, cornerRadius: 0)
        default:
            break
        }
    }
}
