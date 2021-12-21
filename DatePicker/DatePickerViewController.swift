//
//  DatePickerViewController.swift
//  DatePicker
//
//  Created by Igor Drljic on 5.12.21..
//

import Foundation
import UIKit

final public class DatePickerViewController: UIViewController {
    public var presentTransition: UIViewControllerAnimatedTransitioning = FadeInAnimator()
    public var dismissTransition: UIViewControllerAnimatedTransitioning = FadeOutAnimator()
    private (set) var datePicker: DatePicker!
    let backgroundView = UIView().autolayoutView
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setConstraints()
    }
    
    public static func create(with params: DatePicker.Parameters = DatePicker.Parameters(),
                              confirm: @escaping (DateSelection?) -> Void,
                              cancel: @escaping () -> Void) throws -> DatePickerViewController {
        let viewController = DatePickerViewController()
        viewController.transitioningDelegate = viewController
        viewController.modalPresentationStyle = .overFullScreen
        viewController.datePicker = try DatePicker(parameters: params,
                                                   confirm: confirm,
                                                   cancel: cancel).autolayoutView
        return viewController
    }
        
    private init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("Method not implemented: \(#function)")
    }
    
    internal required init?(coder: NSCoder) {
        fatalError("Method not implemented: \(#function)")
    }
        
    func setViews() {
        backgroundView.backgroundColor = theme.colors.dimmedBackground
        view.addSubview(backgroundView)
        
        view.addSubview(datePicker)
    }
    
    func setConstraints() {
        [backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
         backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
         datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor)]
            .forEach { $0.isActive = true }
        let constraint = NSLayoutConstraint(item: datePicker!,
                                            attribute: .top,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .centerY,
                                            multiplier: 0.5,
                                            constant: 0)
        constraint.isActive = true
        view.addConstraint(constraint)
    }
}

extension DatePickerViewController: Themable {}

extension DatePickerViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController,
                                    presenting: UIViewController,
                                    source: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {
        return presentTransition
    }
    
    public func animationController(forDismissed dismissed: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {
        return dismissTransition
    }
}
