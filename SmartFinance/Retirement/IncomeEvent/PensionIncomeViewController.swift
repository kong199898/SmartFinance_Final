import UIKit
import DropDown
import CoreData
import MaterialComponents.MaterialButtons

class PensionIncomeViewController: UIViewController {

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var AgeSldierValue = UILabel()
    var AgeSlider = UISlider()
    var AmountPerYearField = UITextField()
    var frequency:String?
    var FrequencyField = UIButton()
    let defaults = UserDefaults()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var isEdit:Bool?
    var editItem:TheIncomeEvent?
    
    var currAge = 0
    var retireAge = 0
    var assumptAge = 0
    
    let frequencyMenu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
            "Once",
            "Every Month",
            "Every Year"
        ]
        return menu
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAge()
        showForm()
        showButton()
        self.hideKeyboardWhenTapped()
        
        isEdit = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(editPensionIncomeNotification), name: Notification.Name("editPensionIncome"), object: nil)
    }
    
    @objc func editPensionIncomeNotification(_ notification: Notification){
        isEdit = true
        editItem = notification.userInfo?["item"] as! TheIncomeEvent
        AmountPerYearField.text = String(notification.userInfo?["amount"] as! Int64)
        FrequencyField.setTitle(notification.userInfo?["frequency"] as! String, for: .normal)
        frequency = notification.userInfo?["frequency"] as! String
        AgeSlider.value =  Float(notification.userInfo?["startingage"] as! Int64)
        AgeSldierValue.text = "Age " + Int(AgeSlider.value).description + " for life"
    }
    
    func getAge(){
        do{
            let Fetch_Assumption = try context.fetch(TheAssumption.fetchRequest())
            for i in Fetch_Assumption as! [NSManagedObject]{
                currAge = (defaults.value(forKey: "UserAge")) as! Int
                retireAge = Int(i.value(forKey: "retirement") as! Int64)
                assumptAge = Int(i.value(forKey: "life") as! Int64)
            }
        }
        catch{
            showMessage(alert: "Error", message: "cannnot find age in Assumption")
        }
    }
    
    func showForm(){
        //AmountPerYear
        let AmountPerYearLabel = UILabel(frame: CGRect(x: 0,
                                                y: screenHeight*0.01,
                                                width: screenWidth*0.9,
                                                height: screenHeight*0.04))
        AmountPerYearLabel.text = "Amount"
        AmountPerYearLabel.textColor = .white
        AmountPerYearLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        AmountPerYearField = UITextField(frame: CGRect(x: 0,
                                                    y: screenHeight*0.01+screenHeight*0.04,
                                                    width: screenWidth*0.9,
                                                    height: screenHeight*0.05))
        AmountPerYearField.textColor = .black
        AmountPerYearField.backgroundColor = .white
        AmountPerYearField.placeholder = "$HKD"
        AmountPerYearField.keyboardType = UIKeyboardType.numberPad
        
        let FrequencyLabel = UILabel(frame: CGRect(x: 0,
                                                y: screenHeight*0.01+screenHeight*0.04+screenHeight*0.06,
                                                width: screenWidth*0.9,
                                                height: screenHeight*0.04))
        FrequencyLabel.text = "Frequency"
        FrequencyLabel.textColor = .white
        FrequencyLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        FrequencyField = UIButton(frame: CGRect(x: 0,
                                                    y: screenHeight*0.01+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04,
                                                    width: screenWidth*0.9,
                                                    height: screenHeight*0.05))
        FrequencyField.setTitle("Click to choose frequency", for: .normal)
        FrequencyField.contentHorizontalAlignment = .left
        FrequencyField.backgroundColor = .white
        FrequencyField.setTitleColor(.black, for: .normal)
        FrequencyField.addTarget(self, action: #selector(showFrequencyMenu(_:)), for: .touchUpInside)
        frequencyMenu.anchorView = FrequencyField
        frequencyMenu.selectionAction = {index, item in
            self.FrequencyField.setTitle(item, for: .normal)
            self.frequency = item
        }
        
        let WhenLabel = UILabel(frame: CGRect(x: 0,
                                                y: screenHeight*0.01+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                                width: screenWidth*0.9,
                                                height: screenHeight*0.04))
        WhenLabel.text = "When Will This Start?"
        WhenLabel.textColor = .white
        WhenLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        AgeSlider = UISlider(frame: CGRect(x: 0,
                                           y: screenHeight*0.01+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04+screenHeight*0.04,
                                           width: screenWidth*0.9,
                                           height: screenHeight*0.04))
        AgeSlider.backgroundColor = .black
        AgeSlider.maximumTrackTintColor = .lightGray
        AgeSlider.minimumTrackTintColor = .white
        AgeSlider.thumbTintColor = .white
        AgeSlider.minimumValue = Float(currAge)
        AgeSlider.maximumValue = Float(assumptAge)
        AgeSlider.value = Float(currAge)
        AgeSlider.isContinuous = true
        AgeSlider.addTarget(self, action: #selector(AgeSliderChange(_:)), for: .valueChanged)
        
        AgeSldierValue = UILabel(frame: CGRect(x: 0,
                                               y: screenHeight*0.01+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04,
                                               width: screenWidth*0.9,
                                               height: screenHeight*0.04))
        AgeSldierValue.text = "Age " + Int(AgeSlider.value).description + " for life"
        AgeSldierValue.textColor = .white
        AgeSldierValue.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        view.addSubview(AmountPerYearLabel)
        view.addSubview(AmountPerYearField)
        view.addSubview(FrequencyLabel)
        view.addSubview(FrequencyField)
        view.addSubview(WhenLabel)
        view.addSubview(AgeSldierValue)
        view.addSubview(AgeSlider)
    }
    
    func showButton(){
        let SubmitButton = MDCButton(frame: CGRect(x: 0,
                                                   y: screenHeight*0.4,
                                                   width: screenWidth*0.9,
                                                   height: screenHeight*0.05))
        SubmitButton.setTitle(" Submit", for: .normal)
        SubmitButton.backgroundColor = .white
        SubmitButton.setTitleColor(.black, for: .normal)
        SubmitButton.setImage(UIImage(systemName: "forward"), for: .normal)
        SubmitButton.setImageTintColor(.black, for: .normal)
        SubmitButton.addTarget(self, action: #selector(SubmitButtonTapped(_:)), for: .touchUpInside)
        
        let CancelButton = MDCButton(frame: CGRect(x: 0,
                                                   y: screenHeight*0.4+screenHeight*0.06,
                                                   width: screenWidth*0.9,
                                                   height: screenHeight*0.05))
        CancelButton.setTitle(" Cancel", for: .normal)
        CancelButton.backgroundColor = .white
        CancelButton.setTitleColor(.black, for: .normal)
        CancelButton.setImage(UIImage(systemName: "arrow.uturn.backward"), for: .normal)
        CancelButton.setImageTintColor(.black, for: .normal)
        CancelButton.addTarget(self, action: #selector(CancelButtonTapped(_:)), for: .touchUpInside)
        
        view.addSubview(SubmitButton)
        view.addSubview(CancelButton)
    }
    
    @objc func showFrequencyMenu(_ sender:UIButton){
        frequencyMenu.show()
    }
    
    @objc func SubmitButtonTapped(_ sender: UIButton){
        if validateInput(){
            if isEdit!{
                updateItem(item: editItem!, newamount: Int(AmountPerYearField.text!) ?? 0, newfrequency: frequency!, newStartingAge: Int(AgeSlider.value))
                dismiss(animated: true, completion: nil)
            }else{
                createItem(type: "Pension Income", amount: Int(AmountPerYearField.text!) ?? 0, frequency: frequency!, StartingAge: Int(AgeSlider.value))
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func CancelButtonTapped(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func AgeSliderChange(_ sender: UISlider){
        AgeSlider.value.round()
        AgeSldierValue.text = "Age " + Int(AgeSlider.value).description + " for life"
    }
    
    func validateInput() -> Bool{
        let set = CharacterSet(charactersIn: "0123456789")
        if AmountPerYearField.text == ""{
            showMessage(alert: "Invalid Amount", message: "Please input an amount.")
            return false
        }else if(AmountPerYearField.text?.rangeOfCharacter(from: set.inverted) != nil || Int(AmountPerYearField.text!) ?? 0 < 0){
            showMessage(alert: "Invalid Amount", message: "Only Positive Numbers are allowed.")
            return false
        }
        if frequency == nil {
            showMessage(alert: "Invalid Frequency", message: "Please choose a frequency.")
            return false
        }
        if defaults.value(forKey: "UserAge") as! Int == Int(AgeSlider.value){
            showMessage(alert: "Invalid Age", message: "Occurence of event cannot be the same as your current age.")
            return false
        }
        return true
    }
    
    func createItem(type:String, amount:Int, frequency:String, StartingAge:Int){
        let newitems = TheIncomeEvent(context: context)
        newitems.type = type
        newitems.amount = Int64(amount)
        newitems.frequency = frequency
        newitems.startingage = Int64(StartingAge)
        newitems.other = nil
        
        do{
            try context.save()
            NotificationCenter.default.post(name: Notification.Name("refreshIncomeEvent"), object: nil, userInfo: nil)
        }
        catch{
            showMessage(alert: "Error", message: "failed to create item")
        }
    }
    
    func updateItem(item: TheIncomeEvent, newamount:Int, newfrequency:String, newStartingAge:Int){
        item.amount = Int64(newamount)
        item.frequency = newfrequency
        item.startingage = Int64(newStartingAge)
        
        do{
            try context.save()
            NotificationCenter.default.post(name: Notification.Name("refreshIncomeEvent"), object: nil, userInfo: nil)
        }
        catch{
            showMessage(alert: "Error", message: "failed to update item")
        }
    }
}
