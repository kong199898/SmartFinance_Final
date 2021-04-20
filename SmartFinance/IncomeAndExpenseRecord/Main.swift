import SwiftUI
import MaterialComponents.MaterialDialogs

struct ExpenseView: View {
    @State private var filter: ExpenseFilter = .all
    @State private var showFilter:Bool = false
    @State private var showSetting:Bool = false
    @State private var hideNavigationBar:Bool = true
    @Environment(\.presentationMode) var Mode: Binding<PresentationMode>
    @FetchRequest(fetchRequest: ExpenseCD.getAllExpense(sort: ExpenseSort.occuredOn, order: false)) var expense: FetchedResults<ExpenseCD>
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Primary").edgesIgnoringSafeArea(.all)
                VStack {
                    NavigationLink(destination: LazyView(ExpenseSettingsView()), isActive: $showSetting, label: {})
                    Toolbar(title: "Expense", BackButt: false, FirstIcon: "setting_icon", SecondIcon: "filter_icon", ThirdIcon: "back_arrow") { self.Mode.wrappedValue.dismiss() }
                        button1Method: { showSetting = true }
                        button2Method: { showFilter = true }
                        button3Method: {
                            hideNavigationBar = false
                            self.Mode.wrappedValue.dismiss()
                        }
                        .actionSheet(isPresented: $showFilter) {
                            ActionSheet(title: Text("Select a filter"), buttons: [
                                    .default(Text("Overall")) { filter = .all },
                                    .default(Text("Last week")) { filter = .week },
                                    .default(Text("Last month")) { filter = .month },
                                    .cancel()
                            ])
                        }
                    ExpenseMain(filter: filter)
                    Spacer()
                }.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: LazyView(AddExpenseView(AddExpenseModelView: AddExpenseModel())),
                                       label: { Image("add_icon").resizable().frame(width: 32.0, height: 32.0) })
                        .padding().background(Color("Main")).cornerRadius(35)
                    }
                }.padding()
            }
            .navigationBarHidden(hideNavigationBar)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(hideNavigationBar)
        .navigationBarBackButtonHidden(hideNavigationBar)
    }
}

struct ExpenseMain: View {
    var ExpFilter: ExpenseFilter
    var ExpFetchRequest: FetchRequest<ExpenseCD>
    var ExpFecthResult: FetchedResults<ExpenseCD> { ExpFetchRequest.wrappedValue }
    @AppStorage(Currency) var CURRENCY: String = ""
    
    init(filter: ExpenseFilter) {
        let sortDescriptor = NSSortDescriptor(key: "occuredOn", ascending: false)
        self.ExpFilter = filter
        if filter != .all {
            var startDate: NSDate!
            let endDate: NSDate = NSDate()
            if filter == .week { startDate = Date().LastSevenDay()! as NSDate }
            else if filter == .month { startDate = Date().LastThirtyDay()! as NSDate }
            else { startDate = Date().LastSixMonth()! as NSDate }
            let predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@", startDate, endDate)
            ExpFetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [sortDescriptor], predicate: predicate)
        } else {
            ExpFetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [sortDescriptor])
        }
    }
    
    private func getBalance() -> String {
        var value = Double(0)
        for e in ExpFecthResult {
            if e.type == "expense" {
                value -= e.amount
            }
            else if e.type == "income" {
                value += e.amount
            }
        }
        return "\(String(format: "%.2f", value))"
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if !ExpFetchRequest.wrappedValue.isEmpty {
                VStack(spacing: 16) {
                    TextView(text: "TOTAL BALANCE", type: .overline).foregroundColor(Color("GreyText")).padding(.top, 30)
                    TextView(text: "\(CURRENCY)\(getBalance())", type: .h5).foregroundColor(Color("PrimaryText")).padding(.bottom, 30)
                }.frame(maxWidth: .infinity).background(Color("Secondary")).cornerRadius(4)
                
                HStack(spacing: 8) {
                    NavigationLink(destination: LazyView(ExpenseFilterView(isIncome: true)),
                                   label: { ExpenseModel(isExpense: false, filter: ExpFilter) })
                    NavigationLink(destination: LazyView(ExpenseFilterView(isIncome: false)),
                                   label: { ExpenseModel(isExpense: true, filter: ExpFilter) })
                }.frame(maxWidth: .infinity)
                
                Spacer().frame(height: 16)
                
                HStack {
                    TextView(text: "Recent Transaction", type: .subtitle_1).foregroundColor(Color("PrimaryText"))
                    Spacer()
                }.padding(4)
                
                ForEach(self.ExpFetchRequest.wrappedValue) { object in
                    NavigationLink(destination: ExpenseDetailView(ExpenseDB: object), label: { ExpenseTransaction(ExpObject: object) })
                }
            } else {
                LottieView(AnimateType: .cross).frame(width: 300, height: 300)
                VStack {
                    TextView(text: "No Transaction!", type: .h6).foregroundColor(Color("PrimaryText"))
                }.padding(.horizontal)
            }
            Spacer().frame(height: 150)
        }.padding(.horizontal, 8).padding(.top, 0)
    }
}

