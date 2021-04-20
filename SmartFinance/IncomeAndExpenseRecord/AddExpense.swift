import SwiftUI
import UIKit
import CoreData

struct AddExpenseView: View {
    @State private var toBeDeleted:Bool = false
    @State var showActionSheet:Bool = false
    @StateObject var AddExpenseModelView: AddExpenseModel
    @Environment(\.presentationMode) var Mode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var ObjectContext
    var hideNavigationBar = true
    
    let DropdownType = [
        DropdownMenu(item: "income", value: "Income"),
        DropdownMenu(item: "expense", value: "Expense")
    ]
    
    let DropdownTag = [
        DropdownMenu(item: "entertainment", value: "Entertainment"),
        DropdownMenu(item: "food", value: "Food"),
        DropdownMenu(item: "housing", value: "Housing"),
        DropdownMenu(item: "insurance", value: "Insurance"),
        DropdownMenu(item: "medical", value: "Medical"),
        DropdownMenu(item: "personal", value: "Personal"),
        DropdownMenu(item: "salary", value: "Salary"),
        DropdownMenu(item: "transport", value: "Transport"),
        DropdownMenu(item: "others", value: "Others")
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Primary").edgesIgnoringSafeArea(.all)
                VStack {
                    Group {
                        if AddExpenseModelView.ExpenseDB != nil {
                            Toolbar(title: "Edit Transaction", FirstIcon: "trash_icon") { Mode.wrappedValue.dismiss() }
                                button1Method: { toBeDeleted = true }
                        } else {
                            Toolbar(title: "Add Transaction") { Mode.wrappedValue.dismiss() }
                        }
                    }.alert(isPresented: $toBeDeleted,
                            content: {
                                Alert(title: Text("SmartFinance"), message: Text("This transaction is going to be deleted."),
                                    primaryButton: .destructive(Text("Confirm")) {
                                        AddExpenseModelView.DeleteRecord(obj: ObjectContext)
                                    }, secondaryButton: Alert.Button.cancel(Text("Cancel"), action: { toBeDeleted = false })
                                )
                            })
                    
                    ScrollView(showsIndicators: true) {
                        VStack(spacing: 10) {
                            DropdownButton(showDropDown: $AddExpenseModelView.ShowType, showText: $AddExpenseModelView.TypeExpense,
                                           item: DropdownType, color: Color("PrimaryText"),
                                           bgcolor: Color("Secondary"), radius: 3, btnHeight: 48) { key in
                                var selected = DropdownType.filter({ $0.item == key }).first
                                if selected != nil{
                                    AddExpenseModelView.SelectType = key
                                    AddExpenseModelView.TypeExpense = selected!.value
                                }
                                AddExpenseModelView.ShowType = false
                            }
                            DropdownButton(showDropDown: $AddExpenseModelView.ShowTag, showText: $AddExpenseModelView.Tag,
                                           item: DropdownTag, color: Color("PrimaryText"),
                                           bgcolor: Color("Secondary"), radius: 3, btnHeight: 48) { key in
                                var selected = DropdownTag.filter({ $0.item == key }).first
                                if selected != nil {
                                    AddExpenseModelView.SelectTag = key
                                    AddExpenseModelView.Tag = selected!.value
                                }
                                AddExpenseModelView.ShowTag = false
                            }
                            TextField("Title", text: $AddExpenseModelView.Title)
                                .accentColor(Color("PrimaryText"))
                                .frame(height: 48).padding(.leading, 15)
                                .background(Color("Secondary"))
                                .cornerRadius(3)
                                .foregroundColor(.white)
                            
                            TextField("Amount", text: $AddExpenseModelView.Amount)
                                .accentColor(Color("PrimaryText"))
                                .frame(height: 48).padding(.leading, 15)
                                .background(Color("Secondary"))
                                .cornerRadius(3).keyboardType(.decimalPad)
                                .foregroundColor(.white)
                            HStack {
                                DatePicker("PickerView", selection: $AddExpenseModelView.Occurrence,
                                           displayedComponents: [.date, .hourAndMinute]).labelsHidden().padding(.leading, 15)
                                Spacer()
                            }
                            .frame(height: 48).frame(maxWidth: .infinity)
                            .accentColor(Color("PrimaryText"))
                            .background(Color("Secondary")).cornerRadius(3)
                            
                            Button(action: { AddExpenseModelView.AttachTransImage() }, label: {
                                MyText(text: "Attach an image", type: .button).foregroundColor(Color("SecondaryText"))
                            })
                            .frame(height: 48).frame(maxWidth: .infinity)
                            .background(Color("Secondary"))
                            .cornerRadius(3)
                            .actionSheet(isPresented: $showActionSheet) {
                                ActionSheet(title: Text("This attachment is going to be removed."), buttons: [
                                    .destructive(Text("Confirm")) { AddExpenseModelView.RemoveTransImage() },
                                    .cancel()
                                ])
                            }
                            if AddExpenseModelView.AttachImage != nil {
                                let image = AddExpenseModelView.AttachImage
                                Button(action: { showActionSheet = true }, label: {
                                    Image(uiImage: image!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 245).frame(maxWidth: .infinity)
                                        .background(Color("Secondary"))
                                        .cornerRadius(3)
                                })
                            }
                            Spacer().frame(height: 145)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity).padding(.horizontal, 7)
                        .alert(isPresented: $AddExpenseModelView.ShowAlertMessage,
                               content: { Alert(title: Text("SmartFinance"), message: Text(AddExpenseModelView.Alert), dismissButton: .default(Text("Close"))) })
                    }
                }.edgesIgnoringSafeArea(.top)
                VStack {
                    Spacer()
                    VStack {
                        Button(action: { AddExpenseModelView.SaveRecord(obj: ObjectContext) }, label: {
                            HStack {
                                Spacer()
                                MyText(text: AddExpenseModelView.getTitleText(), type: .button).foregroundColor(.white)
                                Spacer()
                            }
                        })
                        .padding(.vertical, 10).background(Color("Main")).cornerRadius(7)
                    }.padding(.bottom, 15).padding(.horizontal, 7)
                }
                
            }
            .navigationBarHidden(hideNavigationBar)
        }
        .closeKeyboard()
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(hideNavigationBar)
        .navigationBarBackButtonHidden(hideNavigationBar)
        .onReceive(AddExpenseModelView.$ClosePresentation) { close in
            if close { Mode.wrappedValue.dismiss() }
        }
    }
}


