import UIKit
import CoreData
 
protocol AddDelegate {
    func addPerson(name : String, lastname: String)
}

extension PersonViewController: PresenterDelegate{
    func popToPrevious() {
        navigationController!.popViewController(animated: false)
    }
}

class PersonViewController: UIViewController {
    
    var names:String = ""
    var lastnames:String = ""
    static var indexes:Int = 0
    var colors = UIColor()
    
    var delegate:AddDelegate?
    
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
        
        view.backgroundColor = .white
        view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        labelName.text = names
        labelLastname.text = lastnames
        circleView.backgroundColor = colors
        
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
        else{
            guard let nametxt = nameTextField.text else {
                return
            }
            guard let lastnametxt = lastnameTextField.text else{
                return
            }
            DispatchQueue.main.async {[self] in
                if delegate != nil{
                    self.delegate!.addPerson(name: nametxt, lastname: lastnametxt)
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
        let colorBottom = UIColor(red: 250.0/255.0, green: 110.0/255.0, blue: 10.0/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = self.view.bounds
        self.gradientView.layer.insertSublayer(gradientLayer, at:0)

    }
    func buttonBackground() {
        let colorTop =  UIColor(red: 251.0/255.0, green: 241.0/255.0, blue: 259.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 255.0/255.0, green: 90.0/255.0, blue: 0.0/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
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
        errorLabel.frame = CGRect(x: 120, y: 415, width: 300, height: 40)
        nameTextField.frame = CGRect(x: 75, y: 475, width: 240, height: 40)
        lastnameTextField.frame = CGRect(x: 75, y: 530, width: 240, height: 40)
        addButton.frame = CGRect(x: 235, y: 590, width: 80, height: 40)
        editButton.frame = CGRect(x: 230, y: 315, width: 100, height: 40)
        gradientView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
        circleView.frame = CGRect(x: 150, y: 165, width: 70, height: 70)
        dotsButton.frame = CGRect(x: 320, y: 285, width: 30, height: 30)
        circleView.layer.cornerRadius = 35

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
