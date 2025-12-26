//
// MainViewFactory.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

public enum MainViewFactory {

    /// Создать вью основного приложения
    @MainActor public static func createView() -> some View {
        let palette = TQPalette()
        let competitionStore = CoreDataCompetitionStore(
            controller: PersistenceController()
        )
        let onboardingState = OnboardingState()

        return OnboardingContainerView()
            .environment(\.palette, palette)
            .environment(\.competitionStore, competitionStore)
            .environmentObject(onboardingState)
    }
}
