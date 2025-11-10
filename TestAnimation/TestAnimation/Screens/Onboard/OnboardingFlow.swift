//
//  OnboardingFlow.swift
//  TestAnimation
//
//  Created by Ruslan Liulka on 10.11.2025.
//

import SwiftUI

enum OnboardingStep: Int, CaseIterable, Hashable {
    case stepOne
    case stepTwo
    case stepThree
    case paywall
}


struct OnboardingFlow: View {
    private let flowId = "onboard_steps"
    private let onboardId = "onboard_tag"
    
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    //@AppStorage("onb_last_shown_ts") private var onbLastShownTS: Double = 0

    @State private var currentStep: OnboardingStep = .stepOne
    @State private var prevStep: OnboardingStep? = nil          // ← старий екран (фон)
    @State private var incomingStep: OnboardingStep? = nil      // ← новий екран (оверлей)
    @State private var overlayX: CGFloat = 0                       // ← офсет оверлея
    @State private var isAnimating = false
    @State private var isForward = true
    
    @State private var stepsVisited: [String] = []
    

    @EnvironmentObject var coordinator: AppCoordinator
    @Environment(\.dismiss) private var dismiss
    
    
    
    @State private var childAnimate = false
    private let slideDuration: Double = 0.5
    
    
    private func appendStep(_ step: OnboardingStep) {
        let id = screenId(for: step)
        if stepsVisited.last != id { stepsVisited.append(id) }
    }
    
    @State private var paywallShown = false

//    private func persist(tag: OnboardTag) {
//        OnboardingSessionStore.shared.save(tag: tag, steps: stepsVisited, paywallShown: paywallShown)
//    }

    var body: some View {
        GeometryReader { geo in
            ZStack {

                // 2) Старий екран — залишається на місці під час анімації
                if let p = prevStep {
                    screen(for: p, startAnimations: false, staticDisplay: true)
                        .id(p)
                        .frame(width: geo.size.width, height: geo.size.height)  // ✅ фіксуємо розмір
                        .zIndex(0)
                } else {
                    // якщо немає prevStep, показуємо поточний як базовий
                    screen(for: currentStep, startAnimations: true, staticDisplay: false)
                        .id(currentStep)
                        .frame(width: geo.size.width, height: geo.size.height)  // ✅
                        .zIndex(0)
                }

                // 3) Новий екран — в’їжджає зверху поверх старого
                if let inc = incomingStep {
                    screen(for: inc, startAnimations: childAnimate, staticDisplay: false)
                        .id(inc)
                        .frame(width: geo.size.width, height: geo.size.height)  // ✅
//                                        .ignoresSafeArea()
                        .offset(x: overlayX)         // ← тільки він рухається
                        .zIndex(1)
                        .onAppear {
                            // стартуємо за межами екрана справа/зліва
                            overlayX = (isForward ? 1 : -1) * geo.size.width
                            withAnimation(.easeInOut(duration: slideDuration)) {
                                            overlayX = 0
                                        }
                            DispatchQueue.main.asyncAfter(deadline: .now() + slideDuration) {
                                            childAnimate = true
                                        }
//                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.9)) {
//                                overlayX = 0
//                            }
                        }
                }
            }
            .task {
                //onbLastShownTS = Date().timeIntervalSince1970
                //Telemetry.shared.onboardFlowMark(.v41)
                
//                Telemetry.shared.onboardStarted(onboardId: onboardId)
//                
//                Telemetry.shared.onbFlowStart(flowId: flowId)
//                Telemetry.shared.onbScreenView(flowId: flowId, screenId: screenId(for: currentStep))
                
                appendStep(currentStep)
            }
        }
    }

    // MARK: - Навігація
    private func goTo(_ step: OnboardingStep, forward: Bool) {
        guard !isAnimating, step != currentStep else { return }
        isAnimating = true
        isForward = forward
        childAnimate = false

        // фіксуємо старий і запускаємо оверлей
        prevStep = currentStep
        incomingStep = step

        // після короткої затримки (кінець пружини) — фіксуємо новий current і чистимо тимчасові
        //let delay = 0.7
        DispatchQueue.main.asyncAfter(deadline: .now() + slideDuration) {
            currentStep = step
            prevStep = nil
            incomingStep = nil
            isAnimating = false
            
            //Telemetry.shared.onbScreenView(flowId: flowId, screenId: screenId(for: step))
            
            if step != .paywall {
//                       incomingStep = nil
                // Telemetry.shared.onbScreenView(flowId: flowId, screenId: screenId(for: step))
                
                appendStep(step)
              //  persist(tag: .v41)
            } else {
               // PaywallGate.shared.currentContext = .onboarding
            }

        }
    }

    private func finishOnboarding() {
        //Telemetry.shared.onboardingFinish()
        //hasSeenOnboarding = true
        dismiss()
        coordinator.showMainTabbar()
    }
    

    // Виклики з дочірніх екранів
    private func goToNextStep() {
        if let idx = OnboardingStep.allCases.firstIndex(of: currentStep),
           idx + 1 < OnboardingStep.allCases.count {
            goTo(OnboardingStep.allCases[idx + 1], forward: true)
        }
    }
    
    // MARK: - Screen IDs для аналітики
    private func screenId(for step: OnboardingStep) -> String {
        
        switch step {
        case .stepOne:
            return "step_1"
        case .stepTwo:
            return "step_2"
        case .stepThree:
            return "step_3"
        case .paywall:
            return "paywall"
        }

    }

    // MARK: - Рендер екрана та фону
    @ViewBuilder
    private func screen(for step: OnboardingStep, startAnimations: Bool = true, staticDisplay: Bool = false) -> some View {
        switch step {
        case .stepOne:
            OnboardFirstView(action: { goTo(.stepTwo, forward: true) })
            
        case .stepTwo:
            OnboardSecondView(action: { goTo(.stepThree, forward: true) })
            //OnboardFourthSecondView(action: { goTo(.stepThree, forward: true) })
        case .stepThree:
            OnboardThirdView(action: { goTo(.paywall, forward: true) })
           // OnboardFourthSixthView(action: { goTo(.paywall, forward: true) })
        case .paywall:
            
            PaywallView(action: { finishOnboarding() })

//            PaywallThirdView(
//                    onFinish: finishOnboarding,
//                    onboardId: onboardId,
//                    startDelay: slideDuration + 0.1,   // 0.55 s
//                    summaryTag: .v41,
//                    stepsVisited: stepsVisited
//                    
//                )
//            .onAppear {
//                    //Telemetry.shared.onbScreenView(flowId: flowId, screenId: "paywall")
//                    paywallShown = true        // <-- тут, а не вище
//                    persist(tag: .v41)      // якщо зберігаєш прогрес
//                
//            }
        }
    }

}


#Preview {
    OnboardingFlow()
}
