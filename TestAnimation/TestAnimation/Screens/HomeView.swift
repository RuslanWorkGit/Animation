//
//  HomeView.swift
//  TestAnimation
//
//  Created by Ruslan Liulka on 10.11.2025.
//

import SwiftUI

struct HomeView: View {
    @State private var showOnboarding = false
    @EnvironmentObject private var tabBarState: TabBarState
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        ZStack {
            VStack {
                
                Spacer(minLength: 120)
                
                Button("NewOnboard") {
                    tabBarState.isHidden = true           // ← сховаємо
                    showOnboarding = true
                    
                }
                .buttonStyle(PillButtonStyle())
                
                Spacer()
                
                Image(systemName: "heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                
                Spacer(minLength: 200)
            }
        }
        .fullScreenCover(isPresented: $showOnboarding, onDismiss: {
            tabBarState.isHidden = false           // повернемо таббар (якщо треба)
        }) {
            HomeViewNew()
                .environmentObject(coordinator)    // пробросимо координатор
        }
        
    }
}

#Preview {
    HomeView()
}

struct PillButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.gray)
            Spacer()
            Image(systemName: "chevron.right") // опційно
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.gray.opacity(0.9))
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading) // ✅ на всю ширину
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.gray.opacity(0.2))                           // ✅ сірий напівпрозорий фон
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.08))                       // тонка обводка (опц.)
        )
        .opacity(configuration.isPressed ? 0.85 : 1)
        .contentShape(RoundedRectangle(cornerRadius: 16))                // коректна зона тапа
    }
}
