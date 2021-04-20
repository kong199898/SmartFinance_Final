import UIKit
import CoreData

class DetailCashFlowViewController: UIViewController {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let contentViewSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+500)
    
    var scrollView = UIScrollView()
    var AgeStack = UIStackView()
    var valueStack = UIStackView()
    var IncomeStack = UIStackView()
    var SpendingStack = UIStackView()
    var CashFlowStack = UIStackView()
    let defaults = UserDefaults()
    
    var currAge = 0
    var assumptAge = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadCoreData()
        createTable()
        addDetails()
    }
    
    func loadCoreData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            let fetch = try context.fetch(TheAssumption.fetchRequest())
            for i in fetch as! [NSManagedObject]{
                currAge = (defaults.value(forKey: "UserAge")) as! Int
                assumptAge = Int(i.value(forKey: "life") as! Int64)
            }
        }catch{
            print("error wor")
        }
        
        print("\(currAge), \(assumptAge)" )
        
    }
    
    func createTable(){
        scrollView = UIScrollView(frame: .zero)
        scrollView.contentSize = contentViewSize
        scrollView.frame = UIScreen.main.bounds
        scrollView.backgroundColor = .black
        
        let TitleLabel = UILabel(frame: CGRect(x: screenWidth*0.05,
                                               y: screenHeight*0.05,
                                               width: screenWidth*0.9,
                                               height: screenHeight*0.05))
        TitleLabel.text = "Detailed Cash Flow Table"
        TitleLabel.textColor = .white
        TitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        
        let OuterStack = UIStackView()
        OuterStack.axis = .horizontal
        OuterStack.distribution = .fillProportionally
        OuterStack.backgroundColor = UIColor(red: 33/255, green: 33/255, blue: 33/255, alpha: 1)
        OuterStack.spacing = 5
        OuterStack.frame = CGRect(x: screenWidth*0.05,
                                  y: screenHeight*0.05+screenHeight*0.06,
                                  width: screenWidth*0.9,
                                  height: UIScreen.main.bounds.height + 500 - screenHeight*0.05)
        
        AgeStack = UIStackView()
        AgeStack.axis = .vertical
        AgeStack.distribution = .fillEqually
        AgeStack.spacing = 5
        
        let AgeLabel = UILabel()
        AgeLabel.text = "Age"
        AgeLabel.textColor = .white
        
        valueStack = UIStackView()
        valueStack.axis = .vertical
        valueStack.distribution = .fillEqually
        valueStack.spacing = 5
        
        let valueLabel = UILabel()
        valueLabel.text = "Portfolio\nValue"
        valueLabel.textColor = .white
        valueLabel.numberOfLines = 0
        valueLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        IncomeStack = UIStackView()
        IncomeStack.axis = .vertical
        IncomeStack.distribution = .fillEqually
        IncomeStack.spacing = 5
        
        let IncomeLabel = UILabel()
        IncomeLabel.text = "Income\nEvents"
        IncomeLabel.textColor = .white
        IncomeLabel.numberOfLines = 0
        IncomeLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        SpendingStack = UIStackView()
        SpendingStack.axis = .vertical
        SpendingStack.distribution = .fillEqually
        SpendingStack.spacing = 5
        
        let SpendingLabel = UILabel()
        SpendingLabel.text = "Spending\nGoals"
        SpendingLabel.textColor = .white
        SpendingLabel.numberOfLines = 0
        SpendingLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        CashFlowStack = UIStackView()
        CashFlowStack.axis = .vertical
        CashFlowStack.distribution = .fillEqually
        CashFlowStack.spacing = 5
        
        let CashFlowLabel = UILabel()
        CashFlowLabel.text = "Cash\nFlow"
        CashFlowLabel.textColor = .white
        CashFlowLabel.numberOfLines = 0
        CashFlowLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        OuterStack.addArrangedSubview(AgeStack)
        OuterStack.addArrangedSubview(valueStack)
        OuterStack.addArrangedSubview(IncomeStack)
        OuterStack.addArrangedSubview(SpendingStack)
        OuterStack.addArrangedSubview(CashFlowStack)
        
        AgeStack.addArrangedSubview(AgeLabel)
        valueStack.addArrangedSubview(valueLabel)
        IncomeStack.addArrangedSubview(IncomeLabel)
        SpendingStack.addArrangedSubview(SpendingLabel)
        CashFlowStack.addArrangedSubview(CashFlowLabel)
        
        scrollView.addSubview(TitleLabel)
        scrollView.addSubview(OuterStack)
        
        view.addSubview(scrollView)
    }
    
    func addDetails(){
        let CurrAge = 40
        let LifeExpectancy = 90
        
        for i in 0 ... LifeExpectancy-CurrAge{
            addView(age: CurrAge+i, income:120000, spending:40000, i: i)
        }
    }
    
    func addView(age: Int, income: Int, spending: Int, i: Int) -> Void{
        
        var AgeDetailLabel = UILabel()
        var ValueLabel = UILabel()
        var IncomeDetailLabel = UILabel()
        var SpendingDetailLabel = UILabel()
        var CashFlowDetailLabel = UILabel()
        
        AgeDetailLabel.text = "\(age)"
        ValueLabel.text = "\((income-spending)*(i+1))"
        IncomeDetailLabel.text = "\(income)"
        SpendingDetailLabel.text = "\(spending)"
        CashFlowDetailLabel.text = "\(income-spending)"
        
        AgeDetailLabel.textColor = .white
        ValueLabel.textColor = .white
        IncomeDetailLabel.textColor = .white
        SpendingDetailLabel.textColor = .white
        CashFlowDetailLabel.textColor = .white
        
        AgeStack.addArrangedSubview(AgeDetailLabel)
        valueStack.addArrangedSubview(ValueLabel)
        IncomeStack.addArrangedSubview(IncomeDetailLabel)
        SpendingStack.addArrangedSubview(SpendingDetailLabel)
        CashFlowStack.addArrangedSubview(CashFlowDetailLabel)
    }
    
}
