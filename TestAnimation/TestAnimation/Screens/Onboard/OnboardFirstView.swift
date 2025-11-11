//
//  OnboardFirstView.swift
//  TestAnimation
//
//  Created by Ruslan Liulka on 11.11.2025.
//

import SwiftUI

struct OnboardFirstView: View {
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
                            Text("First Onboard Screen(On tap screen)").font(.system(size: 30, weight: .semibold))

                        )
                        .foregroundStyle(Color(red: 17/255, green: 17/255, blue: 17/255))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.top, 16)
                        .padding(.bottom, 12)

                    }
                    

//                    
//                    AnimatedHeroImage(
//                        name: "newImg",
//                        fromSize: 250,
//                        toSize: 150,
//                        startDelay: 0.5,
//                        transformTime: 0.6,
//                        blurTime: 0.35,
//                        blurRadius: 14
//                    )
                    AnimatedHeroImage(
                        name: "newImg",
                        fromSize: 250,
                        toSize: 150,
                        startDelay: 0.5,
                        transformTime: 0.6,
                        blurTime: 0.35,
                        blurRadius: 14,
                        //showCard: true,       // залиш верхню «картку», щоб було чітко видно обертання блоку
                        cornerRadius: 16
                    )
                        .padding(.top, 8) // опційно
                    
                                        
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

struct AnimatedHeroImage: View {
    let name: String
    // Геометрія та таймінги
    var fromSize: CGFloat = 250
    var toSize: CGFloat = 150
    var startDelay: Double = 0.5
    var transformTime: Double = 0.9      // зробив довше, за потреби підкрути
    var blurTime: Double = 0.45
    var blurRadius: CGFloat = 14

    var cornerRadius: CGFloat = 16
    var showShadow: Bool = true

    @State private var animateTransform = false   // поворот + зменшення (контейнер)
    @State private var removeBlur = false         // зняття блюра (картинка)

    var body: some View {
        let containerSize = animateTransform ? toSize : fromSize
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        ZStack {
            // Фото на весь блок
            Image(name)
                .resizable()
                .scaledToFill()
                //.blur(radius: removeBlur ? 0 : blurRadius, opaque: true)
                .animation(.easeOut(duration: blurTime), value: removeBlur)
        }
        .opacity(animateTransform ? 1 : 0)
        .frame(width: containerSize, height: containerSize)
        .clipShape(shape) // обрізаємо фото по радіусу картки
        .shadow(color: .black.opacity(showShadow ? 0.08 : 0), radius: 12, x: 0, y: 6)
        .rotationEffect(.degrees(animateTransform ? 0 : 12)) // обертаємо весь блок
        .blur(radius: animateTransform ? 0 : 20)

        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + startDelay) {
                // Фаза 1: поворот + зменшення 250 → 150
                withAnimation(.spring(response: 1.4, dampingFraction: 0.88, blendDuration: 0.2)) {
                    animateTransform = true
                }
                // Фаза 2: коли майже завершилось — прибираємо блюр
                DispatchQueue.main.asyncAfter(deadline: .now() + transformTime) {
                    withAnimation(.easeOut(duration: blurTime)) {
                        removeBlur = true
                    }
                }
            }
        }
        .onDisappear {
            animateTransform = false
            removeBlur = false
        }
    }
}


struct PillButtonNew: View {
    let title: String
    let action: () -> Void
    var arrow: Bool = false
    
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(minHeight: 52)
                .frame(maxWidth: .infinity)
            //.contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            
        }
        //.buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(red: 81 / 255, green: 132 / 255, blue: 234 / 255)) // як на скріні
                .innerShadow(
                    RoundedRectangle(cornerRadius: 16),
                    color: .white, opacity: 0.25,
                    x: 0, y: 1, blur: 0, spread: 2
                )
        )
        .overlay( // стрілка зверху, не зсуває текст
            Group {
                if arrow {
                    Image(systemName: "arrow.right")
                        .foregroundStyle(.white)
                    
                        .padding(.trailing, 16)
                }
            },
            alignment: .trailing
        )
        //        .overlay(
        //            RoundedRectangle(cornerRadius: 16, style: .continuous)
        //                .stroke(Color.white.opacity(0.08), lineWidth: 1) // тонка обводка (опційно)
        //        )
        
    }
}

