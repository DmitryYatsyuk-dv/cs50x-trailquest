//
// TQBackgroundColors.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

struct TQBackgroundColors: Sendable {
    let base: TQColorToken
    let card: TQColorToken
    let group: TQColorToken
    let groupElement: TQColorToken
    let selection: TQColorToken

    init(theme: TQBackgroundTheme) {
        self.base = TQColorToken(color: .tqaDynamic(from: theme.baseBackgroundColor))
        self.card = TQColorToken(color: .tqaDynamic(from: theme.cardBackgroundColor))
        self.group = TQColorToken(color: .tqaDynamic(from: theme.groupBackgroundColor))
        self.groupElement = TQColorToken(color: .tqaDynamic(from: theme.groupElementBackgroundColor))
        self.selection = TQColorToken(color: .tqaDynamic(from: theme.selectionBackgroundColor))
    }
}
