//
// TQUtilityColors.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

struct TQUtilityColors: Sendable {
    let border: TQColorToken
    let error: TQColorToken

    init(theme: TQBackgroundTheme) {
        self.border = TQColorToken(color: .tqaDynamic(from: theme.utilityBorderColor))
        self.error = TQColorToken(color: .tqaDynamic(from: theme.utilityErrorColor))
    }
}
