import UIKit

class EditIncomeEventViewController: UIViewController {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    private lazy var AnnuityIncomeVC = AnnuityIncomeViewController()
    private lazy var PensionIncomeVC = PensionIncomeViewController()
    private lazy var RentalIncomeVC = RentalIncomeViewController()
    private lazy var OtherIncomeVC = OtherIncomeViewController()
    private lazy var SaleofPropertyDownsizeVC = SaleofPropertyDownsizeViewController()
    private lazy var WorkDuringRetirementVC = WorkDuringRetirementViewController()
    
    var  menuButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        addLabel()
        self.hideKeyboardWhenTapped()
        
        NotificationCenter.default.addObserver(self, selector: #selector(editIncomeEventNotification), name: Notification.Name("editIncomeEvent"), object: nil)
    }
    
    func addLabel(){
        let Title = UILabel(frame: CGRect(x: screenWidth*0.05,
                                          y: screenHeight*0.05,
                                          width: screenWidth*0.9,
                                          height: screenHeight*0.05))
        Title.text = "Edit Income Event"
        Title.textColor = .white
        Title.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        
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
        menuButton.backgroundColor = .white
        menuButton.setTitleColor(.black, for: .normal)
        
        view.addSubview(Title)
        view.addSubview(menuLabel)
        view.addSubview(menuButton)
    }
    
    @objc func editIncomeEventNotification(_ notification: Notification){
        let type = notification.userInfo?["type"] as! String
        
        menuButton.setTitle(type, for: .normal)
        
        if type == "Annuity Income" {
            addChild(AnnuityIncomeVC)
            AnnuityIncomeVC.view.frame = CGRect(x: screenWidth*0.05,
                                                y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                                width: screenWidth*0.9,
                                                height: screenHeight*0.65)
            view.addSubview(AnnuityIncomeVC.view)
            NotificationCenter.default.post(name: Notification.Name("editAnnuityIncome"), object: nil, userInfo:["item":notification.userInfo?["item"],
                                                                                                               "type":notification.userInfo?["type"],
                                                                                                               "amount":notification.userInfo?["amount"],
                                                                                                               "frequency":notification.userInfo?["frequency"],
                                                                                                               "startingage":notification.userInfo?["startingage"],
                                                                                                               "other":notification.userInfo?["other"]])
        }else if type == "Sale of Property/Downsize" {
            addChild(SaleofPropertyDownsizeVC)
            SaleofPropertyDownsizeVC.view.frame = CGRect(x: screenWidth*0.05,
                                                y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                                width: screenWidth*0.9,
                                                height: screenHeight*0.65)
            view.addSubview(SaleofPropertyDownsizeVC.view)
            NotificationCenter.default.post(name: Notification.Name("editPropertyIncome"), object: nil, userInfo:["item":notification.userInfo?["item"],
                                                                                                               "type":notification.userInfo?["type"],
                                                                                                               "amount":notification.userInfo?["amount"],
                                                                                                               "frequency":notification.userInfo?["frequency"],
                                                                                                               "startingage":notification.userInfo?["startingage"],
                                                                                                               "other":notification.userInfo?["other"]])
        }else if type == "Work During Retirement" {
            addChild(WorkDuringRetirementVC)
            WorkDuringRetirementVC.view.frame = CGRect(x: screenWidth*0.05,
                                                y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                                width: screenWidth*0.9,
                                                height: screenHeight*0.65)
            view.addSubview(WorkDuringRetirementVC.view)
            NotificationCenter.default.post(name: Notification.Name("editWorkIncome"), object: nil, userInfo:["item":notification.userInfo?["item"],
                                                                                                               "type":notification.userInfo?["type"],
                                                                                                               "amount":notification.userInfo?["amount"],
                                                                                                               "frequency":notification.userInfo?["frequency"],
                                                                                                               "startingage":notification.userInfo?["startingage"],
                                                                                                               "other":notification.userInfo?["other"]])
        }else if type == "Other Income" {
            addChild(OtherIncomeVC)
            OtherIncomeVC.view.frame = CGRect(x: screenWidth*0.05,
                                                y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                                width: screenWidth*0.9,
                                                height: screenHeight*0.65)
            view.addSubview(OtherIncomeVC.view)
            NotificationCenter.default.post(name: Notification.Name("editOtherIncome"), object: nil, userInfo:["item":notification.userInfo?["item"],
                                                                                                               "type":notification.userInfo?["type"],
                                                                                                               "amount":notification.userInfo?["amount"],
                                                                                                               "frequency":notification.userInfo?["frequency"],
                                                                                                               "startingage":notification.userInfo?["startingage"],
                                                                                                               "other":notification.userInfo?["other"]])
        }else if type == "Pension Income" {
            addChild(PensionIncomeVC)
            PensionIncomeVC.view.frame = CGRect(x: screenWidth*0.05,
                                                y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                                width: screenWidth*0.9,
                                                height: screenHeight*0.65)
            view.addSubview(PensionIncomeVC.view)
            NotificationCenter.default.post(name: Notification.Name("editPensionIncome"), object: nil, userInfo:["item":notification.userInfo?["item"],
                                                                                                               "type":notification.userInfo?["type"],
                                                                                                               "amount":notification.userInfo?["amount"],
                                                                                                               "frequency":notification.userInfo?["frequency"],
                                                                                                               "startingage":notification.userInfo?["startingage"],
                                                                                                               "other":notification.userInfo?["other"]])
        }else if type == "Rental Income" {
            addChild(RentalIncomeVC)
            RentalIncomeVC.view.frame = CGRect(x: screenWidth*0.05,
                                                y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                                width: screenWidth*0.9,
                                                height: screenHeight*0.65)
            view.addSubview(RentalIncomeVC.view)
            NotificationCenter.default.post(name: Notification.Name("editRentalIncome"), object: nil, userInfo:["item":notification.userInfo?["item"],
                                                                                                               "type":notification.userInfo?["type"],
                                                                                                               "amount":notification.userInfo?["amount"],
                                                                                                               "frequency":notification.userInfo?["frequency"],
                                                                                                               "startingage":notification.userInfo?["startingage"],
                                                                                                               "other":notification.userInfo?["other"]])
        }else {
            print("do not have this model \(type)")
        }
    }
}
