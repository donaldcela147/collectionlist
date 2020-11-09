import UIKit
import CoreData

protocol EditDelegate: class {
    func editPerson(editedName : String, editedLastname: String, index: Int)
}

class ModalPresentationViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    static var names:String = ""
    static var lastnames:String = ""
    static var editDelegate:EditDelegate?
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        if editNameTextfield.text != "" || editlastNameTextfield.text != ""{
            let alertSheet = UIAlertController(
                title: nil,
                message: nil,
                preferredStyle: .actionSheet)
            
            let saveAction = UIAlertAction(title: "Save", style: .default) { [self]
                (action) in
                ModalPresentationViewController.editDelegate?.editPerson(editedName: editNameTextfield.text!, editedLastname: editlastNameTextfield.text!, index: PersonViewController.indexes)
                if editNameTextfield.text == "" || editlastNameTextfield.text == ""{
                    self.errorLbl.alpha = 1
                }
                else{
                    self.goToList()
                }
            }
           
            let discardAction = UIAlertAction(title: "Discard Changes", style: .destructive) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertSheet.addAction(saveAction)
            alertSheet.addAction(cancelAction)
            alertSheet.addAction(discardAction)
            
            self.present(alertSheet, animated: true, completion: nil)
        }
        else {
            isModalInPresentation = false
        }
    }

    @objc func savePerson(){
        if editNameTextfield.text == "" || editlastNameTextfield.text == ""{
            self.errorLbl.alpha = 1
        }
        else{
            guard let textName = editNameTextfield.text else{
                return
            }
            guard let textLastName = editlastNameTextfield.text else{
                return
            }
            let index = PersonViewController.indexes
            DispatchQueue.main.async {
                if ModalPresentationViewController.editDelegate != nil{
                    ModalPresentationViewController.editDelegate!.editPerson(editedName: textName, editedLastname: textLastName, index: index)
                }
            }
            self.goToList()
        }
    }
    
    
    @objc func cancell(){
        dismiss(animated: true, completion: nil)
    }
    
    func goToList(){
        let presentedVC = self.presentingViewController
        dismiss(animated: false) {
            if let vc = self.navigationController?.viewControllers.filter({$0 is ViewController}).first {
                presentedVC?.navigationController?.popToViewController(vc, animated: true)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
        view.addSubview(errorLbl)
        view.addSubview(editNameTextfield)
        view.addSubview(editlastNameTextfield)
        view.addSubview(saveEditButton)
        view.addSubview(cancelEditButton)
        
        isModalInPresentation = true
        modalTransitionStyle = .flipHorizontal
        
        presentationController?.delegate = self
        modalPresentationStyle = .popover

        viewDidLayoutSubviews()
        view.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200).isActive = true
        errorLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        editNameTextfield.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        editlastNameTextfield.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        saveEditButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        errorLbl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45).isActive = true
        editNameTextfield.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        editlastNameTextfield.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        saveEditButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true

    }
    override func viewDidLayoutSubviews() {
        errorLbl.frame = CGRect(x: 100, y: 60, width: 200, height: 40)
        editNameTextfield.frame = CGRect(x: 100, y: 140, width: 200, height: 40)
        editlastNameTextfield.frame = CGRect(x: 100, y: 200, width: 200, height: 40)
        saveEditButton.frame = CGRect(x: 160, y: 280, width: 90, height: 30)
        cancelEditButton.frame = CGRect(x: 160, y: 330, width: 90, height: 30)
        
    }
    
    fileprivate let errorLbl: UILabel = {
        let label = UILabel()
        label.text = "Please Fill in all fields"
        label.alpha = 0
        label.textAlignment = .center
        label.textColor = .red
        return label
    }()
    
    fileprivate let editNameTextfield: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.clipsToBounds = true
        text.placeholder = "Name"
        text.layer.cornerRadius = 5.0
        text.layer.borderWidth = 1.0
        text.autocorrectionType = .no
        text.layer.borderColor = UIColor.black.cgColor
        text.font  = UIFont.systemFont(ofSize: 20, weight: .semibold)
        text.textAlignment = .center
        text.backgroundColor = .white
        return text
        
    }()
    fileprivate let editlastNameTextfield: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.clipsToBounds = true
        text.placeholder = "Lastname"
        text.layer.cornerRadius = 5.0
        text.layer.borderWidth = 1.0
        text.autocorrectionType = .no
        text.layer.borderColor = UIColor.black.cgColor
        text.font  = UIFont.systemFont(ofSize: 20, weight: .semibold)
        text.textAlignment = .center
        text.backgroundColor = .white
        return text
    }()
    
    fileprivate let saveEditButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(savePerson), for: .touchUpInside)
        return button
    }()
    fileprivate let cancelEditButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(cancell), for: .touchUpInside)
        return button
    }()
}
