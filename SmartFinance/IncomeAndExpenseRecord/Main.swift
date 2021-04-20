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
    var showView:Bool = true
    var ExpFilter: ExpenseFilter
    var ExpFetchRequest: FetchRequest<ExpenseCD>
    var ExpFecthResult: FetchedResults<ExpenseCD> { ExpFetchRequest.wrappedValue }
    @AppStorage(Currency) var CURRENCY: String = ""
    
    init(filter: ExpenseFilter) {
        if filter != .all {
            var start: NSDate!
            if filter == .month {
                start = Date().LastThirtyDay()! as NSDate
            }
            else if filter == .week {
                start = Date().LastSevenDay()! as NSDate
            }
            ExpFetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(),
                                                      sortDescriptors: [NSSortDescriptor(key: "occuredOn", ascending: false)],
                                                      predicate: NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@", start, NSDate()))
        } else {
            ExpFetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [NSSortDescriptor(key: "occuredOn", ascending: false)])
        }
        self.ExpFilter = filter
    }
    
    private func getBalance() -> String {
        var value:Double = 0
        for e in ExpFecthResult {
            if e.type == "expense" {
                value = value - e.amount
            }
            else if e.type == "income" {
                value = value + e.amount
            }
        }
        let valueString = String(format: "%.1f", value)
        return valueString
    }
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            if !ExpFetchRequest.wrappedValue.isEmpty {
                VStack(spacing: 15) {
                    MyText(text: "BALANCE", type: .overline).foregroundColor(Color("GreyText")).padding(.top, 25)
                    MyText(text: "\(CURRENCY)\(getBalance())", type: .h5).foregroundColor(Color("PrimaryText")).padding(.bottom, 25)
                }.frame(maxWidth: .infinity).background(Color("Secondary")).cornerRadius(4)
                
                HStack(spacing: 7) {
                    if showView {
                        NavigationLink(destination: LazyView(ExpenseFilterView(isIncome: true)),
                                       label: { ExpenseModel(isExpense: false, filter: ExpFilter) })
                        NavigationLink(destination: LazyView(ExpenseFilterView(isIncome: false)),
                                       label: { ExpenseModel(isExpense: true, filter: ExpFilter) })
                    }
                }.frame(maxWidth: .infinity)
                Spacer()
                HStack {
                    MyText(text: "Recent Transaction", type: .subtitle_1).foregroundColor(Color("PrimaryText"))
                    Spacer()
                }.padding(2)
                
                ForEach(ExpFetchRequest.wrappedValue) { object in
                    NavigationLink(destination: ExpenseDetailView(ExpenseDB: object), label: { ExpenseTransaction(ExpObject: object) })
                }
            } else {
                LottieView(AnimateType: .cross).frame(width: 290, height: 290)
                VStack {
                    MyText(text: "No Transaction!", type: .h5).foregroundColor(Color("PrimaryText"))
                }.padding(.horizontal)
            }
            Spacer()
        }.padding(.horizontal, 6)
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
        for i in ExpFecthResult {
            value = value + i.amount
        }
        return "\(String(format: "%.1f", value))"
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
            var start: NSDate!
            if filter == .week {
                start = Date().LastSevenDay()! as NSDate
            }
            else if filter == .month {
                start = Date().LastThirtyDay()! as NSDate
            }
            if let tag = categTag {
                ExpFetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [sortDescriptor], predicate: NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@ AND type == %@ AND tag == %@", start, NSDate(), type, tag))
            } else {
                ExpFetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [sortDescriptor], predicate: NSPredicate(format: "occuredOn >= %@ AND occuredOn <= %@ AND type == %@", start, NSDate(), type))
            }
        } else {
            if let tag = categTag {
                ExpFetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [sortDescriptor], predicate: NSPredicate(format: "type == %@ AND tag == %@", type, tag))
            } else {
                ExpFetchRequest = FetchRequest<ExpenseCD>(entity: ExpenseCD.entity(), sortDescriptors: [sortDescriptor], predicate: NSPredicate(format: "type == %@", type))
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer()
            }
            HStack{
                if isExpense {
                    MyText(text: "INCOME", type: .overline).foregroundColor(Color("GreyText"))
                }else{
                    MyText(text: "EXPENSE", type: .overline).foregroundColor(Color("GreyText"))
                }
                Spacer()
            }.padding(.horizontal, 10)
            HStack {
                MyText(text: "\(CURRENCY)\(getTotalValue())", type: .h5).foregroundColor(Color("PrimaryText"))
                Spacer()
            }.padding(.horizontal, 10)
        }.padding(.bottom, 10).background(Color("Secondary")).cornerRadius(2)
    }
}

struct ExpenseTransaction: View {
    @AppStorage(Currency) var CURRENCY: String = ""
    @ObservedObject var ExpObject: ExpenseCD
    
    var body: some View {
        HStack {
            NavigationLink(destination: LazyView(ExpenseFilterView(Tag: ExpObject.tag)), label: {
                Image(getTransactionIcon(Tag: ExpObject.tag ?? ""))
                    .resizable().frame(width: 25, height: 25).padding(15)
                    .background(Color("Primary")).cornerRadius(2)
            })
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    MyText(text: ExpObject.title ?? "", type: .subtitle_1).foregroundColor(Color("PrimaryText"))
                    Spacer()
                    if ExpObject.type == "income" {
                        MyText(text: "\("+")\(CURRENCY)\(ExpObject.amount)", type: .subtitle_1)
                            .foregroundColor(Color(UIColor(red: 109/255, green: 205/255, blue: 149/255, alpha: 1.0)))
                    }else{
                        MyText(text: "\("-")\(CURRENCY)\(ExpObject.amount)", type: .subtitle_1)
                            .foregroundColor(Color(UIColor(red: 233/255, green: 85/255, blue: 85/255, alpha: 1.0)))
                    }
                }
                HStack {
                    if ExpObject.tag != nil {
                        MyText(text: getTransactionTitle(Tag: ExpObject.tag!), type: .body_2).foregroundColor(Color("PrimaryText"))
                    }else{
                        MyText(text: "", type: .body_2).foregroundColor(Color("PrimaryText"))
                    }
                    Spacer()
                    MyText(text: DateFormatter(date: ExpObject.occuredOn, format: "E, dd MMMM yyyy"), type: .body_2).foregroundColor(Color("PrimaryText"))
                }
            }.padding(.leading, 2)
            Spacer()
        }.padding(6).background(Color("Secondary")).cornerRadius(2)
    }
}

struct ExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseView()
    }
}
