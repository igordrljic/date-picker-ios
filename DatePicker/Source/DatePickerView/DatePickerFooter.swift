//
//  DatePickerFooter.swift
//  CalendarPicker
//
//  Created by Igor Drljic on 5.12.21..
//

import Foundation
import UIKit

class DatePickerFooter: UIView, Themable {
    let confirmButton = UIButton().autolayoutView
    let cancelButton = UIButton().autolayoutView
    let horizontalSeparator = UIView().autolayoutView
    let verticalSeparator = UIView().autolayoutView
    private let confirm: () -> Void
    private let cancel: () -> Void
    private let padding: CGFloat = 10
    private let buttonDimension: CGFloat = 30
    private let localization = Localization.prefered
    
    init(confirm: @escaping () -> Void, cancel: @escaping () -> Void) {
        self.confirm = confirm
        self.cancel = cancel
        super.init(frame: .zero)
        setViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViews() {
        cancelButton.setTitle(localization.cancel, for: .normal)
        cancelButton.setTitleColor(theme.colors.cancelAction, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        cancelButton.titleLabel?.font = theme.fonts.regular
        addSubview(cancelButton)
        
        confirmButton.setTitle(localization.confirm, for: .normal)
        confirmButton.setTitleColor(theme.colors.confirmAction, for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonAction), for: .touchUpInside)
        confirmButton.titleLabel?.font = theme.fonts.semibold
        addSubview(confirmButton)
        
        horizontalSeparator.backgroundColor = theme.colors.separator
        addSubview(horizontalSeparator)
        
        verticalSeparator.backgroundColor = theme.colors.separator
        addSubview(verticalSeparator)
    }
    
    func setConstraints() {
        [cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor),
         cancelButton.topAnchor.constraint(equalTo: horizontalSeparator.bottomAnchor, constant: padding),
         cancelButton.trailingAnchor.constraint(equalTo: verticalSeparator.leadingAnchor),
         cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor),
         cancelButton.widthAnchor.constraint(equalTo: confirmButton.widthAnchor),
         cancelButton.heightAnchor.constraint(equalToConstant: buttonDimension),
         
         confirmButton.leadingAnchor.constraint(equalTo: verticalSeparator.trailingAnchor),
         confirmButton.topAnchor.constraint(equalTo: horizontalSeparator.bottomAnchor, constant: padding),
         confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor),
         confirmButton.bottomAnchor.constraint(equalTo: bottomAnchor),
         confirmButton.heightAnchor.constraint(equalToConstant: buttonDimension),
         
         horizontalSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
         horizontalSeparator.topAnchor.constraint(equalTo: topAnchor),
         horizontalSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
         horizontalSeparator.heightAnchor.constraint(equalToConstant: 1),
         
         verticalSeparator.topAnchor.constraint(equalTo: topAnchor, constant: padding/2),
         verticalSeparator.bottomAnchor.constraint(equalTo: bottomAnchor),
         verticalSeparator.widthAnchor.constraint(equalToConstant: 1)]
            .forEach { $0.isActive = true }
    }
    
    @objc private func confirmButtonAction() {
        confirm()
    }
    
    @objc private func cancelButtonAction() {
        cancel()
    }
}
