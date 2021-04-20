import SwiftUI
import Charts

struct ExpenseFilterView: View {
    var isTypeIncome: Bool?
    var category: String?
    @State var ExpFilter: ExpenseFilter = .all
    @State var showActionSheet:Bool = false
    @State var shownavigationbar:Bool = true
    @Environment(\.presentationMode) var Mode: Binding<PresentationMode>
    
    init(isIncome: Bool? = nil, Tag: String? = nil) {
        isTypeIncome = isIncome
        category = Tag
    }
    
    func getTitle() -> String {
        if let type = isTypeIncome {
            return type ? "Income" : "Expense"
        } else if let tag = category {
            return getTransactionTitle(Tag: tag)
        }
        return "Expense"
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Primary").edgesIgnoringSafeArea(.all)
                VStack {
                    Toolbar(title: getTitle(), FirstIcon: "filter_icon") { self.Mode.wrappedValue.dismiss() }
                        button1Method: { showActionSheet = true }
                        .actionSheet(isPresented: $showActionSheet) {
                            ActionSheet(title: Text("Select a filter"), buttons: [
                                    .default(Text("Overall")) { ExpFilter = .all },
                                    .default(Text("Last week")) { ExpFilter = .week },
                                    .default(Text("Last month")) { ExpFilter = .month },
                                    .cancel()
                            ])
                        }
                    ScrollView(showsIndicators: false) {
                        if let type = isTypeIncome {
                            ExpenseFilterChart(isIncome: type, filter: ExpFilter).frame(width: 350, height: 350)
                            ExpenseFilterList(isIncome: type, filter: ExpFilter)
                        }
                        if let tag = category {
                            HStack(spacing: 8) {
                                ExpenseModel(isExpense: false, filter: ExpFilter, categTag: tag)
                                ExpenseModel(isExpense: true, filter: ExpFilter, categTag: tag)
                            }.frame(maxWidth: .infinity)
                            ExpenseFilterList(filter: ExpFilter, tag: tag)
                        }
                        Spacer().frame(height: 150)
                    }.padding(.horizontal, 8).padding(.top, 0)
                    Spacer()
                }.edgesIgnoringSafeArea(.all)
            }
            .navigationBarHidden(shownavigationbar)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(shownavigationbar)
        .navigationBarBackButtonHidden(shownavigationbar)
    }
}


struct ExpenseFilterChart: View {
    var isTypeIncome: Bool
    var ExpType: String
    var ExpFetchRequest: FetchRequest<ExpenseCD>
    var ExpFetchedResult: FetchedResults<ExpenseCD> { ExpFetchRequest.wrappedValue }
    @AppStorage(Currency) var CURRENCY: String = ""
    
    private func getValue() -> String {
        var value = Double(0)
        for i in ExpFetchedResult { value += i.amount }
        return "\(String(format: "%.2f", value))"
    }
    
    private func getChartModel() -> [ChartModel] {
        var transactions = [String: Double]()
        for e in ExpFetchedResult {
            guard let tag = e.tag else { continue }
            if let value = transactions[tag] {
                transactions[tag] = value + e.amount
            } else { transactions[tag] = e.amount }
        }
        var models = [ChartModel]()
        for t in transactions {
            models.append(ChartModel(transactionType: getTransactionTitle(Tag: t.key), transactionAmount: t.value))
        }
        return models
    }
    
    init(isIncome: Bool, filter: ExpenseFilter) {
        isTypeIncome = isIncome
        ExpType = isIncome ? "income" : "expense"
        let sortDescriptor = NSSortDescriptor(key: "occuredOn", ascending: false)
        
        if filter != .all {
            var start: NSDate!
            let end: NSDate = NSDate()
            if filter == .month {
                start = Date().LastThirtyDay()! as NSDate
            }
            else if filter == .week {
                start = Date().LastSevenDay()! as NSDate
            }
            else {
                start = Date().LastSixMonth()! as NSDate
            }
            let predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@ AND type == %@", start, end, ExpType)
            ExpFetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [sortDescriptor], predicate: predicate)
        } else {
            let predicate = NSPredicate(format: "type == %@", ExpType)
            ExpFetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [sortDescriptor], predicate: predicate)
        }
    }
    
    var body: some View {
        Group {
            if !ExpFetchedResult.isEmpty {
                Chart(label: "Total \(isTypeIncome ? "Income" : "Expense") - \(CURRENCY)\(getValue())",
                          entries: ChartModel.getTransaction(transactions: getChartModel()))
            }
        }
    }
}

