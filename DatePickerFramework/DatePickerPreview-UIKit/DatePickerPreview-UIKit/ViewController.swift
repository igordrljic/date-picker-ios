//
//  ViewController.swift
//  DatePickerPreview-UIKit
//
//  Created by Igor Drljic on 21.12.21..
//

import UIKit
import DatePicker

class ViewController: UIViewController {
    private let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }

    func setViews() {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show DatePicker", for: .normal)
        button.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        button.setTitleColor(.systemBlue, for: .normal)
        view.addSubview(button)
        
        setConstraints()
    }
    
    func setConstraints() {
        [button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
         button.widthAnchor.constraint(equalToConstant: 150),
         button.heightAnchor.constraint(equalToConstant: 50)]
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
}

