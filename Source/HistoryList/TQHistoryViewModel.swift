//
// TQHistoryViewModel.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import Combine
import Foundation

final class TQHistoryViewModel: ObservableObject {
    @Published private(set) var state: TQState<[TQCompetitionRecordPresentable]> = .loading

    private var store: CompetitionStore?
    private var loadTask: Task<Void, Never>?
    private var changesTask: Task<Void, Never>?
    private var isConfigured = false

    deinit {
        loadTask?.cancel()
        changesTask?.cancel()
    }

    func configure(with store: CompetitionStore) {
        guard !isConfigured else { return }
        self.store = store
        isConfigured = true

        scheduleLoad(showLoading: true)
        changesTask = Task { [weak self] in
            await self?.observeChanges(from: store)
        }
    }

    func delete(id: UUID) async {
        guard let store else { return }

        do {
            try await store.delete(id: id)
            scheduleLoad(showLoading: false)
        } catch {
            guard !Task.isCancelled else { return }
            await MainActor.run {
                self.state = .failure
            }
        }
    }

    private func scheduleLoad(showLoading: Bool) {
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            await self?.loadHistory(showLoading: showLoading)
        }
    }

    private func loadHistory(showLoading: Bool) async {
        guard let store else { return }
        guard !Task.isCancelled else { return }

        if showLoading {
            await MainActor.run {
                self.state = .loading
            }
        }

        do {
            let records = try await fetchRecords(from: store)
            guard !Task.isCancelled else { return }
            let presentables = records
                .sorted { ($0.finishDate ?? .distantPast) > ($1.finishDate ?? .distantPast) }
                .compactMap(TQCompetitionRecordPresentable.init)

            await MainActor.run {
                self.state = .result(presentables)
            }
        } catch {
            guard !Task.isCancelled else { return }
            await MainActor.run {
                self.state = .failure
            }
        }
    }

    private func fetchRecords(from store: CompetitionStore) async throws -> [CompetitionRecord] {
        var allRecords: [CompetitionRecord] = []
        var offset = 0
        let pageSize = 20

        repeat {
            let page = try await store.fetchPage(offset: offset, limit: pageSize)
            allRecords.append(contentsOf: page)
            offset += page.count

            if page.count < pageSize {
                break
            }
        } while true

        return allRecords
    }

    private func observeChanges(from store: CompetitionStore) async {
        for await change in store.changes() {
            switch change {
            case .created, .updated, .deleted:
                scheduleLoad(showLoading: false)
            }
        }
    }
}
