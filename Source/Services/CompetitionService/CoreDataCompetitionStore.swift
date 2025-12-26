//
// CoreDataCompetitionStore.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import CoreData
import Foundation

final class CoreDataCompetitionStore: CompetitionStore {
    private let controller: PersistenceController
    private let context: NSManagedObjectContext
    private let broadcaster = CompetitionChangeBroadcaster()

    init(controller: PersistenceController = PersistenceController()) {
        self.controller = controller
        self.context = controller.container.newBackgroundContext()
        self.context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        self.context.automaticallyMergesChangesFromParent = true
        self.context.undoManager = nil
    }

    func create(_ record: CompetitionRecord) async throws {
        let createdRecord: CompetitionRecord = try await context.perform {
            if try self.fetchCompetitionManagedObject(id: record.id) != nil {
                throw CompetitionStoreError.recordAlreadyExists
            }

            let object = self.insertCompetition(record, in: self.context)
            try self.context.save()
            return try self.makeCompetitionRecord(from: object)
        }

        await broadcaster.yield(.created(createdRecord))
    }

    func delete(id: UUID) async throws {
        let deletedID: UUID? = try await context.perform {
            guard let object = try self.fetchCompetitionManagedObject(id: id) else {
                throw CompetitionStoreError.recordNotFound
            }

            self.context.delete(object)
            try self.context.save()
            return id
        }

        if let deletedID {
            await broadcaster.yield(.deleted(deletedID))
        }
    }

    func fetchPage(offset: Int, limit: Int) async throws -> [CompetitionRecord] {
        try await context.perform {
            let request = NSFetchRequest<NSManagedObject>(entityName: Entities.competition)
            request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: false)]
            request.fetchOffset = offset
            request.fetchLimit = limit
            request.returnsObjectsAsFaults = false

