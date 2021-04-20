import UIKit
import DropDown

class AddIncomeEventViewController: UIViewController {

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    private lazy var AnnuityIncomeVC = AnnuityIncomeViewController()
    private lazy var PensionIncomeVC = PensionIncomeViewController()
    private lazy var RentalIncomeVC = RentalIncomeViewController()
    private lazy var OtherIncomeVC = OtherIncomeViewController()
    private lazy var SaleofPropertyDownsizeVC = SaleofPropertyDownsizeViewController()
    private lazy var WorkDuringRetirementVC = WorkDuringRetirementViewController()
    
    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
            "Annuity Income",
            "Pension Income",
            "Rental Income",
            "Sale of Property/Downsize",
            "Work During Retirement",
            "Other Income"
        ]
        let icons = [
            "dollarsign.circle",
            "mustache",
            "building.2",
            "building.2.crop.circle",
            "figure.stand.line.dotted.figure.stand",
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
        Title.text = "Add Income Event"
        Title.textColor = .white
        Title.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        
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
                self.showAnnuityIncomeForm()
            }else if index == 1 {
                self.showPensionIncomeForm()
            }else if index == 2 {
                self.showRentalIncomeForm()
            }else if index == 3 {
                self.showSalePropertyDownsizeForm()
            }else if index == 4 {
                self.showWorkDuringRetirementForm()
            }else if index == 5 {
                self.showOtherIncomeForm()
            }
        }
        
        view.addSubview(Title)
        view.addSubview(menuLabel)
        view.addSubview(menuButton)
    }
    
    func showAnnuityIncomeForm(){
        self.PensionIncomeVC.view.removeFromSuperview()
        self.RentalIncomeVC.view.removeFromSuperview()
        self.OtherIncomeVC.view.removeFromSuperview()
        self.SaleofPropertyDownsizeVC.view.removeFromSuperview()
        self.WorkDuringRetirementVC.view.removeFromSuperview()
        
        addChild(AnnuityIncomeVC)
        AnnuityIncomeVC.view.frame = CGRect(x: screenWidth*0.05,
                                            y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                            width: screenWidth*0.9,
                                            height: screenHeight*0.65)
        view.addSubview(AnnuityIncomeVC.view)
    }
    
    func showPensionIncomeForm(){
        self.AnnuityIncomeVC.view.removeFromSuperview()
        self.RentalIncomeVC.view.removeFromSuperview()
        self.OtherIncomeVC.view.removeFromSuperview()
        self.SaleofPropertyDownsizeVC.view.removeFromSuperview()
        self.WorkDuringRetirementVC.view.removeFromSuperview()
        
        addChild(PensionIncomeVC)
        PensionIncomeVC.view.frame = CGRect(x: screenWidth*0.05,
                                            y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                            width: screenWidth*0.9,
                                            height: screenHeight*0.65)
        view.addSubview(PensionIncomeVC.view)
    }
    
    func showRentalIncomeForm(){
        self.PensionIncomeVC.view.removeFromSuperview()
        self.AnnuityIncomeVC.view.removeFromSuperview()
        self.OtherIncomeVC.view.removeFromSuperview()
        self.SaleofPropertyDownsizeVC.view.removeFromSuperview()
        self.WorkDuringRetirementVC.view.removeFromSuperview()
        
        addChild(RentalIncomeVC)
        RentalIncomeVC.view.frame = CGRect(x: screenWidth*0.05,
                                            y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                            width: screenWidth*0.9,
                                            height: screenHeight*0.65)
        view.addSubview(RentalIncomeVC.view)
    }
    
    func showOtherIncomeForm(){
        self.PensionIncomeVC.view.removeFromSuperview()
        self.RentalIncomeVC.view.removeFromSuperview()
        self.AnnuityIncomeVC.view.removeFromSuperview()
        self.SaleofPropertyDownsizeVC.view.removeFromSuperview()
        self.WorkDuringRetirementVC.view.removeFromSuperview()
        
        addChild(OtherIncomeVC)
        OtherIncomeVC.view.frame = CGRect(x: screenWidth*0.05,
                                            y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                            width: screenWidth*0.9,
                                            height: screenHeight*0.65)
        view.addSubview(OtherIncomeVC.view)
    }
    
    func showSalePropertyDownsizeForm(){
        self.PensionIncomeVC.view.removeFromSuperview()
        self.RentalIncomeVC.view.removeFromSuperview()
        self.AnnuityIncomeVC.view.removeFromSuperview()
        self.OtherIncomeVC.view.removeFromSuperview()
        self.WorkDuringRetirementVC.view.removeFromSuperview()
        
        addChild(SaleofPropertyDownsizeVC)
        SaleofPropertyDownsizeVC.view.frame = CGRect(x: screenWidth*0.05,
                                            y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                            width: screenWidth*0.9,
                                            height: screenHeight*0.65)
        view.addSubview(SaleofPropertyDownsizeVC.view)
    }
    
    func showWorkDuringRetirementForm(){
        self.PensionIncomeVC.view.removeFromSuperview()
        self.RentalIncomeVC.view.removeFromSuperview()
        self.AnnuityIncomeVC.view.removeFromSuperview()
        self.SaleofPropertyDownsizeVC.view.removeFromSuperview()
        self.OtherIncomeVC.view.removeFromSuperview()
        
        addChild(WorkDuringRetirementVC)
        WorkDuringRetirementVC.view.frame = CGRect(x: screenWidth*0.05,
                                            y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                            width: screenWidth*0.9,
                                            height: screenHeight*0.65)
        view.addSubview(WorkDuringRetirementVC.view)
    }
    
    @objc func showMenu(_ sender: UIButton){
        menu.show()
    }
    
}
