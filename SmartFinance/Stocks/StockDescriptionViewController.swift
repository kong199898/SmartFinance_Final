import UIKit
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

struct Stock: Codable{
    var shortName:String
    var sector:String
    var industry:String
    var fullTimeEmployees:String
    var city:String
    var country:String
    var phone:String
    var fax:String
    var website:String
    var address1:String
}

class StockDescriptionViewController: UIViewController {
    
    @IBOutlet weak var LabelStackView: UIStackView!
    
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var searchField = MDCFilledTextField()
    var searchButton = MDCButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        tabBarController?.tabBar.barTintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
        tabBarController?.tabBar.tintColor = .white
        navigationController?.navigationBar.topItem?.title = "Stock"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        addSearchView()
        addDescriptionView()
        self.hideKeyboardWhenTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewDidLoad()
    }

    func addDescriptionView(){
        
        let Title = UILabel(frame: CGRect(x: screenWidth*0.05,
                                             y: screenHeight*0.13+screenHeight*0.06+screenHeight*0.05,
                                             width: screenWidth*0.9,
                                             height: screenHeight*0.03))
        Title.text = "COMPANY INFORMATION"
        Title.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
        Title.textColor = .white
        Title.textAlignment = .center
        Title.font = UIFont.preferredFont(forTextStyle: .caption2)
        Title.font = Title.font.withSize(15)
        Title.layer.borderWidth = 3
        Title.layer.borderColor = UIColor.white.cgColor
        Title.layer.cornerRadius = 10
        
        view.addSubview(Title)
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
        
        searchButton = MDCButton(frame: CGRect(x: screenWidth*0.05,
                                                   y: screenHeight*0.13+screenHeight*0.06,
                                                   width: screenWidth*0.9,
                                                   height: screenHeight*0.03))
        searchButton.setTitle(" Search", for: .normal)
        searchButton.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
        searchButton.tintColor = .white
        searchButton.setTitleFont(UIFont.preferredFont(forTextStyle: .caption2), for: .normal)
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.setImageTintColor(.white, for: .normal)
        searchButton.addTarget(self, action: #selector(searchButtonTapped(_:)), for: .touchUpInside)
        
        self.view.addSubview(searchField)
        self.view.addSubview(searchButton)
    }
    
    @objc func searchButtonTapped(_ sender: UIButton){
        if let input = searchField.text{
            if validateStockNumber(stocknumber:input){
                if isStockCodeExist(stocknumber: input){
                    let url = URL(string: "https://smartfinance-cityu.herokuapp.com/description/\(input)")!
                    var request = URLRequest(url: url)
                    request.httpMethod = "GET"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    let task = URLSession.shared.dataTask(with: url){(data, response, error) in
                        if let error = error {
                            print(error);
                            return
                        }
                        let decoder = JSONDecoder()
                        do{
                            let stockInfo = try decoder.decode(Stock.self, from: data!)
                            DispatchQueue.main.async {
                                let Vstack = UIStackView()
                                Vstack.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
                                Vstack.frame = CGRect(x: self.screenWidth*0.05,
                                                      y: self.screenHeight*0.13+self.screenHeight*0.06+self.screenHeight*0.1,
                                                      width: self.screenWidth*0.9,
                                                      height: self.screenHeight*0.5)
                                Vstack.distribution = .fillEqually
                                Vstack.axis = .vertical
                                
                                let labelA = UILabel()
                                labelA.text = "Company Name:   \(stockInfo.shortName)"
                                labelA.textColor = .white
                                labelA.font = UIFont.preferredFont(forTextStyle: .caption2)
                                labelA.font = labelA.font.withSize(15)
                                
                                let labelB = UILabel()
                                labelB.text = "Sector:   \(stockInfo.sector)"
                                labelB.textColor = .white
                                labelB.font = UIFont.preferredFont(forTextStyle: .caption2)
                                labelB.font = labelB.font.withSize(15)
                                
                                let labelC = UILabel()
                                labelC.text = "Industry:   \(stockInfo.industry)"
                                labelC.textColor = .white
                                labelC.font = UIFont.preferredFont(forTextStyle: .caption2)
                                labelC.font = labelC.font.withSize(15)
                                
                                let labelD = UILabel()
                                labelD.text = "FullTime Employees:   \(stockInfo.fullTimeEmployees)"
                                labelD.textColor = .white
                                labelD.font = UIFont.preferredFont(forTextStyle: .caption2)
                                labelD.font = labelD.font.withSize(15)
                                
                                let labelE = UILabel()
                                labelE.text = "City:   \(stockInfo.city)"
                                labelE.textColor = .white
                                labelE.font = UIFont.preferredFont(forTextStyle: .caption2)
                                labelE.font = labelE.font.withSize(15)
                                
                                let labelF = UILabel()
                                labelF.text = "Country:   \(stockInfo.country) "
                                labelF.textColor = .white
                                labelF.font = UIFont.preferredFont(forTextStyle: .caption2)
                                labelF.font = labelF.font.withSize(15)
                                
                                let labelG = UILabel()
                                labelG.text = "Phone:   \(stockInfo.phone)"
                                labelG.textColor = .white
                                labelG.font = UIFont.preferredFont(forTextStyle: .caption2)
                                labelG.font = labelG.font.withSize(15)
                                
                                let labelH = UILabel()
                                labelH.text = "Fax:   \(stockInfo.fax)"
                                labelH.textColor = .white
                                labelH.font = UIFont.preferredFont(forTextStyle: .caption2)
                                labelH.font = labelH.font.withSize(15)
                                
                                let labelI = UILabel()
                                labelI.text = "Website:   \(stockInfo.website)"
                                labelI.textColor = .white
                                labelI.font = UIFont.preferredFont(forTextStyle: .caption2)
                                labelI.font = labelI.font.withSize(15)
                                
                                let labelJ = UILabel()
                                labelJ.text = "Address:   \(stockInfo.address1)"
                                labelJ.textColor = .white
                                labelJ.font = UIFont.preferredFont(forTextStyle: .caption2)
                                labelJ.font = labelJ.font.withSize(15)
                                
                                Vstack.addArrangedSubview(labelA)
                                Vstack.addArrangedSubview(labelB)
                                Vstack.addArrangedSubview(labelC)
                                Vstack.addArrangedSubview(labelD)
                                Vstack.addArrangedSubview(labelE)
                                Vstack.addArrangedSubview(labelF)
                                Vstack.addArrangedSubview(labelG)
                                Vstack.addArrangedSubview(labelH)
                                Vstack.addArrangedSubview(labelI)
                                Vstack.addArrangedSubview(labelJ)
                                
                                self.view.addSubview(Vstack)
                            }
                        }catch{
                            self.showMessage(alert: "Error", message: "Error in Json parsing")
                        }
                    }
                    task.resume()
                }else{
                    showMessage(alert: "Invalid Stock Code", message: "Stock Code does not exist")
                }
            }else{
                showMessage(alert: "Invalid Input", message: "Please input a 4 digits stock number.")
            }
        }
    }
    
}

