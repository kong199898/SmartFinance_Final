import UIKit
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialTextControls_FilledTextAreas
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_OutlinedTextAreas
import MaterialComponents.MaterialTextControls_OutlinedTextFields

struct Description:Codable{
    var Name:String
    var Price:String
    var ChangeInPrice:String
    var PreviousClose:String
    var OpenPrice:String
    var Bid:String
    var Ask:String
    var DaysRange:String
    var fivetwoWeekrange:String
    var Volume:String
    var AvgVolume:String
    var MarketCap:String
    var Beta:String
    var PEratio:String
    var EPS:String
    var EarningsDate:String
    var Forward:String
    var ExDiv:String
    var YearTarget:String
}

class StockViewController: UIViewController {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var searchField = MDCFilledTextField()
    var searchButton = MDCButton()
    var StockImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        tabBarController?.tabBar.barTintColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
        tabBarController?.tabBar.tintColor = .white
        navigationController?.navigationBar.topItem?.title = "Stock"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        
        addSearchView()
        self.hideKeyboardWhenTapped()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewDidLoad()
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
    
    func addDescriptionView(){
        
        if let input = searchField.text{
            let url = URL(string: "https://smartfinance-cityu.herokuapp.com/search/\(input)")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: url){(data, response, error) in
                if let error = error {print(error); return}
                let decoder = JSONDecoder()
                do{
                    let stockInfo = try decoder.decode(Description.self, from: data!)
                    DispatchQueue.main.async {
                        let DescriptionStack = UIStackView()
                        DescriptionStack.axis = .vertical
                        DescriptionStack.distribution = .fillEqually
                        DescriptionStack.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
                        DescriptionStack.frame = CGRect (x: self.screenWidth*0.05,
                                                         y:self.screenHeight*0.13+self.screenHeight*0.06+self.screenHeight*0.035+self.screenHeight*0.04+self.screenWidth*0.66,
                                                         width: self.screenWidth*0.9,
                                                         height: self.screenWidth*0.65)
                        
                        var PriceGoesUp: Bool
                        if stockInfo.ChangeInPrice.contains("+"){
                            PriceGoesUp = true
                        } else {
                            PriceGoesUp = false
                        }
                        
                        
                        let labelName = UILabel()
                        labelName.text = stockInfo.Name
                        if PriceGoesUp{
                            labelName.textColor = .green
                        }else{
                            labelName.textColor = .red
                        }
                        labelName.font = UIFont.preferredFont(forTextStyle: .caption2)
                        labelName.font = labelName.font.withSize(12)
                        
                        let labelCurrentPrice = UILabel()
                        labelCurrentPrice.text = stockInfo.Price + "   " + stockInfo.ChangeInPrice
                        if PriceGoesUp{
                            labelCurrentPrice.textColor = .green
                        }else{
                            labelCurrentPrice.textColor = .red
                        }
                        labelCurrentPrice.font = UIFont.preferredFont(forTextStyle: .caption2)
                        labelCurrentPrice.font = labelCurrentPrice.font.withSize(12)
                        
                        let labelA = UILabel()
                        labelA.text = "Previous Close:   \(stockInfo.PreviousClose)"
                        labelA.textColor = .white
                        labelA.font = UIFont.preferredFont(forTextStyle: .caption2)
                        labelA.font = labelA.font.withSize(10)
                        
                        let labelB = UILabel()
                        labelB.text = "Open:   \(stockInfo.OpenPrice)"
                        labelB.textColor = .white
                        labelB.font = UIFont.preferredFont(forTextStyle: .caption2)
                        labelB.font = labelB.font.withSize(10)
                        
                        let labelC = UILabel()
                        labelC.text = "Bid:   \(stockInfo.Bid)"
                        labelC.textColor = .white
                        labelC.font = UIFont.preferredFont(forTextStyle: .caption2)
                        labelC.font = labelC.font.withSize(10)
                        
                        let labelD = UILabel()
                        labelD.text = "Ask:   \(stockInfo.Ask)"
                        labelD.textColor = .white
                        labelD.font = UIFont.preferredFont(forTextStyle: .caption2)
                        labelD.font = labelD.font.withSize(10)
                        
                        let labelE = UILabel()
                        labelE.text = "Day's Range:   \(stockInfo.DaysRange)"
                        labelE.textColor = .white
                        labelE.font = UIFont.preferredFont(forTextStyle: .caption2)
                        labelE.font = labelE.font.withSize(10)
                        
                        let labelF = UILabel()
                        labelF.text = "52 Week Range:   \(stockInfo.fivetwoWeekrange)"
                        labelF.textColor = .white
                        labelF.font = UIFont.preferredFont(forTextStyle: .caption2)
                        labelF.font = labelF.font.withSize(10)
                        
                        let labelG = UILabel()
                        labelG.text = "Volume:   \(stockInfo.Volume)"
                        labelG.textColor = .white
                        labelG.font = UIFont.preferredFont(forTextStyle: .caption2)
                        labelG.font = labelG.font.withSize(10)
                        
                        let labelH = UILabel()
                        labelH.text = "Avg. Volume:   \(stockInfo.AvgVolume)"
                        labelH.textColor = .white
                        labelH.font = UIFont.preferredFont(forTextStyle: .caption2)
                        labelH.font = labelH.font.withSize(10)
                        
                        let labelI = UILabel()
                        labelI.text = "Market Cap:   \(stockInfo.MarketCap)"
                        labelI.textColor = .white
                        labelI.font = UIFont.preferredFont(forTextStyle: .caption2)
                        labelI.font = labelI.font.withSize(10)
                        
                        let labelJ = UILabel()
                        labelJ.text = "Beta (5Y Monthly):   \(stockInfo.Beta)"
                        labelJ.textColor = .white
                        labelJ.font = UIFont.preferredFont(forTextStyle: .caption2)
                        labelJ.font = labelJ.font.withSize(10)
                        
                        let labelK = UILabel()
                        labelK.text = "PE Ratio (TTM):   \(stockInfo.PEratio)"
                        labelK.textColor = .white
                        labelK.font = UIFont.preferredFont(forTextStyle: .caption2)
                        labelK.font = labelK.font.withSize(10)
                        
                        let labelL = UILabel()
                        labelL.text = "EPS (TTM):   \(stockInfo.EPS)"
                        labelL.textColor = .white
                        labelL.font = UIFont.preferredFont(forTextStyle: .caption2)
                        labelL.font = labelL.font.withSize(10)
                        
                        let labelM = UILabel()
                        labelM.text = "Earnings Date:   \(stockInfo.EarningsDate)"
                        labelM.textColor = .white
                        labelM.font = UIFont.preferredFont(forTextStyle: .caption2)
                        labelM.font = labelM.font.withSize(10)
                        
                        let labelN = UILabel()
                        labelN.text = "Forward Dividend & Yield:   \(stockInfo.Forward)"
                        labelN.textColor = .white
                        labelN.font = UIFont.preferredFont(forTextStyle: .caption2)
                        labelN.font = labelN.font.withSize(10)
                        
                        let labelO = UILabel()
                        labelO.text = "Ex-Dividend Date:   \(stockInfo.ExDiv)"
                        labelO.textColor = .white
                        labelO.font = UIFont.preferredFont(forTextStyle: .caption2)
                        labelO.font = labelO.font.withSize(10)
                        
                        let labelP = UILabel()
                        labelP.text = "Avg. Volume:   \(stockInfo.YearTarget)"
                        labelP.textColor = .white
                        labelP.font = UIFont.preferredFont(forTextStyle: .caption2)
                        labelP.font = labelP.font.withSize(10)
                        
                        DescriptionStack.addArrangedSubview(labelName)
                        DescriptionStack.addArrangedSubview(labelCurrentPrice)
                        DescriptionStack.addArrangedSubview(labelA)
                        DescriptionStack.addArrangedSubview(labelB)
                        DescriptionStack.addArrangedSubview(labelC)
                        DescriptionStack.addArrangedSubview(labelD)
                        DescriptionStack.addArrangedSubview(labelE)
                        DescriptionStack.addArrangedSubview(labelF)
                        DescriptionStack.addArrangedSubview(labelG)
                        DescriptionStack.addArrangedSubview(labelH)
                        DescriptionStack.addArrangedSubview(labelI)
                        DescriptionStack.addArrangedSubview(labelJ)
                        DescriptionStack.addArrangedSubview(labelK)
                        DescriptionStack.addArrangedSubview(labelL)
                        DescriptionStack.addArrangedSubview(labelM)
                        DescriptionStack.addArrangedSubview(labelN)
                        DescriptionStack.addArrangedSubview(labelO)
                        DescriptionStack.addArrangedSubview(labelP)
                        
                        self.view.addSubview(DescriptionStack)
                    }
                }catch{
                    self.showMessage(alert: "Error", message: "Error in Json parsing")
                }
            }
            task.resume()
        }
    }
    
    func addStockImageView(){
        StockImageView.backgroundColor = .black
        StockImageView.frame = CGRect(x: screenWidth*0.05,
                                      y: screenHeight*0.13+screenHeight*0.06+screenHeight*0.035+screenHeight*0.04,
                                      width: screenWidth*0.9,
                                      height: screenWidth*0.65)
        
        self.view.addSubview(StockImageView)
    }
    
    func addDayButtonView(){
        let ButtonStack = UIStackView()
        ButtonStack.axis = .horizontal
        ButtonStack.frame = CGRect(x: screenWidth*0.05,
                                   y: screenHeight*0.13+screenHeight*0.06+screenHeight*0.035,
                                   width: screenWidth*0.9,
                                   height: screenHeight*0.03)
        ButtonStack.distribution = .fillEqually
        ButtonStack.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
        
        let ButtonOne = MDCButton()
        ButtonOne.setTitle("1D", for: .normal)
        ButtonOne.tintColor = .white
        ButtonOne.setTitleFont(UIFont.preferredFont(forTextStyle: .caption2), for: .normal)
        ButtonOne.addTarget(self, action: #selector(ButtonOneBtnTapped(_:)), for: .touchUpInside)

        let ButtonTwo = MDCButton()
        ButtonTwo.setTitle("5D", for: .normal)
        ButtonTwo.tintColor = .white
        ButtonTwo.setTitleFont(UIFont.preferredFont(forTextStyle: .caption2), for: .normal)
        ButtonTwo.addTarget(self, action: #selector(ButtonTwoBtnTapped(_:)), for: .touchUpInside)
        
        let ButtonThree = MDCButton()
        ButtonThree.setTitle("1M", for: .normal)
        ButtonThree.tintColor = .white
        ButtonThree.setTitleFont(UIFont.preferredFont(forTextStyle: .caption2), for: .normal)
        ButtonThree.addTarget(self, action: #selector(ButtonThreeBtnTapped(_:)), for: .touchUpInside)
        
        let ButtonFour = MDCButton()
        ButtonFour.setTitle("6M", for: .normal)

        ButtonFour.tintColor = .white
        ButtonFour.setTitleFont(UIFont.preferredFont(forTextStyle: .caption2), for: .normal)
        ButtonFour.addTarget(self, action: #selector(ButtonFourBtnTapped(_:)), for: .touchUpInside)
        
        let ButtonFive = MDCButton()
        ButtonFive.setTitle("1Y", for: .normal)
        ButtonFive.tintColor = .white
        ButtonFive.setTitleFont(UIFont.preferredFont(forTextStyle: .caption2), for: .normal)
        ButtonFive.addTarget(self, action: #selector(ButtonFiveBtnTapped(_:)), for: .touchUpInside)
        
        let ButtonSix = MDCButton()
        ButtonSix.setTitle("YTD", for: .normal)
        ButtonSix.tintColor = .white
        ButtonSix.setTitleFont(UIFont.preferredFont(forTextStyle: .caption2), for: .normal)
        ButtonSix.addTarget(self, action: #selector(ButtonSixBtnTapped(_:)), for: .touchUpInside)
        
        ButtonStack.addArrangedSubview(ButtonOne)
        ButtonStack.addArrangedSubview(ButtonTwo)
        ButtonStack.addArrangedSubview(ButtonThree)
        ButtonStack.addArrangedSubview(ButtonFour)
        ButtonStack.addArrangedSubview(ButtonFive)
        ButtonStack.addArrangedSubview(ButtonSix)
        
        view.addSubview(ButtonStack)
        
    }
    
    @objc func ButtonOneBtnTapped(_ sender: UIButton){
        if let input = searchField.text{
            let url = URL(string: "https://smartfinance-cityu.herokuapp.com/graph/\(input)/1d/2m")
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.StockImageView.image = UIImage(data: data!)
                }
            }
        }
    }
    
    @objc func ButtonTwoBtnTapped(_ sender: UIButton){
        if let input = searchField.text{
            let url = URL(string: "https://smartfinance-cityu.herokuapp.com/graph/\(input)/5d/15m")
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.StockImageView.image = UIImage(data: data!)
                }
            }
        }
    }
    
    @objc func ButtonThreeBtnTapped(_ sender: UIButton){
        if let input = searchField.text{
            let url = URL(string: "https://smartfinance-cityu.herokuapp.com/graph/\(input)/1mo/90m")
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.StockImageView.image = UIImage(data: data!)
                }
            }
        }
    }
    
    @objc func ButtonFourBtnTapped(_ sender: UIButton){
        if let input = searchField.text{
            let url = URL(string: "https://smartfinance-cityu.herokuapp.com/graph/\(input)/6mo/1d")
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.StockImageView.image = UIImage(data: data!)
                }
            }
        }
    }
    
    @objc func ButtonFiveBtnTapped(_ sender: UIButton){
        if let input = searchField.text{
            let url = URL(string: "https://smartfinance-cityu.herokuapp.com/graph/\(input)/1y/1wk")
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.StockImageView.image = UIImage(data: data!)
                }
            }
        }
    }
    
    @objc func ButtonSixBtnTapped(_ sender: UIButton){
        if let input = searchField.text{
            let url = URL(string: "https://smartfinance-cityu.herokuapp.com/graph/\(input)/YTD/1d")
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.StockImageView.image = UIImage(data: data!)
                }
            }
        }
    }
    
    @objc func searchButtonTapped(_ sender: UIButton){
        if let input = searchField.text{
            if validateStockNumber(stocknumber:input){
                if isStockCodeExist(stocknumber: input){
                    addDayButtonView()
                    addStockImageView()
                    addDescriptionView()
                    let url = URL(string: "https://smartfinance-cityu.herokuapp.com/graph/\(input)/1d/2m")
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            self.StockImageView.image = UIImage(data: data!)
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