struct ExpenseFilterList: View {
    var ExpFetchRequest: FetchRequest<ExpenseCD>
    var ExpFetchedResult: FetchedResults<ExpenseCD> { ExpFetchRequest.wrappedValue }
    
    init(isIncome: Bool? = nil, filter: ExpenseFilter, tag: String? = nil) {
        let sortDescriptor = NSSortDescriptor(key: "occuredOn", ascending: false)
        if filter != .all {
            var start: NSDate!
            let end: NSDate = NSDate()
            if filter == .month {
                start = Date().LastThirtyDay()! as NSDate
            }
            else if filter == .week {
                start = Date().LastSevenDay()! as NSDate
            }
            else {
                start = Date().LastSixMonth()! as NSDate
            }
            let predicate: NSPredicate!
            if let tag = tag {
                predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@ AND tag == %@", start, end, tag)
            }
            else if let isIncome = isIncome {
                predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@ AND type == %@", start, end, (isIncome ? "income" : "expense"))
            }
            else {
                predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@", start, end)
            }
            ExpFetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [sortDescriptor], predicate: predicate)
        } else {
            let predicate: NSPredicate!
            if let tag = tag {
                predicate = NSPredicate(format: "tag == %@", tag)
            }
            else if let isIncome = isIncome {
                predicate = NSPredicate(format: "type == %@", (isIncome ? "income" : "expense"))
            }
            else { predicate = NSPredicate(format: "occuredOn <= %@", NSDate()) }
            ExpFetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [sortDescriptor], predicate: predicate)
        }
    }
    var body: some View {
        ForEach(self.ExpFetchRequest.wrappedValue) { object in
            NavigationLink(destination: ExpenseDetailView(ExpenseDB: object), label: { ExpenseTransaction(ExpObject: object) })
        }
    }
}

struct ExpenseFilterView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseFilterView(isIncome: true)
    }
}

struct Chart: UIViewRepresentable {
    var label: String
    var entries: [PieChartDataEntry]
    
    func makeUIView(context: Context) -> PieChartView {
        let pieChartView = PieChartView()
        pieChartView.holeColor = UIColor(named: "Primary")
        return pieChartView
    }
    
    func updateUIView(_ uiView: PieChartView, context: Context) {
        let dataSet = PieChartDataSet(entries: entries, label: label)
        dataSet.valueFont = UIFont.init(name: "Inter-Bold", size: 18) ?? .systemFont(ofSize: 18, weight: .bold)
        dataSet.entryLabelFont = UIFont.init(name: "Inter-Light", size: 14)
        dataSet.colors = [UIColor(hex: "#DD222D")] + [UIColor(hex: "#F9AA07")] + [UIColor(hex: "#7220DC")] + [UIColor(hex: "#1DB0F3")] +
                            [UIColor(hex: "#D21667")] + [UIColor(hex: "#EC5B2A")] + [UIColor(hex: "#FADFB4")] +
                            [UIColor(hex: "#CCCF2E")] + [UIColor(hex: "#E1C10C")] + [UIColor(hex: "#716942")]
        uiView.data = PieChartData(dataSet: dataSet)
    }
}

struct ChartModel {
    var transactionType: String
    var transactionAmount: Double
    
    static func getTransaction(transactions: [ChartModel]) -> [PieChartDataEntry] {
        return transactions.map { PieChartDataEntry(value: $0.transactionAmount, label: $0.transactionType) }
    }
}
