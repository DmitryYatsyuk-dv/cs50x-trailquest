//
// TQHistoryCardView.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

struct TQHistoryCardView: View {
    @Environment(\.palette) private var palette

    let record: TQCompetitionRecordPresentable

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(record.parkName)
                .font(.headline)
                .foregroundStyle(palette.text.primary.color)

            Text("\(record.durationText)")
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(palette.text.primary.color)

            Text(record.progressText)
                .font(.footnote)
                .foregroundStyle(palette.text.secondary.color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(palette.background.card.color)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(palette.utility.border.color, lineWidth: 1)
        )
    }
}

#Preview {
    let visited = (0..<7).map { index in
        VisitedCheckpointRecord(
            checkpointID: index,
            sequenceNumber: index,
            visitedAt: Date().addingTimeInterval(TimeInterval(index * 300)),
            latitude: 0,
            longitude: 0,
            checkpointName: "Точка \(index)",
            source: .qr
        )
    }

    let record = CompetitionRecord(
        competitionUID: "comp-1",
        parkID: 1,
        parkName: "Парк победы",
        startDate: Date().addingTimeInterval(-3600),
        finishDate: Date(),
        totalCheckpoints: 10,
        visitedCheckpoints: visited,
        lastUpdatedAt: Date(),
        progress: 0.7,
        difficulty: .medium
    )

    return Group {
        if let presentable = TQCompetitionRecordPresentable(record: record) {
            TQHistoryCardView(record: presentable)
        } else {
            EmptyView()
        }
    }
    .environment(\.palette, TQPalette())
}
