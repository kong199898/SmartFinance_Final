import UIKit
import DropDown
import MaterialComponents.MaterialButtons

class RoiViewController: UIViewController {

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var firmName:String?
    let BuyingPriceField = UITextField()
    let NumberofLotField = UITextField()
    let SharePerLotField = UITextField()
    let SellingPriceField = UITextField()
    var SubmitButton = MDCButton()
    
    let ProfitEquation = UILabel()
    let Profit = UILabel()
    let NetValueBuy = UILabel()
    let NetValueSell = UILabel()
    let BrokerageBuy = UILabel()
    let BrokerageSell = UILabel()
    let TransactionLevyBuy = UILabel()
    let TransactionLevySell = UILabel()
    let SFCTransactionLevyBuy = UILabel()
    let SFCTransactionLevySell = UILabel()
    let StampDutyBuy = UILabel()
    let StampDutySell = UILabel()
    let CCASSfeeBuy = UILabel()
    let CCASSfeeSell = UILabel()
    let HandlingFeeBuy = UILabel()
    let HandlingFeeSell = UILabel()
    let StorageFeeBuy = UILabel()
    let StorageFeeSell = UILabel()
    let TotalFeeBuy = UILabel()
    let TotalFeeSell = UILabel()
    let TotalValueBuy = UILabel()
    let TotalValueSell = UILabel()
    
