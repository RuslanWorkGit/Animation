//
//  TestAnimationApp.swift
//  TestAnimation
//
//  Created by Ruslan Liulka on 10.11.2025.
//

import SwiftUI

@main
struct TestAnimationApp: App {
    
    @StateObject var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            NewCardsView()
//            RootView()
//                .environmentObject(coordinator)
        }
    }
}
