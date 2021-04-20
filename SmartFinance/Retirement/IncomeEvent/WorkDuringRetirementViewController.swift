import UIKit
import CoreData
import MaterialComponents.MaterialButtons

class WorkDuringRetirementViewController: UIViewController {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var AgeSldierValue = UILabel()
    var AgeSlider = UISlider()
    var YearOfWorkSldierValue = UILabel()
    var YearOfWorkSlider = UISlider()
    var AmountPerYearField = UITextField()
    let defaults = UserDefaults()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var isEdit:Bool?
    var editItem:TheIncomeEvent?
    
    var currAge = 0
    var retireAge = 0
    var assumptAge = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAge()
        showForm()
        showButton()
        
        isEdit = false
        self.hideKeyboardWhenTapped()
        
        NotificationCenter.default.addObserver(self, selector: #selector(editWorkIncomeNotification), name: Notification.Name("editWorkIncome"), object: nil)
    }
    
    @objc func editWorkIncomeNotification(_ notification: Notification){
        isEdit = true
        editItem = notification.userInfo?["item"] as! TheIncomeEvent
        AmountPerYearField.text = String(notification.userInfo?["amount"] as! Int64)
        AgeSlider.value =  Float(notification.userInfo?["startingage"] as! Int64)
        AgeSldierValue.text = "Age " + Int(AgeSlider.value).description + " for life"
        YearOfWorkSlider.value = Float(notification.userInfo?["other"] as! String)!
        YearOfWorkSldierValue.text = Int(YearOfWorkSlider.value).description + " Year(s)"
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
        
        let WhenLabel = UILabel(frame: CGRect(x: 0,
                                              y: screenHeight*0.01+screenHeight*0.04+screenHeight*0.06,
                                              width: screenWidth*0.9,
                                              height: screenHeight*0.04))
        WhenLabel.text = "When Will This Start?"
        WhenLabel.textColor = .white
        WhenLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        AgeSlider = UISlider(frame: CGRect(x: 0,
                                           y: screenHeight*0.01+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04+screenHeight*0.04,
                                           width: screenWidth*0.9,
                                           height: screenHeight*0.04))
        AgeSlider.backgroundColor = .black
        AgeSlider.maximumTrackTintColor = .lightGray
        AgeSlider.minimumTrackTintColor = .white
        AgeSlider.thumbTintColor = .white
        AgeSlider.minimumValue = Float(retireAge)
        AgeSlider.maximumValue = Float(assumptAge)
        AgeSlider.value = Float(retireAge)
        AgeSlider.isContinuous = true
        AgeSlider.addTarget(self, action: #selector(AgeSliderChange(_:)), for: .valueChanged)
        
        AgeSldierValue = UILabel(frame: CGRect(x: 0,
                                               y: screenHeight*0.01+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04,
                                               width: screenWidth*0.9,
                                               height: screenHeight*0.04))
        AgeSldierValue.text = "Age " + Int(AgeSlider.value).description
        AgeSldierValue.textColor = .white
        AgeSldierValue.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        let DurationLabel = UILabel(frame: CGRect(x: 0,
                                                y: screenHeight*0.01+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04+screenHeight*0.04+screenHeight*0.06,
                                                width: screenWidth*0.9,
                                                height: screenHeight*0.04))
        DurationLabel.text = "Duration of Work"
        DurationLabel.textColor = .white
        DurationLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        YearOfWorkSlider = UISlider(frame: CGRect(x: 0,
                                           y: screenHeight*0.01+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04+screenHeight*0.04,
                                           width: screenWidth*0.9,
                                           height: screenHeight*0.04))
        YearOfWorkSlider.backgroundColor = .black
        YearOfWorkSlider.maximumTrackTintColor = .lightGray
        YearOfWorkSlider.minimumTrackTintColor = .white
        YearOfWorkSlider.thumbTintColor = .white
        YearOfWorkSlider.minimumValue = 1
        YearOfWorkSlider.maximumValue = Float(assumptAge - retireAge)
        YearOfWorkSlider.value = 1
        YearOfWorkSlider.isContinuous = true
        YearOfWorkSlider.addTarget(self, action: #selector(YearOfWorkSliderChange(_:)), for: .valueChanged)
        
        YearOfWorkSldierValue = UILabel(frame: CGRect(x: 0,
                                               y: screenHeight*0.01+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04,
                                               width: screenWidth*0.9,
                                               height: screenHeight*0.04))
        YearOfWorkSldierValue.text = Int(YearOfWorkSlider.value).description + " Year(s)"
        YearOfWorkSldierValue.textColor = .white
        YearOfWorkSldierValue.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        view.addSubview(AmountPerYearLabel)
        view.addSubview(AmountPerYearField)
        view.addSubview(WhenLabel)
        view.addSubview(AgeSldierValue)
        view.addSubview(AgeSlider)
        view.addSubview(DurationLabel)
        view.addSubview(YearOfWorkSldierValue)
        view.addSubview(YearOfWorkSlider)
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
    
    func validateInput() -> Bool{
        let set = CharacterSet(charactersIn: "0123456789")
        if AmountPerYearField.text == ""{
            showMessage(alert: "Invalid Amount", message: "Please input an amount.")
            return false
        }else if(AmountPerYearField.text?.rangeOfCharacter(from: set.inverted) != nil || Int(AmountPerYearField.text!) ?? 0 < 0){
            showMessage(alert: "Invalid Amount", message: "Only Positive Numbers are allowed.")
            return false
        }
        if Int(AgeSlider.value) + Int(YearOfWorkSlider.value) > assumptAge {
            showMessage(alert: "Invalid Duration of Work", message: "Duration of Work is greater than your life expectancy(\(assumptAge)).")
            return false
        }
        return true
    }
    
    @objc func SubmitButtonTapped(_ sender: UIButton){
        if validateInput(){
            if isEdit!{
                updateItem(item: editItem!, newamount: Int(AmountPerYearField.text!) ?? 0, newStartingAge: Int(AgeSlider.value), newother: String(Int(YearOfWorkSlider.value)))
                dismiss(animated: true, completion: nil)
            }else{
                createItem(type: "Work During Retirement", amount: Int(AmountPerYearField.text!) ?? 0, StartingAge: Int(AgeSlider.value), other: String(Int(YearOfWorkSlider.value)))
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @objc func CancelButtonTapped(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func AgeSliderChange(_ sender: UISlider){
        AgeSlider.value.round()
        AgeSldierValue.text = "Age " + Int(AgeSlider.value).description
    }
        
    @objc func YearOfWorkSliderChange(_ sender: UISlider){
        YearOfWorkSlider.value.round()
        YearOfWorkSldierValue.text = Int(YearOfWorkSlider.value).description + " Year(s)"
    }
    
    func createItem(type:String, amount:Int, StartingAge:Int, other:String){
        let newitems = TheIncomeEvent(context: context)
        newitems.type = type
        newitems.amount = Int64(amount)
        newitems.frequency = nil
        newitems.startingage = Int64(StartingAge)
        newitems.other = other
        
        do{
            try context.save()
            NotificationCenter.default.post(name: Notification.Name("refreshIncomeEvent"), object: nil, userInfo: nil)
        }
        catch{
            showMessage(alert: "Error", message: "failed to create item")
        }
    }
    
    func updateItem(item: TheIncomeEvent, newamount:Int, newStartingAge:Int, newother:String){
        item.amount = Int64(newamount)
        item.startingage = Int64(newStartingAge)
        item.other = newother
        
        do{
            try context.save()
            NotificationCenter.default.post(name: Notification.Name("refreshIncomeEvent"), object: nil, userInfo: nil)
        }
        catch{
            showMessage(alert: "Error", message: "failed to update item")
        }
    }
}
