//
// SummaryHeaderCell.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

struct SummaryHeaderCell: View {
    @Environment(\.palette) private var palette

    let durationText: String
    let progressText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(durationText)
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(palette.text.primary.color)

            Text(progressText)
                .font(.subheadline)
                .foregroundStyle(palette.text.secondary.color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 12)
    }
}

#Preview {
    SummaryHeaderCell(
        durationText: "01:32:41",
        progressText: "посещено 7 из 10"
    )
    .environment(\.palette, TQPalette())
}

