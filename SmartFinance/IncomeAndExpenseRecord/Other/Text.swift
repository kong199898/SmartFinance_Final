import SwiftUI
import Lottie

enum MyTextType {
    case h5
    case subtitle_1
    case body_1
    case body_2
    case button
    case caption
    case overline
}

enum AnimType: String {
    case cross = "search-clear"
}

struct LottieView: UIViewRepresentable {
    var AnimateType: AnimType
    let AnimateView = AnimationView()
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {}
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        AnimateView.animation = Animation.named(AnimateType.rawValue)
        AnimateView.contentMode = .scaleAspectFit
        AnimateView.animationSpeed = 0.5
        AnimateView.backgroundBehavior = .pauseAndRestore
        AnimateView.loopMode = .loop
        AnimateView.play()
        
        AnimateView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(AnimateView)
        
        NSLayoutConstraint.activate([
            AnimateView.widthAnchor.constraint(equalTo: view.widthAnchor),
            AnimateView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        return view
    }
}

struct LottieView_Previews: PreviewProvider {
    static var previews: some View {
        LottieView(AnimateType: .cross)
    }
}

struct MyText: View {
    var text: String
    var type: MyTextType
    
    var body: some View {
        if type == .h5{
            return Text(text).tracking(0).lineLimit(0)
        }else if type == .subtitle_1{
            return Text(text).tracking(0.15).lineLimit(0)
        }else if type == .body_1{
            return Text(text).tracking(0.5).lineLimit(0)
        }else if type == .body_2{
            return Text(text).tracking(0.25).lineLimit(0)
        }else if type == .button{
            return Text(text).tracking(1.25).lineLimit(0)
        }else if type == .caption{
            return Text(text).tracking(0.4).lineLimit(0)
        }else if type == .overline{
            return Text(text).tracking(1.5).lineLimit(0)
        }
        return Text(text).tracking(0.15).lineLimit(0)
    }
}
