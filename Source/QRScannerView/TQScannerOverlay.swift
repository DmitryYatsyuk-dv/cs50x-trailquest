//
// TQScannerOverlay.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

struct TQScannerOverlay: View {
    @Environment(\.palette) private var palette

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height) * 0.65
            let origin = CGPoint(
                x: (geometry.size.width - size) / 2,
                y: (geometry.size.height - size) / 2
            )
            let rect = CGRect(origin: origin, size: CGSize(width: size, height: size))

            Path { path in
                path.addRect(CGRect(origin: .zero, size: geometry.size))
                path.addRoundedRect(in: rect, cornerSize: CGSize(width: 20, height: 20))
            }
            .fill(Color.black.opacity(0.55), style: FillStyle(eoFill: true))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(palette.accent.primary.color.opacity(0.9), lineWidth: 3)
                    .frame(width: size, height: size)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            )
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}
