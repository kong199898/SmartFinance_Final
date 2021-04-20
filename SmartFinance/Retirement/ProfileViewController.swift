import UIKit
import CoreData

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let toolbar = UIToolbar()
    let datePicker = UIDatePicker()
    let defaults = UserDefaults()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")

        return table
    }()
    
    private var models = [TheProfile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        title = "Profile"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(addProfileButtonTapped))
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshProfileNotification), name: Notification.Name("refreshProfile"), object: nil)
        
        view.addSubview(tableView)
        
        getAllItem()
    }
    
    @objc func refreshProfileNotification(){
        getAllItem()
    }
    
    @objc func addProfileButtonTapped(){
        let PopVC = storyboard?.instantiateViewController(identifier: "AddProfileVC") as! AddProfileFormViewController
        present(PopVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier:"cell", for: indexPath)
        cell.textLabel?.text = "Full Name: \(model.name!)\nBirth Date: \(formatter.string(from: model.birthdate!))\nAge: \((defaults.value(forKey: "UserAge"))!)\nEarning: $\(String(model.earning))"
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]
        
        let sheet = UIAlertController(title: "Edit Profile",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler: nil))
        
        sheet.addAction(UIAlertAction(title:"Edit", style: .default, handler: {_ in
            
            let PopVC = self.storyboard?.instantiateViewController(identifier: "EditProfileVC") as! EditProfileFormViewController
            self.present(PopVC, animated: true)
            
            NotificationCenter.default.post(name: Notification.Name("editProfile"), object: nil, userInfo: ["item":item,
                                                                                                            "name": item.name,
                                                                                                            "birth": item.birthdate,
                                                                                                            "earn": item.earning])
        }))
        
        sheet.addAction(UIAlertAction(title:"Delete", style: .destructive, handler: {_ in
            self.deleteItem(item: item)
        }))
        
        present(sheet, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight*0.3
    }
    
    func getAllItem(){
        do{
            models = try context.fetch(TheProfile.fetchRequest())
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
            enableAddButton()
        }
        catch{
            showMessage(alert: "Error", message: "failed to get item in CoreData")
        }
    }
    
    func deleteItem(item: TheProfile){
        context.delete(item)
        
        do{
            try context.save()
            getAllItem()
        }
        catch{
            showMessage(alert: "Error", message: "failed to delete item")
        }
    }
    
    func enableAddButton(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            let count = try context.count(for: NSFetchRequest(entityName: "TheProfile"))
            if count == 0 {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }else{
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }catch{
            showMessage(alert: "Error", message: "failed to enable button")
        }
    }
}
