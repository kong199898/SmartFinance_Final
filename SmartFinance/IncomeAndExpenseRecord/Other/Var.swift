import Foundation

let Currency = "expenseCurrency"
let CurrencyList = ["$", "€", "¥", "£"]

func DateFormatter(date: Date?, format: String = "yyyy-MM-dd") -> String {
    guard let date = date else { return "" }
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: date)
}

func getTransactionIcon(Tag: String) -> String {
    if Tag == "transport"{return "transport_icon"}
    else if Tag == "food"{return "food_icon"}
    else if Tag == "housing"{return "housing_icon"}
    else if Tag == "insurance"{return "insurance_icon"}
    else if Tag == "medical"{return "medicial_icon"}
    else if Tag == "salary"{return "salary_icon"}
    else if Tag == "personal"{return "personal_icon"}
    else if Tag == "entertainment"{return "entertainment_icon"}
    else {return "other_icon"}
}

func getTransactionTitle(Tag: String) -> String {
    if Tag == "transport"{return "Transport"}
    else if Tag == "food"{return "Food"}
    else if Tag == "housing"{return "Housing"}
    else if Tag == "insurance"{return "Insurance"}
    else if Tag == "medical"{return "Medical"}
    else if Tag == "salary"{return "Salary"}
    else if Tag == "personal"{return "Personal"}
    else if Tag == "entertainment"{return "Entertainment"}
    else {return "Others"}

}
