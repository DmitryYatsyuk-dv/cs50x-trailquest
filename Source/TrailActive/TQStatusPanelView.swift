//
// TQStatusPanelView.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import Foundation
import SwiftUI

struct TQStatusPanelView: View {
    @Environment(\.palette) private var palette

    let title: String
    let elapsedTime: TimeInterval
    let visitedCount: Int
    let totalPoints: Int
    let totalDistanceMeters: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline.weight(.semibold))
                .foregroundStyle(palette.text.primary.color)
                .lineLimit(2)
                .multilineTextAlignment(.leading)

            HStack(spacing: 12) {
                statusValue(
                    icon: "clock.fill",
                    value: formattedTime(elapsedTime)
                )

                statusValue(
                    icon: "checkmark.seal.fill",
                    value: "\(visitedCount) / \(totalPoints)"
                )

                statusValue(
                    icon: "map.fill",
                    value: formattedDistance(totalDistanceMeters)
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.15), radius: 10, y: 6)
        )
    }

    private func statusValue(icon: String, value: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.headline.weight(.semibold))
                .foregroundStyle(palette.accent.primary.color)
            Text(value)
                .font(.headline.weight(.semibold))
                .foregroundStyle(palette.text.primary.color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(palette.background.base.color)
        )
    }

    private func formattedTime(_ time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = time >= 3600 ? [.hour, .minute, .second] : [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: time) ?? L10n.Duration.zeroShort
    }

    private func formattedDistance(_ distance: Double) -> String {
        let totalKm = distance / 1000
        return L10n.Distance.km(Float(totalKm))
    }
}

#Preview {
    TQStatusPanelView(
        title: "Стартовая петля",
        elapsedTime: 543,
        visitedCount: 3,
        totalPoints: 7,
        totalDistanceMeters: 4200
    )
    .environment(\.palette, TQPalette())
    .frame(maxWidth: 360)
}
