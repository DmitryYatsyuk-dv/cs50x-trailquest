//
// TQAccentTheme.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

struct TQAccentTheme: Sendable {
    let primaryAccentColors: TQColorPair
    let secondaryAccentColors: TQColorPair
    let tertiaryAccentColors: TQColorPair

    init(
        primaryAccentColors: TQColorPair,
        secondaryAccentColors: TQColorPair,
        tertiaryAccentColors: TQColorPair
    ) {
        self.primaryAccentColors = primaryAccentColors
        self.secondaryAccentColors = secondaryAccentColors
        self.tertiaryAccentColors = tertiaryAccentColors
    }

    static let current = TQAccentTheme(
        primaryAccentColors: TQColorPair(light: 0x2e544e, dark: 0x4a8e85),
        secondaryAccentColors: TQColorPair(light: 0xE37f04, dark: 0xff9a2d),
        tertiaryAccentColors: TQColorPair(light: 0x4A90E2, dark: 0x3B6CC4)
    )
}
