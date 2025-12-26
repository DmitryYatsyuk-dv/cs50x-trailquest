//
// TQAccentColors.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

struct TQAccentColors: Sendable {
    let primary: TQColorToken
    let secondary: TQColorToken
    let tertiary: TQColorToken

    init(theme: TQAccentTheme) {
        self.primary = TQColorToken(color: .tqaDynamic(from: theme.primaryAccentColors))
        self.secondary = TQColorToken(color: .tqaDynamic(from: theme.secondaryAccentColors))
        self.tertiary = TQColorToken(color: .tqaDynamic(from: theme.tertiaryAccentColors))
    }
}
