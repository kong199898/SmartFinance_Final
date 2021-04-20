import UIKit
import MaterialComponents.MaterialActionSheet
import MaterialComponents.MaterialDialogs
import SwiftUI
import CoreData

class ViewController: UIViewController {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        //NavigationBar
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    
    func GotoStockPage(){
        let  tabBarVC = UITabBarController()
        
        let vc1 = StockViewController()
        let vc2 = StockDescriptionViewController()
        
        vc1.title = "Info"
        vc2.title = "Description"
        
        tabBarVC.setViewControllers([vc1, vc2], animated: false)
        
        guard let items = tabBarVC.tabBar.items else{
            return
        }
        
        let images = ["waveform.path.ecg.rectangle", "info.circle"]
        for x in 0..<items.count{
            items[x].image = UIImage(systemName: images[x])
        }
        
        
        self.navigationController?.pushViewController(tabBarVC, animated: true)
        self.navigationController?.navigationBar.topItem?.title = "Home"
    }
    
    func GotoPredictionPage(){
        let vc = storyboard?.instantiateViewController(identifier: "PredictionVC") as! PredictionViewController
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.navigationBar.topItem?.title = "Home"
    }
    
    @IBAction func StockButtonTapped(_ sender: UIButton){
        let actionSheet = UIAlertController(title: "Go to ", message: nil, preferredStyle: .actionSheet)
        
        let actionOne = UIAlertAction(title: "Latest Stock Info", style: .default, handler: { _ in
            self.GotoStockPage()
         })
        
        let actionTwo = UIAlertAction(title: "Stock Price Prediction", style: .default, handler: { _ in
            self.GotoPredictionPage()
         })
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(actionOne)
        actionSheet.addAction(actionTwo)
        actionSheet.addAction(actionCancel)
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func ExpenseButtonTapped(_ sender: UIButton){
        let persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "SmartFinanceData")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
        
        let host = UIHostingController(rootView: ExpenseView().environment(\.managedObjectContext, persistentContainer.viewContext))
        self.navigationController?.pushViewController(host, animated: true)
        self.navigationController?.navigationBar.topItem?.title = "Home"
    }
    
    @IBAction func RoiButtonTapped(_ sender: UIButton){
        let vc = storyboard?.instantiateViewController(identifier: "RoiVC") as! RoiViewController
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.navigationBar.topItem?.title = "Home"
    }
    
    @IBAction func RetirementButtonTapped(_ sender: UIButton){
        let vc = storyboard?.instantiateViewController(identifier: "RetirementVC") as! RetirementViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
