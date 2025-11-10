//
//  RootView.swift
//  TestAnimation
//
//  Created by Ruslan Liulka on 10.11.2025.
//
import SwiftUI

struct RootView: View {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @EnvironmentObject var coordinator: AppCoordinator
   
    
    var body: some View {
        Group {
            switch coordinator.currentScreen {
            case .boot:
                // Можна поставити свій SplashView/лого/чорний фон
                Color.black.ignoresSafeArea()
            case .paywall:
                PaywallView(action: {print("hello")})
            case .onboarding:
                OnboardingFlow()
//                OnboardingFlowViewFour()
            case .mainTabbar:
                TabBarView()
            }
        }
        .onAppear {

        }
        .animation(nil, value: coordinator.currentScreen)
    }
}
