import UIKit
import CoreData
 
protocol AddDelegate {
    func addPerson(name : String, lastname: String, color: String)
}

extension PersonViewController: UIColorPickerViewControllerDelegate{
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        selectedColor = viewController.selectedColor
        circleColorPicker.backgroundColor = selectedColor
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let hitView = self.view.hitTest(firstTouch.location(in: self.view), with: event)

            if hitView === colorPicker {
                print("touch is inside")
            } else {
                print("touch is outside")
            }
        }
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension PersonViewController: PresenterDelegate{
    func popToPrevious() {
        navigationController!.popViewController(animated: false)
    }
}

class PersonViewController: UIViewController {
    
    var selectedColor = UIColor.red
    var colorPicker = UIColorPickerViewController()
    var buttoncalled = false
    var names:String = ""
    var lastnames:String = ""
    static var indexes:Int = 0
    var colors: String = ""
    var adddelegate:AddDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(labelName)
        view.addSubview(labelLastname)
        view.addSubview(errorLabel)
        view.addSubview(nameTextField)
        view.addSubview(lastnameTextField)
        view.addSubview(addButton)
        view.addSubview(editButton)
        view.addSubview(gradientView)
        view.addSubview(circleView)
        view.addSubview(dotsButton)
        view.addSubview(circleColorPicker)
        view.addSubview(pickColor)
        view.addSubview(errorColorLabel)
        colorPicker.delegate = self
        
        view.backgroundColor = .white
        view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        labelName.text = names
        labelLastname.text = lastnames
        circleView.backgroundColor = StringColor.UIColorFromString(string: colors)
        
    }
    
    @objc func selectColor(){
        colorPicker.supportsAlpha = true
        colorPicker.selectedColor = selectedColor
        buttoncalled = true
        present(colorPicker, animated: true)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        buttonBackground()
    }
    
    @objc func editCell(){
        let presentViewController = ModalPresentationViewController()
        presentViewController.presenterDelegate = self
        errorLabel.alpha = 0
        editButton.alpha = 0
        errorColorLabel.alpha = 0
        nameTextField.text = ""
        lastnameTextField.text = ""
        dotsButton.isSelected = false
        present(presentViewController, animated: true, completion: nil)
    }
    
    
    @objc func addCell(){
        
        let error = validateFields()
        if error != nil {
            self.showError(error!)
        }
        else if buttoncalled == false{
            errorColorLabel.alpha = 1
        }
        else{
            guard let nametxt = nameTextField.text else {
                return
            }
            guard let lastnametxt = lastnameTextField.text else{
                return
            }
            let newColor = StringColor.StringFromUIColor(color: selectedColor)

            DispatchQueue.main.async {[self] in
                if adddelegate != nil{
                    self.adddelegate!.addPerson(name: nametxt, lastname: lastnametxt, color: newColor)
            }
        }
            navigationController?.popViewController(animated: true)
        }
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    func validateFields() -> String?{
        if  nameTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" || lastnameTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }else {
            return nil
        }
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 251.0/255.0, green: 241.0/255.0, blue: 229.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 250.0/255.0, green: 90.0/255.0, blue: 10.0/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = self.view.bounds
        self.gradientView.layer.insertSublayer(gradientLayer, at:0)

    }
    func buttonBackground() {
        let colorTop =  UIColor(red: 251.0/255.0, green: 241.0/255.0, blue: 170.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 10/255.0, blue: 110.0/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.view.bounds
        self.addButton.layer.insertSublayer(gradientLayer, at:0)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        labelName.frame = CGRect(x: 85, y: 245, width: 200, height: 45)
        labelLastname.frame = CGRect(x: 85, y: 270, width: 200, height: 45)
        errorLabel.frame = CGRect(x: 120, y: 405, width: 300, height: 40)
        nameTextField.frame = CGRect(x: 75, y: 465, width: 240, height: 40)
        lastnameTextField.frame = CGRect(x: 75, y: 520, width: 240, height: 40)
        addButton.frame = CGRect(x: 235, y: 580, width: 80, height: 40)
        editButton.frame = CGRect(x: 230, y: 315, width: 100, height: 40)
        gradientView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
        circleView.frame = CGRect(x: 150, y: 165, width: 70, height: 70)
        dotsButton.frame = CGRect(x: 320, y: 285, width: 30, height: 30)
        circleColorPicker.frame = CGRect(x: 75, y: 580, width: 40, height: 40)
        pickColor.frame = CGRect(x: 135, y: 580, width: 80, height: 40)
        errorColorLabel.frame = CGRect(x: 120, y: 630, width: 300, height: 40)
        circleView.layer.cornerRadius = 35
        circleColorPicker.layer.cornerRadius = 20
        
        circleColorPicker.backgroundColor = .red
        circleView.backgroundColor = StringColor.UIColorFromString(string: colors)
       
    }
    @objc func DOT(_ sender: Any){
        guard let loopButton = sender as? UIButton else {
            return
        }
        let selected = !loopButton.isSelected

        if !selected {
            editButton.alpha = 0
        } else {
            editButton.alpha = 1
        }

        loopButton.isSelected = selected
    }
    
    fileprivate let gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate let circleView: UIView = {
        let circle = UIView()
        circle.clipsToBounds = true
        circle.translatesAutoresizingMaskIntoConstraints = false
        return circle
    }()
    fileprivate let circleColorPicker: UIView = {
        let circle = UIView()
        circle.clipsToBounds = true
        circle.translatesAutoresizingMaskIntoConstraints = false
        return circle
    }()
    fileprivate let pickColor: UIButton = {
        let button = UIButton()
       
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setTitle("Color", for: .normal)
        button.addTarget(self, action: #selector(selectColor), for: .touchUpInside)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 10.0
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    fileprivate let dotsButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "dots")
        button.setImage(image, for: .normal)
        button.isSelected = false
        button.addTarget(self, action: #selector(DOT), for: .touchUpInside)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    fileprivate let errorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.alpha = 0
        label.textColor = .red
        return label
    }()
    fileprivate let errorColorLabel: UILabel = {
        let label = UILabel()
        label.text = "Plese pick a color"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.alpha = 0
        label.textColor = .red
        return label
        
    }()
    fileprivate let labelName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 22)
        return label
    }()
    fileprivate let labelLastname: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    fileprivate let nameTextField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.clipsToBounds = true
        text.placeholder = "Emri"
        text.layer.cornerRadius = 10.0
        text.layer.borderWidth = 1.0
        text.autocorrectionType = .no
        text.layer.borderColor = UIColor.black.cgColor
        
        return text
    }()
    fileprivate let lastnameTextField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.placeholder = "Mbiemri"
        text.clipsToBounds = true
        text.layer.cornerRadius = 10.0
        text.layer.borderWidth = 1.0
        text.autocorrectionType = .no
        text.layer.borderColor = UIColor.black.cgColor
        return text
    }()
    fileprivate let addButton: UIButton = {
        let button = UIButton()
       
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setTitle("Add", for: .normal)
        button.addTarget(self, action: #selector(addCell), for: .touchUpInside)
        button.layer.cornerRadius = 10.0
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    fileprivate let editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setTitle("Edit Name", for: .normal)
        button.backgroundColor = .systemGray3
        button.alpha = 0
        button.addTarget(self, action: #selector(editCell), for: .touchUpInside)
        return button
    }()
}
