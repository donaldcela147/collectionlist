import UIKit
import CoreData
 
protocol AddDelegate {
    func addPerson(name : String, lastname: String)
}

class PersonViewController: UIViewController {
    
    var names:String = ""
    var lastnames:String = ""
    static var indexes:Int = 0
    
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
        view.backgroundColor = .systemOrange
        view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        labelName.text = names
        labelLastname.text = lastnames
        
    }
    
    @objc func editCell(){
        let presentViewController = ModalPresentationViewController() 
        
        navigationController?.present(presentViewController, animated: true, completion: nil)
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
    
    override func viewDidLayoutSubviews() {
        labelName.frame = CGRect(x: 150, y: 125, width: 200, height: 45)
        labelLastname.frame = CGRect(x: 150, y: 165, width: 200, height: 45)
        errorLabel.frame = CGRect(x: 120, y: 315, width: 300, height: 40)
        nameTextField.frame = CGRect(x: 100, y: 375, width: 200, height: 45)
        lastnameTextField.frame = CGRect(x: 100, y: 460, width: 200, height: 45)
        addButton.frame = CGRect(x: 170, y: 535, width: 60, height: 30)
        editButton.frame = CGRect(x: 170, y: 240, width: 60, height: 50)
        
    }
    
    fileprivate let errorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.alpha = 0
        label.textColor = .red
        return label
    }()
    fileprivate let labelName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    fileprivate let labelLastname: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    fileprivate let nameTextField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.clipsToBounds = true
        text.placeholder = "Emri"
        text.layer.cornerRadius = 5.0
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
        text.layer.cornerRadius = 5.0
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
        button.backgroundColor = .systemRed
        button.addTarget(self, action: #selector(addCell), for: .touchUpInside)
        button.layer.borderWidth = 4
        return button
    }()
    fileprivate let editButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "edit") as UIImage?
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(editCell), for: .touchUpInside)
        return button
    }()
}
