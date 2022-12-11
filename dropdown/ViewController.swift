//
//  ViewController.swift
//  dropdown
//
//  Created by ajay singh thakur on 13/09/22.
//

import UIKit

class ViewController: UIViewController {
	
	lazy var myTextField: UITextField = {
		let textField = UITextField()
		textField.font = UIFont.systemFont(ofSize: 17)
		textField.borderStyle = .roundedRect
		textField.layer.cornerRadius = 6
		textField.layer.borderWidth = 1
		textField.layer.borderColor = UIColor.darkGray.cgColor
		
		return textField
	}()
	
    private var dropDownView: DropdownView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		myTextField.delegate = self

        dropDownView = DropdownView.init(delegate: self, dataSource: ["abc", "def", "ghi", "klm", "nop"])
		dropDownView.isHidden = true
        dropDownView.backgroundColor = .black
		self.configureConstraints()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

	}
	
	private func configureConstraints() {
		
		[myTextField, dropDownView].forEach { view in
			view.translatesAutoresizingMaskIntoConstraints = false
			self.view.addSubview(view)
		}
		
		// get safe area
		let safeAreaGuide = self.view.safeAreaLayoutGuide
		
		NSLayoutConstraint.activate([
			
			myTextField.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 64),
			myTextField.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16),
			myTextField.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16),
			
			dropDownView.topAnchor.constraint(equalTo: myTextField.bottomAnchor, constant: 1),
			dropDownView.leadingAnchor.constraint(equalTo: myTextField.leadingAnchor),
			dropDownView.trailingAnchor.constraint(equalTo: myTextField.trailingAnchor),
			
			dropDownView.heightAnchor.constraint(equalToConstant: 200)
			
		])
		
	}
	
}

extension ViewController: REDropDownDelegate {
	func onSelected(_ value: String) {
		self.myTextField.text = value
		self.dropDownView.isHidden = true
	}
}
extension ViewController: UITextFieldDelegate {
	// to hide the text editing and directly assigning the
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		print("prevent the text field from opening")
		dropDownView.isHidden = false
		return false
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
		dropDownView.isHidden = true
	}
}