class AddExpenseModel: ObservableObject {
    var ExpenseDB: ExpenseCD?
    @Published var Title:String = ""
    @Published var Amount:String = ""
    @Published var Occurrence = Date()
    @Published var TypeExpense:String = "Income"
    @Published var Tag = getTransactionTitle(Tag: "others")
    @Published var ShowType:Bool = false
    @Published var ShowTag:Bool = false
    @Published var SelectType = "income"
    @Published var SelectTag = "others"
    @Published var UpdateImage:Bool = false
    @Published var AttachImage: UIImage? = nil
    @Published var Alert = String()
    @Published var ShowAlertMessage:Bool = false
    @Published var ClosePresentation:Bool = false
    
    init(Object: ExpenseCD? = nil) {
        ExpenseDB = Object
        
        if Object?.title != nil {
            Title = Object!.title!
        }else{
            Title = ""
        }
        
        if Object != nil {
            Amount = String(Object!.amount)
            TypeExpense = Object!.type == "income" ? "Income" : "Expense"
        }else {
            Amount = ""
            TypeExpense = "Income"
        }
        
        if Object?.occuredOn != nil {
            Occurrence = Object!.occuredOn!
        }else{
            Occurrence = Date()
        }
        
        if Object?.tag != nil {
            Tag = getTransactionTitle(Tag: Object!.tag!)
        }else{
            Tag = "others"
        }
        
        if Object?.type != nil {
            SelectType = Object!.type!
        }else{
            SelectType = "income"
        }
        
        if Object?.tag != nil {
            SelectTag = Object!.tag!
        }else{
            SelectTag = "others"
        }
        
        if Object?.imageAttached != nil {
            AttachImage = UIImage(data: Object!.imageAttached!)
        }
        
        Attachment.share.imagePicked = { [weak self] image in
            self?.UpdateImage = true
            self?.AttachImage = image
        }
    }
    
    func getTitleText() -> String {
        if ExpenseDB == nil{
            return "ADD TRANSACTION"
        }else{
            return "EDIT TRANSACTION"
        }
    }
    
    func AttachTransImage() {
        Attachment.share.showActionSheet()
    }
    
    func RemoveTransImage() {
        AttachImage = nil
    }
    
    func SaveRecord(obj: NSManagedObjectContext) {
        let expense: ExpenseCD
        let amountString = Amount
        let titleString = Title
        
        if amountString.isEmpty {
            Alert = "Please enter an amount"; ShowAlertMessage = true
            return
        }
        if titleString.isEmpty {
            Alert = "Pease enter a title"; ShowAlertMessage = true
            return
        }
        guard let amount = Double(amountString) else {
            Alert = "Please Enter a valid amount"; ShowAlertMessage = true
            return
        }
        
        if ExpenseDB == nil {
            expense = ExpenseCD(context: obj)
            if let image = AttachImage {
                expense.imageAttached = image.jpegData(compressionQuality: 1.0)
            }
        } else {
            expense = ExpenseDB!
            if let image = AttachImage {
                if UpdateImage {
                    if let _ = expense.imageAttached {
                    }
                    expense.imageAttached = image.jpegData(compressionQuality: 1.0)
                }
            } else {
                if let _ = expense.imageAttached {
                }
                expense.imageAttached = nil
            }
        }
        expense.type = SelectType
        expense.title = titleString
        expense.tag = SelectTag
        expense.occuredOn = Occurrence
        expense.amount = amount
        do {
            try obj.save()
            ClosePresentation = true
        }
        catch {
            Alert = "error when saving transaction"; ShowAlertMessage = true
        }
    }
    
    func DeleteRecord(obj: NSManagedObjectContext) {
        guard let expenseObj = ExpenseDB else { return }
        obj.delete(expenseObj)
        do {
            try obj.save(); ClosePresentation = true
        }
        catch {
            Alert = "error when deleting transaction"; ShowAlertMessage = true
        }
    }
}
