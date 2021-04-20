import UIKit
import CoreData

class IncomeEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")

        return table
    }()
    
    private var models = [TheIncomeEvent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        title = "Income Event"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(addIncomeEventButtonTapped))
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshIncomeEventNotification), name: Notification.Name("refreshIncomeEvent"), object: nil)
        
        view.addSubview(tableView)
        getAllItem()
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
        if model.type == "Annuity Income" || model.type == "Pension Income" || model.type == "Rental Income"{
            cell.textLabel?.text = "Type: \(model.type!)\nAmount: $\(model.amount)\nFrequency: \(model.frequency!)\nStart At Age: \(model.startingage)"
        }else if model.type == "Sale of Property/Downsize" {
            cell.textLabel?.text = "Type: \(model.type!)\nAmount: $\(model.amount)\nHappen At Age: \(model.startingage)"
        }else if model.type == "Work During Retirement" {
            cell.textLabel?.text = "Type: \(model.type!)\nAmount: $\(model.amount)\nStart At Age: \(model.startingage)\nDuration: \(model.other!) years"
        }else if model.type == "Other Income" {
            cell.textLabel?.text = "Type: \(model.type!) - \(model.other!)\nAmount: $\(model.amount)\nFrequency: \(model.frequency!)\nStart At Age: \(model.startingage)"
        }else {
            print("do not have this model \(model.type!)")
        }
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
            
            let PopVC = self.storyboard?.instantiateViewController(identifier: "EditIncomeEventVC") as! EditIncomeEventViewController
            self.present(PopVC, animated: true)
            
            NotificationCenter.default.post(name: Notification.Name("editIncomeEvent"), object: nil, userInfo:["item":item,
                                                                                                               "type":item.type,
                                                                                                               "amount":item.amount,
                                                                                                               "frequency":item.frequency,
                                                                                                               "startingage":item.startingage,
                                                                                                               "other":item.other])
        }))
        
        sheet.addAction(UIAlertAction(title:"Delete", style: .destructive, handler: {_ in
            self.deleteItem(item: item)
        }))
        
        present(sheet, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight*0.15
    }
    
    @objc func addIncomeEventButtonTapped(){
        let PopVC = storyboard?.instantiateViewController(identifier: "AddIncomeEventVC") as! AddIncomeEventViewController
        present(PopVC, animated: true)
    }
    
    @objc func refreshIncomeEventNotification(){
        getAllItem()
    }
    
    func getAllItem(){
        do{
            let request = TheIncomeEvent.fetchRequest() as NSFetchRequest<TheIncomeEvent>
            let sort = NSSortDescriptor(key: "type", ascending: true)
            request.sortDescriptors = [sort]
            
            models = try context.fetch(request)
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
        catch{
            showMessage(alert: "Error", message: "failed to get item from CoreData")
        }
    }
    
    func deleteItem(item: TheIncomeEvent){
        context.delete(item)
        
        do{
            try context.save()
            getAllItem()
        }
        catch{
            showMessage(alert: "Error", message: "failed to delete item")
        }
    }
    
}
