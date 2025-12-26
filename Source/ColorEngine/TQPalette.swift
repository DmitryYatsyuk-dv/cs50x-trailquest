//
// TQPalette.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

struct TQPalette: Sendable {
    let accent: TQAccentColors
    let background: TQBackgroundColors
    let text: TQTextColors
    let utility: TQUtilityColors

    init(
        accentTheme: TQAccentTheme = .current,
        backgroundTheme: TQBackgroundTheme = .current
    ) {
        self.accent = TQAccentColors(theme: accentTheme)
        self.background = TQBackgroundColors(theme: backgroundTheme)
        self.text = TQTextColors(theme: backgroundTheme)
        self.utility = TQUtilityColors(theme: backgroundTheme)
    }
}
