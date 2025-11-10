//
//  HomeViewNe.swift
//  TestAnimation
//
//  Created by Ruslan Liulka on 11.11.2025.
//

import SwiftUI

struct HomeViewNew: View {
    @State private var showOnboarding = false
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        ZStack {
            VStack {
                
                Spacer(minLength: 120)
                
                Spacer()
                
                Image(systemName: "heart")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                
                Spacer(minLength: 200)
            }
        }
        .onAppear {
            showOnboarding = true
        }
        .fullScreenCover(isPresented: $showOnboarding, onDismiss: {
            //tabBarState.isHidden = false           // повернемо таббар (якщо треба)
        }) {
            OnboardingFlow()
                .environmentObject(coordinator)    // пробросимо координатор
        }
    }
}

#Preview {
    HomeViewNew()
}
