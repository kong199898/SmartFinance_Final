import UIKit
import CoreData
import MaterialComponents.MaterialButtons

class VehicleViewController: UIViewController {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var AgeSldierValue = UILabel()
    var AgeSlider = UISlider()
    var DownPaymentField = UITextField()
    let defaults = UserDefaults()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var isEdit:Bool?
    var editItem:TheSpendingGoal?
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(editVehicleNotification), name: Notification.Name("editVehicle"), object: nil)
    }
    
    @objc func editVehicleNotification(_ notification: Notification){
        isEdit = true
        editItem = notification.userInfo?["item"] as! TheSpendingGoal
        DownPaymentField.text = String(notification.userInfo?["amount"] as! Int64)
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
        //DownPayment
        let DownPaymentLabel = UILabel(frame: CGRect(x: 0,
                                                y: screenHeight*0.01,
                                                width: screenWidth*0.9,
                                                height: screenHeight*0.04))
        DownPaymentLabel.text = "Down Payment"
        DownPaymentLabel.textColor = .white
        DownPaymentLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        DownPaymentField = UITextField(frame: CGRect(x: 0,
                                                    y: screenHeight*0.01+screenHeight*0.04,
                                                    width: screenWidth*0.9,
                                                    height: screenHeight*0.05))
        DownPaymentField.textColor = .black
        DownPaymentField.backgroundColor = .white
        DownPaymentField.placeholder = "$HKD"
        DownPaymentField.keyboardType = UIKeyboardType.numberPad
        
        let WhenLabel = UILabel(frame: CGRect(x: 0,
                                                y: screenHeight*0.01+screenHeight*0.04+screenHeight*0.06,
                                                width: screenWidth*0.9,
                                                height: screenHeight*0.04))
        WhenLabel.text = "When Will This Happen?"
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
        AgeSlider.minimumValue = Float(currAge)
        AgeSlider.maximumValue = Float(assumptAge)
        AgeSlider.value = Float(currAge)
        AgeSlider.isContinuous = true
        AgeSlider.addTarget(self, action: #selector(AgeSliderChange(_:)), for: .valueChanged)
        
        AgeSldierValue = UILabel(frame: CGRect(x: 0,
                                               y: screenHeight*0.01+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04,
                                               width: screenWidth*0.9,
                                               height: screenHeight*0.04))
        AgeSldierValue.text = "Age " + Int(AgeSlider.value).description
        AgeSldierValue.textColor = .white
        AgeSldierValue.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        view.addSubview(DownPaymentLabel)
        view.addSubview(DownPaymentField)
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
    
    func validateInput() -> Bool{
        let set = CharacterSet(charactersIn: "0123456789")
        if DownPaymentField.text == ""{
            showMessage(alert: "Invalid Amount", message: "Please input an amount.")
            return false
        }else if(DownPaymentField.text?.rangeOfCharacter(from: set.inverted) != nil || Int(DownPaymentField.text!) ?? 0 < 0){
            showMessage(alert: "Invalid Amount", message: "Only Positive Numbers are allowed.")
            return false
        }
        if defaults.value(forKey: "UserAge") as! Int == Int(AgeSlider.value){
            showMessage(alert: "Invalid Age", message: "Occurence of event cannot be the same as your current age.")
            return false
        }
        return true
    }
    
    @objc func SubmitButtonTapped(_ sender: UIButton){
        if validateInput(){
            if isEdit!{
                updateItem(item: editItem!, newamount: Int(DownPaymentField.text!) ?? 0, newStartingAge: Int(AgeSlider.value))
                dismiss(animated: true, completion: nil)
            }else{
                createItem(type: "Vehicle", amount: Int(DownPaymentField.text!) ?? 0, StartingAge: Int(AgeSlider.value))
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
    
    func createItem(type:String, amount:Int, StartingAge:Int){
        let newitems = TheSpendingGoal(context: context)
        newitems.type = type
        newitems.amount = Int64(amount)
        newitems.frequency = nil
        newitems.startingage = Int64(StartingAge)
        newitems.other = nil
        
        do{
            try context.save()
            NotificationCenter.default.post(name: Notification.Name("refreshSpendingGoal"), object: nil, userInfo: nil)
        }
        catch{
            showMessage(alert: "Error", message: "failed to create item")
        }
    }
    
    func updateItem(item: TheSpendingGoal, newamount:Int, newStartingAge:Int){
        item.amount = Int64(newamount)
        item.startingage = Int64(newStartingAge)
        
        do{
            try context.save()
            NotificationCenter.default.post(name: Notification.Name("refreshSpendingGoal"), object: nil, userInfo: nil)
        }
        catch{
            showMessage(alert: "Error", message: "failed to update item")
        }
    }
}
