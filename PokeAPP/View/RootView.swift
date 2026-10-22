//
//  RootView.swift
//  PokeAPP
//
//  Created by ENZZO FERREIRA DE SOUZA on 20/10/26.
//

import SwiftUI

struct RootView: View {
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashScreen()
                    .transition(.opacity)
            } else {
                ContentView()
                    .transition(.opacity)
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation(.easeInOut(duration: 0.5)) {
                showSplash = false
            }
        }
    }
}
