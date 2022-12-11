//
//  REDropDown.swift
//  dropdown
//
//  Created by ajay singh thakur on 13/09/22.
//

import UIKit

protocol REDropDownDelegate: AnyObject {
	func onSelected(_ value: String)
}

class DropdownView: UIView {
	
	let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
	
    weak var delegate: REDropDownDelegate?
	private var dataSource: [String]?
	
	// appearance
	var tableBackground: UIColor = UIColor.lightGray
	var tableSelectedCellColor: UIColor = UIColor.green
	var tableTextColor: UIColor = UIColor.black
	
	private lazy var backgroundView: UIView = {
		let backgroundView = UIView()
		backgroundView.backgroundColor = UIColor.red
		return backgroundView
	}()
	
    // DI
    required init(delegate: REDropDownDelegate, dataSource: [String]) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.dataSource = dataSource
        configureUI()
    }
    
//	override init(frame: CGRect) {
//		super.init(frame: frame)
//
//	}
	
	@available(*, unavailable)
	required init?(coder _: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	private func configureUI() {
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.delegate = self
		tableView.dataSource = self
		
		tableView.backgroundColor = tableBackground
		
		tableView.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(tableView)
		// get safe area
		let safeAreaGuide = safeAreaLayoutGuide
		
		NSLayoutConstraint.activate([
			
			tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
			tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
			
		])
	}
}
extension DropdownView: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataSource?.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.selectedBackgroundView = backgroundView
		cell.backgroundColor = tableBackground
		if let dataSource = dataSource {
			cell.textLabel?.text = dataSource[indexPath.row]
			cell.textLabel?.textColor = tableTextColor
		}
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let dataSource = dataSource {
			let value = dataSource[indexPath.row]
			delegate?.onSelected(value)
		}
	}
}
