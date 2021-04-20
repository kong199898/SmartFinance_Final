import SwiftUI
import Foundation

extension Date {
    func LastSevenDay() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)
    }
    
    func LastThirtyDay() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -30, to: self)
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexString: String = hex.trimmingCharacters(in: CharacterSet.whitespaces).uppercased()
        if hexString.hasPrefix("#") {
            hexString = String(hexString.dropFirst())
        }
        assert(hexString.count == 6, "Invalid hex code.")
        var RGB: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&RGB)
        self.init(red: CGFloat((RGB & 0xFF0000) >> 16) / 255.0, green: CGFloat((RGB & 0x00FF00) >> 8) / 255.0, blue: CGFloat(RGB & 0x0000FF) / 255.0, alpha: 1.0)
    }
}
