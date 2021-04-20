import Foundation

class DetailsData{
    var Age = ""
    var Portfolio = ""
    var Income = ""
    var Spending = ""
    var Cashflow = ""
    
    init(Age: String, Portfolio: String, Income: String, Spending: String, Cashflow: String) {
        self.Age = Age
        self.Portfolio = Portfolio
        self.Income = Income
        self.Spending = Spending
        self.Cashflow = Cashflow
    }
}
