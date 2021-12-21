//
//  ViewController.swift
//  DatePickerPreview-UIKit
//
//  Created by Igor Drljic on 21.12.21..
//

import UIKit
import DatePicker

class ViewController: UIViewController {
    let stackView = UIStackView()
    private let button = UIButton()
    private let italianButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }

    func setViews() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show English DatePicker", for: .normal)
        button.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        button.setTitleColor(.systemBlue, for: .normal)
        stackView.addArrangedSubview(button)
        
        italianButton.translatesAutoresizingMaskIntoConstraints = false
        italianButton.setTitle("Show Italian DatePicker", for: .normal)
        italianButton.addTarget(self, action: #selector(showItalianDatePicker), for: .touchUpInside)
        italianButton.setTitleColor(.systemBlue, for: .normal)
        stackView.addArrangedSubview(italianButton)
        
        setConstraints()
    }
    
    func setConstraints() {
        [stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
         button.widthAnchor.constraint(equalToConstant: 200),
         button.heightAnchor.constraint(equalToConstant: 50),
         italianButton.widthAnchor.constraint(equalToConstant: 200),
         italianButton.heightAnchor.constraint(equalToConstant: 50)]
            .forEach { $0.isActive = true }
    }
    
    @objc private func showDatePicker() {
        do {
            var viewController: UIViewController!
            viewController = try DatePickerViewController.create { selection in
                print("date picker confirmed selection: \(String(describing: selection))")
                viewController.dismiss(animated: true, completion: nil)
            } cancel: {
                print("date picker selection canceled")
                viewController.dismiss(animated: true, completion: nil)
            }
            present(viewController, animated: true, completion: nil)
        } catch {
            fatalError(String(describing: error))
        }
    }
    
    @objc private func showItalianDatePicker() {
        do {
            let localization = Localization(cancel: "Cancellare", confirm: "Confermare")
            let params = DatePicker.Parameters(locale: Locale(identifier: "it"), localization: localization)
            var viewController: UIViewController!
            viewController = try DatePickerViewController.create(with: params) { selection in
                print("date picker confirmed selection: \(String(describing: selection))")
                viewController.dismiss(animated: true, completion: nil)
            } cancel: {
                print("date picker selection canceled")
                viewController.dismiss(animated: true, completion: nil)
            }
            present(viewController, animated: true, completion: nil)
        } catch {
            fatalError(String(describing: error))
        }
    }
}