struct OnboardScaffoldNew<Content: View>: View {
    let ctaTitle: String
    let ctaAction: () -> Void
    var fixedWidth: CGFloat = 260
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        ZStack { content() }
            .safeAreaInset(edge: .bottom) {
                HStack { // гарантує однакову геометрію
                    Spacer()
//                    PillButtonNew(title: ctaTitle, action: ctaAction, arrow: true)
//                        .padding(.horizontal, 32)
//                        .frame(minHeight: 52) // ключ
////                        .frame(width: fixedWidth)
                    Spacer()
                }
                
                .padding(.bottom, 30)
                
            }
    }
}


struct SelectableChipOne: View {
    let title: String
    @Binding var isSelected: Bool
    
    var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            HStack(spacing: 12) {
                Image(isSelected ? "fillCheckmark" : "emptyCheckmark")
//                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
//                    .imageScale(.large)
//                    .font(.system(size: 18, weight: .semibold))
//                    .foregroundStyle(isSelected ? Color(red: 81 / 255, green: 132 / 255, blue: 234 / 255) : Color(red: 195 / 255, green: 198 / 255, blue: 205 / 255))
                
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color(red: 17 / 255, green: 17 / 255, blue: 17 / 255))
                
                Spacer(minLength: 0)
            }
            .padding(.vertical, 19)
            .padding(.horizontal, 14)
            .contentShape(RoundedRectangle(cornerRadius: 16))
            
        }
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .innerShadow(
                    RoundedRectangle(cornerRadius: 16),
                    color: Color(red: 17 / 255, green: 17 / 255, blue: 17 / 255), opacity: 0.05,
                    x: 0, y: -1, blur: 0, spread: 2
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? Color(red: 81 / 255, green: 132 / 255, blue: 234 / 255) : Color.white.opacity(0),
                        lineWidth: isSelected ? 1 : 1)
        )
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}


extension View {
    /// Figma-like inner shadow (overlay + mask)
    func innerShadow<S: Shape>(
        _ shape: S,
        color: Color = .black,
        opacity: Double = 1,
        x: CGFloat = 0,
        y: CGFloat = 0,
        blur: CGFloat = 6,
        spread: CGFloat = 0
    ) -> some View {
        overlay(
            shape
                .stroke(color.opacity(opacity), lineWidth: max(spread, 0.0001))
                .offset(x: x, y: y)
                .blur(radius: blur)
                .mask(shape)
        )
    }
}

//
//struct AnimatedHeroImage: View {
//    let name: String
//    var size: CGFloat = 150
//    var delay: Double = 0.5   // ⟵ керування затримкою
//
//    @State private var animateIn = false
//
//    var body: some View {
//        Image(name)
//            .resizable()
//            .scaledToFit()
//            .frame(width: size, height: size)
//            // Початковий стан: збільшено, повернуто, заблюрено
//            .scaleEffect(animateIn ? 1.0 : 1.35)
//            .rotationEffect(.degrees(animateIn ? 0 : 45))
//            .blur(radius: animateIn ? 0 : 14, opaque: true)
//            .opacity(animateIn ? 1 : 0.95)
//            // Узгоджена пружинна анімація
//            .animation(.spring(response: 0.9, dampingFraction: 0.78, blendDuration: 0.2),
//                       value: animateIn)
//            .onAppear {
//                // Затримка перед запуском анімації
//                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
//                    animateIn = true
//                }
//            }
//    }
//}

#Preview {
    OnboardFirstView(action: {print("N")})
}
