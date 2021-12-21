//
//  MonthViewController.swift
//  CalendarPicker
//
//  Created by Igor Drljic on 2.12.21..
//

import Foundation
import UIKit

class CalendarView: UIView, Themable {
    var presentedDate: Date { didSet { reloadData() } }
    var selection: DateSelection? { didSet { reloadData() } }
    weak var dateSelectionDelegate: DateSelectionDelegate?
    var calendar: Calendar {
        Calendar.prefered
    }
    private (set) var days: [Day]
    private let numberOfDaysInAWeek = Calendar.prefered.weekdaySymbols.count
    
    private var collectionView: UICollectionView!
    private let collectionLayout = UICollectionViewFlowLayout()
    private var itemSize: CGSize = .zero
    private let daysFactory: DaysFactory
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric,
               height: CGFloat(days.count / numberOfDaysInAWeek) * itemSize.height)
    }
    
    init(presentedDate: Date,
         minDate: Date?,
         maxDate: Date?,
         selection: DateSelection? = nil,
         frame: CGRect = .zero) {
        self.presentedDate = presentedDate
        self.selection = selection
        self.daysFactory = DaysFactory(minDate: minDate, maxDate: maxDate)
        self.days = self.daysFactory.generateDaysInMonth(for: presentedDate, selection: selection)
        super.init(frame: frame)
        setViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let itemDimension = bounds.width / CGFloat(numberOfDaysInAWeek)
        let newItemSize = CGSize(width: itemDimension, height: itemDimension)
        if itemSize != newItemSize {
            itemSize = newItemSize
            collectionLayout.itemSize = newItemSize
            collectionView.reloadData()
            invalidateIntrinsicContentSize()
        }
    }
    
    func reloadData() {
        days = daysFactory.generateDaysInMonth(for: presentedDate, selection: selection)
        collectionView.reloadData()
        invalidateIntrinsicContentSize()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func setViews() {
        collectionLayout.minimumInteritemSpacing = .leastNormalMagnitude
        collectionLayout.minimumLineSpacing = .leastNormalMagnitude
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: collectionLayout).autolayoutView
        collectionView.backgroundColor = theme.colors.background
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DayCell.self,
                                forCellWithReuseIdentifier: DayCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
    }
    
    func setConstraints() {
        constrain(subview: collectionView, padding: .zero)
    }
}

extension CalendarView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dateSelectionDelegate?.didSelect(day: days[indexPath.item])
    }
}

extension CalendarView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        days.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.reuseIdentifier,
                                                            for: indexPath) as? DayCell
        else {
            fatalError("Can't dequeue reusable collection cell with identifier: \(DayCell.reuseIdentifier)")
        }
        cell.configure(with: days[indexPath.item])
        return cell
    }
}
