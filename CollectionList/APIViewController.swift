//
//  APIViewController.swift
//  CollectionList
//
//  Created by Florian Cela on 12.11.20.
//

import UIKit

class APIViewController: UIViewController {
    
    var users: [User] = []
    var adderDelegate:AddDelegate?
    var presenterDelegate:PresenterDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        collectionView.delegate = self
        collectionView.dataSource = self
        
        ApiController.downloadJSON{users in
            self.users = users
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    fileprivate let collectionView: UICollectionView = {
        let layout  = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(APICustomCell.self, forCellWithReuseIdentifier: "cell1")
        return cv
    }()

}
extension APIViewController:PresenterDelegate{
    func popToPrevious() {
        navigationController!.popViewController(animated: false)
    }
}

extension APIViewController: AddDelegate{
    func addPerson(name: String, lastname: String, color: String) {
        self.popToPrevious()
    }
}

extension APIViewController:CollectionViewAlert{
    
    func onClick(index: Int) {
        
        var random: UIColor {
                return UIColor(red: .random(in: 0...1),
                               green: .random(in: 0...1),
                               blue: .random(in: 0...1),
                               alpha: 1.0)
            }
        let newColor = StringColor.StringFromUIColor(color: random)

        let alert = UIAlertController(title: "Add this Person?", message: nil, preferredStyle: .alert)
        
        let user = users[index]
        
        let labelName = UILabel(frame: CGRect(x: 100, y: 50, width: 100, height: 30))
        labelName.text = user.name.first
        alert.view.addSubview(labelName)
        let labelLastName = UILabel(frame: CGRect(x: 100, y: 80, width: 100, height: 30))
        labelLastName.text = user.name.last
        alert.view.addSubview(labelLastName)
    
        let yesButton = UIAlertAction(title: "Yes", style: .default) { [self] (action) in
            adderDelegate?.addPerson(name: labelName.text!, lastname: labelLastName.text!, color: newColor)
            
            dismiss(animated: false) {
                self.presenterDelegate?.popToPrevious()
            }
        }
        let noButton = UIAlertAction(title: "No", style: .destructive) { (action) in
            self.dismiss(animated: false) {
                self.presenterDelegate?.popToPrevious()
            }
        }
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view as Any, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.25)
            alert.view.addConstraint(height)
        
            alert.addAction(yesButton)
            alert.addAction(noButton)
            present(alert, animated: true, completion: nil)
    }
}

extension APIViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath) as! APICustomCell
        let user = users[indexPath.row]
        cell.nameLabel.text = user.name.first
        cell.lastnameLabel.text = user.name.last
        cell.alertDelegate = self
        cell.index = indexPath
        
        cell.backgroundColor = .white
        cell.layer.borderColor = UIColor.systemGray5.cgColor
        cell.layer.borderWidth = 1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onClick(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width/6)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

protocol CollectionViewAlert {
    func onClick(index: Int )
    }


class APICustomCell: UICollectionViewCell{
    
    var alertDelegate:CollectionViewAlert?
    var index: IndexPath?
    
    fileprivate let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        return label
        
    }()
    fileprivate let lastnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.font = .boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.textColor = .gray
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(lastnameLabel)
        layoutSubviews()
        nameLabel.frame = CGRect(x: 55, y: 15, width: 250, height: 20)
        lastnameLabel.frame = CGRect(x: 55, y: 36, width: 250, height: 20)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
}
