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
                    ScrollView(showsIndicators: true) {
                        VStack(spacing: 22) {
                            if ExpenseDetailModelView.ExpenseObject.title != nil {
                                DetailedList(Title: "Title", Description: ExpenseDetailModelView.ExpenseObject.title!)
                            }else {
                                DetailedList(Title: "Title", Description: "")
                            }
                            
                            DetailedList(Title: "Amount", Description: "\(CURRENCY)\(ExpenseDetailModelView.ExpenseObject.amount)")
                            
                            if ExpenseDetailModelView.ExpenseObject.type == "income"{
                                DetailedList(Title: "Transaction type", Description: "Income")
                            }else{
                                DetailedList(Title: "Transaction type", Description: "Expense")
                            }
                            
                            if ExpenseDetailModelView.ExpenseObject.tag != nil {
                                DetailedList(Title: "Tag", Description: getTransactionTitle(Tag: ExpenseDetailModelView.ExpenseObject.tag!))
                            }else{
                                DetailedList(Title: "Tag", Description: "")
                            }
                            
                            DetailedList(Title: "When", Description: DateFormatter(date: ExpenseDetailModelView.ExpenseObject.occuredOn, format: "EEEE, dd MMMM yyyy hh:mm a"))
                            
                            if ExpenseDetailModelView.ExpenseObject.imageAttached != nil {
                                VStack(spacing: 6) {
                                    HStack { MyText(text: "Attachment", type: .caption).foregroundColor(Color("GreyText")); Spacer() }
                                    Image(uiImage: UIImage(data: ExpenseDetailModelView.ExpenseObject.imageAttached!)!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 245).frame(maxWidth: .infinity)
                                        .background(Color("Secondary"))
                                        .cornerRadius(2)
                                }
                            }
                        }.padding(15)
                        Spacer().frame(height: 22)
                        Spacer()
                    }
                    .alert(isPresented: $confirmDelete,
                                content: {
                                    Alert(title: Text("SmartFinance"), message: Text("This transaction is going to be deleted"),
                                        primaryButton: Alert.Button.cancel(Text("Cancel"), action: { confirmDelete = false }), secondaryButton:.destructive(Text("Confirm")) {
                                            ExpenseDetailModelView.deleteRecord(obj: ObjectContext)
                                        }
                                    )
                                })
                }.edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: AddExpenseView(AddExpenseModelView: AddExpenseModel(Object: ExpenseDetailModelView.ExpenseObject)), label: {
                            Text("EDIT").foregroundColor(.white)
                            Image("edit_icon").resizable().frame(width: 25, height: 25)
                        })
                        .padding(EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 18))
                        .background(Color("Main")).cornerRadius(20)
                    }.padding(20)
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
        VStack(spacing: 6) {
            HStack {
                MyText(text: Title, type: .caption).foregroundColor(Color("GreyText"))
                Spacer()
            }
            HStack { MyText(text: Description, type: .body_1).foregroundColor(Color("PrimaryText"))
                Spacer()
            }
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
    
    func deleteRecord(obj: NSManagedObjectContext) {
        obj.delete(ExpenseObject)
        do {
            try obj.save(); ClosePresent = true
        }
        catch {
            Alert = "Error when deleting record."; ShowAlertMessage = true
        }
    }
}