    let Menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
            "HSBC",
            "Hang Seng Bank",
            "Bank of China",
            "FUTU"
        ]
        return menu
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        showMenu()
        showInfo()
        self.hideKeyboardWhenTapped()
    }
    
    func showMenu(){
        let OuterStack = UIStackView()
        OuterStack.axis = .vertical
        OuterStack.distribution = .fillEqually
        OuterStack.spacing = 10
        OuterStack.backgroundColor = .black
        OuterStack.frame = CGRect(x: screenWidth*0.05,
                                  y: screenHeight*0.12,
                                  width: screenWidth*0.9,
                                  height: screenHeight*0.17)
        
        let MenuButton = MDCButton()
        MenuButton.setTitle("Click to Choose a Bank/Firm", for: .normal)
        MenuButton.backgroundColor = .white
        MenuButton.setTitleColor(.black, for: .normal)
        MenuButton.addTarget(self, action: #selector(showMenu(_:)), for: .touchUpInside)
        Menu.anchorView = MenuButton
        Menu.selectionAction = {index, item in
            MenuButton.setTitle(item, for: .normal)
            self.firmName = item
            if self.BuyingPriceField.text != "" && self.NumberofLotField.text != "" && self.SellingPriceField.text != "" && self.SharePerLotField.text != ""{
                self.SubmitButton.sendActions(for: .touchUpInside)
            }
        }
        
        SubmitButton = MDCButton()
        SubmitButton.setTitle(" Submit", for: .normal)
        SubmitButton.backgroundColor = .white
        SubmitButton.setTitleColor(.black, for: .normal)
        SubmitButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        SubmitButton.setImageTintColor(.black, for: .normal)
        SubmitButton.inkColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 0.5)
        SubmitButton.addTarget(self, action: #selector(submitButtonTapped(_:)), for: .touchUpInside)
        
        let labelStack = UIStackView()
        labelStack.axis = .horizontal
        labelStack.distribution = .fillEqually
        labelStack.spacing = 10
        labelStack.backgroundColor = .black
        
        let textFieldStack = UIStackView()
        textFieldStack.axis = .horizontal
        textFieldStack.distribution = .fillEqually
        textFieldStack.spacing = 10
        textFieldStack.backgroundColor = .black
        
        let BuyingPrice = UILabel()
        BuyingPrice.text = "Buying Price"
        BuyingPrice.textColor = .white
        BuyingPrice.font = BuyingPrice.font.withSize(12)
        
        let SellingPrice = UILabel()
        SellingPrice.text = "Selling Price"
        SellingPrice.textColor = .white
        SellingPrice.font = SellingPrice.font.withSize(12)
        
        let SharePerLot = UILabel()
        SharePerLot.text = "Share Per Lot"
        SharePerLot.textColor = .white
        SharePerLot.font = SharePerLot.font.withSize(12)
        
        let NumberofLot = UILabel()
        NumberofLot.text = "Number of Lot"
        NumberofLot.textColor = .white
        NumberofLot.font = NumberofLot.font.withSize(12)
        
        BuyingPriceField.backgroundColor = .white
        BuyingPriceField.textColor = .black
        BuyingPriceField.placeholder = "0.00"
        BuyingPriceField.keyboardType = UIKeyboardType.numberPad

        SellingPriceField.backgroundColor = .white
        SellingPriceField.textColor = .black
        SellingPriceField.placeholder = "0.00"
        SellingPriceField.keyboardType = UIKeyboardType.numberPad
        
        SharePerLotField.backgroundColor = .white
        SharePerLotField.textColor = .black
        SharePerLotField.placeholder = "0"
        SharePerLotField.keyboardType = UIKeyboardType.numberPad
        
        NumberofLotField.backgroundColor = .white
        NumberofLotField.textColor = .black
        NumberofLotField.placeholder = "0"
        NumberofLotField.keyboardType = UIKeyboardType.numberPad

        labelStack.addArrangedSubview(BuyingPrice)
        labelStack.addArrangedSubview(SellingPrice)
        labelStack.addArrangedSubview(SharePerLot)
        labelStack.addArrangedSubview(NumberofLot)
        
        textFieldStack.addArrangedSubview(BuyingPriceField)
        textFieldStack.addArrangedSubview(SellingPriceField)
        textFieldStack.addArrangedSubview(SharePerLotField)
        textFieldStack.addArrangedSubview(NumberofLotField)
        
        OuterStack.addArrangedSubview(MenuButton)
        OuterStack.addArrangedSubview(labelStack)
        OuterStack.addArrangedSubview(textFieldStack)
        OuterStack.addArrangedSubview(SubmitButton)
        
        view.addSubview(OuterStack)
    }
    
    func showInfo(){
        let fontsize = CGFloat(15)
        
        let InfoStack = UIStackView()
        InfoStack.axis = .vertical
        InfoStack.distribution = .fillEqually
        InfoStack.spacing = 8
        InfoStack.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
        InfoStack.frame = CGRect(x: screenWidth*0.05,
                                  y: screenHeight*0.12+screenHeight*0.18,
                                  width: screenWidth*0.9,
                                  height: screenHeight*0.65)
        
        
        ProfitEquation.text = "ProfitEquation"
        ProfitEquation.textColor = .white
        ProfitEquation.textAlignment = .center
        ProfitEquation.font = ProfitEquation.font.withSize(fontsize+2)
        
        
        Profit.text = "Profit"
        Profit.textColor = .white
        Profit.textAlignment = .center
        Profit.font = Profit.font.withSize(fontsize+10)
        
        let ItemLabel = UILabel()
        ItemLabel.text = "Item(s)"
        ItemLabel.textColor = .white
        ItemLabel.font = UIFont.boldSystemFont(ofSize: fontsize+2)
        let BuyLabel = UILabel()
        BuyLabel.text = "Buy"
        BuyLabel.textColor = .white
        BuyLabel.font = UIFont.boldSystemFont(ofSize: fontsize+2)
        BuyLabel.textAlignment = .center
        let SellLabel = UILabel()
        SellLabel.text = "Sell"
        SellLabel.textColor = .white
        SellLabel.font = UIFont.boldSystemFont(ofSize: fontsize+2)
        SellLabel.textAlignment = .center
        
        let NetValue = UILabel()
        NetValue.text = "Net Value"
        NetValue.textColor = .white
        NetValue.font = NetValue.font.withSize(fontsize)
        
        NetValueBuy.text = "0"
        NetValueBuy.textColor = .white
        NetValueBuy.font = NetValueBuy.font.withSize(fontsize)
        NetValueBuy.textAlignment = .center
        
        NetValueSell.text = "0"
        NetValueSell.textColor = .white
        NetValueSell.font = NetValueSell.font.withSize(fontsize)
        NetValueSell.textAlignment = .center
        
        let Brokerage = UILabel()
        Brokerage.text = "Brokerage"
        Brokerage.textColor = .white
        Brokerage.font = Brokerage.font.withSize(fontsize)
        
        BrokerageBuy.text = "0"
        BrokerageBuy.textColor = .white
        BrokerageBuy.font = BrokerageBuy.font.withSize(fontsize)
        BrokerageBuy.textAlignment = .center
        
        BrokerageSell.text = "0"
        BrokerageSell.textColor = .white
        BrokerageSell.font = BrokerageSell.font.withSize(fontsize)
        BrokerageSell.textAlignment = .center
        
        let TransactionLevy = UILabel()
        TransactionLevy.text = "Transaction Levy"
        TransactionLevy.textColor = .white
        TransactionLevy.font = TransactionLevy.font.withSize(fontsize)
        
        TransactionLevyBuy.text = "0"
        TransactionLevyBuy.textColor = .white
        TransactionLevyBuy.font = TransactionLevyBuy.font.withSize(fontsize)
        TransactionLevyBuy.textAlignment = .center
        
        TransactionLevySell.text = "0"
        TransactionLevySell.textColor = .white
        TransactionLevySell.font = TransactionLevySell.font.withSize(fontsize)
        TransactionLevySell.textAlignment = .center
        
        let SFCTransactionLevy = UILabel()
        SFCTransactionLevy.text = "SFC Transaction\nLevy"
        SFCTransactionLevy.textColor = .white
        SFCTransactionLevy.font = SFCTransactionLevy.font.withSize(fontsize)
        SFCTransactionLevy.numberOfLines = 0
        SFCTransactionLevy.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        SFCTransactionLevyBuy.text = "0"
        SFCTransactionLevyBuy.textColor = .white
        SFCTransactionLevyBuy.font = SFCTransactionLevyBuy.font.withSize(fontsize)
        SFCTransactionLevyBuy.textAlignment = .center
        
        SFCTransactionLevySell.text = "0"
        SFCTransactionLevySell.textColor = .white
        SFCTransactionLevySell.font = SFCTransactionLevySell.font.withSize(fontsize)
        SFCTransactionLevySell.textAlignment = .center
        
        let StampDuty = UILabel()
        StampDuty.text = "Stamp Duty"
        StampDuty.textColor = .white
        StampDuty.font = StampDuty.font.withSize(fontsize)
        
        StampDutyBuy.text = "0"
        StampDutyBuy.textColor = .white
        StampDutyBuy.font = StampDutyBuy.font.withSize(fontsize)
        StampDutyBuy.textAlignment = .center
        
        StampDutySell.text = "0"
        StampDutySell.textColor = .white
        StampDutySell.font = StampDutySell.font.withSize(fontsize)
        StampDutySell.textAlignment = .center
        
        let CCASSfee = UILabel()
        CCASSfee.text = "CCASS Fee"
        CCASSfee.textColor = .white
        CCASSfee.font = CCASSfee.font.withSize(fontsize)
        
        CCASSfeeBuy.text = "0"
        CCASSfeeBuy.textColor = .white
        CCASSfeeBuy.font = CCASSfeeBuy.font.withSize(fontsize)
        CCASSfeeBuy.textAlignment = .center
        
        CCASSfeeSell.text = "0"
        CCASSfeeSell.textColor = .white
        CCASSfeeSell.font = CCASSfeeSell.font.withSize(fontsize)
        CCASSfeeSell.textAlignment = .center
        
        let HandlingFee = UILabel()
        HandlingFee.text = "Handling Fee"
        HandlingFee.textColor = .white
        HandlingFee.font = HandlingFee.font.withSize(fontsize)
        
        HandlingFeeBuy.text = "0"
        HandlingFeeBuy.textColor = .white
        HandlingFeeBuy.font = HandlingFeeBuy.font.withSize(fontsize)
        HandlingFeeBuy.textAlignment = .center
        
        HandlingFeeSell.text = "0"
        HandlingFeeSell.textColor = .white
        HandlingFeeSell.font = HandlingFeeSell.font.withSize(fontsize)
        HandlingFeeSell.textAlignment = .center
        
        let StorageFee = UILabel()
        StorageFee.text = "Storage Fee"
        StorageFee.textColor = .white
        StorageFee.font = StorageFee.font.withSize(fontsize)
        
        StorageFeeBuy.text = "0"
        StorageFeeBuy.textColor = .white
        StorageFeeBuy.font = StorageFeeBuy.font.withSize(fontsize)
        StorageFeeBuy.textAlignment = .center
        
        StorageFeeSell.text = "0"
        StorageFeeSell.textColor = .white
        StorageFeeSell.font = StorageFeeSell.font.withSize(fontsize)
        StorageFeeSell.textAlignment = .center
        
        let TotalFee = UILabel()
        TotalFee.text = "Total Fee"
        TotalFee.textColor = .white
        TotalFee.font = TotalFee.font.withSize(fontsize)
        
        TotalFeeBuy.text = "0"
        TotalFeeBuy.textColor = .white
        TotalFeeBuy.font = TotalFeeBuy.font.withSize(fontsize)
        TotalFeeBuy.textAlignment = .center
        
        TotalFeeSell.text = "0"
        TotalFeeSell.textColor = .white
        TotalFeeSell.font = TotalFeeSell.font.withSize(fontsize)
        TotalFeeSell.textAlignment = .center
        
        let TotalValue = UILabel()
        TotalValue.text = "Total Value"
        TotalValue.textColor = .white
        TotalValue.font = TotalValue.font.withSize(fontsize)
        
        TotalValueBuy.text = "0"
        TotalValueBuy.textColor = .white
        TotalValueBuy.font = TotalValueBuy.font.withSize(fontsize)
        TotalValueBuy.textAlignment = .center
        
        TotalValueSell.text = "0"
        TotalValueSell.textColor = .white
        TotalValueSell.font = TotalValueSell.font.withSize(fontsize)
        TotalValueSell.textAlignment = .center
        
        let TitleStack = UIStackView()
        TitleStack.axis = .horizontal
        TitleStack.distribution = .fillEqually
        TitleStack.spacing = 10
        
        let NetValueStack = UIStackView()
        NetValueStack.axis = .horizontal
        NetValueStack.distribution = .fillEqually
        NetValueStack.spacing = 10
        
        let BrokerageStack = UIStackView()
        BrokerageStack.axis = .horizontal
        BrokerageStack.distribution = .fillEqually
        BrokerageStack.spacing = 10
        
        let TransactionLevyStack = UIStackView()
        TransactionLevyStack.axis = .horizontal
        TransactionLevyStack.distribution = .fillEqually
        TransactionLevyStack.spacing = 10
        
        let SFCTransactionLevyStack = UIStackView()
        SFCTransactionLevyStack.axis = .horizontal
        SFCTransactionLevyStack.distribution = .fillEqually
        SFCTransactionLevyStack.spacing = 10
        
        let StampDutyStack = UIStackView()
        StampDutyStack.axis = .horizontal
        StampDutyStack.distribution = .fillEqually
        StampDutyStack.spacing = 10
        
        let CCASSfeeStack = UIStackView()
        CCASSfeeStack.axis = .horizontal
        CCASSfeeStack.distribution = .fillEqually
        CCASSfeeStack.spacing = 10
        
        let HandlingFeeStack = UIStackView()
        HandlingFeeStack.axis = .horizontal
        HandlingFeeStack.distribution = .fillEqually
        HandlingFeeStack.spacing = 10
        
        let StorageFeeStack = UIStackView()
        StorageFeeStack.axis = .horizontal
        StorageFeeStack.distribution = .fillEqually
        StorageFeeStack.spacing = 10
        
        let TotalFeeStack = UIStackView()
        TotalFeeStack.axis = .horizontal
        TotalFeeStack.distribution = .fillEqually
        TotalFeeStack.spacing = 10
        
        let TotalValueStack = UIStackView()
        TotalValueStack.axis = .horizontal
        TotalValueStack.distribution = .fillEqually
        TotalValueStack.spacing = 10
        
        TitleStack.addArrangedSubview(ItemLabel)
        TitleStack.addArrangedSubview(BuyLabel)
        TitleStack.addArrangedSubview(SellLabel)
        
        NetValueStack.addArrangedSubview(NetValue)
        NetValueStack.addArrangedSubview(NetValueBuy)
        NetValueStack.addArrangedSubview(NetValueSell)
        
        BrokerageStack.addArrangedSubview(Brokerage)
        BrokerageStack.addArrangedSubview(BrokerageBuy)
        BrokerageStack.addArrangedSubview(BrokerageSell)
        
        TransactionLevyStack.addArrangedSubview(TransactionLevy)
        TransactionLevyStack.addArrangedSubview(TransactionLevyBuy)
        TransactionLevyStack.addArrangedSubview(TransactionLevySell)
                                                
        SFCTransactionLevyStack.addArrangedSubview(SFCTransactionLevy)
        SFCTransactionLevyStack.addArrangedSubview(SFCTransactionLevyBuy)
        SFCTransactionLevyStack.addArrangedSubview(SFCTransactionLevySell)
        
        StampDutyStack.addArrangedSubview(StampDuty)
        StampDutyStack.addArrangedSubview(StampDutyBuy)
        StampDutyStack.addArrangedSubview(StampDutySell)
        
        CCASSfeeStack.addArrangedSubview(CCASSfee)
        CCASSfeeStack.addArrangedSubview(CCASSfeeBuy)
        CCASSfeeStack.addArrangedSubview(CCASSfeeSell)
        
        HandlingFeeStack.addArrangedSubview(HandlingFee)
        HandlingFeeStack.addArrangedSubview(HandlingFeeBuy)
        HandlingFeeStack.addArrangedSubview(HandlingFeeSell)
        
        StorageFeeStack.addArrangedSubview(StorageFee)
        StorageFeeStack.addArrangedSubview(StorageFeeBuy)
        StorageFeeStack.addArrangedSubview(StorageFeeSell)
        
        TotalFeeStack.addArrangedSubview(TotalFee)
        TotalFeeStack.addArrangedSubview(TotalFeeBuy)
        TotalFeeStack.addArrangedSubview(TotalFeeSell)
        
        TotalValueStack.addArrangedSubview(TotalValue)
        TotalValueStack.addArrangedSubview(TotalValueBuy)
        TotalValueStack.addArrangedSubview(TotalValueSell)
        
        InfoStack.addArrangedSubview(ProfitEquation)
        InfoStack.addArrangedSubview(Profit)
        InfoStack.addArrangedSubview(TitleStack)
        InfoStack.addArrangedSubview(NetValueStack)
        InfoStack.addArrangedSubview(BrokerageStack)
        InfoStack.addArrangedSubview(TransactionLevyStack)
        InfoStack.addArrangedSubview(SFCTransactionLevyStack)
        InfoStack.addArrangedSubview(StampDutyStack)
        InfoStack.addArrangedSubview(CCASSfeeStack)
        InfoStack.addArrangedSubview(HandlingFeeStack)
        InfoStack.addArrangedSubview(StorageFeeStack)
        InfoStack.addArrangedSubview(TotalFeeStack)
        InfoStack.addArrangedSubview(TotalValueStack)
        
        view.addSubview(InfoStack)
    }
    
    @objc func showMenu(_ sender: UIButton){
        Menu.show()
    }
    
    @objc func submitButtonTapped(_ sender: UIButton){
        if firmName != nil || NumberofLotField.text != "" || SellingPriceField.text != "" || BuyingPriceField.text != "" || SharePerLotField.text != ""{
            if validateInput(){
                let userBuy = Double(BuyingPriceField.text!)
                let userSell = Double(SellingPriceField.text!)
                let userShare = Double(SharePerLotField.text!)
                let userLot = Double(NumberofLotField.text!)
                
                if firmName != nil {
                    calculate(company: firmName!, buy:userBuy!, sell:userSell!, share:userShare!, lot:userLot!)
                }else {
                    showMessage(alert: "Missing Bank/Firm", message: "Please choose a bank/firm.")
                }
            }
        }else{
            showMessage(alert: "Missing Information", message: "Please fill in empty textfield.")
        }
    }
    
    func validateInput() -> Bool{
        let PriceSet = CharacterSet(charactersIn: "0123456789.")
        let LotSet = CharacterSet(charactersIn: "0123456789")
        if(BuyingPriceField.text?.rangeOfCharacter(from: PriceSet.inverted) != nil) || (SellingPriceField.text?.rangeOfCharacter(from: PriceSet.inverted) != nil) {
            showMessage(alert: "Invalid Type of Input for Price", message: "Only Positive Numbers are allowed.")
            return false
        }
        if (NumberofLotField.text?.rangeOfCharacter(from: LotSet.inverted) != nil) || (SharePerLotField.text?.rangeOfCharacter(from: LotSet.inverted) != nil){
            showMessage(alert: "Invalid Type of Input for Lot", message: "Only Positive Integer are allowed.")
            return false
        }
        if Double(BuyingPriceField.text!) ?? 0 < 0.001 || Double(BuyingPriceField.text!) ?? 0 > 999{
            showMessage(alert: "Invalid Buying Price", message: "ranging from 0.001 - 999")
            return false
        }
        if Double(SellingPriceField.text!) ?? 0 < 0.001 || Double(SellingPriceField.text!) ?? 0 > 999{
            showMessage(alert: "Invalid Selling Price", message: "ranging from 0.001 - 999")
            return false
        }
        if Int(NumberofLotField.text!) ?? 0 < 1 || Int(NumberofLotField.text!) ?? 0 > 3000 {
            showMessage(alert: "Invalid Number of Lot", message: "ranging from 1 - 3000")
            return false
        }
        if Int(SharePerLotField.text!) ?? 0 < 50 || Int(SharePerLotField.text!) ?? 0 > 99999{
            showMessage(alert: "Invalid Share per Lot", message: "ranging from 50 - 99999")
            return false
        }
        return true
    }
    
    func calculate(company: String, buy: Double, sell: Double, share: Double, lot: Double){
        
        let hkex = ["levy":0.000027, "sfc":0.00005, "stamp": 0.001]
        let hsbc = ["brokerage":0.0025, "brokerageMin": 100, "storage": 5, "storageMin":30, "storageMax": 200, "ccass":0, "ccassMin":0, "ccassMax":0, "handling":0, "handlingMin":0, "handlingMax":0]
        let hengseng = ["brokerage":0.0025, "brokerageMin": 100, "storage": 5, "storageMin":30, "storageMax": 200, "ccass":0, "ccassMin":0, "ccassMax":0, "handling":0, "handlingMin":0, "handlingMax":0]
        let boc = ["brokerage":0.0025, "brokerageMin": 100, "storage": 2.5, "storageMin":30, "storageMax": 200, "ccass":0, "ccassMin":0, "ccassMax":0, "handling":0, "handlingMin":0, "handlingMax":0]
        let futu = ["brokerage":0.0, "brokerageMin": 0, "storage": 0, "storageMin":0, "storageMax": 0, "ccass":0.00002, "ccassMin":2, "ccassMax":100, "handling":15, "handlingMin":0, "handlingMax":0]
        
        var DictforCal = [String:Double]()
        
        if company == "HSBC"{
            DictforCal = hsbc
        }else if company == "Hang Seng Bank"{
            DictforCal = hengseng
        }else if company == "Bank of China"{
            DictforCal = boc
        }else if company == "FUTU"{
            DictforCal = futu
        }else{
            print("company not found")
        }
        
        let ValueBuy:Double
        ValueBuy = buy*share*lot
        let ValueSell:Double
        ValueSell = sell*share*lot
        
        var FeeStorage = DictforCal["storage"]!*lot
        if FeeStorage>DictforCal["storageMax"]!{
            FeeStorage = DictforCal["storageMax"]!
        }else if FeeStorage<DictforCal["storageMin"]!{
            FeeStorage = DictforCal["storageMin"]!
        }
        
        var FeeBrokerageBuy = ValueBuy*DictforCal["brokerage"]!
        if FeeBrokerageBuy < DictforCal["brokerageMin"]! {
            FeeBrokerageBuy = DictforCal["brokerageMin"]!
        }
        
        var FeeBrokerageSell = ValueSell*DictforCal["brokerage"]!
        if FeeBrokerageSell < DictforCal["brokerageMin"]! {
            FeeBrokerageSell = DictforCal["brokerageMin"]!
        }
        
        var FeeCCASSfeeBuy = ValueBuy * DictforCal["ccass"]!
        if  FeeCCASSfeeBuy > DictforCal["ccassMax"]! {
            FeeCCASSfeeBuy = DictforCal["ccassMax"]!
        }else if FeeCCASSfeeBuy < DictforCal["ccassMin"]! {
            FeeCCASSfeeBuy = DictforCal["ccassMin"]!
        }
        
        var FeeCCASSfeeSell = ValueSell * DictforCal["ccass"]!
        if  FeeCCASSfeeSell > DictforCal["ccassMax"]! {
            FeeCCASSfeeSell = DictforCal["ccassMax"]!
        }else if FeeCCASSfeeSell < DictforCal["ccassMin"]! {
            FeeCCASSfeeSell = DictforCal["ccassMin"]!
        }
        
        var FeeHandlingFeeBuy = DictforCal["handling"]!
        
        var FeeHandlingFeeSell = DictforCal["handling"]!
        
        let FeeTotalBuy:Double
        FeeTotalBuy = FeeBrokerageBuy+ValueBuy*hkex["levy"]!+ValueBuy*hkex["sfc"]!+ValueBuy*hkex["stamp"]!+FeeStorage+FeeCCASSfeeBuy+FeeHandlingFeeBuy
        let FeeTotalSell:Double
        FeeTotalSell = FeeBrokerageSell+ValueSell*hkex["levy"]!+ValueSell*hkex["sfc"]!+ValueSell*hkex["stamp"]!+FeeCCASSfeeSell+FeeHandlingFeeSell
        let PercentageChange:Double
        PercentageChange = (ValueSell-FeeTotalSell-FeeTotalBuy-ValueBuy)/(FeeTotalBuy+ValueBuy)*100
        let CalProfit:Double
        CalProfit = ValueSell-FeeTotalSell-FeeTotalBuy-ValueBuy
        
        if CalProfit>0{
            Profit.textColor = .green
        }else{
            Profit.textColor = .red
        }
        
        ProfitEquation.text = "$\(ValueSell-FeeTotalSell) - $\(FeeTotalBuy+ValueBuy)"
        Profit.text = "$" + String(format: "%.2f", CalProfit) + " (" + String(format: "%.2f", PercentageChange)+")%"
        NetValueBuy.text = String(ValueBuy)
        NetValueSell.text = String(ValueSell)
        BrokerageBuy.text = String(FeeBrokerageBuy)
        BrokerageSell.text = String(FeeBrokerageSell)
        TransactionLevyBuy.text = String(round((ValueBuy * hkex["levy"]!)*1000)/1000)
        TransactionLevySell.text = String(round((ValueSell * hkex["levy"]!)*1000)/1000)
        SFCTransactionLevyBuy.text = String(ValueBuy * hkex["sfc"]!)
        SFCTransactionLevySell.text = String(ValueSell * hkex["sfc"]!)
        StampDutyBuy.text = String(ValueBuy * hkex["stamp"]!)
        StampDutySell.text = String(ValueSell * hkex["stamp"]!)
        CCASSfeeBuy.text = String(FeeCCASSfeeBuy)
        CCASSfeeSell.text = String(FeeCCASSfeeSell)
        HandlingFeeBuy.text = String(FeeHandlingFeeBuy)
        HandlingFeeSell.text = String(FeeHandlingFeeSell)
        StorageFeeBuy.text = String(FeeStorage)
        TotalFeeBuy.text = String(round(FeeTotalBuy*1000)/1000)
        TotalFeeSell.text = String(round(FeeTotalSell*1000)/1000)
        TotalValueBuy.text = String(FeeTotalBuy+ValueBuy)
        TotalValueSell.text = String(ValueSell-FeeTotalSell)
    }
    
}
