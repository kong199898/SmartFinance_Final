import UIKit
import DropDown

class AddSpendingGoalsViewController: UIViewController {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    private lazy var CharityGiftVC = CharityGiftViewController()
    private lazy var HealthCareVC = HealthCareViewController()
    private lazy var HomePurchaseVC = HomePurchaseViewController()
    private lazy var VacationVC = VacationViewController()
    private lazy var VehicleVC = VehicleViewController()
    private lazy var OtherExpenseVC = OtherExpenseViewController()
    
    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
            "Charity/Gift",
            "Health Care",
            "Home Purchase/Upgrade",
            "Vacation",
            "Vehicle",
            "Other Expense"
        ]
        let icons = [
            "gift",
            "cross",
            "house",
            "airplane",
            "car.fill",
            "signature"
        ]
        menu.cellNib = UINib(nibName: "DropDownCell", bundle: nil)
        menu.customCellConfiguration = { index, title, cell in
            guard let cell = cell as? MyCell else{
                return
            }
            cell.myImageView.image = UIImage(systemName: icons[index])
        }
        return menu
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        addDropDownList()
        self.hideKeyboardWhenTapped()
    }
    
    func addDropDownList(){
        
        let Title = UILabel(frame: CGRect(x: screenWidth*0.05,
                                          y: screenHeight*0.05,
                                          width: screenWidth*0.9,
                                          height: screenHeight*0.05))
        Title.text = "Add Spending Goals"
        Title.textColor = .white
        Title.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        
        view.addSubview(Title)
        
        let menuLabel = UILabel(frame: CGRect(x: screenWidth*0.05,
                                              y: screenHeight*0.06+screenHeight*0.06,
                                              width: screenWidth*0.9,
                                              height: screenHeight*0.05))
        menuLabel.text = "Type of Event"
        menuLabel.textColor = .white
        menuLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        let menuButton = UIButton(frame: CGRect(x: screenWidth*0.05,
                                                  y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04,
                                                  width: screenWidth*0.9,
                                                  height: screenHeight*0.05))
        menuButton.setTitle("Click to Choose a Type of Event", for: .normal)
        menuButton.backgroundColor = .white
        menuButton.setTitleColor(.black, for: .normal)
        menuButton.addTarget(self, action: #selector(showMenu(_:)), for: .touchUpInside)
        menu.anchorView = menuButton
        
        menu.selectionAction = {index, item in
            menuButton.setTitle(item, for: .normal)
            if index == 0 {
                self.showCharityGiftForm()
            }else if index == 1 {
                self.showHealthCareForm()
            }else if index == 2 {
                self.showHomePurchaseForm()
            }else if index == 3 {
                self.showVacationForm()
            }else if index == 4 {
                self.showVehicleForm()
            }else if index == 5 {
                self.showOtherExpenseForm()
            }
        }
        
        view.addSubview(Title)
        view.addSubview(menuLabel)
        view.addSubview(menuButton)
    }
    
    func showCharityGiftForm(){
        self.HealthCareVC.view.removeFromSuperview()
        self.HomePurchaseVC.view.removeFromSuperview()
        self.VacationVC.view.removeFromSuperview()
        self.VehicleVC.view.removeFromSuperview()
        self.OtherExpenseVC.view.removeFromSuperview()
        
        addChild(CharityGiftVC)
        CharityGiftVC.view.frame = CGRect(x: screenWidth*0.05,
                                            y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                            width: screenWidth*0.9,
                                            height: screenHeight*0.65)
        view.addSubview(CharityGiftVC.view)
    }
    
    func showHealthCareForm(){
        self.CharityGiftVC.view.removeFromSuperview()
        self.HomePurchaseVC.view.removeFromSuperview()
        self.VacationVC.view.removeFromSuperview()
        self.VehicleVC.view.removeFromSuperview()
        self.OtherExpenseVC.view.removeFromSuperview()
        
        addChild(HealthCareVC)
        HealthCareVC.view.frame = CGRect(x: screenWidth*0.05,
                                            y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                            width: screenWidth*0.9,
                                            height: screenHeight*0.65)
        view.addSubview(HealthCareVC.view)
    }
    
    func showHomePurchaseForm(){
        self.HealthCareVC.view.removeFromSuperview()
        self.CharityGiftVC.view.removeFromSuperview()
        self.VacationVC.view.removeFromSuperview()
        self.VehicleVC.view.removeFromSuperview()
        self.OtherExpenseVC.view.removeFromSuperview()
        
        addChild(HomePurchaseVC)
        HomePurchaseVC.view.frame = CGRect(x: screenWidth*0.05,
                                            y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                            width: screenWidth*0.9,
                                            height: screenHeight*0.65)
        view.addSubview(HomePurchaseVC.view)
    }
    
    func showVacationForm(){
        self.HealthCareVC.view.removeFromSuperview()
        self.HomePurchaseVC.view.removeFromSuperview()
        self.CharityGiftVC.view.removeFromSuperview()
        self.VehicleVC.view.removeFromSuperview()
        self.OtherExpenseVC.view.removeFromSuperview()
        
        addChild(VacationVC)
        VacationVC.view.frame = CGRect(x: screenWidth*0.05,
                                            y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                            width: screenWidth*0.9,
                                            height: screenHeight*0.65)
        view.addSubview(VacationVC.view)
    }
    
    func showVehicleForm(){
        self.HealthCareVC.view.removeFromSuperview()
        self.HomePurchaseVC.view.removeFromSuperview()
        self.VacationVC.view.removeFromSuperview()
        self.CharityGiftVC.view.removeFromSuperview()
        self.OtherExpenseVC.view.removeFromSuperview()
        
        addChild(VehicleVC)
        VehicleVC.view.frame = CGRect(x: screenWidth*0.05,
                                            y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                            width: screenWidth*0.9,
                                            height: screenHeight*0.65)
        view.addSubview(VehicleVC.view)
    }
    
    func showOtherExpenseForm(){
        self.HealthCareVC.view.removeFromSuperview()
        self.HomePurchaseVC.view.removeFromSuperview()
        self.VacationVC.view.removeFromSuperview()
        self.VehicleVC.view.removeFromSuperview()
        self.CharityGiftVC.view.removeFromSuperview()
        
        addChild(OtherExpenseVC)
        OtherExpenseVC.view.frame = CGRect(x: screenWidth*0.05,
                                            y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                            width: screenWidth*0.9,
                                            height: screenHeight*0.65)
        view.addSubview(OtherExpenseVC.view)
    }
    
    @objc func showMenu(_ sender: UIButton){
        menu.show()
    }
    
}
