//
// OnboardingContainerView.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

struct OnboardingContainerView: View {
    @Environment(\.palette) private var palette
    @EnvironmentObject private var onboardingState: OnboardingState

    var body: some View {
        ZStack {
            RootTabView()
                .opacity(onboardingState.needsOnboarding ? 0 : 1)

            if onboardingState.needsOnboarding {
                OnboardingView(
                    onFinish: {
                        withAnimation(.easeOut(duration: 0.45)) {
                            onboardingState.markCompleted()
                        }
                    }
                )
                    .environment(\.palette, palette)
                    .transition(.opacity)
            }
        }
        .animation(.easeOut(duration: 0.45), value: onboardingState.needsOnboarding)
    }
}

#Preview {
    OnboardingContainerView()
        .environment(\.palette, TQPalette())
        .environmentObject(OnboardingState(forceShow: true))
}
