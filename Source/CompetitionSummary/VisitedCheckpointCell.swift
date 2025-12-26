//
// VisitedCheckpointCell.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

struct VisitedCheckpointCell: View {
    @Environment(\.palette) private var palette

    let checkpoint: TQVisitedCheckpointPresentable

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(checkpoint.checkpointName)
                .font(.headline)
                .foregroundStyle(palette.text.primary.color)

            Text(checkpoint.durationText)
                .font(.footnote)
                .foregroundStyle(palette.text.secondary.color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 12)
    }
}

#Preview {
    VisitedCheckpointCell(
        checkpoint: TQVisitedCheckpointPresentable(
            sequenceNumber: 1,
            checkpointName: "Контрольная точка 1",
            durationText: "00:15:23"
        )
    )
    .environment(\.palette, TQPalette())
}

