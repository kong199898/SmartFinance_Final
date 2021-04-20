import UIKit
import CoreData

class DetailsTableViewController: UITableViewController {

    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let defaults = UserDefaults()
    
    var DetailsList:[DetailsData] = [
        DetailsData(Age: "Age", Portfolio: "Portfolio", Income: "Income", Spending: "Spending", Cashflow: "Cashflow")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        getAllData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DetailsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RetirementCell", for: indexPath) as! DetailsTableViewCell
        
        cell.age.text = DetailsList[indexPath.row].Age
        cell.portfolio.text = DetailsList[indexPath.row].Portfolio
        cell.income.text = DetailsList[indexPath.row].Income
        cell.spending.text = DetailsList[indexPath.row].Spending
        cell.cashflow.text = DetailsList[indexPath.row].Cashflow
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight*0.04
    }
    
    func getAllData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        var currAge = 0
        var retireAge = 0
        var assumptAge = 0
        var yearlyEarning = 0
        
        var portfolio = [Int]()
        var income = [Int]()
        var spending = [Int]()
        var cashflow = [Int]()
        
        do{
            let Fetch_Profile =  try context.fetch(TheProfile.fetchRequest())
            for p in Fetch_Profile as! [NSManagedObject]{
                yearlyEarning = Int(p.value(forKey: "earning") as! Int64)
            }
            
            let Fetch_Assumption = try context.fetch(TheAssumption.fetchRequest())
            for a in Fetch_Assumption as! [NSManagedObject]{
                currAge = (defaults.value(forKey: "UserAge")) as! Int
                retireAge = Int(a.value(forKey: "retirement") as! Int64)
                assumptAge = Int(a.value(forKey: "life") as! Int64)
            }
            
            for age in currAge ... assumptAge{
                income.append(yearlyEarning)
                portfolio.append(0)
                spending.append(0)
                cashflow.append(0)
            }
            
            let Fetch_Income = try context.fetch(TheIncomeEvent.fetchRequest())
            for i in Fetch_Income as! [NSManagedObject]{
                var type:String?
                var frequency:String?
                var amount:Int?
                var startingage:Int?
                var other:String?
                type = i.value(forKey: "type") as! String
                if type == "Annuity Income" || type == "Pension Income" || type == "Rental Income" || type == "Other Income"{
                    amount = Int(i.value(forKey: "amount") as! Int64)
                    frequency = i.value(forKey: "frequency") as! String
                    startingage = Int(i.value(forKey: "startingage") as! Int64)
                    if frequency == "Once"{
                        income[startingage!-currAge] += amount!
                    }else if frequency == "Every Month"{
                        for age in startingage! ... assumptAge{
                            income[age-currAge] += amount! * 12
                        }
                    }else if frequency == "Every Year"{
                        for age in startingage! ... assumptAge{
                            income[age-currAge] += amount!
                        }
                    }else{
                        print("cannot find frequency \(frequency)")
                    }
                }else if type == "Sale of Property/Downsize"{
                    amount = Int(i.value(forKey: "amount") as! Int64)
                    startingage = Int(i.value(forKey: "startingage") as! Int64)
                    income[startingage!-currAge] += amount!
                }else if type == "Work During Retirement"{
                    amount = Int(i.value(forKey: "amount") as! Int64)
                    startingage = Int(i.value(forKey: "startingage") as! Int64)
                    other = i.value(forKey: "other") as! String
                    for age in 1 ... Int(other!)!{
                        income[startingage!-currAge+age-1] += amount!
                    }
                }else{
                    print("Error, do not have \(type)")
                }
            }
            
            let Fetch_Spending = try context.fetch(TheSpendingGoal.fetchRequest())
            for s in Fetch_Spending as! [NSManagedObject]{
                var type:String?
                var frequency:String?
                var amount:Int?
                var startingage:Int?
                var other:String?
                type = s.value(forKey: "type") as! String
                if type == "Health Care" || type == "Charity/Gift" || type == "Vacation" || type == "Other Expense"{
                    amount = Int(s.value(forKey: "amount") as! Int64)
                    frequency = s.value(forKey: "frequency") as! String
                    startingage = Int(s.value(forKey: "startingage") as! Int64)
                    if frequency == "Once"{
                        spending[startingage!-currAge] += amount!
                    }else if frequency == "Every Month"{
                        for age in startingage! ... assumptAge{
                            spending[age-currAge] += amount! * 12
                        }
                    }else if frequency == "Every Year"{
                        for age in startingage! ... assumptAge{
                            spending[age-currAge] += amount!
                        }
                    }else{
                        showMessage(alert: "Error", message: "frequency does not match")
                    }
                }else if type == "Vehicle" || type == "Home Purchase/Upgrade"{
                    amount = Int(s.value(forKey: "amount") as! Int64)
                    startingage = Int(s.value(forKey: "startingage") as! Int64)
                    spending[startingage!-currAge] += amount!
                }else {
                    showMessage(alert: "Error", message: "type does not match")
                }
            }
            
            var count = 0
            for age in currAge ... assumptAge{
                if count == 0 { portfolio[count] = income[count] }
                else { portfolio[count] = portfolio[count-1] + income[count] }
                cashflow[count] = income[count] - spending[count]
                DetailsList.append(DetailsData(Age: String(age), Portfolio: String(portfolio[count]), Income: String(income[count]), Spending: String(spending[count]), Cashflow: String(cashflow[count])))
                count += 1
            }
        }
        catch{
            showMessage(alert: "Error", message: "failed to fetch data")
        }
    }
    
}
