import UIKit
import MaterialComponents.MaterialButtons

class EditProfileFormViewController: UIViewController {

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var editItem: TheProfile!
    let defaults = UserDefaults()
    let datePicker = UIDatePicker()
    var NameField = UITextField()
    var BirthDateField = UITextField()
    var SalaryField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        addForm()
        addButton()
        createDatePicker()
        self.hideKeyboardWhenTapped()
        
        NotificationCenter.default.addObserver(self, selector: #selector(editProfileNotification), name: Notification.Name("editProfile"), object: nil)
        
    }
    
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        BirthDateField.inputAccessoryView = toolbar
        BirthDateField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = formatter.date(from: "1900-01-01")
        datePicker.maximumDate = Date()
        datePicker.setDate(Date(), animated: false)
    }
    
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        
        BirthDateField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func addForm(){
        
        let Title = UILabel(frame: CGRect(x: screenWidth*0.05,
                                          y: screenHeight*0.05,
                                          width: screenWidth*0.9,
                                          height: screenHeight*0.05))
        Title.text = "Edit Profile"
        Title.textColor = .white
        Title.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        
        //name
        let NameLabel = UILabel(frame: CGRect(x: screenWidth*0.05,
                                              y: screenHeight*0.06+screenHeight*0.06,
                                              width: screenWidth*0.9,
                                              height: screenHeight*0.05))
        NameLabel.text = "Full Name"
        NameLabel.textColor = .white
        NameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        NameField = UITextField(frame: CGRect(x: screenWidth*0.05,
                                                  y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04,
                                                  width: screenWidth*0.9,
                                                  height: screenHeight*0.05))
        NameField.textColor = .black
        NameField.backgroundColor = .white
        
        //birthday
        let BirthDateLabel  = UILabel(frame: CGRect(x: screenWidth*0.05,
                                                    y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                                    width: screenWidth*0.9,
                                                    height: screenHeight*0.05))
        BirthDateLabel.text = "Birth Date"
        BirthDateLabel.textColor = .white
        BirthDateLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        BirthDateField = UITextField(frame: CGRect(x: screenWidth*0.05,
                                                       y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04,
                                                       width: screenWidth*0.9,
                                                       height: screenHeight*0.05))
        BirthDateField.textColor = .black
        BirthDateField.backgroundColor = .white
 
        //salary
        let SalaryLabel = UILabel(frame: CGRect(x: screenWidth*0.05,
                                                y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06,
                                                width: screenWidth*0.9,
                                                height: screenHeight*0.05))
        SalaryLabel.text = "Salary of a Year"
        SalaryLabel.textColor = .white
        SalaryLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        SalaryField = UITextField(frame: CGRect(x: screenWidth*0.05,
                                                    y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04,
                                                    width: screenWidth*0.9,
                                                    height: screenHeight*0.05))
        SalaryField.textColor = .black
        SalaryField.backgroundColor = .white
        SalaryField.keyboardType = UIKeyboardType.numberPad

        view.addSubview(Title)
        view.addSubview(NameLabel)
        view.addSubview(NameField)
        view.addSubview(BirthDateLabel)
        view.addSubview(BirthDateField)
        view.addSubview(SalaryLabel)
        view.addSubview(SalaryField)
    }
    
    func addButton(){
        
        let SubmitButton = MDCButton(frame: CGRect(x: screenWidth*0.05,
                                                   y: screenHeight*0.7,
                                                   width: screenWidth*0.9,
                                                   height: screenHeight*0.05))
        SubmitButton.setTitle(" Submit", for: .normal)
        SubmitButton.backgroundColor = .white
        SubmitButton.setTitleColor(.black, for: .normal)
        SubmitButton.setImage(UIImage(systemName: "forward"), for: .normal)
        SubmitButton.setImageTintColor(.black, for: .normal)
        SubmitButton.addTarget(self, action: #selector(SubmitButtonTapped(_:)), for: .touchUpInside)
        
        let CancelButton = MDCButton(frame: CGRect(x: screenWidth*0.05,
                                                   y: screenHeight*0.7+screenHeight*0.06,
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
    
    @objc func SubmitButtonTapped(_ sender: UIButton){
        if NameField.text != "" && BirthDateField.text != "" && SalaryField.text != ""{
            if checkName() && checkBirthdate() && checkSalary(){
                updateItem(item:editItem, newName: NameField.text!, newBirth: datePicker.date, newEarn: Int64(SalaryField.text!) ?? 0)
                dismiss(animated: true, completion: nil)
            }
        }else{
            showMessage(alert: "Missing Information", message: "Please fill in empty textfield.")
        }
    }
    
    @objc func CancelButtonTapped(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    func calculateAge(userBirth:Date){
        let today = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year,.month,.day], from: userBirth, to:today)
        
        let ageYears = components.year
        defaults.setValue(ageYears, forKey: "UserAge")
    }
    
    func checkName() -> Bool{
        let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ ")
        if(NameField.text?.rangeOfCharacter(from: set.inverted) != nil && NameField.text != ""){
            showMessage(alert: "Invalid Name", message: "Only Alphabets and whitespaces are allowed.")
            return false
           }
        return true
    }
    
    func checkBirthdate() -> Bool{
        let today = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year,.month,.day], from: datePicker.date, to:today)
        let ageYears = components.year
        
        if ageYears ?? 0 < 19 && BirthDateField.text != "" {
            showMessage(alert: "Invalid Birth date", message: "Your age should be no less than 18.")
            return false
        }
        return true
    }
    
    func checkSalary() -> Bool{
        let set = CharacterSet(charactersIn: "0123456789")
        if SalaryField.text != ""{
            if(SalaryField.text?.rangeOfCharacter(from: set.inverted) != nil){
                showMessage(alert: "Invalid Salary", message: "Only Numbers are allowed.")
                return false
               }
            else if Int(SalaryField.text!) ?? 0 <= 8000{
                showMessage(alert: "Invalid Salary", message: "Your salary of a year should be no less than 8000.")
                return false
            }
        }
        return true
    }
    
    @objc func editProfileNotification(_ notification: Notification){
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ja_JP")
        
        editItem = notification.userInfo?["item"] as! TheProfile
        
        NameField.text = notification.userInfo?["name"] as? String
        BirthDateField.text = formatter.string(from: notification.userInfo?["birth"] as! Date)
        datePicker.date = notification.userInfo?["birth"] as! Date
        SalaryField.text = String(notification.userInfo?["earn"] as! Int64)
    }
    
    func updateItem(item: TheProfile, newName:String, newBirth:Date, newEarn:Int64){
        item.name = newName
        item.birthdate = newBirth
        item.earning = newEarn
        calculateAge(userBirth: newBirth)
        
        do{
            try context.save()
            NotificationCenter.default.post(name: Notification.Name("refreshProfile"), object: nil, userInfo: nil)
        }
        catch{
            showMessage(alert: "Error", message: "failed to update item")
        }
    }

}
