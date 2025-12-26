//
// TQTextColors.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

struct TQTextColors: Sendable {
    let primary: TQColorToken
    let secondary: TQColorToken

    init(theme: TQBackgroundTheme) {
        self.primary = TQColorToken(color: .tqaDynamic(from: theme.primaryTextColor))
        self.secondary = TQColorToken(color: .tqaDynamic(from: theme.secondaryTextColor))
    }
}
