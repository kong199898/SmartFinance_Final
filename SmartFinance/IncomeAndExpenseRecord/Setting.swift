import SwiftUI
import UIKit
import CoreData

struct ExpenseSettingsView: View {
    @State private var showCurrencySetting = false
    @State private var showNavigationBar = true
    @Environment(\.presentationMode) var Mode: Binding<PresentationMode>
    @ObservedObject private var SettingModelView = ExpenseSettingsModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Primary").edgesIgnoringSafeArea(.all)
                VStack {
                    Toolbar(title: "Setting") { self.Mode.wrappedValue.dismiss() }
                    VStack {
                        Button(action: { showCurrencySetting = true }, label: {
                            HStack {
                                Spacer()
                                TextView(text: "Currency - \(SettingModelView.SettingCurrency)", type: .button).foregroundColor(Color("PrimaryText"))
                                Spacer()
                            }
                        })
                        .frame(height: 25)
                        .padding().background(Color("Secondary"))
                        .cornerRadius(4)
                        .foregroundColor(Color("PrimaryText"))
                        .accentColor(Color("PrimaryText"))
                        .actionSheet(isPresented: $showCurrencySetting) {
                            var buttons: [ActionSheet.Button] = CurrencyList.map { curr in
                                ActionSheet.Button.default(Text(curr)) { SettingModelView.saveCurrency(currency: curr) }
                            }
                            buttons.append(.cancel())
                            return ActionSheet(title: Text("Please select a currency"), buttons: buttons)
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: { self.Mode.wrappedValue.dismiss() }, label: {
                                Image("confirm_icon").resizable().frame(width: 32.0, height: 32.0)
                            }).padding().background(Color("Main")).cornerRadius(35)
                        }
                    }
                    .padding(.horizontal, 8).padding(.top, 1)
                }.edgesIgnoringSafeArea(.top)
            }
            .navigationBarHidden(showNavigationBar)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(showNavigationBar)
        .navigationBarBackButtonHidden(showNavigationBar)
    }
}

struct ExpenseSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseSettingsView()
    }
}

class ExpenseSettingsModel: ObservableObject {
    @Published var SettingCurrency = UserDefaults.standard.string(forKey: Currency) ?? ""
    init() {}
    
    func saveCurrency(currency: String) {
        SettingCurrency = currency
        UserDefaults.standard.set(currency, forKey: Currency)
    }
}
