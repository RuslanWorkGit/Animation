//
//  SettingView.swift
//  TestAnimation
//
//  Created by Ruslan Liulka on 10.11.2025.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        ZStack {
            Image(systemName: "heart")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
        }
    }
}

#Preview {
    SettingView()
}
