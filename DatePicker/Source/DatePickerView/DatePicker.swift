//
//  CalendarPicker.swift
//  CalendarPicker
//
//  Created by Igor Drljic on 2.12.21..
//

import Foundation
import UIKit

extension DatePicker {
    public struct Parameters {
        let theme: Theme?
        let presentedDate: Date
        let minDate: Date?
        let maxDate: Date?
        let selection: DateSelection?
        let preferedWidth: CGFloat?
        
        public init(theme: Theme? = nil,
                    presentedDate: Date = Date(),
                    minDate: Date? = nil,
                    maxDate: Date? = nil,
                    selection: DateSelection? = nil,
                    preferedWidth: CGFloat? = 290,
                    timeZone: TimeZone = .current,
                    locale: Locale = .current,
                    localization: Localization? = nil) {
            self.theme = theme
            self.presentedDate = presentedDate
            self.minDate = minDate
            self.maxDate = maxDate
            self.selection = selection
            self.preferedWidth = preferedWidth
            TimeZone.prefered = timeZone
            Locale.prefered = locale
            if let localization = localization {
                Localization.prefered = localization
            }
        }
    }
}

final public class DatePicker: UIView, Themable {
    private (set) var presentedDate: Date {
        didSet {
            headerView.presentedDate = presentedDate
            calendarView.presentedDate = presentedDate
        }
    }
    private (set) var minDate: Date?
    private (set) var maxDate: Date?
    private (set) var selection: DateSelection?
    
    private let preferedWidth: CGFloat?
    private var headerView: DatePickerHeader!
    private var calendarView: CalendarView!
    private var footerView: DatePickerFooter!
    private let padding: CGFloat = 10
    private let confirm: (DateSelection?) -> Void
    private let cancel: () -> Void
    
    public init(parameters: Parameters,
                confirm: @escaping (DateSelection?) -> Void,
                cancel: @escaping () -> Void) throws {
        if let theme = parameters.theme {
            ThemeManager.theme = theme
        }
        self.presentedDate = parameters.presentedDate
        self.minDate = parameters.minDate
        self.maxDate = parameters.maxDate
        self.selection = parameters.selection
        self.preferedWidth = parameters.preferedWidth
        self.confirm = confirm
        self.cancel = cancel
        super.init(frame: .zero)
        setViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var intrinsicContentSize: CGSize {
        guard let preferedWidth = preferedWidth else {
            return super.intrinsicContentSize
        }
        return CGSize(width: preferedWidth, height: UIView.noIntrinsicMetric)
    }

    func setViews() {
        clipsToBounds = true
        layer.cornerRadius = 10
        backgroundColor = theme.colors.background
        
        calendarView = CalendarView(presentedDate: presentedDate,
                                    minDate: minDate,
                                    maxDate: maxDate,
                                    selection: selection).autolayoutView
        calendarView.dateSelectionDelegate = self
        addSubview(calendarView)
        
        let weekDayLetters = calendarView.days.prefix(7).map({ // 7 is number of days in week
            $0.dayOfWeekSingleLetter
        })
        headerView = DatePickerHeader(presentedDate: presentedDate,
                                      weekDayLetters: weekDayLetters,
                                      dateAction: { [unowned self] in
                                        print("show month and year selection")
                                      },
                                      scrollAction: { [unowned self] direction in
                                        let calendar = Calendar.prefered
                                        var date: Date?
                                        switch direction {
                                        case .left:
                                            date = try? calendar.previousMonth(for: self.presentedDate)
                                        case .right:
                                            date = try? calendar.nextMonth(for: self.presentedDate)
                                        }
                                        guard let date = date, shouldScroll(to: date, direction: direction) else {
                                            return
                                        }
                                        self.presentedDate = date
                                        self.invalidateIntrinsicContentSize()
                                      }).autolayoutView
        addSubview(headerView)
        
        footerView = DatePickerFooter(confirm: { [unowned self] in
            self.confirm(self.calendarView.selection)
        },
        cancel: { [unowned self] in
            self.cancel()
        }).autolayoutView
        addSubview(footerView)
    }
    
    func setConstraints() {
        [headerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
         headerView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
         headerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
         headerView.bottomAnchor.constraint(equalTo: calendarView.topAnchor, constant: -padding/2),
         
         calendarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
         calendarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
         calendarView.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: -padding/2),
        
         footerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
         footerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
         footerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)]
            .forEach { $0.isActive = true }
    }
    
    private func shouldScroll(to date: Date, direction: DatePickerHeader.Direction) -> Bool {
        switch direction {
        case .left:
            guard let minDate = minDate else { return true }
            return date.isEqualOrMoreRecent(than: minDate) ||
                Calendar.prefered.isDate(date, equalTo: minDate, toGranularity: .month)
        case .right:
            guard let maxDate = maxDate else { return true }
            return maxDate.isEqualOrMoreRecent(than: date) ||
                Calendar.prefered.isDate(date, equalTo: maxDate, toGranularity: .month)
        }
    }
}

extension DatePicker: DateSelectionDelegate {
    
    func didSelect(day selectedDay: Day) {
        guard selectedDay.isSelectable else {
            return
        }
        if let dateSelection = calendarView.selection {
            switch dateSelection {
            case let .single(date):
                if calendarView.calendar.isDate(date, inSameDayAs: selectedDay.date) {
                    calendarView.selection = nil
                } else if selectedDay.date > date {
                    calendarView.selection = .range(date, selectedDay.date)
                } else {
                    calendarView.selection = .single(selectedDay.date)
                }
            case .range:
                calendarView.selection = .single(selectedDay.date)
            }
        } else {
            calendarView.selection = .single(selectedDay.date)
        }
    }
}
