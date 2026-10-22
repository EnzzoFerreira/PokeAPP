import SwiftUI

struct SplashScreen: View {

    @State private var scale = 0.7
    @State private var opacity: Double = 0.0

    var body: some View {
        ZStack {
            LinearGradient(colors: [.orange, .red],
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()

            Image("pokebola")
                .resizable()
                .scaledToFit()
                .frame(width: 280)
                .scaleEffect(scale)
                .opacity(opacity)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}
