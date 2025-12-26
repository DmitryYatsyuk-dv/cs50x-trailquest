//
// CoreDataCompetitionStoreTests.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import XCTest
@testable import TrailQuest

final class CoreDataCompetitionStoreTests: XCTestCase {

    func testCreateAndFetchRecordsReturnsSortedResults() async throws {
        let store = makeStore()
        let newer = makeRecord(
            id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
            competitionUID: "newer",
            startDate: Date(timeIntervalSince1970: 2000)
        )
        let older = makeRecord(
            id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
            competitionUID: "older",
            startDate: Date(timeIntervalSince1970: 1000)
        )

        try await store.create(older)
        try await store.create(newer)

        let results = try await store.fetchPage(offset: 0, limit: 10)

        XCTAssertEqual(results, [newer, older])
    }

    func testDuplicateCreateThrowsError() async throws {
        let store = makeStore()
        let record = makeRecord(
            id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!,
            competitionUID: "duplicate",
            startDate: Date(timeIntervalSince1970: 1000)
        )

        try await store.create(record)

        await XCTAssertThrowsErrorAsync {
            try await store.create(record)
        } validator: { error in
            XCTAssertEqual(error as? CompetitionStoreError, .recordAlreadyExists)
        }
    }

    func testDeleteRemovesRecord() async throws {
        let store = makeStore()
        let record = makeRecord(
            id: UUID(uuidString: "44444444-4444-4444-4444-444444444444")!,
            competitionUID: "delete",
            startDate: Date(timeIntervalSince1970: 1000)
        )

        try await store.create(record)
        try await store.delete(id: record.id)

        let results = try await store.fetchPage(offset: 0, limit: 10)
        XCTAssertTrue(results.isEmpty)
    }

    func testDeleteMissingRecordThrowsError() async {
        let store = makeStore()
        let missingID = UUID(uuidString: "99999999-9999-9999-9999-999999999999")!

        await XCTAssertThrowsErrorAsync {
            try await store.delete(id: missingID)
        } validator: { error in
            XCTAssertEqual(error as? CompetitionStoreError, .recordNotFound)
        }
    }

    func testDeleteAllRemovesAllRecords() async throws {
        let store = makeStore()
        let first = makeRecord(
            id: UUID(uuidString: "55555555-5555-5555-5555-555555555555")!,
            competitionUID: "first",
            startDate: Date(timeIntervalSince1970: 1000)
        )
        let second = makeRecord(
            id: UUID(uuidString: "66666666-6666-6666-6666-666666666666")!,
            competitionUID: "second",
            startDate: Date(timeIntervalSince1970: 2000)
        )

        try await store.create(first)
        try await store.create(second)
        try await store.deleteAll()

        let results = try await store.fetchPage(offset: 0, limit: 10)
        XCTAssertTrue(results.isEmpty)
    }

    func testChangesEmitsCreateAndDelete() async throws {
        let store = makeStore()
        let record = makeRecord(
            id: UUID(uuidString: "77777777-7777-7777-7777-777777777777")!,
            competitionUID: "changes",
            startDate: Date(timeIntervalSince1970: 1000)
        )

        var iterator = store.changes().makeAsyncIterator()

        try await store.create(record)
        let created = await iterator.next()
        XCTAssertEqual(created, .created(record))

        try await store.delete(id: record.id)
        let deleted = await iterator.next()
        XCTAssertEqual(deleted, .deleted(record.id))
    }

    private func makeStore() -> CoreDataCompetitionStore {
        let controller = PersistenceController(kind: .inMemory)
        return CoreDataCompetitionStore(controller: controller)
    }

    private func makeRecord(id: UUID, competitionUID: String, startDate: Date) -> CompetitionRecord {
        let visited = [
            VisitedCheckpointRecord(
                id: UUID(uuidString: "AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA")!,
                checkpointID: 1,
                sequenceNumber: 1,
                visitedAt: startDate,
                latitude: 55.0,
                longitude: 37.0,
                checkpointName: "Checkpoint",
                source: .manual
            )
        ]

        return CompetitionRecord(
            id: id,
            competitionUID: competitionUID,
            parkID: 1,
            parkName: "Test Park",
            startDate: startDate,
            finishDate: nil,
            totalCheckpoints: 3,
            visitedCheckpoints: visited,
            lastUpdatedAt: startDate,
            progress: 0.33,
            difficulty: .easy
        )
    }
}

private extension XCTestCase {
    
    func XCTAssertThrowsErrorAsync(
        _ expression: @escaping () async throws -> Void,
        validator: (Error) -> Void
    ) async {
        do {
            try await expression()
            XCTFail("Expected error to be thrown")
        } catch {
            validator(error)
        }
    }
}
