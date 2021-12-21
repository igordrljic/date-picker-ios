//
//  DatePickerHeader.swift
//  CalendarPicker
//
//  Created by Igor Drljic on 3.12.21..
//

import Foundation
import UIKit

class DatePickerHeader: UIView, Themable {
    enum Direction {
        case left
        case right
    }
    
    var presentedDate: Date {
        didSet {
            dateLabel.text = dateFormatter.string(from: presentedDate).capitalized
        }
    }
    let dateLabel = UILabel().autolayoutView
    let dateButton = UIButton().autolayoutView
    let previousButton = UIButton().autolayoutView
    let nextButton = UIButton().autolayoutView
    let daysOfWeekStack = UIStackView().autolayoutView
    let separatorView = UIView().autolayoutView
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter.prefered
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    private let verticalPadding: CGFloat = 10
    private let horizontalPadding: CGFloat = 10
    private let buttonDimension: CGFloat = 30
    private let weekDayLetters: [String]
    private let dateAction: () -> Void
    private let scrollAction: (Direction) -> Void
    
    init(presentedDate: Date,
         frame: CGRect = .zero,
         weekDayLetters: [String],
         dateAction: @escaping () -> Void,
         scrollAction: @escaping (Direction) -> Void) {
        self.presentedDate = presentedDate
        self.weekDayLetters = weekDayLetters
        self.dateAction = dateAction
        self.scrollAction = scrollAction
        super.init(frame: frame)
        setViews()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setViews() {
        backgroundColor = theme.colors.background
        
        dateLabel.textColor = theme.colors.primaryText
        dateLabel.text = dateFormatter.string(from: presentedDate).capitalized
        dateLabel.font = theme.fonts.semibold.withSize(20)
        addSubview(dateLabel)
        dateButton.addTarget(self, action: #selector(dateButtonAction), for: .touchUpInside)
        addSubview(dateButton)
        
        previousButton.setImage(theme.images.leftArrow, for: .normal)
        previousButton.addTarget(self, action: #selector(previousMonthAction), for: .touchUpInside)
        previousButton.tintColor = theme.colors.primary
        addSubview(previousButton)
        
        nextButton.setImage(theme.images.rightArrow, for: .normal)
        nextButton.addTarget(self, action: #selector(nextMonthAction), for: .touchUpInside)
        nextButton.tintColor = theme.colors.primary
        addSubview(nextButton)
        
        daysOfWeekStack.axis = .horizontal
        daysOfWeekStack.spacing = 0
        daysOfWeekStack.distribution = .fillEqually
        daysOfWeekStack.alignment = .center
        for index in 0..<weekDayLetters.count {
            let dayOfWeekLabel = UILabel().autolayoutView
            dayOfWeekLabel.textColor = theme.colors.secondaryText
            dayOfWeekLabel.text = weekDayLetters[index]
            dayOfWeekLabel.textAlignment = .center
            dayOfWeekLabel.font = theme.fonts.regular
            daysOfWeekStack.addArrangedSubview(dayOfWeekLabel)
        }
        addSubview(daysOfWeekStack)
        
        separatorView.backgroundColor = theme.colors.separator
        addSubview(separatorView)
    }
    
    func setConstraints() {
        [dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
         dateLabel.topAnchor.constraint(equalTo: topAnchor),
         dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: previousButton.leadingAnchor, constant: -horizontalPadding),
         dateLabel.bottomAnchor.constraint(equalTo: daysOfWeekStack.topAnchor, constant: -verticalPadding),
         
         dateButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
         dateButton.centerXAnchor.constraint(equalTo: dateLabel.centerXAnchor),
         dateButton.widthAnchor.constraint(equalTo: dateLabel.widthAnchor),
         dateButton.heightAnchor.constraint(equalTo: dateLabel.heightAnchor),
         
         previousButton.widthAnchor.constraint(equalToConstant: buttonDimension),
         previousButton.heightAnchor.constraint(equalToConstant: buttonDimension),
         previousButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
         previousButton.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: -horizontalPadding),
         
         nextButton.widthAnchor.constraint(equalToConstant: buttonDimension),
         nextButton.heightAnchor.constraint(equalToConstant: buttonDimension),
         nextButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
         nextButton.trailingAnchor.constraint(equalTo: trailingAnchor),
         
         daysOfWeekStack.leadingAnchor.constraint(equalTo: leadingAnchor),
         daysOfWeekStack.trailingAnchor.constraint(equalTo: trailingAnchor),
         daysOfWeekStack.bottomAnchor.constraint(equalTo: separatorView.topAnchor),
         
         separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
         separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
         separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
         separatorView.heightAnchor.constraint(equalToConstant: 1)]
            .forEach { $0.isActive = true }
    }
    
    @objc private func dateButtonAction() {
        dateAction()
    }
    
    @objc private func previousMonthAction() {
        scrollAction(.left)
    }
    
    @objc private func nextMonthAction() {
        scrollAction(.right)
    }
}
