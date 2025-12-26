//
// TQProfileSaveSuccessOverlay.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

struct TQProfileSaveSuccessOverlay: View {
    @Binding var show: Bool
    let palette: TQPalette

    var body: some View {
        Group {
            if show {
                ZStack {
                    Circle()
                        .fill(palette.background.base.color.opacity(0.9))
                        .frame(width: 170, height: 170)
                        .shadow(color: palette.accent.primary.color.opacity(0.35), radius: 25, y: 16)

                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [
                                    palette.accent.primary.color,
                                    palette.accent.secondary.color
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 6
                        )
                        .frame(width: 170, height: 170)

                    VStack(spacing: 12) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 72, weight: .semibold))
                            .foregroundStyle(palette.accent.primary.color)
                        Text(L10n.Profile.Save.success)
                            .font(.headline)
                            .foregroundStyle(palette.text.primary.color)
                    }
                }
                .transition(.scale.combined(with: .opacity))
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: show)
                .allowsHitTesting(false)
            }
        }
    }
}

#Preview {
    StatefulOverlayPreview()
        .environment(\.palette, TQPalette())
}

private struct StatefulOverlayPreview: View {
    @State private var isVisible = true

    var body: some View {
        ZStack {
            Color.black.opacity(0.2).ignoresSafeArea()
            TQProfileSaveSuccessOverlay(show: $isVisible, palette: TQPalette())
        }
    }
}
