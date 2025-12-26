//
// Color+Palette.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI
import UIKit

extension Color {
    static func tqaDynamic(from pair: TQColorPair) -> Color {
        Color(
            UIColor { traitCollection in
                UIColor(hex: traitCollection.userInterfaceStyle == .dark ? pair.dark : pair.light)
            }
        )
    }
}

private extension UIColor {
    convenience init(hex: UInt) {
        self.init(
            red: CGFloat((hex >> 16) & 0xFF) / 255.0,
            green: CGFloat((hex >> 8) & 0xFF) / 255.0,
            blue: CGFloat(hex & 0xFF) / 255.0,
            alpha: 1.0
        )
    }
}