struct ExpenseModel: View {
    var isExpense: Bool
    var type: String
    var ExpFetchRequest: FetchRequest<ExpenseCD>
    var ExpFecthResult: FetchedResults<ExpenseCD> { ExpFetchRequest.wrappedValue }
    @AppStorage(Currency) var CURRENCY: String = ""
    
    private func getTotalValue() -> String {
        var value = Double(0)
        for i in ExpFecthResult { value += i.amount }
        return "\(String(format: "%.2f", value))"
    }
    
    init(isExpense: Bool, filter: ExpenseFilter, categTag: String? = nil) {
        self.isExpense = isExpense
        if isExpense{
            type = "expense"
        }else{
            type = "income"
        }
        let sortDescriptor = NSSortDescriptor(key: "occuredOn", ascending: false)
        
        if filter != .all {
            var startDate: NSDate!
            let endDate: NSDate = NSDate()
            if filter == .week { startDate = Date().LastSevenDay()! as NSDate }
            else if filter == .month { startDate = Date().LastThirtyDay()! as NSDate }
            else { startDate = Date().LastSixMonth()! as NSDate }
            var predicate: NSPredicate!
            if let tag = categTag {
                predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@ AND type == %@ AND tag == %@", startDate, endDate, type, tag)
            } else { predicate = NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@ AND type == %@", startDate, endDate, type) }
            ExpFetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [sortDescriptor], predicate: predicate)
        } else {
            var predicate: NSPredicate!
            if let tag = categTag {
                predicate = NSPredicate(format: "type == %@ AND tag == %@", type, tag)
            } else { predicate = NSPredicate(format: "type == %@", type) }
            ExpFetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [sortDescriptor], predicate: predicate)
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Spacer()
            }
            HStack{
                TextView(text: isExpense ? "EXPENSE" : "INCOME", type: .overline).foregroundColor(Color("GreyText"))
                Spacer()
            }.padding(.horizontal, 12)
            HStack {
                TextView(text: "\(CURRENCY)\(getTotalValue())", type: .h5).foregroundColor(Color("PrimaryText"))
                Spacer()
            }.padding(.horizontal, 12)
        }.padding(.bottom, 12).background(Color("Secondary")).cornerRadius(4)
    }
}

struct ExpenseTransaction: View {
    @AppStorage(Currency) var CURRENCY: String = ""
    @ObservedObject var ExpObject: ExpenseCD
    
    var body: some View {
        HStack {
            NavigationLink(destination: LazyView(ExpenseFilterView(Tag: ExpObject.tag)), label: {
                Image(getTransactionIcon(Tag: ExpObject.tag ?? ""))
                    .resizable().frame(width: 24, height: 24).padding(16)
                    .background(Color("Primary")).cornerRadius(4)
            })
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    TextView(text: ExpObject.title ?? "", type: .subtitle_1).foregroundColor(Color("PrimaryText"))
                    Spacer()
                    TextView(text: "\(ExpObject.type == "income" ? "+" : "-")\(CURRENCY)\(ExpObject.amount)", type: .subtitle_1)
                        .foregroundColor(ExpObject.type == "income" ? Color(UIColor(red: 109/255, green: 205/255, blue: 149/255, alpha: 1.0)) : Color(UIColor(red: 233/255, green: 85/255, blue: 85/255, alpha: 1.0)))
                }
                HStack {
                    TextView(text: getTransactionTitle(Tag: ExpObject.tag ?? ""), type: .body_2).foregroundColor(Color("PrimaryText"))
                    Spacer()
                    TextView(text: DateFormatter(date: ExpObject.occuredOn, format: "MMM dd, yyyy"), type: .body_2).foregroundColor(Color("PrimaryText"))
                }
            }.padding(.leading, 4)
            Spacer()
        }.padding(8).background(Color("Secondary")).cornerRadius(4)
    }
}

struct ExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseView()
    }
}
