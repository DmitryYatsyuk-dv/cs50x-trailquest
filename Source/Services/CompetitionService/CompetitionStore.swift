//
// CompetitionStore.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import Foundation

protocol CompetitionStore {
    func create(_ record: CompetitionRecord) async throws
    func delete(id: UUID) async throws
    func deleteAll() async throws
    func fetchPage(offset: Int, limit: Int) async throws -> [CompetitionRecord]
    func changes() -> AsyncStream<CompetitionChange>
}

enum CompetitionChange: Equatable {
    case created(CompetitionRecord)
    case updated(CompetitionRecord)
    case deleted(UUID)
}
