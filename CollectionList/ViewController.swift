import UIKit
import CoreData

protocol CollectionViewCellTapButton {
    func deleteCell(index: Int)
}

class ViewController: UIViewController {
    
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private var persons:[Persons] = []
    static var colours:[UIColor] = []
        
    func createP(){
        let entity =
                NSEntityDescription.entity(forEntityName: "Persons",
                                           in: context)!
        let newPerson = NSManagedObject(entity: entity,
                                          insertInto: context)

        newPerson.setValue("Default Value", forKey: "emer")
        newPerson.setValue("defaultvalue@gmail.com", forKey: "mbiemer")
        persons.append(newPerson as! Persons)
    }
    func fetchPersons(){
        
        do {
            try context.save()
            self.persons = try context.fetch(Persons.fetchRequest())
        }
        catch {
            print("...Error...")
        }
    }
    
    fileprivate let collectionView: UICollectionView = {
        let layout  = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        fetchPersons()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.title = "Persons"
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Back", style: .plain, target: nil, action: nil)
        createP()
        
    }
}

extension ViewController: CollectionViewCellTapButton{
    
    func deleteCell(index: Int) {
        let personToRemove = self.persons[index]
        
        context.delete(personToRemove)
        do {
            try context.save()
            self.collectionView.reloadData()
        }
        catch{
            print("Error Deleting")
        }
        fetchPersons()
    }
}

extension ViewController: EditDelegate{
    func editPerson(editedName: String, editedLastname: String, index: Int) {

        let person = self.persons[index]
        person.emer = editedName
        person.mbiemer = editedLastname
        
        do {
            try context.save()
            self.collectionView.reloadData()
        }
        catch{
            print("Error Saving")
        }
        fetchPersons()
    }
}

extension ViewController: AddDelegate {
    func addPerson(name: String, lastname: String) {
        
        let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let entity =
                NSEntityDescription.entity(forEntityName: "Persons",
                                           in: context)!
        let newPerson = NSManagedObject(entity: entity,
                                          insertInto: context)
        
        newPerson.setValue(name, forKey: "emer")
        
        newPerson.setValue(lastname, forKey: "mbiemer")
        
        
        do {
            try context.save()
            persons.append(newPerson as! Persons)
            DispatchQueue.main.async { [self] in
                self.collectionView.reloadData()
            }
        }
        catch {
            print("...Error...")
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        persons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        
        cell.nameLabel.text = persons[indexPath.row].emer
        cell.lastnameLabel.text = persons[indexPath.row].mbiemer
        cell.backgroundColor = .white
        cell.cellDelegate = self
        cell.index = indexPath
        cell.layer.borderColor = UIColor.systemGray5.cgColor
        cell.layer.borderWidth = 1
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PersonViewController()
        
        vc.names = persons[indexPath.row].emer!
        vc.lastnames = persons[indexPath.row].mbiemer!
        vc.colors = ViewController.colours[indexPath.row]
        vc.delegate = self
        ModalPresentationViewController.names = persons[indexPath.row].emer!
        ModalPresentationViewController.lastnames = persons[indexPath.row].mbiemer!
        ModalPresentationViewController.editDelegate = self
        PersonViewController.indexes = indexPath.row
        
        self.navigationController?.pushViewController(vc, animated: true)
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

class CustomCell: UICollectionViewCell{
    
    var cellDelegate: CollectionViewCellTapButton?
    var index: IndexPath?
    
    var persons: Persons?{
        didSet {
            guard let pers = persons else {
                return
            }
                nameLabel.text = pers.emer
                lastnameLabel.text = pers.mbiemer
        }
    }
    
    @objc func cellDeleted(){
    
        guard let index = index else {return}
        if let cellDelegate = cellDelegate {
        cellDelegate.deleteCell(index: index.row)
        }
    }
    
    fileprivate let circleView: UIView = {
        let circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.clipsToBounds = true
        return circle
    }()
    
    lazy var random = {
        return UIColor(red: .random(in: 0...1),
                   green: .random(in: 0...1),
                   blue: .random(in: 0...1),
                   alpha: 1.0)
    }()
    
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
    fileprivate let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        let image = UIImage(named: "thrash")
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(lastnameLabel)
        contentView.addSubview(circleView)
        contentView.addSubview(deleteButton)
        contentView.addSubview(circleView)
        layoutSubviews()
        circleView.layer.cornerRadius = 22
        circleView.backgroundColor = random
        ViewController.colours.append(random)
        nameLabel.frame = CGRect(x: 95, y: 15, width: 250, height: 20)
        lastnameLabel.frame = CGRect(x: 95, y: 36, width: 250, height: 20)
        circleView.frame = CGRect(x: 26, y: 13, width: 45, height: 45)
        deleteButton.frame = CGRect(x: 330, y: 17, width: 35, height: 35)
        
        nameLabel.text = persons?.emer
        lastnameLabel.text = persons?.mbiemer
        self.deleteButton.addTarget(self, action: #selector(cellDeleted), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
}
