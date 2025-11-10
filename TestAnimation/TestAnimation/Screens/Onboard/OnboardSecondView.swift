//
//  OnboardSecondView.swift
//  TestAnimation
//
//  Created by Ruslan Liulka on 11.11.2025.
//


import SwiftUI

struct OnboardSecondView: View {
    let action: () -> Void
    private func handleCTA() {

        action()
    }

    
    var body: some View {
        
        
        
        
        OnboardScaffoldNew(ctaTitle: "Continue", ctaAction: handleCTA, fixedWidth: 260) {
            
            LinearGradient(gradient: Gradient(stops: [
                .init(color: Color(red: 255/255, green: 255/255, blue: 255/255).opacity(1), location: 0),
                .init(color: Color(red: 222/255, green: 233/255, blue: 255/255).opacity(1), location: 0.5),
                .init(color: Color(red: 255/255, green: 255/255, blue: 255/255).opacity(1), location: 1.0)
            ]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            ScrollView{
                VStack {
                    
                    Spacer(minLength: 300)
                    
                    Group {
                        
                        (
                            Text("Second Onboard Screen(On tap screen)").font(.system(size: 30, weight: .semibold))

                        )
                        .foregroundStyle(Color(red: 17/255, green: 17/255, blue: 17/255))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.top, 16)
                        .padding(.bottom, 12)

                    }
                    
                                        
                    Spacer()
                    
                    
                }
                .padding(.horizontal, 32)
            }
        }
        .onTapGesture {
            handleCTA()
        }
        //        .onAppear {
        //            tempSelected = ChooseDevice(rawValue: selectedDeviceRaw) ?? .iphone
        //        }
        
        
    }
}
