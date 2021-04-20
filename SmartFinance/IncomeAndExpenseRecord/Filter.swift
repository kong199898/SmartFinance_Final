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
            if type {
                return " Income"
            }else{
                return "Expense"
            }
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
                                    .default(Text("Last week")) { ExpFilter = .week },
                                    .default(Text("Last month")) { ExpFilter = .month },
                                    .default(Text("Overall")) { ExpFilter = .all },
                                    .cancel()
                            ])
                        }
                    ScrollView(showsIndicators: false) {
                        if isTypeIncome != nil {
                            let type = isTypeIncome
                            ExpenseFilterChart(isIncome: type!, filter: ExpFilter).frame(width: 345, height: 345)
                            ExpenseFilterList(isIncome: type!, filter: ExpFilter)
                        }
                        if category != nil {
                            let tag = category
                            HStack(spacing: 9) {
                                ExpenseModel(isExpense: false, filter: ExpFilter, categTag: tag!)
                                ExpenseModel(isExpense: true, filter: ExpFilter, categTag: tag!)
                            }.frame(maxWidth: .infinity)
                            ExpenseFilterList(filter: ExpFilter, tag: tag)
                        }
                        Spacer().frame(height: 145)
                    }.padding(.horizontal, 9).padding(.top, 0)
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
        for i in ExpFetchedResult {
            value = value + i.amount
        }
        return "\(String(format: "%.1f", value))"
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
        if isIncome {
            ExpType = "income"
        }else {
            ExpType = "expense"
        }
        
        if filter != .all {
            var start: NSDate!
            if filter == .month {
                start = Date().LastThirtyDay()! as NSDate
            }
            else if filter == .week {
                start = Date().LastSevenDay()! as NSDate
            }
            ExpFetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [NSSortDescriptor(key: "occuredOn", ascending: false)], predicate: NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@ AND type == %@", start, NSDate(), ExpType))
        } else {
            ExpFetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [NSSortDescriptor(key: "occuredOn", ascending: false)], predicate: NSPredicate(format: "type == %@", ExpType))
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
            if filter == .month {
                start = Date().LastThirtyDay()! as NSDate
            }
            else if filter == .week {
                start = Date().LastSevenDay()! as NSDate
            }
            if let tag = tag {
                ExpFetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [sortDescriptor], predicate: NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@ AND tag == %@", start, NSDate(), tag))
            }
            else if let isIncome = isIncome {
                ExpFetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [sortDescriptor], predicate: NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@ AND type == %@", start, NSDate(), (isIncome ? "income" : "expense")))
            }
            else {
                ExpFetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [sortDescriptor], predicate: NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@", start, NSDate()))
            }
        } else {
            if let tag = tag {
                ExpFetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [sortDescriptor], predicate: NSPredicate(format: "tag == %@", tag))
            }
            else if let isIncome = isIncome {
                ExpFetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [sortDescriptor], predicate: NSPredicate(format: "type == %@", (isIncome ? "income" : "expense")))
            }
            else {
                ExpFetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [sortDescriptor], predicate: NSPredicate(format: "occuredOn <= %@", NSDate()))
            }
            
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
        dataSet.valueFont = UIFont.init(name: "Inter-Bold", size: 16) ?? .systemFont(ofSize: 16, weight: .bold)
        dataSet.entryLabelFont = UIFont.init(name: "Inter-Light", size: 12)
        dataSet.colors = [UIColor(hex: "#F8AB10")] + [UIColor(hex: "#7321DD")] + [UIColor(hex: "#2DB1F4")] +
                            [UIColor(hex: "#D31869")] + [UIColor(hex: "#EB5B3B")] + [UIColor(hex: "#FAB4F7")] +
                            [UIColor(hex: "#DDCE2F")] + [UIColor(hex: "#1EA300")] + [UIColor(hex: "#606833")]
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
