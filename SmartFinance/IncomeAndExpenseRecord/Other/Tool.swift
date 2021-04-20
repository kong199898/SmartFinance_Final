import UIKit
import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) { self.build = build }
    var body: Content { build() }
}

struct Toolbar: View {
    var title: String
    var BackButt = true
    var FirstIcon: String?
    var SecondIcon: String?
    var ThirdIcon: String?
    var backButtonClick: () -> ()
    var button1Method: (() -> ())?
    var button2Method: (() -> ())?
    var button3Method: (() -> ())?
    
    var body: some View {
        ZStack {
            HStack {
                if BackButt {
                    Button(action: { self.backButtonClick() },
                        label: { Image("back_arrow").resizable().frame(width: 31.0, height: 31.0) })
                }
                if let button3Method = self.button3Method {
                    Button(action: { button3Method() },
                           label: { Image(ThirdIcon ?? "").resizable().frame(width: 31.0, height: 31.0) }).padding(.horizontal, 6)
                }
                Spacer()
                if let button2Method = self.button2Method {
                    Button(action: { button2Method() },
                           label: { Image(SecondIcon ?? "").resizable().frame(width: 31.0, height: 31.0) }).padding(.horizontal, 6)
                }
                if let button1Method = self.button1Method {
                    Button(action: { button1Method() },
                           label: { Image(FirstIcon ?? "").resizable().frame(width: 31.0, height: 31.0) }).padding(.horizontal, 6)
                }
            }
            HStack {
                TextView(text: title, type: .h5).foregroundColor(Color("PrimaryText"))
            }
        }.padding(14).padding(.horizontal, 6).padding(.top, 28).background(Color("Secondary"))
    }
}

struct DropdownMenu: Hashable {
    public static func == (left: DropdownMenu, right: DropdownMenu) -> Bool {
        if left.item == right.item{
            return true
        }else{
            return false
        }
    }
    var item: String
    var value: String
}

struct DropdownElement: View {
    var value: String
    var item: String
    let color: Color
    var onClick: ((_ key: String) -> Void)?
    var body: some View {
        Button(action: {
            if let onClick = self.onClick {
                onClick(self.item)
            }
        }) {
            Text(self.value).foregroundColor(color).frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 6)
    }
}

struct Dropdown: View {
    var items: [DropdownMenu]
    var onClick: ((_ key: String) -> Void)?
    let Radius: CGFloat
    let color: Color
    let bgcolor: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(self.items, id: \.self) { option in
                DropdownElement(value: option.value, item: option.item, color: self.color, onClick: self.onClick)
            }
        }
        .padding(.vertical, 3)
        .background(bgcolor)
        .cornerRadius(Radius)
        .overlay(
            RoundedRectangle(cornerRadius: Radius)
                .stroke(color)
        )
    }
}

struct DropdownButton: View {
    @Binding var showDropDown: Bool
    @Binding var showText: String
    var item: [DropdownMenu]
    let color: Color
    let bgcolor: Color
    let radius: CGFloat
    let btnHeight: CGFloat
    var onClick: ((_ key: String) -> Void)?

    var body: some View {
        VStack {
            Button(action: {
                self.showDropDown.toggle()
            }) {
                HStack {
                    Text(showText).foregroundColor(color)
                    Spacer()
                    if showDropDown{
                        Image(systemName: "chevron.up").foregroundColor(color)
                    }else{
                        Image(systemName: "chevron.down").foregroundColor(color)
                    }
                }
            }
            .padding(.horizontal)
            .cornerRadius(radius)
            .frame(height: self.btnHeight)
            .background(
                RoundedRectangle(cornerRadius: radius).fill(bgcolor)
            )
            VStack {
                if self.showDropDown {
                    Dropdown(items: self.item, onClick: self.onClick, Radius: self.radius, color: self.color, bgcolor: self.bgcolor)
                }
            }
        }.animation(.spring())
    }
}
