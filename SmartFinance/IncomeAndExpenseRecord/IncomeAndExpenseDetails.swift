import SwiftUI
import UIKit
import CoreData

struct ExpenseDetailView: View {
    @State private var confirmDelete:Bool = false
    @State private var showNavigationBar = true
    @Environment(\.presentationMode) var Mode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) var ObjectContext
    @ObservedObject private var ExpenseDetailModelView: ExpenseDetailModel
    @AppStorage(Currency) var CURRENCY: String = ""
    
    init(ExpenseDB: ExpenseCD) {
        ExpenseDetailModelView = ExpenseDetailModel(Object: ExpenseDB)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Primary").edgesIgnoringSafeArea(.all)
                VStack {
                    Toolbar(title: "Details", FirstIcon: "trash_icon") { Mode.wrappedValue.dismiss() }
                         button1Method: { confirmDelete = true }
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            DetailedList(Title: "Title", Description: ExpenseDetailModelView.ExpenseObject.title ?? "")
                            DetailedList(Title: "Amount", Description: "\(CURRENCY)\(ExpenseDetailModelView.ExpenseObject.amount)")
                            if ExpenseDetailModelView.ExpenseObject.type == "income"{
                                DetailedList(Title: "Transaction type", Description: "Income")
                            }else{
                                DetailedList(Title: "Transaction type", Description: "Expense")
                            }
                            DetailedList(Title: "Tag", Description: getTransactionTitle(Tag: ExpenseDetailModelView.ExpenseObject.tag ?? ""))
                            DetailedList(Title: "When", Description: DateFormatter(date: ExpenseDetailModelView.ExpenseObject.occuredOn, format: "EEEE, dd MMM hh:mm a"))
                            if let note = ExpenseDetailModelView.ExpenseObject.note, note != "" {
                                DetailedList(Title: "Note", Description: note)
                            }
                            if let data = ExpenseDetailModelView.ExpenseObject.imageAttached {
                                VStack(spacing: 8) {
                                    HStack { TextView(text: "Attachment", type: .caption).foregroundColor(Color("GreyText")); Spacer() }
                                    Image(uiImage: UIImage(data: data)!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 250).frame(maxWidth: .infinity)
                                        .background(Color("Secondary"))
                                        .cornerRadius(4)
                                }
                            }
                        }.padding(16)
                        Spacer().frame(height: 24)
                        Spacer()
                    }
                    .alert(isPresented: $confirmDelete,
                                content: {
                                    Alert(title: Text("SmartFinance"), message: Text("Are you going to delete this transaction?"),
                                        primaryButton: .destructive(Text("Delete")) {
                                            ExpenseDetailModelView.deleteNote(Objc: ObjectContext)
                                        }, secondaryButton: Alert.Button.cancel(Text("Cancel"), action: { confirmDelete = false })
                                    )
                                })
                }.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: AddExpenseView(AddExpenseModelView: AddExpenseModel(Object: ExpenseDetailModelView.ExpenseObject)), label: {
                            Image("edit_icon").resizable().frame(width: 28.0, height: 28.0)
                            Text("Edit").foregroundColor(.white)
                        })
                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 20))
                        .background(Color("Main")).cornerRadius(25)
                    }.padding(24)
                }
            }
            .navigationBarHidden(showNavigationBar)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(showNavigationBar)
        .navigationBarBackButtonHidden(showNavigationBar)
    }
}

struct DetailedList: View {
    var Title: String
    var Description: String
    var body: some View {
        VStack(spacing: 8) {
            HStack { TextView(text: Title, type: .caption).foregroundColor(Color("GreyText")); Spacer() }
            HStack { TextView(text: Description, type: .body_1).foregroundColor(Color("PrimaryText")); Spacer() }
        }
    }
}


class ExpenseDetailModel: ObservableObject {
    @Published var ExpenseObject: ExpenseCD
    @Published var Alert = String()
    @Published var ShowAlertMessage:Bool = false
    @Published var ClosePresent:Bool = false
    
    init(Object: ExpenseCD) {
        ExpenseObject = Object
    }
    
    func deleteNote(Objc: NSManagedObjectContext) {
        Objc.delete(ExpenseObject)
        do {
            try Objc.save(); ClosePresent = true
        }
        catch {
            Alert = "\(error)"; ShowAlertMessage = true
        }
    }
}
