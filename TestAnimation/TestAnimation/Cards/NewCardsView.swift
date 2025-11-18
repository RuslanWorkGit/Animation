//
//  NewCardsView.swift
//  TestAnimation
//
//  Created by Ruslan Liulka on 18.11.2025.
//

import SwiftUI

struct NewCardsView: View {

    var cards: [Color] = [
        Color(red: 0.89, green: 0.49, blue: 0.36),
        Color(red: 0.90, green: 0.76, blue: 0.44),
        Color(red: 0.58, green: 0.80, blue: 0.62)
    ]
    
    var text: [String] = [
        "How be myself?",
        "What is universe made of?",
        "Whate song can make me happy"
    ]

    @State private var dragOffset: CGSize = .zero
    @State private var showText: Bool = true
    @State private var topCardIndex: Int = 0
    @State private var colorIndex: Int = 0

    var width: CGFloat = 220
    var height: CGFloat = 160

    var body: some View {
        ZStack {


                

                
                ForEach(cards.indices, id: \.self) { index in
                    let visualIndex = (index - topCardIndex + cards.count) % cards.count
                    let progress = min(abs(dragOffset.height) / 150, 1)
                    let signedProgress = (dragOffset.height >= 0 ? 1 : -1) * progress
                    
                  
                        
                    
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: width, height: height)
                        .foregroundStyle(cards[index])
                        .offset(
                            x: visualIndex == 0 ? 0 : Double(visualIndex) * -15,
                            y: visualIndex == 0 ? -dragOffset.height * 0.9 : Double(visualIndex) * -25
                        )
                        .zIndex(Double(cards.count - visualIndex))
                        .rotationEffect(
                            .degrees(
                                visualIndex == 0
                                ? Double(visualIndex) * 30 - progress * 35
                                : 0
                            ),
                            anchor: .bottom
                        )
                    
                        .offset(x: visualIndex == 0 ? 0 : Double(visualIndex) * -3)
                        .contentShape(Rectangle())
                        
          
                    
                }
            
            Text(text[colorIndex])
                .frame(width: 200)
                .padding(20)
                .background(
                    Capsule()
                        .fill(cards[topCardIndex])
                )
                .opacity(showText ? 1 : 0)
                .padding(.top, 270)
            
                
                
                

            
            
        }
        // тап по всьому ZStack
        .contentShape(Rectangle())
        .onTapGesture {
            let delay: CGFloat = 0.4        // затримка як у жесті
            let targetOffset = height * -1.33  // куди "вилітає" картка вправо
            
            withAnimation(.smooth(duration: 0.5)) {
                showText = false
               
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.smooth(duration: 0.8)) {
                    if colorIndex != 2 {
                        colorIndex += 1
                    } else {
                        colorIndex = 0
                    }
                    showText = true
                    
                }
            }

            // 1) виносимо верхню картку вправо
            withAnimation(.smooth(duration: 0.7)) {
                dragOffset.height = targetOffset
               
            }

            // 2) після невеликої паузи змінюємо індекс і повертаємо в нуль
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.smooth(duration: 0.8)) {
                    topCardIndex = (topCardIndex + 1) % cards.count
                    dragOffset = .zero
                    
                    
                }
            }
        }
        .padding()
    }
}

#Preview {
    NewCardsView()
}
