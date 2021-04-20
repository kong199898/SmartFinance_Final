import SwiftUI
import UIKit
import CoreData

struct AddExpenseView: View {
    @State private var toBeDeleted = false
    @State var showActionSheet = false
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
                                Alert(title: Text("SmartFinance"), message: Text("Are you going to delete this transaction?"),
                                    primaryButton: .destructive(Text("Delete")) {
                                        AddExpenseModelView.DeleteTransRecord(managedObjectContext: ObjectContext)
                                    }, secondaryButton: Alert.Button.cancel(Text("Cancel"), action: { toBeDeleted = false })
                                )
                            })
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 12) {
                            DropdownButton(showDropDown: $AddExpenseModelView.ShowType, showText: $AddExpenseModelView.TypeExpense,
                                           item: DropdownType, color: Color("PrimaryText"),
                                           bgcolor: Color("Secondary"), radius: 4, btnHeight: 50) { key in
                                let selectedObj = DropdownType.filter({ $0.item == key }).first
                                if let object = selectedObj {
                                    AddExpenseModelView.TypeExpense = object.value
                                    AddExpenseModelView.SelectType = key
                                }
                                AddExpenseModelView.ShowType = false
                            }
                            DropdownButton(showDropDown: $AddExpenseModelView.ShowTag, showText: $AddExpenseModelView.Tag,
                                           item: DropdownTag, color: Color("PrimaryText"),
                                           bgcolor: Color("Secondary"), radius: 4, btnHeight: 50) { key in
                                let selectedObj = DropdownTag.filter({ $0.item == key }).first
                                if let object = selectedObj {
                                    AddExpenseModelView.Tag = object.value
                                    AddExpenseModelView.SelectTag = key
                                }
                                AddExpenseModelView.ShowTag = false
                            }
                            TextField("Title", text: $AddExpenseModelView.Title)
                                .accentColor(Color("PrimaryText"))
                                .frame(height: 50).padding(.leading, 16)
                                .background(Color("Secondary"))
                                .cornerRadius(4)
                                .foregroundColor(.white)
                            
                            TextField("Amount", text: $AddExpenseModelView.Amount)
                                .accentColor(Color("PrimaryText"))
                                .frame(height: 50).padding(.leading, 16)
                                .background(Color("Secondary"))
                                .cornerRadius(4).keyboardType(.decimalPad)
                                .foregroundColor(.white)
                            HStack {
                                DatePicker("PickerView", selection: $AddExpenseModelView.Occurrence,
                                           displayedComponents: [.date, .hourAndMinute]).labelsHidden().padding(.leading, 16)
                                Spacer()
                            }
                            .frame(height: 50).frame(maxWidth: .infinity)
                            .accentColor(Color("PrimaryText"))
                            .background(Color("Secondary")).cornerRadius(4)
                            
                            TextField("Note", text: $AddExpenseModelView.Note)
                                .accentColor(Color("PrimaryText"))
                                .frame(height: 50).padding(.leading, 16)
                                .background(Color("Secondary"))
                                .cornerRadius(4)
                                .foregroundColor(.white)
                            
                            Button(action: { AddExpenseModelView.AttachTransImage() }, label: {
                                HStack {
                                    Image(systemName: "paperclip")
                                        .font(.system(size: 18.0, weight: .bold))
                                        .foregroundColor(Color("SecondaryText"))
                                        .padding(.leading, 16)
                                    TextView(text: "Attach an image", type: .button).foregroundColor(Color("SecondaryText"))
                                    Spacer()
                                }
                            })
                            .frame(height: 50).frame(maxWidth: .infinity)
                            .background(Color("Secondary"))
                            .cornerRadius(4)
                            .actionSheet(isPresented: $showActionSheet) {
                                ActionSheet(title: Text("Do you want to remove the attachment?"), buttons: [
                                    .default(Text("Remove")) { AddExpenseModelView.RemoveTransImage() },
                                    .cancel()
                                ])
                            }
                            if let image = AddExpenseModelView.AttachImage {
                                Button(action: { showActionSheet = true }, label: {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 250).frame(maxWidth: .infinity)
                                        .background(Color("Secondary"))
                                        .cornerRadius(4)
                                })
                            }
                            Spacer().frame(height: 150)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity).padding(.horizontal, 8)
                        .alert(isPresented: $AddExpenseModelView.ShowAlertMessage,
                               content: { Alert(title: Text("SmartFinance"), message: Text(AddExpenseModelView.Alert), dismissButton: .default(Text("OK"))) })
                    }
                }.edgesIgnoringSafeArea(.top)
                VStack {
                    Spacer()
                    VStack {
                        Button(action: { AddExpenseModelView.SaveTransRecord(managedObjectContext: ObjectContext) }, label: {
                            HStack {
                                Spacer()
                                TextView(text: AddExpenseModelView.getTitleText(), type: .button).foregroundColor(.white)
                                Spacer()
                            }
                        })
                        .padding(.vertical, 12).background(Color("Main")).cornerRadius(8)
                    }.padding(.bottom, 16).padding(.horizontal, 8)
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
    @Published var Note:String = ""
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
        Title = Object?.title ?? ""
        if let expenseObj = Object {
            Amount = String(expenseObj.amount)
            TypeExpense = expenseObj.type == "income" ? "Income" : "Expense"
        } else {
            Amount = ""
            TypeExpense = "Income"
        }
        Occurrence = Object?.occuredOn ?? Date()
        Note = Object?.note ?? ""
        Tag = getTransactionTitle(Tag: Object?.tag ?? "others")
        SelectType = Object?.type ?? "income"
        SelectTag = Object?.tag ?? "others"
        
        if let data = Object?.imageAttached {
            AttachImage = UIImage(data: data)
        }
        
        Attachment.share.imagePicked = { [weak self] image in
            self?.UpdateImage = true
            self?.AttachImage = image
        }
    }
    
    func AttachTransImage() {
        Attachment.share.showActionSheet()
    }
    
    func RemoveTransImage() {
        AttachImage = nil
    }
    
    func getTitleText() -> String {
        if ExpenseDB == nil{
            return "ADD TRANSACTION"
        }else{
            return "EDIT TRANSACTION"
        }
    }
    
    func SaveTransRecord(managedObjectContext: NSManagedObjectContext) {
        let expense: ExpenseCD
        let titleString = Title.trimmingCharacters(in: .whitespacesAndNewlines)
        let amountString = Amount.trimmingCharacters(in: .whitespacesAndNewlines)
        
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
            expense = ExpenseCD(context: managedObjectContext)
            expense.createdAt = Date()
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
        expense.updatedAt = Date()
        expense.type = SelectType
        expense.title = titleString
        expense.tag = SelectTag
        expense.occuredOn = Occurrence
        expense.note = Note
        expense.amount = amount
        do {
            try managedObjectContext.save()
            ClosePresentation = true
        }
        catch {
            Alert = "error when saving transaction"; ShowAlertMessage = true
        }
    }
    
    func DeleteTransRecord(managedObjectContext: NSManagedObjectContext) {
        guard let expenseObj = ExpenseDB else { return }
        managedObjectContext.delete(expenseObj)
        do {
            try managedObjectContext.save(); ClosePresentation = true
        }
        catch {
            Alert = "error when deleting transaction"; ShowAlertMessage = true
        }
    }
}
