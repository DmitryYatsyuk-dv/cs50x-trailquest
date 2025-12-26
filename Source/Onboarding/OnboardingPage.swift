//
// OnboardingPage.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

struct OnboardingPage: Identifiable, Equatable {
    enum Illustration {
        case horizontally
        case vertically
    }

    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let assetName: String
    let accent: Color
    let illustrationView: Illustration

    static func defaultPages(palette: TQPalette) -> [OnboardingPage] {
        [
            OnboardingPage(
                title: L10n.Onboarding.Page1.title,
                description: L10n.Onboarding.Page1.description,
                icon: "map.fill",
                assetName: "1",
                accent: palette.accent.primary.color,
                illustrationView: .horizontally
            ),
            OnboardingPage(
                title: L10n.Onboarding.Page2.title,
                description: L10n.Onboarding.Page2.description,
                icon: "qrcode.viewfinder",
                assetName: "2",
                accent: palette.accent.secondary.color,
                illustrationView: .vertically
            ),
            OnboardingPage(
                title: L10n.Onboarding.Page3.title,
                description: L10n.Onboarding.Page3.description,
                icon: "chart.line.uptrend.xyaxis",
                assetName: "3",
                accent: palette.accent.tertiary.color,
                illustrationView: .vertically
            ),
            OnboardingPage(
                title: L10n.Onboarding.Page4.title,
                description: L10n.Onboarding.Page4.description,
                icon: "square.and.arrow.up.fill",
                assetName: "4",
                accent: palette.accent.secondary.color,
                illustrationView: .vertically
            )
        ]
    }
}
