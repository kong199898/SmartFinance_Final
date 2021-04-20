import UIKit
import CoreData
import MaterialComponents.MaterialButtons

class RetirementViewController: UIViewController {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let ProfileBtn = MDCButton()
    let AssumptionBtn = MDCButton()
    let IncomeEventBtn = MDCButton()
    let SpendingGoalBtn = MDCButton()
    let DetailBtn = MDCButton()
    let OuterStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        loadContent()
        enableButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        enableButton()
    }
    
    func loadContent() {
        ProfileBtn.setTitle("Profile  ", for: .normal)
        ProfileBtn.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        ProfileBtn.tintColor = .white
        ProfileBtn.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        ProfileBtn.addTarget(self, action: #selector(ProfileBtnPressed), for: .touchUpInside)
        
        AssumptionBtn.setTitle("Assumption  ", for: .normal)
        AssumptionBtn.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        AssumptionBtn.tintColor = .white
        AssumptionBtn.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        AssumptionBtn.addTarget(self, action: #selector(AssumptionBtnPressed), for: .touchUpInside)
        
        IncomeEventBtn.setTitle("Income Event  ", for: .normal)
        IncomeEventBtn.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        IncomeEventBtn.tintColor = .white
        IncomeEventBtn.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        IncomeEventBtn.addTarget(self, action: #selector(IncomeEventBtnPressed), for: .touchUpInside)
        
        SpendingGoalBtn.setTitle("Spending Goal  ", for: .normal)
        SpendingGoalBtn.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        SpendingGoalBtn.tintColor = .white
        SpendingGoalBtn.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        SpendingGoalBtn.addTarget(self, action: #selector(SpendingGoalBtnPressed), for: .touchUpInside)
        
        DetailBtn.setTitle("Get Details  ", for: .normal)
        DetailBtn.setImage(UIImage(systemName: "dollarsign.circle.fill"), for: .normal)
        DetailBtn.tintColor = .white
        DetailBtn.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        DetailBtn.addTarget(self, action: #selector(DetailBtnPressed), for: .touchUpInside)
        
        OuterStack.axis = .vertical
        OuterStack.distribution = .fillEqually
        OuterStack.spacing = 10
        OuterStack.frame = CGRect(x: screenWidth*0.02,
                                  y: screenHeight*0.12,
                                  width: screenWidth*0.95,
                                  height: screenHeight*0.85)
        
        OuterStack.addArrangedSubview(ProfileBtn)
        OuterStack.addArrangedSubview(AssumptionBtn)
        OuterStack.addArrangedSubview(IncomeEventBtn)
        OuterStack.addArrangedSubview(SpendingGoalBtn)
        OuterStack.addArrangedSubview(DetailBtn)
        
        view.addSubview(OuterStack)
    }
    
    func enableButton(){
        if isCoredataEmpty(Name: "TheProfile") || isCoredataEmpty(Name: "TheAssumption"){
            if isCoredataEmpty(Name: "TheProfile"){
                disableButton(btn: AssumptionBtn)
            }else{
                enableButton(btn: AssumptionBtn)
            }
            disableButton(btn: IncomeEventBtn)
            disableButton(btn: SpendingGoalBtn)
            disableButton(btn: DetailBtn)
        }else{
            enableButton(btn: IncomeEventBtn)
            enableButton(btn: SpendingGoalBtn)
            enableButton(btn: DetailBtn)
        }
        
        if isCoredataEmpty(Name: "TheIncomeEvent") && isCoredataEmpty(Name: "TheSpendingGoal"){
            disableButton(btn: DetailBtn)
        }else{
            enableButton(btn: DetailBtn)
        }
    }
    
    func enableButton(btn:MDCButton){
        btn.isEnabled = true
        btn.alpha = 1
    }
    
    func disableButton(btn:MDCButton){
        btn.isEnabled = false
        btn.alpha = 0.95
        
    }
    
    func isCoredataEmpty(Name:String) -> Bool{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            let countProfile = try context.count(for: NSFetchRequest(entityName: Name))
            if countProfile == 0 {
                return true
            }else{
                return false
            }
        }catch{
            return true
        }
    }
    
    @objc func ProfileBtnPressed(){
        let vc = storyboard?.instantiateViewController(identifier: "ProfileVC") as! ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func AssumptionBtnPressed(){
        let vc = storyboard?.instantiateViewController(identifier: "AssumptionVC") as! AssumptionViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func IncomeEventBtnPressed(){
        let vc = storyboard?.instantiateViewController(identifier: "IncomeEventVC") as! IncomeEventViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func SpendingGoalBtnPressed(){
        let vc = storyboard?.instantiateViewController(identifier: "SpendingGoalVC") as! SpendingGoalViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func DetailBtnPressed(){
        let vc = storyboard?.instantiateViewController(identifier: "DetailsVC") as! DetailsTableViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
