import UIKit
import MaterialComponents.MaterialButtons

class EditAssumptionFormViewController: UIViewController {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults()
    
    var editItem: TheAssumption!
    var InflationSldierValue = UILabel()
    var InflationSlider = UISlider()
    var LifeExpectancySldierValue = UILabel()
    var LifeExpectancySlider = UISlider()
    var AgeOfRetirementSldierValue = UILabel()
    var AgeOfRetirementSlider = UISlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        addForm()
        addButton()
        self.hideKeyboardWhenTapped()
        
        NotificationCenter.default.addObserver(self, selector: #selector(editAssumptionNotification), name: Notification.Name("editAssumption"), object: nil)
    }
    
    func addForm(){
        
        let Title = UILabel(frame: CGRect(x: screenWidth*0.05,
                                          y: screenHeight*0.05,
                                          width: screenWidth*0.9,
                                          height: screenHeight*0.05))
        Title.text = "Edit Assumptions"
        Title.textColor = .white
        Title.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        
        //inflation
        let InflationLabel = UILabel(frame: CGRect(x: screenWidth*0.05,
                                              y: screenHeight*0.06+screenHeight*0.06,
                                              width: screenWidth*0.9,
                                              height: screenHeight*0.05))
        InflationLabel.text = "Inflation Rate"
        InflationLabel.textColor = .white
        InflationLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        InflationSldierValue = UILabel(frame: CGRect(x: screenWidth*0.05,
                                                         y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04,
                                                         width: screenWidth*0.9,
                                                         height: screenHeight*0.05))
        InflationSldierValue.text = InflationSlider.value.description+"%"
        InflationSldierValue.textColor = .white
        InflationSldierValue.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        InflationSlider = UISlider(frame: CGRect(x: screenWidth*0.05,
                                                y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.04,
                                                width: screenWidth*0.9,
                                                height: screenHeight*0.05))
        InflationSlider.backgroundColor = .black
        InflationSlider.maximumTrackTintColor = .lightGray
        InflationSlider.minimumTrackTintColor = .white
        InflationSlider.thumbTintColor = .white
        InflationSlider.minimumValue = 0
        InflationSlider.maximumValue = 10
        InflationSlider.value = 0
        InflationSlider.isContinuous = true
        InflationSlider.addTarget(self, action: #selector(InflationSliderChange(_:)), for: .valueChanged)
        
        //LifeExpectancy
        let LifeExpectancyLabel  = UILabel(frame: CGRect(x: screenWidth*0.05,
                                                    y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.04+screenHeight*0.06,
                                                    width: screenWidth*0.9,
                                                    height: screenHeight*0.05))
        LifeExpectancyLabel.text = "Life Expectancy"
        LifeExpectancyLabel.textColor = .white
        LifeExpectancyLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        LifeExpectancySlider = UISlider(frame: CGRect(x: screenWidth*0.05,
                                                y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04+screenHeight*0.04,
                                                width: screenWidth*0.9,
                                                height: screenHeight*0.05))
        LifeExpectancySlider.backgroundColor = .black
        LifeExpectancySlider.maximumTrackTintColor = .lightGray
        LifeExpectancySlider.minimumTrackTintColor = .white
        LifeExpectancySlider.thumbTintColor = .white
        LifeExpectancySlider.minimumValue = Float(defaults.value(forKey: "UserAge") as! Int)
        LifeExpectancySlider.maximumValue = 120
        LifeExpectancySlider.value = Float(defaults.value(forKey: "UserAge") as! Int)
        LifeExpectancySlider.isContinuous = true
        LifeExpectancySlider.addTarget(self, action: #selector(LifeExpectancySliderChange(_:)), for: .valueChanged)
        
        LifeExpectancySldierValue = UILabel(frame: CGRect(x: screenWidth*0.05,
                                                         y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04,
                                                         width: screenWidth*0.9,
                                                         height: screenHeight*0.05))
        LifeExpectancySldierValue.text = Int(LifeExpectancySlider.value).description
        LifeExpectancySldierValue.textColor = .white
        LifeExpectancySldierValue.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        //Age Of Retirement
        let AgeOfRetirementLabel  = UILabel(frame: CGRect(x: screenWidth*0.05,
                                                    y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04+screenHeight*0.04+screenHeight*0.06,
                                                    width: screenWidth*0.9,
                                                    height: screenHeight*0.05))
        AgeOfRetirementLabel.text = "Age of Retirement"
        AgeOfRetirementLabel.textColor = .white
        AgeOfRetirementLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        AgeOfRetirementSlider = UISlider(frame: CGRect(x: screenWidth*0.05,
                                                y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04+screenHeight*0.04,
                                                width: screenWidth*0.9,
                                                height: screenHeight*0.05))
        AgeOfRetirementSlider.backgroundColor = .black
        AgeOfRetirementSlider.maximumTrackTintColor = .lightGray
        AgeOfRetirementSlider.minimumTrackTintColor = .white
        AgeOfRetirementSlider.thumbTintColor = .white
        AgeOfRetirementSlider.minimumValue = Float(defaults.value(forKey: "UserAge") as! Int)
        AgeOfRetirementSlider.maximumValue = 120
        AgeOfRetirementSlider.value = Float(defaults.value(forKey: "UserAge") as! Int)
        AgeOfRetirementSlider.isContinuous = true
        AgeOfRetirementSlider.addTarget(self, action: #selector(AgeofRetirementSliderChange(_:)), for: .valueChanged)
        
        AgeOfRetirementSldierValue = UILabel(frame: CGRect(x: screenWidth*0.05,
                                                         y: screenHeight*0.06+screenHeight*0.06+screenHeight*0.04+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04+screenHeight*0.04+screenHeight*0.06+screenHeight*0.04,
                                                         width: screenWidth*0.9,
                                                         height: screenHeight*0.05))
        AgeOfRetirementSldierValue.text = Int(AgeOfRetirementSlider.value).description
        AgeOfRetirementSldierValue.textColor = .white
        AgeOfRetirementSldierValue.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
        
        view.addSubview(Title)
        view.addSubview(InflationLabel)
        view.addSubview(InflationSldierValue)
        view.addSubview(InflationSlider)
        view.addSubview(LifeExpectancyLabel)
        view.addSubview(LifeExpectancySldierValue)
        view.addSubview(LifeExpectancySlider)
        view.addSubview(AgeOfRetirementLabel)
        view.addSubview(AgeOfRetirementSlider)
        view.addSubview(AgeOfRetirementSldierValue)
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
    
    @objc func InflationSliderChange(_ sender: UISlider){
        InflationSlider.value.round()
        InflationSldierValue.text = InflationSlider.value.description+"%"
    }
    
    @objc func LifeExpectancySliderChange(_ sender: UISlider){
        LifeExpectancySlider.value.round()
        LifeExpectancySldierValue.text = Int(LifeExpectancySlider.value).description
    }
    
    @objc func AgeofRetirementSliderChange(_ sender: UISlider){
        AgeOfRetirementSlider.value.round()
        AgeOfRetirementSldierValue.text = Int(AgeOfRetirementSlider.value).description
    }
    
    @objc func SubmitButtonTapped(_ sender: UIButton){
        if checkSliderValue(){
            updateItem(item:editItem, newInflation:Int64(InflationSlider.value), newLife: Int64(LifeExpectancySlider.value), newRetirement: Int64(AgeOfRetirementSlider.value))
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func CancelButtonTapped(_ sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func editAssumptionNotification(_ notification: Notification){
        editItem = notification.userInfo?["item"] as! TheAssumption
        
        InflationSlider.value = Float(notification.userInfo?["inflation"] as! Int64)
        LifeExpectancySlider.value = Float(notification.userInfo?["life"] as! Int64)
        AgeOfRetirementSlider.value = Float(notification.userInfo?["retirement"] as! Int64)
        
        InflationSldierValue.text = "\(String(notification.userInfo?["inflation"] as! Int64)).0%"
        LifeExpectancySldierValue.text = String(notification.userInfo?["life"] as! Int64)
        AgeOfRetirementSldierValue.text = String(notification.userInfo?["retirement"] as! Int64)
        
    }
    
    func checkSliderValue() -> Bool{
        if Int(LifeExpectancySlider.value) < Int(AgeOfRetirementSlider.value){
            showMessage(alert: "Invalid Retirement Age", message: "Age of Retirement should be less than Expected Life Expectancy.")
            return false
        }
        if defaults.value(forKey: "UserAge") as! Int == Int(LifeExpectancySlider.value){
            showMessage(alert: "Invalid Life Expectancy", message: "Expected Life Expectancy can not be the same as your age.")
            return false
        }
        if defaults.value(forKey: "UserAge") as! Int == Int(AgeOfRetirementSlider.value){
            showMessage(alert: "Invalid Retirement Age", message: "Age of Retirement can not be the same as your age.")
            return false
        }
        return true
    }
    
    func updateItem(item: TheAssumption, newInflation:Int64, newLife:Int64, newRetirement:Int64){
        item.inflation = newInflation
        item.life = newLife
        item.retirement = newRetirement
        
        do{
            try context.save()
            NotificationCenter.default.post(name: Notification.Name("refreshAssumption"), object: nil, userInfo: nil)
        }
        catch{
            showMessage(alert: "Error", message: "failed to update item")
        }
    }
}
