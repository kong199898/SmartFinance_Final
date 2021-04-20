import UIKit
import CoreData

class SpendingGoalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")

        return table
    }()
    
    private var models = [TheSpendingGoal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        title = "Spending Goal"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(addSpendingGoalsButtonTapped))
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshSpendingGoalNotification), name: Notification.Name("refreshSpendingGoal"), object: nil)
        
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
        if model.type == "Health Care" || model.type == "Charity/Gift" || model.type == "Vacation"{
            cell.textLabel?.text = "Type: \(model.type!)\nAmount: $\(model.amount)\nFrequency: \(model.frequency!)\nStart At Age: \(model.startingage)"
        }else if model.type == "Vehicle" || model.type == "Home Purchase/Upgrade"{
            cell.textLabel?.text = "Type: \(model.type!)\nDown Payment: $\(model.amount)\nHappen At Age: \(model.startingage)"
        }else if model.type == "Other Expense" {
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
            
            let PopVC = self.storyboard?.instantiateViewController(identifier: "EditSpendingGoalVC") as! EditSpendingGoalViewController
            self.present(PopVC, animated: true)
            
            NotificationCenter.default.post(name: Notification.Name("editSpendingGoal"), object: nil, userInfo:["item":item,
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
    
    func getAllItem(){
        do{
            let request = TheSpendingGoal.fetchRequest() as NSFetchRequest<TheSpendingGoal>
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
    
    func deleteItem(item: TheSpendingGoal){
        context.delete(item)
        
        do{
            try context.save()
            getAllItem()
        }
        catch{
            showMessage(alert: "Error", message: "failed to delete item")
        }
    }
    
    @objc func addSpendingGoalsButtonTapped(){
        let PopVC = storyboard?.instantiateViewController(identifier: "AddSpendingGoalsVC") as! AddSpendingGoalsViewController
        present(PopVC, animated: true)
    }
    
    @objc func refreshSpendingGoalNotification(){
        getAllItem()
    }
}
