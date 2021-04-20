import SwiftUI

public extension View {
    func closeKeyboard() -> some View {
        modifier(CloseKeyboard())
    }
}

public struct CloseKeyboard: ViewModifier {
    public func body(content: Content) -> some View {
        #if os(macOS)
        return content
        #else
        return content.gesture(TapGesture().onEnded(endEdit))
        #endif
    }
    
    private func endEdit() {
        UIApplication.shared.connectedScenes
            .filter {$0.activationState == .foregroundActive}
            .map {$0 as? UIWindowScene}
            .compactMap({$0})
            .first?.windows
            .filter {$0.isKeyWindow}
            .first?.endEditing(true)
    }
}
