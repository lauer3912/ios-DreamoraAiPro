import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView()
                    .transition(.opacity)
            } else {
                MainTabView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showSplash = false
                }
            }
        }
    }
}

struct SplashView: View {
    @State private var animate = false
    @State private var scale: CGFloat = 0.8

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(AppGradient.primary)
                        .frame(width: 120, height: 120)
                        .blur(radius: animate ? 40 : 20)
                        .opacity(animate ? 0.6 : 0.3)

                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(AppGradient.accentDiagonal)
                }
                .scaleEffect(scale)

                VStack(spacing: 8) {
                    Text("DreamoraAiPro")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("Unlock Your Dream World")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.textSecondary)
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                scale = 1.1
            }
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}