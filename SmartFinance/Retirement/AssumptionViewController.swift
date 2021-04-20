import UIKit
import CoreData

class AssumptionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")

        return table
    }()
    
    private var models = [TheAssumption]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        title = "Assumption"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(addAssumptionButtonTapped))
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshAssumptionNotification), name: Notification.Name("refreshAssumption"), object: nil)
        
        view.addSubview(tableView)
        
        getAllItem()
    }
    
    @objc func refreshAssumptionNotification(){
        getAllItem()
    }
    
    @objc func addAssumptionButtonTapped(){
        let PopVC = storyboard?.instantiateViewController(identifier: "AddAssumptionsVC") as! AddAssumptionsViewController
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
        cell.textLabel?.text = "Expected Inflation Rate: \(String(model.inflation))%\nAge of Retirement: \(String(model.retirement))\nLife Expectancy: \(String(model.life))"
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
            
            let PopVC = self.storyboard?.instantiateViewController(identifier: "EditAssumptionVC") as! EditAssumptionFormViewController
            self.present(PopVC, animated: true)
            
            NotificationCenter.default.post(name: Notification.Name("editAssumption"), object: nil, userInfo: ["item":item,
                                                                                                               "inflation":item.inflation,
                                                                                                               "life":item.life,
                                                                                                               "retirement":item.retirement])
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
            models = try context.fetch(TheAssumption.fetchRequest())
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
            enableAddButton()
        }
        catch{
            showMessage(alert: "Error", message: "failed to get item from CoreData")
        }
    }
    
    func deleteItem(item: TheAssumption){
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
            let count = try context.count(for: NSFetchRequest(entityName: "TheAssumption"))
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