            let objects = try self.context.fetch(request)
            return try objects.map { try self.makeCompetitionRecord(from: $0) }
        }
    }

    func deleteAll() async throws {
        let deletedIDs: [UUID] = try await context.perform {
            let request = NSFetchRequest<NSManagedObject>(entityName: Entities.competition)
            request.returnsObjectsAsFaults = false
            let objects = try self.context.fetch(request)

            let ids = objects.compactMap { $0.value(forKey: "id") as? UUID }
            objects.forEach { self.context.delete($0) }

            if self.context.hasChanges {
                try self.context.save()
            }

            return ids
        }

        for id in deletedIDs {
            await broadcaster.yield(.deleted(id))
        }
    }

    func changes() -> AsyncStream<CompetitionChange> {
        AsyncStream { continuation in
            Task {
                for await change in await broadcaster.stream() {
                    continuation.yield(change)
                }
            }
        }
    }

    // MARK: - Helpers

    private func fetchCompetitionManagedObject(id: UUID) throws -> NSManagedObject? {
        let request = NSFetchRequest<NSManagedObject>(entityName: Entities.competition)
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try context.fetch(request).first
    }

    private func insertCompetition(_ record: CompetitionRecord, in context: NSManagedObjectContext) -> NSManagedObject {
        let competition = NSEntityDescription.insertNewObject(forEntityName: Entities.competition, into: context)

        competition.setValue(record.id, forKey: "id")
        competition.setValue(record.competitionUID, forKey: "competitionUID")
        competition.setValue(Int64(record.parkID), forKey: "parkID")
        competition.setValue(record.parkName, forKey: "parkName")
        competition.setValue(record.startDate, forKey: "startDate")
        competition.setValue(record.finishDate, forKey: "finishDate")
        competition.setValue(Int64(record.totalCheckpoints), forKey: "totalCheckpoints")
        competition.setValue(record.lastUpdatedAt, forKey: "lastUpdatedAt")
        competition.setValue(record.progress, forKey: "progress")
        competition.setValue(record.difficulty.rawValue, forKey: "difficulty")

        let visitedObjects = record.visitedCheckpoints.sorted { $0.sequenceNumber < $1.sequenceNumber }
            .map { checkpoint -> NSManagedObject in
                let managed = NSEntityDescription.insertNewObject(forEntityName: Entities.visitedCheckpoint, into: context)

                managed.setValue(checkpoint.id, forKey: "id")
                managed.setValue(Int64(checkpoint.checkpointID), forKey: "checkpointID")
                managed.setValue(Int64(checkpoint.sequenceNumber), forKey: "sequenceNumber")
                managed.setValue(checkpoint.visitedAt, forKey: "visitedAt")
                managed.setValue(checkpoint.latitude, forKey: "latitude")
                managed.setValue(checkpoint.longitude, forKey: "longitude")
                managed.setValue(checkpoint.checkpointName, forKey: "checkpointName")
                managed.setValue(checkpoint.source.rawValue, forKey: "source")
                managed.setValue(competition, forKey: "competition")

                return managed
            }

        competition.setValue(NSOrderedSet(array: visitedObjects), forKey: "visitedCheckpoints")

        return competition
    }

    private func makeCompetitionRecord(from object: NSManagedObject) throws -> CompetitionRecord {
        guard
            let id = object.value(forKey: "id") as? UUID,
            let competitionUID = object.value(forKey: "competitionUID") as? String,
            let parkIDValue = object.value(forKey: "parkID") as? Int64,
            let parkName = object.value(forKey: "parkName") as? String,
            let startDate = object.value(forKey: "startDate") as? Date,
            let totalCheckpointsValue = object.value(forKey: "totalCheckpoints") as? Int64,
            let lastUpdatedAt = object.value(forKey: "lastUpdatedAt") as? Date,
            let progress = object.value(forKey: "progress") as? Double
        else {
            throw CompetitionStoreError.invalidManagedObject
        }

        let finishDate = object.value(forKey: "finishDate") as? Date
        let totalCheckpoints = Int(totalCheckpointsValue)
        let difficultyRaw = object.value(forKey: "difficulty") as? String ?? TQDifficulty.medium.rawValue
        let difficulty = TQDifficulty(rawValue: difficultyRaw) ?? .medium

        let visitedRecords: [VisitedCheckpointRecord]
        if let orderedSet = object.value(forKey: "visitedCheckpoints") as? NSOrderedSet,
           let managedObjects = orderedSet.array as? [NSManagedObject] {
            visitedRecords = managedObjects.compactMap { managed -> VisitedCheckpointRecord? in
                guard
                    let id = managed.value(forKey: "id") as? UUID,
                    let checkpointIDValue = managed.value(forKey: "checkpointID") as? Int64,
                    let sequenceNumberValue = managed.value(forKey: "sequenceNumber") as? Int64,
                    let visitedAt = managed.value(forKey: "visitedAt") as? Date,
                    let latitude = managed.value(forKey: "latitude") as? Double,
                    let longitude = managed.value(forKey: "longitude") as? Double,
                    let checkpointName = managed.value(forKey: "checkpointName") as? String,
                    let sourceRaw = managed.value(forKey: "source") as? String
                else {
                    return nil
                }

                return VisitedCheckpointRecord(
                    id: id,
                    checkpointID: Int(checkpointIDValue),
                    sequenceNumber: Int(sequenceNumberValue),
                    visitedAt: visitedAt,
                    latitude: latitude,
                    longitude: longitude,
                    checkpointName: checkpointName,
                    source: TQSource(rawValue: sourceRaw) ?? .manual
                )
            }
        } else {
            visitedRecords = []
        }

        return CompetitionRecord(
            id: id,
            competitionUID: competitionUID,
            parkID: Int(parkIDValue),
            parkName: parkName,
            startDate: startDate,
            finishDate: finishDate,
            totalCheckpoints: totalCheckpoints,
            visitedCheckpoints: visitedRecords,
            lastUpdatedAt: lastUpdatedAt,
            progress: progress,
            difficulty: difficulty
        )
    }
}

// MARK: - Change broadcaster

private actor CompetitionChangeBroadcaster {
    private var listeners: [UUID: AsyncStream<CompetitionChange>.Continuation] = [:]

    func stream() -> AsyncStream<CompetitionChange> {
        AsyncStream { continuation in
            let id = UUID()
            listeners[id] = continuation
            continuation.onTermination = { [id] _ in
                Task { await self.remove(id: id) }
            }
        }
    }

    func yield(_ change: CompetitionChange) {
        for continuation in listeners.values {
            continuation.yield(change)
        }
    }

    private func remove(id: UUID) {
        listeners.removeValue(forKey: id)
    }
}

// MARK: - Constants

private enum Entities {
    static let competition = "Competition"
    static let visitedCheckpoint = "VisitedCheckpoint"
}
