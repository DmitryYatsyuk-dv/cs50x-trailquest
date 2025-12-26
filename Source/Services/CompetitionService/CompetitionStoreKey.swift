//
// CompetitionStoreKey.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

private struct CompetitionStoreEnvironmentKey: EnvironmentKey {
    static let defaultValue: CompetitionStore = UnimplementedCompetitionStore()
}

extension EnvironmentValues {
    var competitionStore: CompetitionStore {
        get { self[CompetitionStoreEnvironmentKey.self] }
        set { self[CompetitionStoreEnvironmentKey.self] = newValue }
    }
}

private struct UnimplementedCompetitionStore: CompetitionStore {
    func create(_ record: CompetitionRecord) async throws {
        assertionFailure("CompetitionStore is not provided.")
    }

    func delete(id: UUID) async throws {
        assertionFailure("CompetitionStore is not provided.")
    }

    func deleteAll() async throws {
        assertionFailure("CompetitionStore is not provided.")
    }

    func fetchPage(offset: Int, limit: Int) async throws -> [CompetitionRecord] {
        assertionFailure("CompetitionStore is not provided.")
        return []
    }

    func changes() -> AsyncStream<CompetitionChange> {
        AsyncStream { continuation in
            assertionFailure("CompetitionStore is not provided.")
            continuation.finish()
        }
    }
}
