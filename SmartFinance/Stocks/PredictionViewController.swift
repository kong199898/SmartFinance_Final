import UIKit
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

class PredictionViewController: UIViewController {
    
    let domain = "http://127.0.0.1:5000/"
    //https://smartfinance-cityu.herokuapp.com/
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var stockImageView = UIImageView()
    var searchField = MDCFilledTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        addSearchView()
        addButtonView()
        addImageView()
        self.hideKeyboardWhenTapped()
    }
    
    func addImageView(){
        stockImageView.backgroundColor = .black
        stockImageView.frame = CGRect(x: screenWidth*0.05,
                                y: screenHeight*0.13+screenHeight*0.06+screenHeight*0.035+screenHeight*0.05,
                                width: screenWidth*0.9,
                                height: screenWidth*0.75)
        
        self.view.addSubview(stockImageView)
    }
    
    func addButtonView(){
        
        let buttonStack = UIStackView()
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
        buttonStack.frame = CGRect(x: screenWidth*0.05,
                                   y: screenHeight*0.13+screenHeight*0.06+screenHeight*0.035,
                                   width: screenWidth*0.9,
                                   height: screenHeight*0.03)
        
        let ButtonOne = MDCButton()
        ButtonOne.setTitle("30D", for: .normal)
        ButtonOne.tintColor = .white
        ButtonOne.setTitleFont(UIFont.preferredFont(forTextStyle: .caption2), for: .normal)
        ButtonOne.addTarget(self, action: #selector(ButtonOneBtnTapped(_:)), for: .touchUpInside)

        let ButtonTwo = MDCButton()
        ButtonTwo.setTitle("90D", for: .normal)
        ButtonTwo.tintColor = .white
        ButtonTwo.setTitleFont(UIFont.preferredFont(forTextStyle: .caption2), for: .normal)
        ButtonTwo.addTarget(self, action: #selector(ButtonTwoBtnTapped(_:)), for: .touchUpInside)
        
        let ButtonThree = MDCButton()
        ButtonThree.setTitle("6M", for: .normal)
        ButtonThree.tintColor = .white
        ButtonThree.setTitleFont(UIFont.preferredFont(forTextStyle: .caption2), for: .normal)
        ButtonThree.addTarget(self, action: #selector(ButtonThreeBtnTapped(_:)), for: .touchUpInside)
        
        let ButtonFour = MDCButton()
        ButtonFour.setTitle("1Y", for: .normal)
        ButtonFour.tintColor = .white
        ButtonFour.setTitleFont(UIFont.preferredFont(forTextStyle: .caption2), for: .normal)
        ButtonFour.addTarget(self, action: #selector(ButtonFourBtnTapped(_:)), for: .touchUpInside)
        
        let ButtonFive = MDCButton()
        ButtonFive.setTitle("2Y", for: .normal)
        ButtonFive.tintColor = .white
        ButtonFive.setTitleFont(UIFont.preferredFont(forTextStyle: .caption2), for: .normal)
        ButtonFive.addTarget(self, action: #selector(ButtonFiveBtnTapped(_:)), for: .touchUpInside)
        
        buttonStack.addArrangedSubview(ButtonOne)
        buttonStack.addArrangedSubview(ButtonTwo)
        buttonStack.addArrangedSubview(ButtonThree)
        buttonStack.addArrangedSubview(ButtonFour)
        buttonStack.addArrangedSubview(ButtonFive)
        
        self.view.addSubview(buttonStack)
    }
    
    func addSearchView(){
        searchField = MDCFilledTextField(frame: CGRect(x: screenWidth*0.05,
                                                             y: screenHeight*0.12,
                                                             width: screenWidth*0.9,
                                                             height: screenHeight*0.05))
        searchField.label.text = "Stock Number"
        searchField.placeholder = "0000"
        searchField.sizeToFit()
        searchField.setFilledBackgroundColor(UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1), for: .normal)
        searchField.setNormalLabelColor(.white, for: .normal)
        searchField.sizeToFit()
        searchField.keyboardType = UIKeyboardType.numberPad
        
        let dayLabel = UILabel(frame: CGRect(x: screenWidth*0.05,
                                             y: screenHeight*0.13+screenHeight*0.06,
                                             width: screenWidth*0.9,
                                             height: screenHeight*0.03))
        dayLabel.text = "Periods to be Predicted"
        dayLabel.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
        dayLabel.textColor = .white
        dayLabel.textAlignment = .center
        dayLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        dayLabel.font = dayLabel.font.withSize(15)
        dayLabel.layer.borderWidth = 3
        dayLabel.layer.borderColor = UIColor.white.cgColor
        dayLabel.layer.cornerRadius = 10
        
        self.view.addSubview(searchField)
        self.view.addSubview(dayLabel)
    }
    
    @IBAction func ButtonOneBtnTapped(_ sender: UIButton) {
        if let input = searchField.text{
            if validateStockNumber(stocknumber:input){
                if isStockCodeExist(stocknumber: input){
                    let url = URL(string: "\(domain)predict/\(input)/30")
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            self.stockImageView.image = UIImage(data: data!)
                        }
                    }
                }else{
                    showMessage(alert: "Invalid Stock Code", message: "Stock Code does not exist")
                }
            }else{
                showMessage(alert: "Invalid Input", message: "Please input a 4 digits stock number.")
            }
        }
    }
    
    @IBAction func ButtonTwoBtnTapped(_ sender: UIButton) {
        if let input = searchField.text{
            if validateStockNumber(stocknumber:input){
                if isStockCodeExist(stocknumber: input){
                    let url = URL(string: "\(domain)predict/\(input)/90")
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            self.stockImageView.image = UIImage(data: data!)
                        }
                    }
                }else{
                    showMessage(alert: "Invalid Stock Code", message: "Stock Code does not exist")
                }
            }else{
                showMessage(alert: "Invalid Input", message: "Please input a 4 digits stock number.")
            }
        }
    }
    
    @IBAction func ButtonThreeBtnTapped(_ sender: UIButton) {
        if let input = searchField.text{
            if validateStockNumber(stocknumber:input){
                if isStockCodeExist(stocknumber: input){
                    let url = URL(string: "\(domain)predict/\(input)/180")
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            self.stockImageView.image = UIImage(data: data!)
                        }
                    }
                }else{
                    showMessage(alert: "Invalid Stock Code", message: "Stock Code does not exist")
                }
            }else{
                showMessage(alert: "Invalid Input", message: "Please input a 4 digits stock number.")
            }
        }
    }
    
    @IBAction func ButtonFourBtnTapped(_ sender: UIButton) {
        if let input = searchField.text{
            if validateStockNumber(stocknumber:input){
                if isStockCodeExist(stocknumber: input){
                    let url = URL(string: "\(domain)predict/\(input)/365")
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            self.stockImageView.image = UIImage(data: data!)
                        }
                    }
                }else{
                    showMessage(alert: "Invalid Stock Code", message: "Stock Code does not exist")
                }
            }else{
                showMessage(alert: "Invalid Input", message: "Please input a 4 digits stock number.")
            }
        }
    }
    
    @IBAction func ButtonFiveBtnTapped(_ sender: UIButton) {
        if let input = searchField.text{
            if validateStockNumber(stocknumber:input){
                if isStockCodeExist(stocknumber: input){
                    let url = URL(string: "\(domain)predict/\(input)/730")
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            self.stockImageView.image = UIImage(data: data!)
                        }
                    }
                }else{
                    showMessage(alert: "Invalid Stock Code", message: "Stock Code does not exist")
                }
            }else{
                showMessage(alert: "Invalid Input", message: "Please input a 4 digits stock number.")
            }
        }
    }
    
}
