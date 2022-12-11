# Adding Dropdown option to UITextField

##Requirement. 
To add a dropdown option when clicking on the text field instead of typing manually, and selecting only from the given option.  

## Research
Adding drop-down options to the text field is one of the common UX practice around the mobile and web, the best and nearest option by searching and researching around I found these blogs. 

* [https://medium.com/swift2go/custom-ui-master-class-dropdown-menu-with-textfield-20daf39e5943](https://medium.com/swift2go/custom-ui-master-class-dropdown-menu-with-textfield-20daf39e5943)
* [https://github.com/jriosdev/iOSDropDown](https://github.com/jriosdev/iOSDropDown)

After reading the first article you can implement your own dropdown, and if you don't have time you can go for the second option.

I went with my own custom implementation, below are the details of the implementation.

## Prerequisite
* Beginner knowledge in ios development.
* Revise your knowledge in [UITextfield delegate](https://developer.apple.com/documentation/uikit/uitextfielddelegate). 

## Get Started
#### Initial Setup
1. **Create Project.**  
Let's get started and create a new project in Xcode.
Launch Xcode, then click “Create a new Xcode project” in the Welcome to Xcode window or choose File > New > Project, Select platform as iOS and template as App, after filling in all the fields select UserInterface as Storyboard.

2. **Adding Textfield.**   
Now we are going to add textfield and setup its delegate.   

Inside ```ViewController.swift```
create and initialize the textfield.  

```
	lazy var myTextField: UITextField = {
		let textField = UITextField()
		textField.font = UIFont.systemFont(ofSize: 17)
		textField.borderStyle = .roundedRect
		textField.layer.cornerRadius = 6
		textField.layer.borderWidth = 1
		textField.layer.borderColor = UIColor.darkGray.cgColor
		return textField
	}()
```
Added constraint, set delegate and add it to the viewcontroller view.  

```
private func configureConstraints() {

	[myTextField].forEach { view in
			view.translatesAutoresizingMaskIntoConstraints = false
			self.view.addSubview(view)
		}
		
		// get safe area
		let safeAreaGuide = self.view.safeAreaLayoutGuide
		
		NSLayoutConstraint.activate([
			
			myTextField.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 64),
			myTextField.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16),
			myTextField.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16),
			
		])
}
```

calling the above function and setting delegate your ```ViewDidLoad``` will look like below.   

```
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		myTextField.delegate = self
		self.configureConstraints()
	}
```
after the above steps, you will get an error to set delegate like this `Cannot assign a value of type 'ViewController' to type`, add the extension to ViewController confirming to `UITextFieldDelegate`

```
extension ViewController: UITextFieldDelegate {
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		return false
	}

	func textFieldDidEndEditing(_ textField: UITextField) {
	}
}
```
Now your initial setup is all completed, you can go ahead and run your project you will see the textfield where you can type your input.   
#### Dropdown View Setup

As you have textfield and other things in place, we have to now present the dropdown view instead of the keyboard and allow selection from it. 
  
* **Add Dropdrop View with constraints**.  

The first step is to disable typing and keyboard popups, instead showing an empty view on editing start and hiding it when editing ends.   

Adding view as property.  

```
private let dropDownView = UIView()
```
make it hidden by default inside `viewDidLoad` and add some background color, i am adding black

```
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		myTextField.delegate = self
		dropDownView.isHidden = true
		dropDownView.backgroundColor = UIColor.black
		self.configureConstraints()
	}

```
Modify the constraints and add the dropdownview to the controller, below is the modified `configureConstraints` method

```
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
```

* **Disable text entry and hide unihde view**.

Now modify the `UITextFieldDelegate` methods to show and hide the dropdown view
 
 ```
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
 ```
 
Run the project and click on textfield, you will see the black view appearing at the bottom of textfield.

## Making Dropdown View

Now everything is setup the textfield and the empty view which show and hide on editing start-stop, we have to subclass view to host uitableview to show the list of options in the drop-down and add selection capability.

1. **Subclassing UIView as DropdownView** 

Now lets create a subclass of UIView to host uitableview to show the options.

```
class DropdownView: UIView {
	let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
	
	// writing custom init
	required init() {
        super.init(frame: .zero)
        configureUI()
    }
    
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
		return 10
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

		cell.textLabel?.text = "\(indexpath.row)"
		cell.textLabel?.textColor = .black
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//TODO: Add
	}
}
```
Now again run the project you will see the 

2. **Adding datasource and delegate**.  
 
We have tableview setup inside DropdowView now we have to pass our datasrouce and allow selection for it.
For selection we need to use delegate or closure to pass data backward, we are going to use protocol and delegate for it.

For DataSource add property inside DropdownView

```
class DropdownView: UIView {
	private var dataSource: [String]?
}
```

For data passing create a protocol to pass data backward, write it above DropdownView class inside the same file.

```
protocol DropDownDelegate: AnyObject {
	func onSelected(_ value: String)
}
```

add delegate variable inside DropdownView

```
class DropdownView: UIView {
	weak var delegate: REDropDownDelegate?
}
```
Modify the init of DropdownView to inject both datasource and delegate confirm class

```
class DropdownView: UIView {

    // DI
    required init(delegate: REDropDownDelegate, dataSource: [String]) {
        super.init(frame: .zero)
        self.delegate = delegate
        self.dataSource = dataSource
        configureUI()
    }
}
```

Finally modify the `UITableViewDelegate` and `UITableViewDataSource` methods to show data passed and pass data back on click

```
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
```

3. **Completion**.  

Everything is setup so, in `ViewController` change the normal view to DropdownView and your final code should look like this.


```
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
```

