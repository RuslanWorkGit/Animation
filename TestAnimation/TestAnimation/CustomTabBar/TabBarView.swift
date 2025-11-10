//
//  TabBarView.swift
//  TestAnimation
//
//  Created by Ruslan Liulka on 10.11.2025.
//

import SwiftUI
import Combine

final class TabBarState: ObservableObject {
    @Published var isHidden: Bool = false
}

struct TabBarView: View {
    @State private var selectedTab: TabBarTab = .home
    @StateObject private var tabBarState = TabBarState()

    var body: some View {
        CustomTabBarContainerView(selectedTab: $selectedTab) {
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .setting:
                    SettingView()
                    
                }
            }
            
        }
        .environmentObject(tabBarState)
    }
}



