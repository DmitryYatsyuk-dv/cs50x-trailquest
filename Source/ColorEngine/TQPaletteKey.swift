//
// TQPaletteKey.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

private struct TQPaletteKey: EnvironmentKey {
    static let defaultValue = TQPalette()
}

extension EnvironmentValues {
    var palette: TQPalette {
        get { self[TQPaletteKey.self] }
        set { self[TQPaletteKey.self] = newValue }
    }
}
