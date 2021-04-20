import UIKit

class EditSpendingGoalViewController: UIViewController {

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    private lazy var CharityGiftVC = CharityGiftViewController()
    private lazy var HealthCareVC = HealthCareViewController()
    private lazy var HomePurchaseVC = HomePurchaseViewController()
    private lazy var VacationVC = VacationViewController()
    private lazy var VehicleVC = VehicleViewController()
    private lazy var OtherExpenseVC = OtherExpenseViewController()
    
    var menuButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        addLabel()
        self.hideKeyboardWhenTapped()
        
        NotificationCenter.default.addObserver(self, selector: #selector(editspendingGoalNotification), name: Notification.Name("editSpendingGoal"), object: nil)
    }
    
    @objc func editspendingGoalNotification(_ notification: Notification){
        let type = notification.userInfo?["type"] as! String
        
        menuButton.setTitle(type, for: .normal)
        
        if type == "Charity/Gift" {
            addChild(CharityGiftVC)
            CharityGiftVC.view.frame = CGRect(x: screenWidth*0.05,
                                                y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                                width: screenWidth*0.9,
                                                height: screenHeight*0.65)
            view.addSubview(CharityGiftVC.view)
            NotificationCenter.default.post(name: Notification.Name("editCharity"), object: nil, userInfo:["item":notification.userInfo?["item"],
                                                                                                               "type":notification.userInfo?["type"],
                                                                                                               "amount":notification.userInfo?["amount"],
                                                                                                               "frequency":notification.userInfo?["frequency"],
                                                                                                               "startingage":notification.userInfo?["startingage"],
                                                                                                               "other":notification.userInfo?["other"]])
        }else if type == "Health Care" {
            addChild(HealthCareVC)
            HealthCareVC.view.frame = CGRect(x: screenWidth*0.05,
                                                y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                                width: screenWidth*0.9,
                                                height: screenHeight*0.65)
            view.addSubview(HealthCareVC.view)
            NotificationCenter.default.post(name: Notification.Name("editHealthCare"), object: nil, userInfo:["item":notification.userInfo?["item"],
                                                                                                               "type":notification.userInfo?["type"],
                                                                                                               "amount":notification.userInfo?["amount"],
                                                                                                               "frequency":notification.userInfo?["frequency"],
                                                                                                               "startingage":notification.userInfo?["startingage"],
                                                                                                               "other":notification.userInfo?["other"]])
        }else if type == "Home Purchase/Upgrade" {
            addChild(HomePurchaseVC)
            HomePurchaseVC.view.frame = CGRect(x: screenWidth*0.05,
                                                y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                                width: screenWidth*0.9,
                                                height: screenHeight*0.65)
            view.addSubview(HomePurchaseVC.view)
            NotificationCenter.default.post(name: Notification.Name("editHomePurchase"), object: nil, userInfo:["item":notification.userInfo?["item"],
                                                                                                               "type":notification.userInfo?["type"],
                                                                                                               "amount":notification.userInfo?["amount"],
                                                                                                               "frequency":notification.userInfo?["frequency"],
                                                                                                               "startingage":notification.userInfo?["startingage"],
                                                                                                               "other":notification.userInfo?["other"]])
        }else if type == "Vacation" {
            addChild(VacationVC)
            VacationVC.view.frame = CGRect(x: screenWidth*0.05,
                                                y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                                width: screenWidth*0.9,
                                                height: screenHeight*0.65)
            view.addSubview(VacationVC.view)
            NotificationCenter.default.post(name: Notification.Name("editVacation"), object: nil, userInfo:["item":notification.userInfo?["item"],
                                                                                                               "type":notification.userInfo?["type"],
                                                                                                               "amount":notification.userInfo?["amount"],
                                                                                                               "frequency":notification.userInfo?["frequency"],
                                                                                                               "startingage":notification.userInfo?["startingage"],
                                                                                                               "other":notification.userInfo?["other"]])
        }else if type == "Vehicle" {
            addChild(VehicleVC)
            VehicleVC.view.frame = CGRect(x: screenWidth*0.05,
                                                y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                                width: screenWidth*0.9,
                                                height: screenHeight*0.65)
            view.addSubview(VehicleVC.view)
            NotificationCenter.default.post(name: Notification.Name("editVehicle"), object: nil, userInfo:["item":notification.userInfo?["item"],
                                                                                                               "type":notification.userInfo?["type"],
                                                                                                               "amount":notification.userInfo?["amount"],
                                                                                                               "frequency":notification.userInfo?["frequency"],
                                                                                                               "startingage":notification.userInfo?["startingage"],
                                                                                                               "other":notification.userInfo?["other"]])
        }else if type == "Other Expense" {
            addChild(OtherExpenseVC)
            OtherExpenseVC.view.frame = CGRect(x: screenWidth*0.05,
                                                y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                                width: screenWidth*0.9,
                                                height: screenHeight*0.65)
            view.addSubview(OtherExpenseVC.view)
            NotificationCenter.default.post(name: Notification.Name("editOtherExpense"), object: nil, userInfo:["item":notification.userInfo?["item"],
                                                                                                               "type":notification.userInfo?["type"],
                                                                                                               "amount":notification.userInfo?["amount"],
                                                                                                               "frequency":notification.userInfo?["frequency"],
                                                                                                               "startingage":notification.userInfo?["startingage"],
                                                                                                               "other":notification.userInfo?["other"]])
        }else {
            print("do not have this model \(type)")
        }
    }
    
    func addLabel(){
        let Title = UILabel(frame: CGRect(x: screenWidth*0.05,
                                          y: screenHeight*0.05,
                                          width: screenWidth*0.9,
                                          height: screenHeight*0.05))
        Title.text = "Edit Spending Goals"
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
        
        menuButton = UIButton(frame: CGRect(x: screenWidth*0.05,
                                                  y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04,
                                                  width: screenWidth*0.9,
                                                  height: screenHeight*0.05))
        menuButton.setTitle("Click to Choose a Type of Event", for: .normal)
        menuButton.backgroundColor = .white
        menuButton.setTitleColor(.black, for: .normal)
        
        view.addSubview(Title)
        view.addSubview(menuLabel)
        view.addSubview(menuButton)
    }
}
