//
// TQHistoryList.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

struct TQHistoryList: View {
    @Environment(\.palette) private var palette
    @Environment(\.competitionStore) private var competitionStore
    @StateObject private var viewModel: TQHistoryViewModel
    @State private var selectedRecord: TQCompetitionRecordPresentable?

    init(viewModel: TQHistoryViewModel = TQHistoryViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            content
                .navigationTitle(L10n.History.title)
        }
        .tint(palette.accent.secondary.color)
        .background(palette.background.base.color)
        .task {
            viewModel.configure(with: competitionStore)
        }
        .sheet(item: $selectedRecord) { record in
            NavigationView {
                CompetitionSummaryView(presentable: record)
                    .environment(\.palette, palette)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case .failure:
            emptyStateView
        case .result(let records):
            if records.isEmpty {
                emptyStateView
            } else {
                listView(for: records)
            }
        }
    }

    private var loadingView: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(palette.background.base.color)
    }

    private var emptyStateView: some View {
        Text(L10n.History.empty)
            .multilineTextAlignment(.center)
            .foregroundStyle(palette.text.primary.color)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(palette.background.base.color)
    }

    private func listView(for records: [TQCompetitionRecordPresentable]) -> some View {
        List {
            ForEach(records) { record in
                TQHistoryCardView(record: record)
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
                    .listRowBackground(palette.background.base.color)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        deleteButton(for: record)
                    }
                    .onTapGesture {
                        presentRecordDetails(record)
                    }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(palette.background.base.color)
    }

    private func deleteButton(for record: TQCompetitionRecordPresentable) -> some View {
        Button(role: .destructive) {
            Task { await viewModel.delete(id: record.id) }
        } label: {
            Label(L10n.Common.delete, systemImage: "trash")
        }
    }

    private func presentRecordDetails(_ record: TQCompetitionRecordPresentable) {
        selectedRecord = record
    }
}

#Preview {
    struct PreviewStore: CompetitionStore {
        func deleteAll() async throws {}
        
        let records: [CompetitionRecord]

        func create(_ record: CompetitionRecord) async throws {}

        func delete(id: UUID) async throws {}

        func fetchPage(offset: Int, limit: Int) async throws -> [CompetitionRecord] {
            Array(records.dropFirst(offset).prefix(limit))
        }

        func changes() -> AsyncStream<CompetitionChange> {
            AsyncStream { continuation in
                continuation.finish()
            }
        }
    }

    let visited = (0..<5).map { index in
        VisitedCheckpointRecord(
            checkpointID: index,
            sequenceNumber: index,
            visitedAt: Date().addingTimeInterval(TimeInterval(index * 600)),
            latitude: 0,
            longitude: 0,
            checkpointName: "Точка \(index + 1)",
            source: .qr
        )
    }

    let record = CompetitionRecord(
        competitionUID: "preview-1",
        parkID: 1,
        parkName: "Парк Превью",
        startDate: Date().addingTimeInterval(-7200),
        finishDate: Date(),
        totalCheckpoints: 10,
        visitedCheckpoints: visited,
        lastUpdatedAt: Date(),
        progress: 0.5,
        difficulty: .medium
    )

    return TQHistoryList()
        .environment(\.palette, TQPalette())
        .environment(\.competitionStore, PreviewStore(records: [record]))
}
