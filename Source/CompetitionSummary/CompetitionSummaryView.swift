//
// CompetitionSummaryView.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import Foundation
import SwiftUI

struct CompetitionSummaryView: View {
    @Environment(\.palette) private var palette
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CompetitionSummaryViewModel
    private let onClose: (() -> Void)?

    init(presentable: TQCompetitionRecordPresentable, onClose: (() -> Void)? = nil) {
        self.onClose = onClose
        _viewModel = StateObject(wrappedValue: CompetitionSummaryViewModel(summary: presentable))
    }

    var body: some View {
        List {
            Section {
                SummaryHeaderCell(
                    durationText: viewModel.summary.durationText,
                    progressText: viewModel.summary.progressText
                )
                .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 12, trailing: 16))
                .listRowBackground(palette.background.base.color)
            }

            ForEach(viewModel.summary.visitedCheckpoints) { checkpoint in
                VisitedCheckpointCell(checkpoint: checkpoint)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(palette.background.base.color)
            }
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        .scrollContentBackground(.hidden)
        .background(palette.background.base.color)
        .navigationTitle(viewModel.summary.parkName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                ShareLink(item: shareText) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    onClose?()
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                }
            }
        }
    }

    private var shareText: String {
        L10n.Summary.shareText(
            viewModel.summary.parkName,
            viewModel.summary.progressText,
            viewModel.summary.durationText
        )
    }
}

#Preview {
    let startDate = Date().addingTimeInterval(-7200)
    let visited = (0..<5).map { index in
        VisitedCheckpointRecord(
            checkpointID: index,
            sequenceNumber: index,
            visitedAt: startDate.addingTimeInterval(TimeInterval((index + 1) * 600)),
            latitude: 0,
            longitude: 0,
            checkpointName: "Контрольная точка \(index + 1)",
            source: .qr
        )
    }

    let record = CompetitionRecord(
        competitionUID: "preview-1",
        parkID: 1,
        parkName: "Парк Превью",
        startDate: startDate,
        finishDate: Date(),
        totalCheckpoints: 10,
        visitedCheckpoints: visited,
        lastUpdatedAt: Date(),
        progress: 0.5,
        difficulty: .medium
    )

    let presentable = TQCompetitionRecordPresentable(record: record)!

    return NavigationView {
        CompetitionSummaryView(presentable: presentable)
            .environment(\.palette, TQPalette())
    }
}
