//
// TQBackgroundTheme.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

struct TQBackgroundTheme: Sendable {
    let baseBackgroundColor: TQColorPair
    let cardBackgroundColor: TQColorPair
    let groupBackgroundColor: TQColorPair
    let groupElementBackgroundColor: TQColorPair
    let selectionBackgroundColor: TQColorPair
    let primaryTextColor: TQColorPair
    let secondaryTextColor: TQColorPair
    let utilityBorderColor: TQColorPair
    let utilityErrorColor: TQColorPair

    init(
        baseBackgroundColor: TQColorPair,
        cardBackgroundColor: TQColorPair,
        groupBackgroundColor: TQColorPair,
        groupElementBackgroundColor: TQColorPair,
        selectionBackgroundColor: TQColorPair,
        primaryTextColor: TQColorPair,
        secondaryTextColor: TQColorPair,
        utilityBorderColor: TQColorPair,
        utilityErrorColor: TQColorPair
    ) {
        self.baseBackgroundColor = baseBackgroundColor
        self.cardBackgroundColor = cardBackgroundColor
        self.groupBackgroundColor = groupBackgroundColor
        self.groupElementBackgroundColor = groupElementBackgroundColor
        self.selectionBackgroundColor = selectionBackgroundColor
        self.primaryTextColor = primaryTextColor
        self.secondaryTextColor = secondaryTextColor
        self.utilityBorderColor = utilityBorderColor
        self.utilityErrorColor = utilityErrorColor
    }

    static let current = TQBackgroundTheme(
        baseBackgroundColor: TQColorPair(light: 0xF7F4EF, dark: 0x1C1A17),
        cardBackgroundColor: TQColorPair(light: 0xFFFFFF, dark: 0x25221E),
        groupBackgroundColor: TQColorPair(light: 0xECE7DE, dark: 0x22201B),
        groupElementBackgroundColor: TQColorPair(light: 0xFFFFFF, dark: 0x2E2A24),
        selectionBackgroundColor: TQColorPair(light: 0xE4D4B4, dark: 0x3A3126),
        primaryTextColor: TQColorPair(light: 0x1E211F, dark: 0xF7F4EF),
        secondaryTextColor: TQColorPair(light: 0x6C6A65, dark: 0xCFC9C1),
        utilityBorderColor: TQColorPair(light: 0xD6D0C6, dark: 0x3A362F),
        utilityErrorColor: TQColorPair(light: 0xD95C4C, dark: 0xFF8A76)
    )
}
